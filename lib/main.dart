import 'package:employee_management_app/app/app.dart';
import 'package:employee_management_app/core/config/firebase_env_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:google_sign_in/google_sign_in.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: FirebaseEnvOptions.currentPlatform);
  // await GoogleSignIn.instance.initialize(clientId: '243721627371-0g61op93e8hegif20fkv6ofrvr2dmcmf.apps.googleusercontent.com');
  runApp(const ProviderScope(child: EmployeeManagementApp()));
}
