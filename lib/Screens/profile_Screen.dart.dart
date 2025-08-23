import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = true; // Start with true to show loading initially
  File? profileImage;
  String? imageUrl;
  final userId = FirebaseAuth.instance.currentUser?.uid;
  Map<String, dynamic> userData = {
    'fullName': '',
    'userName': '',
    'contact': '',
    'email': '',
  };

  @override
  void initState() {
    super.initState();
    if (userId != null) {
      _fetchUserProfile();
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchUserProfile() async {
    setState(() => isLoading = true);
    const maxRetries = 3;
    int attempt = 0;

    while (attempt < maxRetries) {
      try {
        final userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .get();

        if (userDoc.exists) {
          setState(() {
            userData = userDoc.data() as Map<String, dynamic>;
          });
        } else {
          await _createUserDocument();
        }

        // Try to get profile image
        try {
          final ref = FirebaseStorage.instance.ref().child(
            'profileImages/$userId.jpg',
          );
          imageUrl = await ref.getDownloadURL();
        } catch (_) {
          imageUrl = null;
        }

        break; // success
      } catch (e) {
        attempt++;
        if (attempt >= maxRetries) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading profile: ${e.toString()}')),
          );
        } else {
          await Future.delayed(Duration(seconds: 2 * attempt));
        }
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _createUserDocument() async {
    if (userId == null) return;

    final user = FirebaseAuth.instance.currentUser;
    final newUserData = {
      'fullName': user?.displayName ?? '',
      'userName': '',
      'contact': '',
      'email': user?.email ?? '',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set(newUserData);

    setState(() {
      userData = newUserData;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() => profileImage = File(pickedFile.path));
      await _saveProfileImage();
    }
  }

  Future<void> _saveProfileImage() async {
    if (profileImage == null || userId == null) return;
    setState(() => isLoading = true);
    const maxRetries = 3;
    int attempt = 0;

    while (attempt < maxRetries) {
      try {
        final ref = FirebaseStorage.instance.ref().child(
          'profileImages/$userId.jpg',
        );
        await ref.putFile(profileImage!);
        imageUrl = await ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('users').doc(userId).update(
          {'profileImage': imageUrl},
        );

        break;
      } catch (e) {
        attempt++;
        if (attempt >= maxRetries) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image upload failed: ${e.toString()}')),
          );
        } else {
          await Future.delayed(Duration(seconds: 2 * attempt));
        }
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00D09E),
                ),
                child: const Text('Logout'),
              ),
            ],
          ),
    );

    if (shouldLogout == true) {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.isNotEmpty ? value : 'Not set',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const Divider(height: 24, thickness: 1),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        color: const Color(0xFF00D09E),
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.09),
              child: const Text(
                "Profile",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: size.height * 0.04),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.08,
                  vertical: size.height * 0.03,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child:
                    isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : SingleChildScrollView(
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: size.width * 0.4,
                                    height: size.width * 0.4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: const Color(0xFF00D09E),
                                        width: 2,
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child:
                                          profileImage != null
                                              ? Image.file(
                                                profileImage!,
                                                fit: BoxFit.cover,
                                              )
                                              : imageUrl != null
                                              ? Image.network(
                                                imageUrl!,
                                                fit: BoxFit.cover,
                                                loadingBuilder: (
                                                  BuildContext context,
                                                  Widget child,
                                                  ImageChunkEvent?
                                                  loadingProgress,
                                                ) {
                                                  if (loadingProgress == null)
                                                    return child;
                                                  return Center(
                                                    child: CircularProgressIndicator(
                                                      value:
                                                          loadingProgress
                                                                      .expectedTotalBytes !=
                                                                  null
                                                              ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                  loadingProgress
                                                                      .expectedTotalBytes!
                                                              : null,
                                                    ),
                                                  );
                                                },
                                                errorBuilder: (
                                                  BuildContext context,
                                                  Object error,
                                                  StackTrace? stackTrace,
                                                ) {
                                                  return Icon(
                                                    Icons.person,
                                                    size: size.width * 0.3,
                                                    color: const Color(
                                                      0xFF00D09E,
                                                    ),
                                                  );
                                                },
                                              )
                                              : Icon(
                                                Icons.person,
                                                size: size.width * 0.3,
                                                color: const Color(0xFF00D09E),
                                              ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: IconButton(
                                      icon: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          border: Border.all(
                                            color: const Color(0xFF00D09E),
                                            width: 2,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt,
                                          size: 20,
                                          color: Color(0xFF00D09E),
                                        ),
                                      ),
                                      onPressed:
                                          () => _pickImage(ImageSource.gallery),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              _buildInfoRow(
                                "Full Name",
                                userData['fullName'] ?? '',
                              ),
                              _buildInfoRow(
                                "Username",
                                userData['userName'] ?? '',
                              ),
                              _buildInfoRow(
                                "Contact",
                                userData['contact'] ?? '',
                              ),
                              _buildInfoRow("Email", userData['email'] ?? ''),
                              SizedBox(height: size.height * 0.04),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _confirmLogout,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF00D09E),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                    ),
                                  ),
                                  child: const Text(
                                    "Logout",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
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
}
