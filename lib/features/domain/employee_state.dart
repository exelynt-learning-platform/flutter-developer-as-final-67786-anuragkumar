import 'package:employee_management_app/features/models/country_model.dart';
import 'package:employee_management_app/features/models/employee_model.dart';

import '../repositories/employee_repository.dart';

class GetEmployees {
  const GetEmployees(this._repository);
  final EmployeeRepository _repository;

  Future<List<Employee>> call() {
    return _repository.getEmployees();
  }
}

class GetEmployeeById {
  const GetEmployeeById(this._repository);
  final EmployeeRepository _repository;

  Future<Employee> call(String id) {
    return _repository.getEmployeeById(id);
  }
}

class CreateEmployee {
  const CreateEmployee(this._repository);
  final EmployeeRepository _repository;

  Future<Employee> call(Employee employee) {
    return _repository.createEmployee(employee);
  }
}

class UpdateEmployee {
  const UpdateEmployee(this._repository);
  final EmployeeRepository _repository;

  Future<Employee> call(Employee employee) {
    return _repository.updateEmployee(employee);
  }
}

class DeleteEmployee {
  const DeleteEmployee(this._repository);
  final EmployeeRepository _repository;

  Future<void> call(String id) {
    return _repository.deleteEmployee(id);
  }
}

class GetCountries {
  const GetCountries(this._repository);

  final EmployeeRepository _repository;

  Future<List<CountryModel>> call() {
    return _repository.getCountries();
  }
}