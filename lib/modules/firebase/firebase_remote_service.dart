import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:inspireui/utils/logs.dart';

class FirebaseRemoteServices {
  static Future<FirebaseRemoteConfig?> loadRemoteConfig() async {
    final _remoteConfig = FirebaseRemoteConfig.instance;

    try {
      await _remoteConfig.fetch();
      await _remoteConfig.activate();
      return _remoteConfig;
    } catch (e) {
      printLog('Unable to fetch remote config. Default value will be used. $e');
    }
    return null;
  }
}
