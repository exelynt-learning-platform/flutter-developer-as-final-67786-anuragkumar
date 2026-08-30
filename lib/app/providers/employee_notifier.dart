import 'package:employee_management_app/core/error/failure.dart';
import 'package:employee_management_app/features/domain/employee_state.dart';
import 'package:employee_management_app/features/models/employee_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'employee_providers.dart';
import 'employee_state.dart';

class EmployeeNotifier extends Notifier<EmployeeState> {
  late final GetEmployees _getEmployees;
  late final GetEmployeeById _getEmployeeById;
  late final CreateEmployee _createEmployee;
  late final UpdateEmployee _updateEmployee;
  late final DeleteEmployee _deleteEmployee;

  @override
  EmployeeState build() {
    _getEmployees = ref.watch(getEmployeesProvider);
    _getEmployeeById = ref.watch(getEmployeeByIdProvider);
    _createEmployee = ref.watch(createEmployeeProvider);
    _updateEmployee = ref.watch(updateEmployeeProvider);
    _deleteEmployee = ref.watch(deleteEmployeeProvider);

    return const EmployeeState.initial();
  }

  Future<void> loadEmployees() async {
    state = EmployeeState.loading(employees: state.employees);

    try {
      final employees = await _getEmployees();
      state = _successState(employees);
    } catch (error) {
      state = _failureState(_messageFromError(error));
    }
  }

  Future<Employee?> getEmployeeById(String id) async {
    try {
      return await _getEmployeeById(id);
    } catch (error) {
      state = _failureState(_messageFromError(error));
      return null;
    }
  }

  Future<Employee?> createEmployee(Employee employee) async {
    try {
      final createdEmployee = await _createEmployee(employee);
      state = _successState([...state.employees, createdEmployee]);
      return createdEmployee;
    } catch (error) {
      state = _failureState(_messageFromError(error));
      return null;
    }
  }

  Future<Employee?> updateEmployee(Employee employee) async {
    try {
      final updatedEmployee = await _updateEmployee(employee);
      final updatedEmployees = state.employees.map((item) {
        return item.id == updatedEmployee.id ? updatedEmployee : item;
      }).toList();

      state = _successState(updatedEmployees);

      return updatedEmployee;
    } catch (error) {
      state = _failureState(_messageFromError(error));
      return null;
    }
  }

  Future<bool> deleteEmployee(String id) async {
    try {
      await _deleteEmployee(id);
      final updatedEmployees = state.employees.where((employee) => employee.id != id).toList();
      state = _successState(updatedEmployees);

      return true;
    } catch (error) {
      state = _failureState(_messageFromError(error));
      return false;
    }
  }

  void searchById(String query) {
    state = _successState(state.employees, searchQuery: query);
  }
  
  void updateFilters({
    String? name,
    String? email,
    String? mobile,
    String? country,
  }) {
    state = _successState(
      state.employees,
      nameFilter: name,
      emailFilter: email,
      mobileFilter: mobile,
      countryFilter: country,
    );
  }

  EmployeeState _successState(List<Employee> employees, {
    String? searchQuery,
    String? nameFilter,
    String? emailFilter,
    String? mobileFilter,
    String? countryFilter,
  }) {
    return EmployeeState.success(
      employees,
      searchQuery: searchQuery ?? state.searchQuery,
      nameFilter: nameFilter ?? state.nameFilter,
      emailFilter: emailFilter ?? state.emailFilter,
      mobileFilter: mobileFilter ?? state.mobileFilter,
      countryFilter: countryFilter ?? state.countryFilter,
    );
  }

  EmployeeState _failureState(String message) {
    return EmployeeState.failure(
      message,
      employees: state.employees,
      searchQuery: state.searchQuery,
      nameFilter: state.nameFilter,
      emailFilter: state.emailFilter,
      mobileFilter: state.mobileFilter,
      countryFilter: state.countryFilter,
    );
  }

  String _messageFromError(Object error) {
    if (error is Failure) {
      return error.message;
    }

    return 'Something went wrong. Please try again.';
  }
}
