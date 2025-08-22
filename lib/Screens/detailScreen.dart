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
  final primaryColor = const Color(0xFF00D09E);

  Future<void> addToCart() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      showLoginPrompt();
      return;
    }
    if (isAddingToCart) return;

    setState(() => isAddingToCart = true);

    try {
      final price = convertPriceToDouble(widget.price);
      await updateOrCreateCartItem(userId, price);

      if (!mounted) return;

      setState(() => isAddingToCart = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${widget.title} added to the cart'),
          backgroundColor: primaryColor,
          duration: const Duration(seconds: 2),
        ),
      );

      Navigator.of(
        context,
      ).pop({'added': true, 'qty': quantity, 'title': widget.title});
    } on FirebaseException catch (e) {
      if (mounted) {
        setState(() => isAddingToCart = false);
        showErrorMessage(e);
      }
    } catch (e) {
      if (mounted) {
        setState(() => isAddingToCart = false);
        showErrorMessage(e);
      }
    }
  }

  double convertPriceToDouble(String priceString) {
    try {
      final numericString = priceString.replaceAll(RegExp(r'[^0-9.]'), '');
      final parts = numericString.split('.');
      String normalizedString;
      if (parts.length > 1) {
        normalizedString = '${parts[0]}.${parts.sublist(1).join()}';
      } else {
        normalizedString = numericString;
      }
      final result = double.tryParse(normalizedString);
      if (result == null) throw FormatException('Could not parse price');
      return result;
    } catch (e) {
      return 0.0;
    }
  }

  Future<void> updateOrCreateCartItem(String userId, double price) async {
    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('cart');
    final existingItem =
        await cartRef
            .where('productId', isEqualTo: widget.productId)
            .limit(1)
            .get();
    if (existingItem.docs.isNotEmpty) {
      await cartRef.doc(existingItem.docs.first.id).update({
        'quantity': FieldValue.increment(quantity),
        'updatedAt': FieldValue.serverTimestamp(),
        'price': price,
      });
    } else {
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
  }

  void showLoginPrompt() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Please login to add items to cart'),
        action: SnackBarAction(label: 'Login', onPressed: () {}),
      ),
    );
  }

  void showErrorMessage(dynamic error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                error is FirebaseException
                    ? error.message ?? 'Failed to add to cart'
                    : 'An error occurred',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(screen),
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
                    isLandscape
                        ? _buildLandscapeLayout(screen)
                        : _buildPortraitLayout(screen),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Size screen) {
    return Padding(
      padding: EdgeInsets.only(top: screen.height * 0.02, left: 16, right: 16),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Align(
            alignment: Alignment.centerLeft,
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
    );
  }

  Widget _buildLandscapeLayout(Size screen) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                widget.image,
                fit: BoxFit.contain,
                height: screen.height * 0.6,
              ),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: _buildProductDetails(),
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitLayout(Size screen) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                widget.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: screen.height * 0.3,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildProductDetails(),
          ),
        ],
      ),
    );
  }

  Widget _buildProductDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            _buildQuantitySelector(),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.orange, size: 20),
            const SizedBox(width: 5),
            Text(
              widget.rating,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          widget.title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          widget.subtitle,
          style: const TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
            ),
            onPressed: isAddingToCart ? null : addToCart,
            child:
                isAddingToCart
                    ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : const Text(
                      'Add to Cart',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              Icons.remove,
              color: quantity > 1 ? primaryColor : Colors.grey,
            ),
            onPressed: () {
              if (quantity > 1) {
                setState(() => quantity--);
              }
            },
          ),
          Text(
            quantity.toString(),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: Icon(Icons.add, color: primaryColor),
            onPressed: () => setState(() => quantity++),
          ),
        ],
      ),
    );
  }
}
