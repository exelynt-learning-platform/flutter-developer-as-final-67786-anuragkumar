import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show TargetPlatform, defaultTargetPlatform, kIsWeb;

class FirebaseEnvOptions {
  const FirebaseEnvOptions._();

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
        apiKey: _required('FIREBASE_WEB_API_KEY'),
        appId: _required('FIREBASE_WEB_APP_ID'),
        messagingSenderId: _required('FIREBASE_MESSAGING_SENDER_ID'),
        projectId: _required('FIREBASE_PROJECT_ID'),
        authDomain: _required('FIREBASE_AUTH_DOMAIN'),
        storageBucket: _optional('FIREBASE_STORAGE_BUCKET'),
      );

  static FirebaseOptions get android => FirebaseOptions(
        apiKey: _required('FIREBASE_ANDROID_API_KEY'),
        appId: _required('FIREBASE_ANDROID_APP_ID'),
        messagingSenderId: _required('FIREBASE_MESSAGING_SENDER_ID'),
        projectId: _required('FIREBASE_PROJECT_ID'),
        storageBucket: _optional('FIREBASE_STORAGE_BUCKET'),
      );

  static FirebaseOptions get ios => FirebaseOptions(
        apiKey: _required('FIREBASE_IOS_API_KEY'),
        appId: _required('FIREBASE_IOS_APP_ID'),
        messagingSenderId: _required('FIREBASE_MESSAGING_SENDER_ID'),
        projectId: _required('FIREBASE_PROJECT_ID'),
        storageBucket: _optional('FIREBASE_STORAGE_BUCKET'),
        iosBundleId: _required('FIREBASE_IOS_BUNDLE_ID'),
      );

  static FirebaseOptions get macos => FirebaseOptions(
        apiKey: _required('FIREBASE_MACOS_API_KEY'),
        appId: _required('FIREBASE_MACOS_APP_ID'),
        messagingSenderId: _required('FIREBASE_MESSAGING_SENDER_ID'),
        projectId: _required('FIREBASE_PROJECT_ID'),
        storageBucket: _optional('FIREBASE_STORAGE_BUCKET'),
        iosBundleId: _required('FIREBASE_IOS_BUNDLE_ID'),
      );

  static FirebaseOptions get windows => FirebaseOptions(
        apiKey: _required('FIREBASE_WINDOWS_API_KEY'),
        appId: _required('FIREBASE_WINDOWS_APP_ID'),
        messagingSenderId: _required('FIREBASE_MESSAGING_SENDER_ID'),
        projectId: _required('FIREBASE_PROJECT_ID'),
        authDomain: _required('FIREBASE_AUTH_DOMAIN'),
        storageBucket: _optional('FIREBASE_STORAGE_BUCKET'),
      );

  static String _required(String key) {
    final value = String.fromEnvironment(key);
    if (value.isEmpty) {
      throw UnsupportedError(
        'Missing required --dart-define value: $key',
      );
    }
    return value;
  }

  static String? _optional(String key) {
    final value = String.fromEnvironment(key);
    if (value.isEmpty) {
      return null;
    }
    return value;
  }
}
