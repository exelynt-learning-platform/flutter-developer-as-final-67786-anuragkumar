import 'package:employee_management_app/core/error/app_exception.dart';
import 'package:employee_management_app/core/network/api_client.dart';

import '../models/country_model.dart';
import '../models/employee_model.dart';

abstract interface class EmployeeRemoteDataSource {
  Future<List<EmployeeModel>> getEmployees();

  Future<EmployeeModel> getEmployeeById(String id);

  Future<EmployeeModel> createEmployee(EmployeeModel employee);

  Future<EmployeeModel> updateEmployee(EmployeeModel employee);

  Future<void> deleteEmployee(String id);

  Future<List<CountryModel>> getCountries();
}

class EmployeeRemoteDataSourceImpl implements EmployeeRemoteDataSource {
  EmployeeRemoteDataSourceImpl(this._apiClient);

  final ApiClient _apiClient;

  @override
  Future<List<EmployeeModel>> getEmployees() async {
    final response = await _apiClient.get(ApiConstants.employees);

    final data = response.data;

    if (data is! List) {
      throw const UnknownException('Invalid employee response.');
    }

    return data.map((json) => EmployeeModel.fromJson(Map<String, dynamic>.from(json as Map))).toList();
  }

  @override
  Future<EmployeeModel> getEmployeeById(String id) async {
    final response = await _apiClient.get(ApiConstants.employeeById(id));
    final data = response.data;

    if (data is! Map) {
      throw const UnknownException('Invalid employee response.');
    }

    return EmployeeModel.fromJson(Map<String, dynamic>.from(data));
  }

  @override
  Future<EmployeeModel> createEmployee(EmployeeModel employee) async {
    final response = await _apiClient.post(
      ApiConstants.employees,
      data: employee.toJson(),
    );

    final data = response.data;

    if (data is! Map) {
      throw const UnknownException('Invalid employee response.');
    }

    return EmployeeModel.fromJson(Map<String, dynamic>.from(data));
  }

  @override
  Future<EmployeeModel> updateEmployee(EmployeeModel employee) async {
    final response = await _apiClient.put(
      ApiConstants.employeeById(employee.id),
      data: employee.toJson(),
    );

    final data = response.data;

    if (data is! Map) {
      throw const UnknownException('Invalid employee response.');
    }

    return EmployeeModel.fromJson(Map<String, dynamic>.from(data));
  }

  @override
  Future<void> deleteEmployee(String id) async {
    await _apiClient.delete(ApiConstants.employeeById(id));
  }

  @override
  Future<List<CountryModel>> getCountries() async {
    final response = await _apiClient.get(ApiConstants.countries);
    final data = response.data;

    if (data is! List) {
      throw const UnknownException('Invalid country response.');
    }

    return data.map((json) => CountryModel.fromJson(Map<String, dynamic>.from(json as Map))).toList();
  }
}
