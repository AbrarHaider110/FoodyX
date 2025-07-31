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
  final fullNameController = TextEditingController();
  final userNameController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  File? profileImage;
  String? imageUrl;
  bool imageChanged = false;

  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    fetchUserProfile();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    userNameController.dispose();
    contactController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> fetchUserProfile() async {
    setState(() => isLoading = true);
    try {
      // Fetch user data from Firestore
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;
        // Set controller values with user data
        fullNameController.text =
            data['fullName'] ??
            FirebaseAuth.instance.currentUser?.displayName ??
            '';
        userNameController.text = data['userName'] ?? '';
        contactController.text = data['contact'] ?? '';
        emailController.text =
            data['email'] ?? FirebaseAuth.instance.currentUser?.email ?? '';
        passwordController.text = data['password'] ?? '';
      }

      // Try to fetch profile image from Storage
      try {
        final ref = FirebaseStorage.instance.ref().child(
          'profileImages/$userId.jpg',
        );
        imageUrl = await ref.getDownloadURL();
      } catch (e) {
        // No image exists, use default
        imageUrl = null;
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching profile: $e')));
    }
    setState(() => isLoading = false);
  }

  Future<void> handleChange() async {
    setState(() => isLoading = true);
    try {
      // Update user data in Firestore
      final data = {
        'fullName': fullNameController.text,
        'userName': userNameController.text,
        'contact': contactController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set(data, SetOptions(merge: true));

      if (imageChanged) {
        final ref = FirebaseStorage.instance.ref().child(
          'profileImages/$userId.jpg',
        );
        if (profileImage != null) {
          await ref.putFile(profileImage!);
          imageUrl = await ref.getDownloadURL();
        } else {
          await ref.delete();
          imageUrl = null;
        }
        setState(() => imageChanged = false);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to update profile: $e')));
    }
    setState(() => isLoading = false);
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
        imageChanged = true;
      });
    }
    Navigator.pop(context);
  }

  void showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from Gallery'),
                  onTap: () => pickImage(ImageSource.gallery),
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take a Photo'),
                  onTap: () => pickImage(ImageSource.camera),
                ),
                if (imageUrl != null || profileImage != null)
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text(
                      'Remove Photo',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () {
                      setState(() {
                        profileImage = null;
                        imageUrl = null;
                        imageChanged = true;
                      });
                      Navigator.pop(context);
                    },
                  ),
              ],
            ),
          ),
    );
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    bool obscure = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          decoration: const InputDecoration(
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
            filled: true,
            fillColor: Color(0xFFDFF7E2),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: const Color(0xFF00D09E),
        width: screenWidth,
        height: screenHeight,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: screenHeight * 0.09),
              child: const Center(
                child: Text(
                  "Profile",
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.08,
                  vertical: screenHeight * 0.03,
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
                                    width: screenWidth * 0.4,
                                    height: screenWidth * 0.4,
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
                                                width: screenWidth * 0.4,
                                                height: screenWidth * 0.4,
                                                fit: BoxFit.cover,
                                              )
                                              : imageUrl != null
                                              ? Image.network(
                                                imageUrl!,
                                                width: screenWidth * 0.4,
                                                height: screenWidth * 0.4,
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
                                              )
                                              : Icon(
                                                Icons.person,
                                                size: screenWidth * 0.3,
                                                color: const Color(0xFF00D09E),
                                              ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: showImageSourceActionSheet,
                                      child: Container(
                                        height: 40,
                                        width: 40,
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
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              buildTextField(
                                label: "Full Name",
                                controller: fullNameController,
                              ),
                              buildTextField(
                                label: "Username",
                                controller: userNameController,
                              ),
                              buildTextField(
                                label: "Contact",
                                controller: contactController,
                              ),
                              buildTextField(
                                label: "Email",
                                controller: emailController,
                              ),
                              buildTextField(
                                label: "Password",
                                controller: passwordController,
                                obscure: true,
                              ),
                              SizedBox(height: screenHeight * 0.04),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: handleChange,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF00D09E,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            40,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 15,
                                        ),
                                      ),
                                      child: const Text(
                                        "Change",
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
