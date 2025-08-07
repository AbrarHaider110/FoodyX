import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _shippingAddress = "Fetching location...";
  bool _isLoading = true;

  final Color _primaryColor = Color(0xFF00C896); // green from login screen
  final Color _textColor = Color(0xFF303030);
  final Color _secondaryTextColor = Color(0xFF7A7A7A);

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      final status = await Permission.location.request();
      if (status.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark place = placemarks.first;
          setState(() {
            _shippingAddress =
                "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}";
            _isLoading = false;
          });
        } else {
          setState(() {
            _shippingAddress = "Location found, but address unavailable.";
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _shippingAddress = "Location permission denied.";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _shippingAddress = "Error fetching location: ${e.toString()}";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 16),
            Text(
              'Payment',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle('Shipping Address'),
                      SizedBox(height: 12),
                      _buildCard(
                        child:
                            _isLoading
                                ? Center(
                                  child: CircularProgressIndicator(
                                    color: _primaryColor,
                                  ),
                                )
                                : Text(
                                  _shippingAddress,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: _textColor,
                                  ),
                                ),
                      ),
                      SizedBox(height: 24),
                      _buildSectionTitle('Order Summary'),
                      SizedBox(height: 12),
                      _buildCard(
                        child: Column(
                          children: [
                            _buildDetailRow('Product A:', '2 items'),
                            SizedBox(height: 8),
                            _buildDetailRow('Product B:', '1 item'),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      _buildSectionTitle('Payment Method'),
                      SizedBox(height: 12),
                      _buildCard(
                        child: _buildDetailRow('Code Card:', '48,780,000'),
                      ),
                      SizedBox(height: 24),
                      _buildSectionTitle('Delivery Time'),
                      SizedBox(height: 12),
                      _buildCard(
                        child: _buildDetailRow(
                          'Estimated Delivery:',
                          '25 mins',
                        ),
                      ),
                      SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // Confirm payment logic
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
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
                      SizedBox(height: 16),
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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF2FFF9), // soft green background like login
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 16, color: _secondaryTextColor)),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: _textColor,
          ),
        ),
      ],
    );
  }
}
