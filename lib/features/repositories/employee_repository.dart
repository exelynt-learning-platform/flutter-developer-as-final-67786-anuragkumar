import 'package:employee_management_app/features/models/country_model.dart';
import 'package:employee_management_app/features/models/employee_model.dart';

abstract interface class EmployeeRepository {
  Future<List<Employee>> getEmployees();

  Future<Employee> getEmployeeById(String id);

  Future<Employee> createEmployee(Employee employee);

  Future<Employee> updateEmployee(Employee employee);

  Future<void> deleteEmployee(String id);
  
  Future<List<CountryModel>> getCountries();
}
