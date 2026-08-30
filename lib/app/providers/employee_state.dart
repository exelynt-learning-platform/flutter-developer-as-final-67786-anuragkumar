import 'package:employee_management_app/features/models/employee_model.dart';
import 'package:flutter/foundation.dart';


enum EmployeeStatus {
  initial,
  loading,
  success,
  failure,
}

@immutable
class EmployeeState {
  const EmployeeState({
    required this.status,
    this.employees = const [],
    this.message,
    this.searchQuery = '',
    this.nameFilter = '',
    this.emailFilter = '',
    this.mobileFilter = '',
    this.countryFilter = '',
  });

  final EmployeeStatus status;
  final List<Employee> employees;
  final String? message;
  final String searchQuery;
  final String nameFilter;
  final String emailFilter;
  final String mobileFilter;
  final String countryFilter;

  const EmployeeState.initial(): status = EmployeeStatus.initial,
    employees = const [],
    searchQuery = '',
    nameFilter = '',
    emailFilter = '',
    mobileFilter = '',
    countryFilter = '',
    message = null;

  const EmployeeState.loading({
    this.employees = const [],
    this.searchQuery = '',
    this.nameFilter = '',
    this.emailFilter = '',
    this.mobileFilter = '',
    this.countryFilter = '',
  }) : status = EmployeeStatus.loading,
    message = null;

  const EmployeeState.success(
    this.employees, {
      this.searchQuery = '',
      this.nameFilter = '',
      this.countryFilter = '',
      this.emailFilter = '',
      this.mobileFilter = '',
    }
  ) : status = EmployeeStatus.success,
    message = null;

  const EmployeeState.failure(
    this.message, {
    this.employees = const [],
    this.searchQuery = '',
    this.nameFilter = '',
    this.emailFilter = '',
    this.mobileFilter = '',
    this.countryFilter = '',
  }) : status = EmployeeStatus.failure;

  bool get isLoading => status == EmployeeStatus.loading;
  bool get hasEmployees => employees.isNotEmpty;
  bool get isEmpty => status == EmployeeStatus.success && employees.isEmpty;
  
  List<Employee> get filteredEmployees {
    final idQuery = searchQuery.trim().toLowerCase();
    final nameQuery = nameFilter.trim().toLowerCase();
    final emailQuery = emailFilter.trim().toLowerCase();
    final mobileQuery = mobileFilter.trim().toLowerCase();
    final countryQuery = countryFilter.trim().toLowerCase();

    return employees.where((employee) {
      if (!_matchesSearchQuery(employee, idQuery)) {
        return false;
      }
      if (!_matchesNameFilter(employee, nameQuery)) {
        return false;
      }
      if (!_matchesEmailFilter(employee, emailQuery)) {
        return false;
      }
      if (!_matchesMobileFilter(employee, mobileQuery)) {
        return false;
      }
      if (!_matchesCountryFilter(employee, countryQuery)) {
        return false;
      }

      return true;
    }).toList();
  }

  bool _matchesSearchQuery(Employee employee, String query) {
    if (query.isEmpty) {
      return true;
    }
    return employee.id.toLowerCase().contains(query);
  }

  bool _matchesNameFilter(Employee employee, String query) {
    if (query.isEmpty) {
      return true;
    }
    return employee.name.toLowerCase().contains(query);
  }

  bool _matchesEmailFilter(Employee employee, String query) {
    if (query.isEmpty) {
      return true;
    }
    return employee.email.toLowerCase().contains(query);
  }

  bool _matchesMobileFilter(Employee employee, String query) {
    if (query.isEmpty) {
      return true;
    }
    return employee.mobile.toLowerCase().contains(query);
  }

  bool _matchesCountryFilter(Employee employee, String query) {
    if (query.isEmpty) {
      return true;
    }
    return employee.country.toLowerCase().contains(query);
  }

  bool get hasActiveFilters {
    return searchQuery.trim().isNotEmpty || nameFilter.trim().isNotEmpty || emailFilter.trim().isNotEmpty || mobileFilter.trim().isNotEmpty || countryFilter.trim().isNotEmpty;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is EmployeeState &&
            runtimeType == other.runtimeType &&
            status == other.status &&
            listEquals(employees, other.employees) &&
            message == other.message &&
            searchQuery == other.searchQuery &&
            nameFilter == other.nameFilter &&
            emailFilter == other.emailFilter &&
            mobileFilter == other.mobileFilter &&
            countryFilter == other.countryFilter;
  }

  @override
  int get hashCode => Object.hash(
        status,
        Object.hashAll(employees),
        message,
        searchQuery,
        nameFilter,
        emailFilter,
        mobileFilter,
        countryFilter,
      );
}
