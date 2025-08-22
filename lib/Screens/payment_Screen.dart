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

  late Future<List<Map<String, dynamic>>> _cartFuture;

  @override
  void initState() {
    super.initState();
    _cartFuture = fetchCartItems();
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<List<Map<String, dynamic>>> fetchCartItems() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return [];
    final cartSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('cart')
            .get();
    return cartSnapshot.docs.map((doc) => doc.data()).toList();
  }

  String _formatQtyPrice(dynamic qty, dynamic price) {
    final q = (qty is num) ? qty : num.tryParse('$qty') ?? 0;
    final p = (price is num) ? price : num.tryParse('$price') ?? 0;
    final priceStr = p % 1 == 0 ? p.toStringAsFixed(0) : p.toStringAsFixed(2);
    return "${q} x $priceStr";
  }

  @override
  Widget build(BuildContext context) {
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
                      FutureBuilder<List<Map<String, dynamic>>>(
                        future: _cartFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: _primaryColor,
                              ),
                            );
                          }
                          final items = snapshot.data ?? [];
                          if (items.isEmpty) {
                            return _buildCard(
                              child: const Text("No items in cart"),
                            );
                          }
                          return _buildCard(
                            child: ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: items.length,
                              separatorBuilder:
                                  (_, __) => const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final item = items[index];
                                final title =
                                    (item['title'] ?? 'Unknown').toString();
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
                          onPressed: () {
                            final address = _addressController.text.trim();
                            if (address.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "Please enter your shipping address",
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderConfirmedScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
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
