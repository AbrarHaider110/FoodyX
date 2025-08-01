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
  bool isLoading = false;
  File? profileImage;
  String? imageUrl;
  final userId = FirebaseAuth.instance.currentUser?.uid;
  Map<String, dynamic> userData = {
    'fullName': '',
    'userName': '',
    'contact': '',
    'email': '',
  };
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    if (userId != null) {
      _fetchUserProfile();
    }
  }

  void _initializeControllers() {
    _controllers['fullName'] = TextEditingController();
    _controllers['userName'] = TextEditingController();
    _controllers['contact'] = TextEditingController();
    _controllers['email'] = TextEditingController();
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
            _updateControllers();
          });
        }

        try {
          final ref = FirebaseStorage.instance.ref().child(
            'profileImages/$userId.jpg',
          );
          imageUrl = await ref.getDownloadURL();
          setState(() {}); // refresh image
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
          await Future.delayed(
            Duration(seconds: 2 * attempt),
          ); // exponential backoff
        }
      } finally {
        setState(() => isLoading = false);
      }
    }
  }

  void _updateControllers() {
    _controllers['fullName']?.text = userData['fullName'] ?? '';
    _controllers['userName']?.text = userData['userName'] ?? '';
    _controllers['contact']?.text = userData['contact'] ?? '';
    _controllers['email']?.text =
        userData['email'] ?? FirebaseAuth.instance.currentUser?.email ?? '';
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

        break; // success
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

  Future<void> _updateField(String field) async {
    if (userId == null) return;
    final newValue = _controllers[field]?.text.trim() ?? '';
    if (newValue.isEmpty) return;

    setState(() => isLoading = true);
    const maxRetries = 3;
    int attempt = 0;

    while (attempt < maxRetries) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(userId).update(
          {field: newValue, 'updatedAt': FieldValue.serverTimestamp()},
        );

        setState(() => userData[field] = newValue);
        break; // success
      } catch (e) {
        attempt++;
        if (attempt >= maxRetries) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Update failed: ${e.toString()}')),
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
                child: const Text('No', style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00D09E),
                ),
                child: const Text('Yes', style: TextStyle(color: Colors.white)),
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

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildEditableField(String label, String field) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                TextField(
                  controller: _controllers[field],
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  onSubmitted: (_) => _updateField(field),
                ),
                const Divider(height: 20, thickness: 1),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF00D09E), size: 20),
            onPressed: () => _updateField(field),
          ),
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
                              _buildEditableField("Full Name", 'fullName'),
                              _buildEditableField("Username", 'userName'),
                              _buildEditableField("Contact", 'contact'),
                              _buildEditableField("Email", 'email'),
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
