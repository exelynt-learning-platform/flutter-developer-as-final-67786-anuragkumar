import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;

class FirebaseEnvOptions {
  const FirebaseEnvOptions._();

  static const _projectId = String.fromEnvironment('FIREBASE_PROJECT_ID');
  static const _messagingSenderId = String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID');
  static const _storageBucket = String.fromEnvironment('FIREBASE_STORAGE_BUCKET');
  static const _authDomain = String.fromEnvironment('FIREBASE_AUTH_DOMAIN');

  static const _webApiKey = String.fromEnvironment('FIREBASE_WEB_API_KEY');
  static const _webAppId = String.fromEnvironment('FIREBASE_WEB_APP_ID');

  static const _androidApiKey = String.fromEnvironment('FIREBASE_ANDROID_API_KEY');
  static const _androidAppId = String.fromEnvironment('FIREBASE_ANDROID_APP_ID');

  static const _iosApiKey = String.fromEnvironment('FIREBASE_IOS_API_KEY');
  static const _iosAppId = String.fromEnvironment('FIREBASE_IOS_APP_ID');
  static const _iosBundleId = String.fromEnvironment('FIREBASE_IOS_BUNDLE_ID');

  static const _macosApiKey = String.fromEnvironment('FIREBASE_MACOS_API_KEY');
  static const _macosAppId = String.fromEnvironment('FIREBASE_MACOS_APP_ID');

  static const _windowsApiKey = String.fromEnvironment('FIREBASE_WINDOWS_API_KEY');
  static const _windowsAppId = String.fromEnvironment('FIREBASE_WINDOWS_APP_ID');

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'Firebase options are not configured for linux in this project.',
        );
      default:
        throw UnsupportedError(
          'Firebase options are not supported for this platform.',
        );
    }
  }

  static FirebaseOptions get web => FirebaseOptions(
        apiKey: _requiredValue(_webApiKey, 'FIREBASE_WEB_API_KEY'),
        appId: _requiredValue(_webAppId, 'FIREBASE_WEB_APP_ID'),
        messagingSenderId: _requiredValue(
          _messagingSenderId,
          'FIREBASE_MESSAGING_SENDER_ID',
        ),
        projectId: _requiredValue(_projectId, 'FIREBASE_PROJECT_ID'),
        authDomain: _requiredValue(_authDomain, 'FIREBASE_AUTH_DOMAIN'),
        storageBucket: _optionalValue(_storageBucket),
      );

  static FirebaseOptions get android => FirebaseOptions(
        apiKey: _requiredValue(_androidApiKey, 'FIREBASE_ANDROID_API_KEY'),
        appId: _requiredValue(_androidAppId, 'FIREBASE_ANDROID_APP_ID'),
        messagingSenderId: _requiredValue(
          _messagingSenderId,
          'FIREBASE_MESSAGING_SENDER_ID',
        ),
        projectId: _requiredValue(_projectId, 'FIREBASE_PROJECT_ID'),
        storageBucket: _optionalValue(_storageBucket),
      );

  static FirebaseOptions get ios => FirebaseOptions(
        apiKey: _requiredValue(_iosApiKey, 'FIREBASE_IOS_API_KEY'),
        appId: _requiredValue(_iosAppId, 'FIREBASE_IOS_APP_ID'),
        messagingSenderId: _requiredValue(
          _messagingSenderId,
          'FIREBASE_MESSAGING_SENDER_ID',
        ),
        projectId: _requiredValue(_projectId, 'FIREBASE_PROJECT_ID'),
        storageBucket: _optionalValue(_storageBucket),
        iosBundleId: _requiredValue(_iosBundleId, 'FIREBASE_IOS_BUNDLE_ID'),
      );

  static FirebaseOptions get macos => FirebaseOptions(
        apiKey: _requiredValue(_macosApiKey, 'FIREBASE_MACOS_API_KEY'),
        appId: _requiredValue(_macosAppId, 'FIREBASE_MACOS_APP_ID'),
        messagingSenderId: _requiredValue(
          _messagingSenderId,
          'FIREBASE_MESSAGING_SENDER_ID',
        ),
        projectId: _requiredValue(_projectId, 'FIREBASE_PROJECT_ID'),
        storageBucket: _optionalValue(_storageBucket),
        iosBundleId: _requiredValue(_iosBundleId, 'FIREBASE_IOS_BUNDLE_ID'),
      );

  static FirebaseOptions get windows => FirebaseOptions(
        apiKey: _requiredValue(_windowsApiKey, 'FIREBASE_WINDOWS_API_KEY'),
        appId: _requiredValue(_windowsAppId, 'FIREBASE_WINDOWS_APP_ID'),
        messagingSenderId: _requiredValue(
          _messagingSenderId,
          'FIREBASE_MESSAGING_SENDER_ID',
        ),
        projectId: _requiredValue(_projectId, 'FIREBASE_PROJECT_ID'),
        authDomain: _requiredValue(_authDomain, 'FIREBASE_AUTH_DOMAIN'),
        storageBucket: _optionalValue(_storageBucket),
      );

  static String _requiredValue(String value, String key) {
    if (value.isEmpty) {
      throw UnsupportedError(
        'Missing required --dart-define value: $key',
      );
    }
    return value;
  }

  static String? _optionalValue(String value) {
    if (value.isEmpty) {
      return null;
    }
    return value;
  }
}
