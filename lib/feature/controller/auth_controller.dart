import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:jimamu/constant/api_path.dart';
import 'package:jimamu/feature/model/user_profile-model.dart';
import 'package:jimamu/feature/view/auth/otp_screen.dart';
import 'package:jimamu/feature/view/home/view/home_screen.dart';
import 'package:jimamu/utils/service/api_request.dart';
import 'package:path_provider/path_provider.dart';
import '../../config/routing/all_route.dart';
import '../../constant/local_string.dart';
import '../../utils/ui/custom_loading.dart';
import '../model/token.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

import '../model/update_rider_data_model.dart';
import '../view/account/view/screens/update_user_profile_screen.dart';

class AuthController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController photoUrlController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  Rx<UserProfileDataModel> userProfileDataModel = Rx(UserProfileDataModel());

  var userCredential = Rxn<UserCredential>();
  var peapleApiData;
  File? imageFile;

  // Hive Box
  final Box<Token> tokenBox = Hive.box<Token>(LocalString.TOKEN_BOX);
  final Box<UserProfileDataModel> userProfileBox =
      Hive.box<UserProfileDataModel>(LocalString.USER_PROFILE_BOX);
  final Box<UpdateRiderDataModel> riderBox =
      Hive.box<UpdateRiderDataModel>(LocalString.RIDER_PROFILE_BOX);

  UserProfileDataModel get userProfile =>
      userProfileBox.get('user') ?? UserProfileDataModel();
  UpdateRiderDataModel get riderProfile =>
      riderBox.get('rider') ?? UpdateRiderDataModel();

  final box = GetStorage();
  RxBool isLoadedUserData = RxBool(false);

  RxString otp = RxString('');
  RxBool isLogging = RxBool(false);
  RxBool isUpdateProfile = RxBool(false);

  sendOtp() {
    CustomLoading.loadingDialog();
    var body = jsonEncode({"email": emailController.text});
    ApiRequest apiRequest =
        ApiRequest(url: ApiPath.sendEmailOtpUrl, body: body);
    apiRequest.postRequest(isLoadingScreen: false).then((res) {
      Get.back();
      if (res!.statusCode == 200) {
        box.write('email', emailController.text);
        Fluttertoast.showToast(msg: jsonDecode(res.body)["message"]);
        Get.to(() => OtpScreen());
      } else {
        Get.back();
        Fluttertoast.showToast(msg: jsonDecode(res.body)["message"]);
      }
    }).catchError((e) {
      Get.back();
      Fluttertoast.showToast(msg: "Something went wrong");
    });
  }

  verifyOtp() {
    CustomLoading.loadingDialog();
    var body = jsonEncode({"email": box.read('email'), "otp_code": otp.value});

    ApiRequest apiRequest =
        ApiRequest(url: ApiPath.emailOtpVerifyUrl, body: body);
    apiRequest.postRequest(isLoadingScreen: false).then((res) async {
      if (res!.statusCode == 200) {
        Token token = Token.fromJson(jsonDecode(res.body));
        if (token.success == true) {
          tokenBox.put('token', token);

          /// 👇 Now fetch full profile first
          await getUserProfileData(isVerify: true);
        } else {
          Get.back();
          Fluttertoast.showToast(msg: jsonDecode(res.body)["message"]);
        }
      } else {
        Get.back();
        Fluttertoast.showToast(msg: jsonDecode(res.body)["message"]);
      }
    }).catchError((e) {
      Get.back();
      Fluttertoast.showToast(msg: "Something went wrong");
    });
  }

  Future<bool> handleGoogleSignIn() async {
    final user = await GoogleSignIn(scopes: [
      'email',
      'profile',
      'https://www.googleapis.com/auth/user.birthday.read',
      'https://www.googleapis.com/auth/user.gender.read',
    ]).signIn();

    GoogleSignInAuthentication googleAuth = await user!.authentication;

    final accessToken = googleAuth.accessToken;

    final response = await http.get(
      Uri.parse(
          'https://people.googleapis.com/v1/people/me?personFields=genders,birthdays'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      peapleApiData = jsonDecode(response.body);
    }

    // Credential
    AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    userCredential.value =
        await FirebaseAuth.instance.signInWithCredential(credential);

    return FirebaseAuth.instance.currentUser != null;
  }

  handleSocialLogin(BuildContext context) async {
    CustomLoading.loadingDialog();
    try {
      // 2. Use user info from Firebase
      var name = userCredential.value?.user?.displayName ?? '';
      var email = userCredential.value?.user?.email ?? '';
      var gender = 'male';
      var dob = '1996-10-25';
      var userType = 'user';

      if (peapleApiData != null || peapleApiData != '') {
        gender = '${peapleApiData['genders'][0]['formattedValue']}';
        dob =
            '${peapleApiData['birthdays'][0]['date']['year']}-${peapleApiData['birthdays'][0]['date']['month']}-${peapleApiData['birthdays'][0]['date']['day']}';
      }
      late File imageFile;
      if (userCredential.value!.user!.photoURL != null &&
          userCredential.value!.user!.photoURL!.isNotEmpty) {
        // Load image from network
        final photoURL =
            await http.get(Uri.parse(userCredential.value!.user!.photoURL!));
        final tempDir = await getTemporaryDirectory();
        final fileName = path.basename(userCredential.value!.user!.photoURL!);
        final filePath = path.join(tempDir.path, fileName);
        // Write bytes to file
        imageFile = File(filePath);
        await imageFile.writeAsBytes(photoURL.bodyBytes);
      } else {
        // Use local asset image
        final byteData = await rootBundle.load('assets/auth/profile.png');
        final tempDir = await getTemporaryDirectory();
        imageFile = File('${tempDir.path}/profile.png');
        await imageFile.writeAsBytes(byteData.buffer.asUint8List());
      }
      // 4. Prepare and send request
      final uri = Uri.parse('${ApiPath.baseUrl}${ApiPath.socialLoginUrl}');
      //
      final request = http.MultipartRequest('POST', uri)
        ..fields['name'] = name
        ..fields['email'] = email
        ..fields['gender'] = gender
        ..fields['dob'] = dob
        ..fields['user_type'] = userType
        ..files.add(
            await http.MultipartFile.fromPath('profile_image', imageFile.path));
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      // final data = jsonDecode(responseBody);
      Token token = Token.fromJson(jsonDecode(responseBody));
      if (token.success == true) {
        Get.back();
        tokenBox.put('token', token);
        getUserProfileData();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(token.message ?? "Login success")),
        );

        Get.offAll(HomeScreen());
      } else {
        Get.back();
        print("FULL ERROR: $token");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(token.message ?? 'Something went wrong')),
        );
      }
    } catch (e) {
      Get.back();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  updateUserProfile(BuildContext context) async {
    Token? token = tokenBox.get('token');
    CustomLoading.loadingDialog();
    try {
      if (imageFile == null) {
        final byteData = await rootBundle.load('assets/auth/profile.png');
        final tempDir = await getTemporaryDirectory();
        imageFile = File('${tempDir.path}/profile.png');
        await imageFile!.writeAsBytes(byteData.buffer.asUint8List());
      }

      final uri =
          Uri.parse('${ApiPath.baseUrl}${ApiPath.updateUserProfileDataUrl}');
      final request = http.MultipartRequest('POST', uri)
        ..fields['name'] = nameController.text
        ..fields['email'] = emailController.text
        ..fields['gender'] = genderController.text
        ..fields['dob'] = dobController.text
        ..fields['phone_number'] = phoneController.text
        ..fields['_method'] = "put";

      request.headers.addAll({
        'Access-Control-Allow-Origin': '*',
        'Authorization': 'Bearer ${token!.data!.token}',
      });

      if (imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
            'profile_image', imageFile!.path));
      }

      var sendRequest = await request.send();
      var response = await http.Response.fromStream(sendRequest);
      final responseData = json.decode(response.body);

      userProfileDataModel.value = UserProfileDataModel.fromJson(responseData);

      updateUserData();

      if (response.statusCode == 200) {
        userProfileBox.put('user', userProfileDataModel.value);
        Get.back();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(userProfileDataModel.value.message ?? "Update success")),
        );
        Get.offAll(HomeScreen());
      } else {
        Get.back();
        print("FULL ERROR: ${userProfileDataModel.value}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(userProfileDataModel.value.message ??
                  'Something went wrong')),
        );
      }
    } catch (e) {
      Get.back();
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  Future<void> getUserProfileData({bool isVerify = false}) async {
    isLoadedUserData.value = true;
    try {
      final apiRequest = ApiRequest(url: ApiPath.getUserProfileDataUrl);
      final res = await apiRequest.getRequestWithAuth();
      isLoadedUserData.value = false;

      if (res != null && res.statusCode == 200) {
        final userData = UserProfileDataModel.fromJson(jsonDecode(res.body));
        userProfileDataModel.value = userData;
        userProfileBox.put('user', userData);
        updateUserData();

        bool isProfileComplete =
            userData.data?.phoneNumber?.isNotEmpty == true &&
                userData.data?.gender?.isNotEmpty == true &&
                userData.data?.dob?.isNotEmpty == true;

        /// 👇 Now do the redirection
        if (isVerify) {
          if (userData.data?.status == 'active' && isProfileComplete) {
            Get.offAll(HomeScreen());
          } else {
            Get.offAll(UpdateUserProfileScreen());
          }
        }
      }
    } catch (e) {
      isLoadedUserData.value = false;
      print("Profile fetch error: $e");
    }
  }

  updateUserData() {
    nameController.text = userProfileDataModel.value.data?.name ?? "";
    emailController.text = userProfileDataModel.value.data?.email ?? "";
    dobController.text = userProfileDataModel.value.data?.dob ?? "";
    photoUrlController.text =
        userProfileDataModel.value.data?.profileImage ?? "";
    phoneController.text = userProfileDataModel.value.data?.phoneNumber ?? "";
    genderController.text = userProfileDataModel.value.data?.gender ?? "";
  }

  Stream<bool> checkLogging() async* {
    var res = false;
    if (tokenBox.isEmpty) {
      res = false;
    } else {
      if (tokenBox.get('token')?.data?.token != null) {
        res = true;
      }
    }
    yield res;
  }

  Stream<bool> checkUpdateUser() async* {
    var res = false;
    if (tokenBox.isEmpty) {
      res = false;
    } else {
      if (tokenBox.get('token')?.data?.token != null) {
        if (tokenBox.get('token')?.data?.status == "active") {
          res = true;
        } else {
          res = false;
        }
      }
    }
    yield res;
  }

  signOut() async {
    await tokenBox.clear();
    await userProfileBox.clear();
    await riderBox.clear();
    box.remove('email');
    await signOutFromGoogle();
    Get.offAllNamed(AllRouters.LOGIN_PAGE);
  }

  Future<void> signOutFromGoogle() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      // Check if user is signed in
      final User? user = auth.currentUser;

      if (user != null) {
        // Check if user signed in using Google
        final isGoogle =
            user.providerData.any((info) => info.providerId == 'google.com');

        // If Google sign in, sign out from Google as well
        if (isGoogle) {
          await googleSignIn
              .signOut(); // or disconnect() if you want to revoke access
        }

        // Sign out from Firebase
        await auth.signOut();

        print("User signed out successfully.");
      } else {
        print("No user is currently signed in.");
      }
    } catch (e) {
      print("Error during sign out: $e");
    }
  }

  @override
  void onInit() {
    super.onInit();
    isLogging.bindStream(checkLogging());
    isUpdateProfile.bindStream(checkUpdateUser());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
