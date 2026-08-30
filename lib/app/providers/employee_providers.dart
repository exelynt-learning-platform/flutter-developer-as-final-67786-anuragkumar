import 'package:employee_management_app/app/providers/app_providers.dart';
import 'package:employee_management_app/app/providers/employee_notifier.dart';
import 'package:employee_management_app/app/providers/employee_state.dart';
import 'package:employee_management_app/features/datasources/employee_remote_data_source.dart';
import 'package:employee_management_app/features/domain/employee_state.dart';
import 'package:employee_management_app/features/repositories/employee_repository.dart';
import 'package:employee_management_app/features/repositories/employee_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final employeeRemoteDataSourceProvider = Provider<EmployeeRemoteDataSource>((ref) {
  return EmployeeRemoteDataSourceImpl(ref.watch(apiClientProvider));
});

final employeeRepositoryProvider = Provider<EmployeeRepository>((ref) {
  return EmployeeRepositoryImpl(ref.watch(employeeRemoteDataSourceProvider),);
});

final getEmployeesProvider = Provider<GetEmployees>((ref) {
  return GetEmployees(ref.watch(employeeRepositoryProvider));
});

final getEmployeeByIdProvider = Provider<GetEmployeeById>((ref) {
  return GetEmployeeById(ref.watch(employeeRepositoryProvider));
});

final createEmployeeProvider = Provider<CreateEmployee>((ref) {
  return CreateEmployee(ref.watch(employeeRepositoryProvider));
});

final updateEmployeeProvider = Provider<UpdateEmployee>((ref) {
  return UpdateEmployee(ref.watch(employeeRepositoryProvider));
});

final deleteEmployeeProvider = Provider<DeleteEmployee>((ref) {
  return DeleteEmployee(ref.watch(employeeRepositoryProvider));
});

final getCountriesProvider = Provider<GetCountries>((ref) {
  return GetCountries(ref.watch(employeeRepositoryProvider));
});

final employeeNotifierProvider = NotifierProvider<EmployeeNotifier, EmployeeState>(EmployeeNotifier.new);