import 'package:employee_management_app/features/repositories/employee_repository.dart';
import '../models/country_model.dart';

import '../../../core/error/app_exception.dart';
import '../datasources/employee_remote_data_source.dart';
import '../models/employee_model.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  EmployeeRepositoryImpl(this._remoteDataSource);
  final EmployeeRemoteDataSource _remoteDataSource;

  @override
  Future<List<Employee>> getEmployees() async {
    try {
      final employees = await _remoteDataSource.getEmployees();
      return employees.map((employee) => employee.toEntity()).toList();
    } on AppException {
      rethrow;
    } catch (_) {
      throw const UnknownException(
        'Unable to fetch employees.',
      );
    }
  }

  @override
  Future<Employee> getEmployeeById(String id) async {
    try {
      final employee = await _remoteDataSource.getEmployeeById(id);
      return employee.toEntity();
    } on AppException {
      rethrow;
    } catch (_) {
      throw const UnknownException('Unable to fetch employee.');
    }
  }

  @override
  Future<Employee> createEmployee(Employee employee) async {
    try {
      final model = EmployeeModel.fromEntity(employee);
      final createdEmployee = await _remoteDataSource.createEmployee(model);
      return createdEmployee.toEntity();
    } on AppException {
      rethrow;
    } catch (_) {
      throw const UnknownException('Unable to create employee.');
    }
  }

  @override
  Future<Employee> updateEmployee(Employee employee) async {
    try {
      final model = EmployeeModel.fromEntity(employee);
      final updatedEmployee = await _remoteDataSource.updateEmployee(model);
      return updatedEmployee.toEntity();
    } on AppException {
      rethrow;
    } catch (_) {
      throw const UnknownException('Unable to update employee.');
    }
  }

  @override
  Future<void> deleteEmployee(String id) async {
    try {
      await _remoteDataSource.deleteEmployee(id);
    } on AppException {
      rethrow;
    } catch (_) {
      throw const UnknownException('Unable to delete employee.');
    }
  }

  @override
  Future<List<CountryModel>> getCountries() async {
    try {
      final countries = await _remoteDataSource.getCountries();
      return countries.toList();
    } on AppException {
      rethrow;
    } catch (_) {
      throw const UnknownException(
        'Unable to fetch countries.',
      );
    }
  }
}
