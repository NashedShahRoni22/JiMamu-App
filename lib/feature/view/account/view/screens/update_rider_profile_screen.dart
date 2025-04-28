import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jimamu/feature/controller/user_controller.dart';
import '../../../../../constant/color_path.dart';
import '../../../../../constant/global_typography.dart';
import '../../../../../utils/ui/custom_loading.dart';

class UpdateRiderProfileAccount extends StatefulWidget {

  const UpdateRiderProfileAccount({super.key});

  @override
  State<UpdateRiderProfileAccount> createState() =>
      _UpdateRiderProfileAccountState();
}

class _UpdateRiderProfileAccountState extends State<UpdateRiderProfileAccount> {
  final UserController _userController=Get.put(UserController());
  final _formKey = GlobalKey<FormState>();

  // File? _image;
  File? _croppedFile;

  String? selectedDocType;
  bool isDefaultPayment = false;

  final _docNumberController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expDateController = TextEditingController();
  final _cvvController = TextEditingController();




  Future<void> _pickFontImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _userController.fontFile = File(pickedFile.path);
      });

    }
  }

  Future<void> _pickBackImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _userController.backSideFile = File(pickedFile.path);
      });

    }
  }

  Future<void> _pickOtherImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _userController.otherFile = File(pickedFile.path);
      });

    }
  }


  @override
  void dispose() {
    _docNumberController.dispose();
    _cardNumberController.dispose();
    _expDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).colorScheme.surface: Colors.white,
      appBar: AppBar(
        backgroundColor: ColorPath.flushMahogany,
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

      body: GetX<UserController>(
        init: UserController(),
        initState: (state) {
          state.controller!.getRiderProfileData();
        },
        builder: (_) {
          return _.isLoadedUserData.isTrue?CustomLoading.loadingScreen(): SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile avatar
              //   Stack(
              //   alignment: Alignment.topCenter,
              //   children: [
              //     Stack(
              //       alignment: Alignment.bottomRight,
              //       children: [
              //         Stack(
              //           alignment: Alignment.center,
              //           children: [
              //             CircleAvatar(
              //               radius: 68,
              //               backgroundColor: Colors.white,
              //               backgroundImage: _userController.imageFile != null
              //                   ? _croppedFile !=null? FileImage(_croppedFile!):const AssetImage('assets/auth/profile.png')
              //                   : const AssetImage('assets/auth/profile.png'),
              //             ),
              //           ],
              //         ),
              //         GestureDetector(
              //           onTap: _pickImage,
              //           child: Stack(
              //             alignment: Alignment.center,
              //             children: [
              //               Container(
              //                 padding: const EdgeInsets.all(12),
              //                 decoration: const BoxDecoration(
              //                   shape: BoxShape.circle,
              //                   color: Colors.white,
              //                 ),
              //                 child: Image.asset('assets/auth/edit.png'),
              //               ),
              //               Container(
              //                 padding: const EdgeInsets.all(10),
              //                 decoration: BoxDecoration(
              //                   shape: BoxShape.circle,
              //                   color: ColorPath.flushMahogany,
              //                 ),
              //                 child: Image.asset('assets/auth/edit.png'),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   ],
              // ),
              //     const SizedBox(height: 32),

                  // Dropdown
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Select Document Type",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: selectedDocType,
                    items: ['Passport', 'ID Card', 'Driver License']
                        .map((type) =>
                            DropdownMenuItem(value: type, child: Text(type)))
                        .toList(),
                    onChanged: (val) {
                      setState(() {
                        selectedDocType = val;

                        if(selectedDocType=='Passport'){
                          _userController.fontFile=null;
                          _userController.backSideFile=null;
                          _userController.docTypeController.text='passport';
                        }else if(selectedDocType=='ID Card'){
                          _userController.otherFile=null;
                          _userController.docTypeController.text='nid';
                        }else if(selectedDocType=='Driver License'){
                          _userController.fontFile=null;
                          _userController.backSideFile=null;
                          _userController.docTypeController.text='driving_licence';
                        }
                      });

                      print(_userController.docTypeController.text);
                    },
                    decoration: InputDecoration(
                      hintText: "Types",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Document number
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Enter Document Number",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller:_userController.docNumberController,
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if(val.toString().isNotEmpty){
                        if(_userController.docTypeController.text=='nid'){
                          if(val.toString().length==10 || val.toString().length==13){
                            return null;
                          }else{
                            return 'Enter valid nid';
                          }
                        }else{
                          return null;
                        }
                      }else{
                        return 'Required Field';
                      }

                    },
                    decoration: InputDecoration(
                      hintText: "Type here",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Upload box
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Document Image",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 12),

                  SizedBox(
                    height: 120,
                    child:_userController.docTypeController.text=='nid'?
                    Row(
                      children: [


                      Expanded(
                          child: FormField<File>(
                            validator: (value) {
                              if (_userController.fontFile == null) {
                                return 'Please select a font image';
                              }
                              return null;
                            },
                            builder: (FormFieldState<File> state) {
                              return GestureDetector(
                                onTap: () {
                                  _pickFontImage();
                                },
                                child: _userController.fontFile != null
                                    ? Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: FileImage(_userController.fontFile!),
                                    ),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                )
                                    : Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: state.hasError ? Colors.red : Colors.grey, // show red if error
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.cloud_upload_outlined,
                                          color: ColorPath.flushMahogany, size: 32),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Select Font",
                                        style: TextStyle(
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.white
                                              : Colors.black54,
                                        ),
                                      ),
                                      if (state.hasError)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8),
                                          child: Text(
                                            state.errorText ?? '',
                                            style: TextStyle(color: Colors.red, fontSize: 12),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                        ),
                      SizedBox(width: 10),
                      Expanded(
                          child:  FormField<File>(
                            validator: (value) {
                              if (_userController.backSideFile == null) {
                                return 'Please select a back image';
                              }
                              return null;
                            },
                            builder: (FormFieldState<File> state) {
                              return GestureDetector(
                                onTap: () {
                                  _pickBackImage();
                                },
                                child: _userController.backSideFile != null
                                    ? Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: FileImage(_userController.backSideFile!),
                                    ),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                )
                                    : Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: state.hasError ? Colors.red : Colors.grey, // show red if error
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.cloud_upload_outlined,
                                          color: ColorPath.flushMahogany, size: 32),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Select Font",
                                        style: TextStyle(
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? Colors.white
                                              : Colors.black54,
                                        ),
                                      ),
                                      if (state.hasError)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8),
                                          child: Text(
                                            state.errorText ?? '',
                                            style: TextStyle(color: Colors.red, fontSize: 12),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                      )
                      ],
                    ):
                    FormField<File>(
                      validator: (value) {
                        if (_userController.otherFile == null) {
                          return 'Please select a font image';
                        }
                        return null;
                      },
                      builder: (FormFieldState<File> state) {
                        return GestureDetector(
                          onTap: () {
                            _pickOtherImage();
                          },
                          child: _userController.otherFile != null
                              ? Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: FileImage(_userController.otherFile!),
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          )
                              : Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: state.hasError ? Colors.red : Colors.grey, // show red if error
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.cloud_upload_outlined,
                                    color: ColorPath.flushMahogany, size: 32),
                                const SizedBox(height: 8),
                                Text(
                                  "Select your file",
                                  style: TextStyle(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black54,
                                  ),
                                ),
                                if (state.hasError)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      state.errorText ?? '',
                                      style: TextStyle(color: Colors.red, fontSize: 12),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 10,),
                  // GestureDetector(
                  //   child: Container(
                  //     height: 140,
                  //     width: double.infinity,
                  //     decoration: BoxDecoration(
                  //       border: Border.all(
                  //         color: Colors.grey,
                  //       ),
                  //       borderRadius: BorderRadius.circular(12),
                  //     ),
                  //     child: Column(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         Icon(Icons.cloud_upload_outlined,
                  //             color: ColorPath.flushMahogany, size: 32),
                  //         const SizedBox(height: 8),
                  //          Text("Select Font",
                  //             style: TextStyle(color:Theme.of(context).brightness == Brightness.dark
                  //                 ?  Colors.white: Colors.black54)),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(height: 24),

                  // Bank info section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Bank Information",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).colorScheme.surface: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                        validator: (value) {
                             if (value == null || value.isEmpty) {
                             return 'This field is required';
                                 }
                                return null;
                                },
                          controller:_userController.cardNumberController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Card Number",
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This field is required';
                                  }
                                  return null;
                                },
                                controller:_userController.expireDateController,
                                decoration: const InputDecoration(
                                  labelText: "Exp Date",
                                  hintText: "DD/MM",
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'This field is required';
                                  }
                                  return null;
                                },
                                controller: _userController.cvcNumberController,
                                decoration: const InputDecoration(
                                  labelText: "CVV Code",
                                  hintText: "000",
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        CheckboxListTile(
                          value: isDefaultPayment,
                          onChanged: (val) {
                            setState(() {
                              isDefaultPayment = val ?? false;
                              _userController.isDefault.value=isDefaultPayment;
                            });
                          },
                          title: const Text("Set as your default payment method"),
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                          activeColor: ColorPath.flushMahogany,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // _userController.updateUserProfile(context);
                          if(_formKey.currentState!.validate()){
                            _userController.updateUserProfile(context);
                          }
                        });

                        // Handle submit
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorPath.flushMahogany,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child:
                          const Text("Submit", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}
