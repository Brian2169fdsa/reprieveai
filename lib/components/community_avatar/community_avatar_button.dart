import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '/flutter_flow/flutter_flow_theme.dart';

class CommunityAvatarButton extends StatefulWidget {
  const CommunityAvatarButton({super.key});

  @override
  State<CommunityAvatarButton> createState() => _CommunityAvatarButtonState();
}

class _CommunityAvatarButtonState extends State<CommunityAvatarButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  String? _profileImageUrl;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _loadProfileImage();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadProfileImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists && mounted) {
        setState(() {
          _profileImageUrl = doc.data()?['profileImageUrl'] as String?;
        });
      }
    } catch (e) {
      debugPrint('Error loading profile image: $e');
    }
  }

  Future<void> _showUploadOptions() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Upload new photo'),
              onTap: () {
                Navigator.pop(context);
                _uploadImage();
              },
            ),
            if (_profileImageUrl != null)
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text('Remove photo'),
                onTap: () {
                  Navigator.pop(context);
                  _removeImage();
                },
              ),
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text('Cancel'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 85,
      );

      if (image == null) return;

      setState(() => _isLoading = true);

      // Upload to Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${user.uid}.jpg');

      final uploadTask = await storageRef.putFile(File(image.path));
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      // Update Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({'profileImageUrl': downloadUrl}, SetOptions(merge: true));

      if (mounted) {
        setState(() {
          _profileImageUrl = downloadUrl;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile image updated')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to upload image. Please try again.'),
          ),
        );
      }
    }
  }

  Future<void> _removeImage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      setState(() => _isLoading = true);

      // Delete from Storage
      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('${user.uid}.jpg');
        await storageRef.delete();
      } catch (e) {
        // File might not exist, continue anyway
      }

      // Clear Firestore field
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'profileImageUrl': FieldValue.delete()});

      if (mounted) {
        setState(() {
          _profileImageUrl = null;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile image removed')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to remove image. Please try again.'),
          ),
        );
      }
    }
  }

  void _navigateToCommunity() {
    context.pushNamed('Community');
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isTablet = MediaQuery.of(context).size.width >= 600;
    final size = isTablet ? 48.0 : 42.0;

    return Tooltip(
      message: 'Community',
      child: GestureDetector(
        onTap: user != null && !_isLoading
            ? () {
                _animationController.forward().then((_) {
                  _animationController.reverse();
                  _navigateToCommunity();
                });
              }
            : null,
        onLongPress: user != null && !_isLoading ? _showUploadOptions : null,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.shade300,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipOval(
              child: _isLoading
                  ? Container(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : _profileImageUrl != null
                      ? Image.network(
                          _profileImageUrl!,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              child: const Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                              child: Icon(
                                Icons.person,
                                size: size * 0.6,
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                            );
                          },
                        )
                      : Container(
                          color: FlutterFlowTheme.of(context)
                              .secondaryBackground,
                          child: Icon(
                            Icons.person,
                            size: size * 0.6,
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                        ),
            ),
          ),
        ),
      ),
    );
  }
}
