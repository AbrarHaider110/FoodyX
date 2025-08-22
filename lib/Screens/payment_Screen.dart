import 'package:FoodyX/Screens/Order_confirmed.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _addressController = TextEditingController();
  final Color _primaryColor = const Color(0xFF00C896);
  final Color _textColor = const Color(0xFF303030);
  final Color _secondaryTextColor = const Color(0xFF7A7A7A);
  bool _isProcessing = false;

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  String _formatQtyPrice(dynamic qty, dynamic price) {
    final q = (qty is num) ? qty : num.tryParse('$qty') ?? 0;
    final p = (price is num) ? price : num.tryParse('$price') ?? 0;
    final priceStr = p % 1 == 0 ? p.toStringAsFixed(0) : p.toStringAsFixed(2);
    return "${q} x $priceStr";
  }

  Future<void> _confirmPayment(List<QueryDocumentSnapshot> cartDocs) async {
    if (_isProcessing) return;
    setState(() => _isProcessing = true);

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    final items =
        cartDocs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return {
            'productId': data['productId'],
            'title': data['title'],
            'price':
                data['price'] is String
                    ? double.tryParse(
                          data['price'].replaceAll(RegExp(r'[^\d.]'), ''),
                        ) ??
                        0.0
                    : (data['price']?.toDouble() ?? 0.0),
            'imageUrl': data['imageUrl'],
            'description': data['description'] ?? data['subtitle'] ?? '',
            'quantity': data['quantity'],
          };
        }).toList();

    double total = items.fold(
      0,
      (sum, item) => sum + ((item['price'] ?? 0) * (item['quantity'] ?? 1)),
    );

    await FirebaseFirestore.instance.collection('orders').add({
      'userId': userId,
      'items': items,
      'total': total,
      'address': _addressController.text.trim(),
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => OrderConfirmedScreen()),
    );

    setState(() => _isProcessing = false);
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: _primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'Payment',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Shipping Address'),
                      const SizedBox(height: 12),
                      _buildCard(
                        child: TextField(
                          controller: _addressController,
                          decoration: const InputDecoration(
                            hintText: "Enter your address",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Order Summary'),
                      const SizedBox(height: 12),
                      userId == null
                          ? _buildCard(
                            child: const Text("Please login to see cart"),
                          )
                          : StreamBuilder<QuerySnapshot>(
                            stream:
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(userId)
                                    .collection('cart')
                                    .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: _primaryColor,
                                  ),
                                );
                              }
                              final cartDocs = snapshot.data?.docs ?? [];
                              if (cartDocs.isEmpty) {
                                return _buildCard(
                                  child: const Text("No items in cart"),
                                );
                              }
                              return _buildCard(
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: cartDocs.length,
                                  separatorBuilder:
                                      (_, __) => const SizedBox(height: 8),
                                  itemBuilder: (context, index) {
                                    final item =
                                        cartDocs[index].data()
                                            as Map<String, dynamic>;
                                    final title = item['title'] ?? "No title";
                                    final qtyPrice = _formatQtyPrice(
                                      item['quantity'],
                                      item['price'],
                                    );
                                    return _buildDetailRow(title, qtyPrice);
                                  },
                                ),
                              );
                            },
                          ),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Payment Method'),
                      const SizedBox(height: 12),
                      _buildCard(
                        child: _buildDetailRow(
                          'Card Payment:',
                          'XXXX XXXX 1234',
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSectionTitle('Delivery Time'),
                      const SizedBox(height: 12),
                      _buildCard(
                        child: _buildDetailRow(
                          'Estimated Delivery:',
                          '25 mins',
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              _isProcessing
                                  ? null
                                  : () async {
                                    if (_addressController.text
                                        .trim()
                                        .isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Please enter your shipping address",
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }
                                    final cartSnapshot =
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(userId)
                                            .collection('cart')
                                            .get();
                                    if (cartSnapshot.docs.isEmpty) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text("Cart is empty"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }
                                    await _confirmPayment(cartSnapshot.docs);
                                  },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child:
                              _isProcessing
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : const Text(
                                    'CONFIRM PAYMENT',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: Text(
                          "Thank you for choosing us!",
                          style: TextStyle(color: _secondaryTextColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: _textColor,
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2FFF9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 16, color: _secondaryTextColor),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
          ),
        ),
      ],
    );
  }
}
