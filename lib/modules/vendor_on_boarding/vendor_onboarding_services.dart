import 'dart:convert';

import '../../common/config.dart';
import '../../common/constants.dart';
import '../../common/error_codes/error_codes.dart';

class VendorOnBoardingServices {
  late final _url;
  late final _type;
  late final _platform;

  static final VendorOnBoardingServices _onBoardingServices =
      VendorOnBoardingServices._internal();

  factory VendorOnBoardingServices() {
    return _onBoardingServices;
  }

  VendorOnBoardingServices._internal() {
    _url = serverConfig['url'];
    _type = serverConfig['type'];
    if (_type == 'vendorAdmin') {
      _platform = serverConfig['platform'] ?? 'wcfm';
    } else {
      _platform = serverConfig['type'];
    }
  }

  Future<ErrorType> updateVendorInformation(token, data) async {
    try {
      var base64Str = EncodeUtils.encodeCookie(token);
      var endpoint = '$_url/wp-json/vendor-admin/profile';
      final response = await httpPut(endpoint.toUri()!, body: {
        'token': base64Str,
        'data': jsonEncode(
          data,
        ),
        'platform': _platform,
      });
      if (jsonDecode(response.body)['response'] == 1) {
        return ErrorType.updateSuccess;
      }
      printLog('vendor_onboarding_services.dart: ${response.body}');
      return ErrorType.updateFailed;
    } catch (e) {
      printLog('vendor_onboarding_services.dart: $e');
      return ErrorType.updateFailed;
    }
  }

  Future<String> getAddressFromLocation(double? lat, double? long) async {
    var response = await httpGet(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=${isIos ? kGoogleAPIKey['ios'] : kGoogleAPIKey['android']}'
            .toUri()!);
    return jsonDecode(response.body)['results'].first['formatted_address'];
  }
}
