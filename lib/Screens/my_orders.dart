import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/order_provider.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = const Color(0xFF00D09E);
    final redColor = Colors.red;
    final screenHeight = MediaQuery.of(context).size.height;

    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;

    return Scaffold(
      backgroundColor: primaryColor,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: screenHeight * 0.09),
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
          SizedBox(height: screenHeight * 0.03),
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
              child: Padding(
                padding: const EdgeInsets.all(16),
                child:
                    orders.isEmpty
                        ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.receipt_long,
                                size: 80,
                                color: Colors.teal.shade200,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                "You don’t have any\nactive orders at this time",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          itemCount: orders.length,
                          itemBuilder: (context, index) {
                            final order = orders[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                              margin: const EdgeInsets.only(bottom: 16),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(12),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    order.imageUrl,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  order.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text("Price: \$${order.price}"),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete, color: redColor),
                                  onPressed:
                                      () => orderProvider.removeOrder(order),
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
