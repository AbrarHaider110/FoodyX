import 'package:FoodyX/Screens/payment_Screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final primaryColor = const Color(0xFF00D09E);
  final redColor = Colors.red;
  bool _isProcessingCheckout = false;
  int _selectedOrderType = 0;
  final Map<String, Timer> _orderTimers = {};
  bool _indexError = false;
  String _indexUrl = '';

  @override
  void initState() {
    super.initState();
    _setupOrderTimers();
  }

  @override
  void dispose() {
    _orderTimers.forEach((key, timer) => timer.cancel());
    super.dispose();
  }

  void _setupOrderTimers() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((snapshot) {
          for (var doc in snapshot.docs) {
            if (!_orderTimers.containsKey(doc.id)) {
              _startOrderTimer(doc.id, doc);
            }
          }
        });
  }

  void _startOrderTimer(String orderId, DocumentSnapshot order) {
    final data = order.data() as Map<String, dynamic>;
    final createdAt = data['createdAt'] as Timestamp;
    final createdTime = createdAt.toDate();
    final now = DateTime.now();
    final elapsed = now.difference(createdTime).inMinutes;
    final timeRemaining = 25 - elapsed;

    if (timeRemaining <= 0) {
      _completeOrder(orderId);
      return;
    }

    final timer = Timer(Duration(minutes: timeRemaining), () {
      _completeOrder(orderId);
    });

    _orderTimers[orderId] = timer;
  }

  Future<void> _completeOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update(
        {'status': 'completed', 'updatedAt': FieldValue.serverTimestamp()},
      );
      _orderTimers.remove(orderId)?.cancel();
    } catch (e) {
      debugPrint('Error completing order: $e');
    }
  }

  Future<void> _cancelOrder(String orderId) async {
    try {
      await FirebaseFirestore.instance.collection('orders').doc(orderId).update(
        {'status': 'cancelled', 'updatedAt': FieldValue.serverTimestamp()},
      );
      _orderTimers.remove(orderId)?.cancel();
    } catch (e) {
      debugPrint('Error cancelling order: $e');
    }
  }

  double calculateTotal(List<DocumentSnapshot> items) {
    try {
      return items.fold(0, (sum, item) {
        final data = item.data() as Map<String, dynamic>;
        final price =
            data['price'] is String
                ? double.tryParse(
                      data['price'].replaceAll(RegExp(r'[^\d.]'), '') ?? '0.0',
                    ) ??
                    0.0
                : (data['price']?.toDouble() ?? 0.0);
        final quantity = (data['quantity'] as num?)?.toInt() ?? 1;
        return sum + (price * quantity);
      });
    } catch (e) {
      debugPrint('Error calculating total: $e');
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
              top: screenHeight * 0.07,
              bottom: screenHeight * 0.02,
            ),
            child: const Center(
              child: Text(
                "My Orders",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child:
                  userId == null
                      ? _buildLoginPrompt()
                      : Column(
                        children: [
                          _buildOrderTypeSelector(),
                          Expanded(child: _buildOrderContent(userId)),
                        ],
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.login, size: 50, color: Colors.grey),
          const SizedBox(height: 20),
          const Text(
            'Please sign in to view your orders',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () {},
            child: const Text('Sign In', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTypeSelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildOrderTypeButton("Cart", 0),
            _buildOrderTypeButton("Active", 1),
            _buildOrderTypeButton("Completed", 2),
            _buildOrderTypeButton("Cancelled", 3),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTypeButton(String text, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _selectedOrderType == index ? primaryColor : Colors.grey[200],
          foregroundColor:
              _selectedOrderType == index ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {
          setState(() {
            _selectedOrderType = index;
            _indexError = false;
          });
        },
        child: Text(text),
      ),
    );
  }

  Widget _buildOrderContent(String userId) {
    if (_indexError) {
      return _buildIndexError();
    }

    switch (_selectedOrderType) {
      case 0:
        return _buildCartItems(userId);
      case 1:
        return _buildActiveOrders(userId);
      case 2:
        return _buildCompletedOrders(userId);
      case 3:
        return _buildCancelledOrders(userId);
      default:
        return _buildCartItems(userId);
    }
  }

  Widget _buildIndexError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.orange),
            const SizedBox(height: 20),
            const Text(
              'Index Required',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'To view your orders, you need to create a Firestore index.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            if (_indexUrl.isNotEmpty) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Index URL: $_indexUrl')),
                  );
                },
                child: const Text('Create Index'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCartItems(String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('cart')
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 50, color: Colors.red),
                const SizedBox(height: 20),
                const Text(
                  'Failed to load cart items',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00D09E)),
            ),
          );
        }

        final cartItems = snapshot.data?.docs ?? [];

        if (cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 80,
                  color: Colors.teal.shade200,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Your cart is empty",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Continue Shopping',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        final total = calculateTotal(cartItems);

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  final data = item.data() as Map<String, dynamic>;

                  final price =
                      data['price'] is String
                          ? double.tryParse(
                                data['price'].replaceAll(RegExp(r'[^\d.]'), ''),
                              ) ??
                              0.0
                          : (data['price']?.toDouble() ?? 0.0);

                  final quantity = (data['quantity'] as num?)?.toInt() ?? 1;
                  final itemTotal = price * quantity;
                  final imageUrl = data['imageUrl'] as String?;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      leading:
                          imageUrl != null && imageUrl.isNotEmpty
                              ? Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                              : Container(
                                width: 50,
                                height: 50,
                                color: Colors.grey[200],
                                child: const Icon(Icons.fastfood),
                              ),
                      title: Text(data['title'] ?? 'Unknown Item'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Quantity: $quantity'),
                          Text('Price: \$${price.toStringAsFixed(2)}'),
                        ],
                      ),
                      trailing: Text(
                        '\$${itemTotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed:
                          _isProcessingCheckout
                              ? null
                              : () => _navigateToPaymentScreen(
                                userId,
                                cartItems,
                                total,
                              ),
                      child:
                          _isProcessingCheckout
                              ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              )
                              : const Text(
                                'Proceed to Payment',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _navigateToPaymentScreen(
    String userId,
    List<DocumentSnapshot> cartItems,
    double total,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentScreen()),
    );
  }

  Widget _buildActiveOrders(String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('orders')
              .where('userId', isEqualTo: userId)
              .where('status', whereIn: ['pending', 'preparing'])
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          final error = snapshot.error.toString();
          if (error.contains('index') || error.contains('indexes')) {
            final regex = RegExp(
              r'https://console\.firebase\.google\.com[^\s]+',
            );
            final match = regex.firstMatch(error);
            if (match != null) {
              _indexUrl = match.group(0)!;
            }

            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() {
                _indexError = true;
              });
            });

            return const SizedBox.shrink();
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 50, color: Colors.red),
                const SizedBox(height: 20),
                const Text(
                  'Failed to load orders',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00D09E)),
            ),
          );
        }

        final orders = snapshot.data?.docs ?? [];

        if (orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 80,
                  color: Colors.teal.shade200,
                ),
                const SizedBox(height: 16),
                const Text(
                  "No active orders",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Continue Shopping',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        }

        orders.sort((a, b) {
          final aData = a.data() as Map<String, dynamic>;
          final bData = b.data() as Map<String, dynamic>;
          final aCreated = aData['createdAt'] as Timestamp;
          final bCreated = bData['createdAt'] as Timestamp;
          return bCreated.compareTo(aCreated);
        });

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            final data = order.data() as Map<String, dynamic>;
            final items = data['items'] as List<dynamic>;
            final total = data['total']?.toDouble() ?? 0.0;
            final createdAt = data['createdAt'] as Timestamp;
            final createdTime = createdAt.toDate();
            final now = DateTime.now();
            final elapsed = now.difference(createdTime).inMinutes;
            final timeRemaining = 25 - elapsed;
            final status = data['status'] as String?;

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order #${order.id.substring(0, 8)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Date: ${createdTime.toString().substring(0, 10)}",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Total: \$${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Items: ${items.length}",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    if (status == 'pending' && timeRemaining > 0)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Time remaining: $timeRemaining minutes",
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: elapsed / 25,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              primaryColor,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Status: ${status ?? 'unknown'}",
                          style: TextStyle(
                            color:
                                status == 'pending'
                                    ? Colors.orange
                                    : (status == 'preparing'
                                        ? Colors.blue
                                        : Colors.grey),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (status == 'pending' && timeRemaining > 0)
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () => _cancelOrder(order.id),
                            child: const Text(
                              'Cancel Order',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCompletedOrders(String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('orders')
              .where('userId', isEqualTo: userId)
              .where('status', isEqualTo: 'completed')
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 50, color: Colors.red),
                const SizedBox(height: 20),
                const Text(
                  'Failed to load orders',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00D09E)),
            ),
          );
        }

        final orders = snapshot.data?.docs ?? [];

        if (orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: Colors.teal.shade200,
                ),
                const SizedBox(height: 16),
                const Text(
                  "No completed orders yet",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        orders.sort((a, b) {
          final aData = a.data() as Map<String, dynamic>;
          final bData = b.data() as Map<String, dynamic>;
          final aCreated = aData['createdAt'] as Timestamp;
          final bCreated = bData['createdAt'] as Timestamp;
          return bCreated.compareTo(aCreated);
        });

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            final data = order.data() as Map<String, dynamic>;
            final items = data['items'] as List<dynamic>;
            final total = data['total']?.toDouble() ?? 0.0;
            final createdAt = data['createdAt'] as Timestamp;
            final createdTime = createdAt.toDate();

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order #${order.id.substring(0, 8)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Date: ${createdTime.toString().substring(0, 10)}",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Total: \$${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Items: ${items.length}",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Status: Completed",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCancelledOrders(String userId) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('orders')
              .where('userId', isEqualTo: userId)
              .where('status', isEqualTo: 'cancelled')
              .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 50, color: Colors.red),
                const SizedBox(height: 20),
                const Text(
                  'Failed to load orders',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00D09E)),
            ),
          );
        }

        final orders = snapshot.data?.docs ?? [];

        if (orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.cancel_outlined,
                  size: 80,
                  color: Colors.teal.shade200,
                ),
                const SizedBox(height: 16),
                const Text(
                  "No cancelled orders",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        }

        orders.sort((a, b) {
          final aData = a.data() as Map<String, dynamic>;
          final bData = b.data() as Map<String, dynamic>;
          final aCreated = aData['createdAt'] as Timestamp;
          final bCreated = bData['createdAt'] as Timestamp;
          return bCreated.compareTo(aCreated);
        });

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            final data = order.data() as Map<String, dynamic>;
            final items = data['items'] as List<dynamic>;
            final total = data['total']?.toDouble() ?? 0.0;
            final createdAt = data['createdAt'] as Timestamp;
            final createdTime = createdAt.toDate();

            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order #${order.id.substring(0, 8)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Date: ${createdTime.toString().substring(0, 10)}",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Total: \$${total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Items: ${items.length}",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Status: Cancelled",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
