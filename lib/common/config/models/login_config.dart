class LoginConfig {
  bool isRequiredLogin = false;
  bool showAppleLogin = false;
  bool showFacebook = false;
  bool showSMSLogin = false;
  bool showGoogleLogin = false;
  bool showPhoneNumberWhenRegister = false;
  bool requirePhoneNumberWhenRegister = false;
  bool isResetPasswordSupported = false;
  String facebookAppId = '451796180143652';
  String facebookLoginProtocolScheme = '';

  LoginConfig.fromJson(dynamic json) {
    isRequiredLogin = json['IsRequiredLogin'] ?? false;
    showAppleLogin = json['showAppleLogin'] ?? false;
    showFacebook = json['showFacebook'] ?? false;
    showSMSLogin = json['showSMSLogin'] ?? false;
    showGoogleLogin = json['showGoogleLogin'] ?? false;
    showPhoneNumberWhenRegister = json['showPhoneNumberWhenRegister'] ?? false;
    requirePhoneNumberWhenRegister =
        json['requirePhoneNumberWhenRegister'] ?? false;
    isResetPasswordSupported = json['isResetPasswordSupported'] ?? false;
    facebookAppId = json['facebookAppId'] ?? '';
    facebookLoginProtocolScheme = json['facebookLoginProtocolScheme'] ?? '';
  }

  Map toJson() {
    var map = <String, dynamic>{};
    map['IsRequiredLogin'] = isRequiredLogin;
    map['showAppleLogin'] = showAppleLogin;
    map['showFacebook'] = showFacebook;
    map['showSMSLogin'] = showSMSLogin;
    map['showGoogleLogin'] = showGoogleLogin;
    map['showPhoneNumberWhenRegister'] = showPhoneNumberWhenRegister;
    map['requirePhoneNumberWhenRegister'] = requirePhoneNumberWhenRegister;
    map['isResetPasswordSupported'] = isResetPasswordSupported;
    map['facebookAppId'] = facebookAppId;
    map['facebookLoginProtocolScheme'] = facebookLoginProtocolScheme;
    return map;
  }
}
