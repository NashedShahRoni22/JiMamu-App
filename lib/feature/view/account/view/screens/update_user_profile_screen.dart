import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jimamu/constant/color_path.dart';
import 'package:jimamu/feature/controller/auth_controller.dart';
import 'package:jimamu/utils/ui/custom_loading.dart';

import '../../../../../constant/global_typography.dart';
import '../../../../../shared_components/custom_button.dart';

class UpdateUserProfileScreen extends StatefulWidget {
  static const String id = 'UpdateProfileScreen';
  const UpdateUserProfileScreen({super.key});

  @override
  State<UpdateUserProfileScreen> createState() =>
      _UpdateUserProfileScreenState();
}

class _UpdateUserProfileScreenState extends State<UpdateUserProfileScreen> {
  final AuthController _auth = Get.put(AuthController());
  final _formKey = GlobalKey<FormState>();
  // File? _image;
  File? _croppedFile;
  DateTime? _selectedDate;
  String? selectedGender = null;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: ColorPath.flushMahogany, // selected date background
              onPrimary: Colors.white, // selected date text
              onSurface: Colors.black, // default text color
            ),
            dialogBackgroundColor: Colors.white, // background of dialog
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        print(_selectedDate);
        _auth.dobController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _auth.imageFile = File(pickedFile.path);
      _cropImage();
    }
  }

  Future<void> _cropImage() async {
    if (_auth.imageFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: _auth.imageFile!.path,
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
  void initState() {
    super.initState();

    // Safely assign gender
    final gender = _auth.userProfile.data?.gender?.toLowerCase();
    if (gender == 'male' || gender == 'female' || gender == 'other') {
      selectedGender =
          gender![0].toUpperCase() + gender.substring(1); // "male" → "Male"
    }

    // DOB logic
    if (_auth.dobController.text.isNotEmpty) {
      try {
        _selectedDate = DateTime.parse(_auth.dobController.text);
      } catch (_) {
        _selectedDate = DateTime(2000, 1, 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorPath.flushMahogany,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text('Customer Profile',
                style:
                    GlobalTypography.sub1Medium.copyWith(color: Colors.white)),
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: GetX<AuthController>(
          init: AuthController(),
          initState: (state) {
            state.controller!.getUserProfileData();
          },
          builder: (_) {
            return _.isLoadedUserData.isTrue
                ? CustomLoading.loadingScreen()
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 32,
                          color: ColorPath.flushMahogany,
                          width: double.infinity,
                        ),
                        Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              height: 71,
                              color: ColorPath.flushMahogany,
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
                                      backgroundImage: _auth.imageFile != null
                                          ? _croppedFile != null
                                              ? FileImage(_croppedFile!)
                                              : const AssetImage(
                                                  'assets/auth/profile.png')
                                          : _auth.userProfile.data
                                                      ?.profileImage !=
                                                  null
                                              ? NetworkImage(_auth.userProfile
                                                  .data!.profileImage!)
                                              : const AssetImage(
                                                  'assets/auth/profile.png'),
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
                                        child:
                                            Image.asset('assets/auth/edit.png'),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: ColorPath.flushMahogany,
                                        ),
                                        child:
                                            Image.asset('assets/auth/edit.png'),
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
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                _buildTextField(
                                    label: 'Enter Name',
                                    hintText: 'Type  name',
                                    controller: _auth.nameController),
                                const SizedBox(height: 16),
                                _buildTextField(
                                    label: 'Enter Email',
                                    hintText: 'Type email',
                                    controller: _auth.emailController),
                                const SizedBox(height: 16),
                                _buildTextField(
                                    label: 'Enter Phone Number',
                                    hintText: 'Type phone',
                                    controller: _auth.phoneController),
                                const SizedBox(height: 16),
                                _buildDatePickerField(
                                    'Date of Birth', _auth.dobController),
                                const SizedBox(height: 16),
                                _buildDropdownField(
                                    'Select Gender', 'Choose an option'),
                                const SizedBox(height: 32),
                                SizedBox(
                                    width: double.infinity,
                                    child: CustomButton(
                                      text: 'Submit',
                                      function: () {
                                        if (selectedGender == null) {
                                          Get.snackbar('Validation Error',
                                              'Please select a gender',
                                              colorText: Colors.white,
                                              backgroundColor: Colors.red);
                                          return;
                                        }
                                        // Get.to(HomeScreen());
                                        if (_formKey.currentState!.validate()) {
                                          _auth.updateUserProfile(context);
                                        }
                                      },
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
          }),
    );
  }

  Widget _buildDatePickerField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GlobalTypography.sub1Medium
                .copyWith(color: ColorPath.black700)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: AbsorbPointer(
            child: TextFormField(
              controller: controller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: 'Select Date',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: ColorPath.black100)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                suffixIcon: Icon(Icons.calendar_today,
                    color: ColorPath.black500, size: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({label, hintText, controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GlobalTypography.sub1Medium
                .copyWith(color: ColorPath.black700)),
        const SizedBox(height: 6),
        label == 'Enter Email'
            ? InkWell(
                onTap: () {
                  Get.snackbar(
                      'Email change request', 'You can not change your email. ',
                      colorText: Colors.white);
                },
                child: IgnorePointer(
                  child: TextFormField(
                    controller: controller,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'This field is required';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: hintText,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: ColorPath.black100)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                    ),
                  ),
                ),
              )
            : TextFormField(
                controller: controller,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field is required';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: hintText,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: ColorPath.black100)),
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
                .copyWith(color: ColorPath.black700)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: ColorPath.black100),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
            value: selectedGender,
            hint: const Text("Select Gender"),
            isExpanded: true,
            items: const [
              DropdownMenuItem(
                value: null,
                child:
                    Text('Select Gender', style: TextStyle(color: Colors.grey)),
                enabled: false, // Makes this unselectable once changed
              ),
              DropdownMenuItem(value: 'Male', child: Text('Male')),
              DropdownMenuItem(value: 'Female', child: Text('Female')),
              DropdownMenuItem(value: 'Other', child: Text('Other')),
            ],
            onChanged: (value) {
              setState(() {
                selectedGender = value;
                _auth.genderController.text =
                    value ?? ''; // update genderController
              });
            },
          )),
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
