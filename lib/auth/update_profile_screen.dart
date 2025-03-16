import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jimamu/global_consts/global_colors.dart';
import 'package:jimamu/global_consts/global_typography.dart';
import 'package:jimamu/home/view/home_screen.dart';

import '../global_widgets/custom_button.dart';

class UpdateProfileScreen extends StatefulWidget {
  static const String id = 'UpdateProfileScreen';
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  File? _image;
  File? _croppedFile;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      _cropImage();
    }
  }

  Future<void> _cropImage() async {
    if (_image != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _image!.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.red,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Crop Image',
            aspectRatioLockEnabled: true,
          )
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _croppedFile = File(croppedFile.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GlobalColors.flushMahogany,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text('Update Profile',
                style:
                    GlobalTypography.sub1Medium.copyWith(color: Colors.white)),
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 32,
              color: GlobalColors.flushMahogany,
              width: double.infinity,
            ),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 71,
                  color: GlobalColors.flushMahogany,
                  width: double.infinity,
                ),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        const CircleAvatar(
                          radius: 72,
                          backgroundColor: Colors.white,
                        ),
                        CircleAvatar(
                          radius: 68,
                          backgroundColor: Colors.white,
                          backgroundImage: _image != null
                              ? FileImage(_croppedFile!)
                              : const AssetImage('assets/auth/profile.png'),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: _pickImage,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: _image != null
                                ? Image.file(_image!)
                                : Image.asset('assets/auth/edit.png'),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: GlobalColors.flushMahogany,
                            ),
                            child: Image.asset('assets/auth/edit.png'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildTextField('Enter Name', 'Mr. Nashed Shah'),
                  const SizedBox(height: 16),
                  _buildTextField('Enter Email', 'nashedshah@gmail.com'),
                  const SizedBox(height: 16),
                  _buildDropdownField('Date of Birth', '30/04/1997'),
                  const SizedBox(height: 16),
                  _buildDropdownField('Select Gender', 'Choose an option'),
                  const SizedBox(height: 32),
                  SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: 'Submit',
                        function: () {
                          Navigator.pushNamed(context, HomeScreen.id);
                        },
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hintText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GlobalTypography.sub1Medium
                .copyWith(color: GlobalColors.balck700)),
        const SizedBox(height: 6),
        TextField(
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: GlobalColors.balck100)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GlobalTypography.sub1Medium
                .copyWith(color: GlobalColors.balck700)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: GlobalColors.balck100),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              icon: Icon(
                Icons.expand_more,
                color: GlobalColors.balck500,
              ),
              value: null,
              hint: Text(value),
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (String? newValue) {},
            ),
          ),
        ),
      ],
    );
  }
}

class CropAspectRatioPresetCustom implements CropAspectRatioPresetData {
  @override
  (int, int)? get data => (2, 3);

  @override
  String get name => '2x3 (customized)';
}
