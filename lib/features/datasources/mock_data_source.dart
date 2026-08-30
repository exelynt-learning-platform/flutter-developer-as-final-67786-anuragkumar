// import 'package:firebase_auth/firebase_auth.dart';
import 'package:mocktail/mocktail.dart';

import 'package:employee_management_app/features/datasources/auth_remote_data_source.dart';
import 'package:employee_management_app/features/datasources/google_sign_in_data_source.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

class MockGoogleSignInDataSource extends Mock implements GoogleSignInDataSource {}
