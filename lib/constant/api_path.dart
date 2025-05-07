class ApiPath {
  static const String baseUrl = 'https://jimamu.nsrdev.com/api/v1/';
  static const String baseUrlImage = '';

  /////  Login //////////
  static const String socialLoginUrl = 'social/login';
  static const String sendEmailOtpUrl = 'send/email/otp';

  ////////// Otp Verify //////////
  static const String emailOtpVerifyUrl = 'email/otp/verify';

  /// Update User
  static const String getUserProfileDataUrl = 'user/profile';
  static const String updateUserProfileDataUrl = 'user/profile/update';
  static const String riderUpdateProfileDataUrl = 'rider/profile/update';
  static const String getRiderProfileDataUrl = 'rider/profile';

  //Order
  static const String placeOrder = 'orders/new/order/request';
  static const String fetchMyOrders = 'orders/my/new/order/list';
  static const String orderDetails = 'orders/new/order/request/show/';
}
