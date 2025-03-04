import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//images/Ellipse 1.png
// class ProfilePicture extends StatefulWidget {
//   @override
//   _ProfilePictureState createState() => _ProfilePictureState();
// }
//
// class _ProfilePictureState extends State<ProfilePicture> {
//   File? _image;
//   final ImagePicker _picker = ImagePicker();
//
//   Future<void> _pickImage(ImageSource source) async {
//     final pickedFile = await _picker.pickImage(source: source);
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return
//         CircleAvatar(
//           radius: 50,
//           backgroundColor: Colors.grey[300],
//           backgroundImage: _image != null ? FileImage(_image!) : null,
//           child: _image == null
//               ? Icon(Icons.person, size: 50, color: Colors.white)
//               : null,
//
//     );
//   }
// }
