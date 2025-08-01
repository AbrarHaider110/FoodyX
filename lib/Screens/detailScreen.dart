import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailScreen extends StatefulWidget {
  final String image;
  final String price;
  final String title;
  final String subtitle;
  final String rating;
  final String productId;

  const DetailScreen({
    super.key,
    required this.image,
    required this.price,
    required this.title,
    required this.subtitle,
    required this.rating,
    required this.productId,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int quantity = 1;
  bool isAddingToCart = false;

  Future<void> addToCart() async {
    // Debug current user
    debugPrint(
      'Attempting to add to cart. Current user: ${FirebaseAuth.instance.currentUser?.uid}',
    );

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to add items to cart')),
      );
      return;
    }

    setState(() => isAddingToCart = true);

    try {
      // Convert price safely by removing all non-numeric characters except decimal point
      final numericPrice = widget.price.replaceAll(RegExp(r'[^\d.]'), '');
      final price = double.tryParse(numericPrice) ?? 0.0;

      debugPrint(
        'Adding item to cart: ${widget.title}, Price: $price, Qty: $quantity',
      );

      final cartRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('cart');

      // Check for existing item with same productId
      final existingItem =
          await cartRef
              .where('productId', isEqualTo: widget.productId)
              .limit(1)
              .get();

      if (existingItem.docs.isNotEmpty) {
        debugPrint('Updating existing cart item');
        await cartRef.doc(existingItem.docs.first.id).update({
          'quantity': FieldValue.increment(quantity),
          'updatedAt': FieldValue.serverTimestamp(),
          'price': price, // Update price in case it changed
        });
      } else {
        debugPrint('Creating new cart item');
        await cartRef.add({
          'productId': widget.productId,
          'title': widget.title,
          'price': price,
          'imageUrl': widget.image,
          'description': widget.subtitle,
          'quantity': quantity,
          'addedAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added $quantity ${widget.title} to cart'),
          duration: const Duration(seconds: 2),
        ),
      );
    } on FirebaseException catch (e) {
      debugPrint('Firebase error: ${e.code} - ${e.message}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to add to cart: ${e.message ?? 'Unknown Firebase error'}',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      debugPrint('Unexpected error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() => isAddingToCart = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: const Color(0xFF00D09E),
      body: SafeArea(
        child: Column(
          children: [
            // Header with back button and title
            Padding(
              padding: EdgeInsets.only(top: screen.height * 0.02),
              child: Stack(
                children: [
                  Center(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.arrow_back, color: Color(0xFF00D09E)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Main content area
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
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screen.width * 0.05,
                        vertical: screen.height * 0.03,
                      ),
                      child:
                          isLandscape
                              ? _buildLandscapeLayout(constraints)
                              : _buildPortraitLayout(screen),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(BoxConstraints constraints) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Product image in landscape
        Expanded(
          flex: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              widget.image,
              fit: BoxFit.cover,
              height: constraints.maxHeight * 0.9,
            ),
          ),
        ),
        const SizedBox(width: 20),

        // Product details in landscape
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: _buildProductDetails(isLandscape: true),
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitLayout(Size screen) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Product image in portrait
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              widget.image,
              fit: BoxFit.cover,
              height: screen.height * 0.3,
            ),
          ),
          const SizedBox(height: 20),

          // Product details in portrait
          _buildProductDetails(),
        ],
      ),
    );
  }

  Widget _buildProductDetails({bool isLandscape = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLandscape ? 16 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Price and quantity selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.price,
                style: const TextStyle(
                  color: Color(0xFF00D09E),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  // Decrease quantity button
                  GestureDetector(
                    onTap: () {
                      if (quantity > 1) {
                        setState(() {
                          quantity--;
                        });
                      }
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor:
                          quantity > 1
                              ? const Color(0xFF00D09E)
                              : Colors.grey.shade400,
                      child: const Icon(
                        Icons.remove,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Quantity display
                  Text(
                    quantity.toString(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Increase quantity button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        quantity++;
                      });
                    },
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: Color(0xFF00D09E),
                      child: Icon(Icons.add, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Rating display
          Row(
            children: [
              const Icon(Icons.star, color: Colors.orange, size: 20),
              const SizedBox(width: 5),
              Text(
                widget.rating,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Product title
          Text(
            widget.title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // Product description
          Text(
            widget.subtitle,
            style: const TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          // Add to cart button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00D09E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
              ),
              onPressed: isAddingToCart ? null : addToCart,
              child:
                  isAddingToCart
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                        'Add to Cart',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
