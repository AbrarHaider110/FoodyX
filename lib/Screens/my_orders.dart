import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final primaryColor = const Color(0xFF00D09E);
  final redColor = Colors.red;
  bool _isProcessingCheckout = false;

  double calculateTotal(List<DocumentSnapshot> items) {
    try {
      return items.fold(0, (sum, item) {
        final data = item.data() as Map<String, dynamic>;
        final price =
            data['price'] is String
                ? double.tryParse(
                  data['price'].replaceAll(RegExp(r'[^\d.]'), '') ?? 0.0,
                )
                : (data['price']?.toDouble() ?? 0.0);
        final quantity = (data['quantity'] as num?)?.toInt() ?? 1;
        return sum + (price * quantity);
      });
    } catch (e) {
      debugPrint('Error calculating total: $e');
      return 0.0;
    }
  }

  Future<void> checkout() async {
    if (_isProcessingCheckout) return;

    setState(() => _isProcessingCheckout = true);

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to complete checkout')),
      );
      setState(() => _isProcessingCheckout = false);
      return;
    }

    try {
      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart');

      final ordersRef = FirebaseFirestore.instance.collection('orders');

      final cartSnapshot = await cartRef.get();
      if (cartSnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Your cart is empty')));
        return;
      }

      // Start transaction
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Create new order
        final orderRef = ordersRef.doc();
        final items =
            cartSnapshot.docs.map((doc) {
              final data = doc.data()!;
              return {
                'productId': data['productId'],
                'title': data['title'],
                'price':
                    data['price'] is String
                        ? double.tryParse(
                          data['price'].replaceAll(RegExp(r'[^\d.]'), '') ??
                              0.0,
                        )
                        : (data['price']?.toDouble() ?? 0.0),
                'imageUrl': data['imageUrl'],
                'description': data['description'] ?? data['subtitle'] ?? '',
                'quantity': data['quantity'],
              };
            }).toList();

        transaction.set(orderRef, {
          'userId': userId,
          'items': items,
          'total': calculateTotal(cartSnapshot.docs),
          'status': 'pending',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Clear cart
        for (final doc in cartSnapshot.docs) {
          transaction.delete(doc.reference);
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully!'),
          duration: Duration(seconds: 2),
        ),
      );
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Checkout failed: ${e.message}'),
          duration: const Duration(seconds: 2),
        ),
      );
      debugPrint('Firebase error during checkout: ${e.code} - ${e.message}');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          duration: const Duration(seconds: 2),
        ),
      );
      debugPrint('Unexpected error during checkout: $e');
    } finally {
      setState(() => _isProcessingCheckout = false);
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
                "My Cart",
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
                      : StreamBuilder<QuerySnapshot>(
                        stream:
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(userId)
                                .collection('cart')
                                .orderBy('addedAt', descending: true)
                                .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return _buildErrorWidget(snapshot.error.toString());
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return _buildLoadingIndicator();
                          }

                          final cartItems = snapshot.data?.docs ?? [];
                          return _buildCartContent(cartItems);
                        },
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
            'Please sign in to view your cart',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () {
              // Implement your login navigation here
            },
            child: const Text('Sign In', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 50, color: Colors.red),
          const SizedBox(height: 20),
          const Text(
            'Failed to load cart',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Text(
            error,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00D09E)),
      ),
    );
  }

  Widget _buildCartContent(List<DocumentSnapshot> cartItems) {
    if (cartItems.isEmpty) {
      return _buildEmptyCart();
    }

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
              final totalPrice = price * quantity;

              return _buildCartItem(item, data, price, quantity, totalPrice);
            },
          ),
        ),
        _buildCheckoutSection(cartItems),
      ],
    );
  }

  Widget _buildEmptyCart() {
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
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () {
              // Navigate back to shopping
              Navigator.pop(context);
            },
            child: const Text(
              'Continue Shopping',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(
    DocumentSnapshot item,
    Map<String, dynamic> data,
    double price,
    int quantity,
    double totalPrice,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                data['imageUrl'] ?? 'assets/placeholder.png',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['title'] ?? 'No Title',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Price: \$${price.toStringAsFixed(2)}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text('Qty: '),
                      // Quantity Controls
                      IconButton(
                        icon: const Icon(Icons.remove, size: 18),
                        onPressed: () async {
                          if (quantity > 1) {
                            await item.reference.update({
                              'quantity': quantity - 1,
                              'updatedAt': FieldValue.serverTimestamp(),
                            });
                          } else {
                            await item.reference.delete();
                          }
                        },
                      ),
                      Text(quantity.toString()),
                      IconButton(
                        icon: const Icon(Icons.add, size: 18),
                        onPressed: () async {
                          await item.reference.update({
                            'quantity': quantity + 1,
                            'updatedAt': FieldValue.serverTimestamp(),
                          });
                        },
                      ),
                    ],
                  ),
                  Text(
                    'Total: \$${totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            // Delete Button
            IconButton(
              icon: Icon(Icons.delete, color: redColor),
              onPressed: () async {
                await item.reference.delete();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutSection(List<DocumentSnapshot> cartItems) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Total: \$${calculateTotal(cartItems).toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _isProcessingCheckout ? null : checkout,
              child:
                  _isProcessingCheckout
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                        'Checkout',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
