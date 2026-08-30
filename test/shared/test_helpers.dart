import 'package:employee_management_app/app/providers/auth_notifier.dart';
import 'package:employee_management_app/app/providers/auth_state.dart';
import 'package:employee_management_app/app/providers/employee_notifier.dart';
import 'package:employee_management_app/app/providers/employee_state.dart';
import 'package:employee_management_app/features/domain/app_user.dart';
import 'package:employee_management_app/features/models/country_model.dart';
import 'package:employee_management_app/features/models/employee_model.dart';

class FakeAuthNotifier extends AuthNotifier {
  FakeAuthNotifier(this._initialState);

  final AuthState _initialState;

  int loginCalls = 0;
  int googleSignInCalls = 0;
  int logoutCalls = 0;
  String? lastLoginEmail;
  String? lastLoginPassword;

  @override
  AuthState build() => _initialState;

  @override
  Future<void> login({required String email, required String password}) async {
    loginCalls += 1;
    lastLoginEmail = email;
    lastLoginPassword = password;
    state = AuthState.authenticated(
      AppUser(id: 'u-login', email: email, name: 'Logged In User'),
    );
  }

  @override
  Future<void> signInWithGoogle() async {
    googleSignInCalls += 1;
    state = const AuthState.authenticated(
      AppUser(id: 'google-user', email: 'google@example.com', name: 'Google User'),
    );
  }

  @override
  Future<void> logout() async {
    logoutCalls += 1;
    state = const AuthState.unauthenticated();
  }
}

class FakeEmployeeNotifier extends EmployeeNotifier {
  FakeEmployeeNotifier(this._initialState);

  final EmployeeState _initialState;

  int loadEmployeesCalls = 0;
  int updateFiltersCalls = 0;
  int searchCalls = 0;
  int deleteCalls = 0;
  int createCalls = 0;
  int updateCalls = 0;
  String? lastDeletedId;
  String? lastSearchQuery;
  Employee? lastCreatedEmployee;
  Employee? lastUpdatedEmployee;

  @override
  EmployeeState build() => _initialState;

  @override
  Future<void> loadEmployees() async {
    loadEmployeesCalls += 1;
    state = EmployeeState.success(
      state.employees,
      searchQuery: state.searchQuery,
      nameFilter: state.nameFilter,
      emailFilter: state.emailFilter,
      mobileFilter: state.mobileFilter,
      countryFilter: state.countryFilter,
    );
  }

  @override
  void searchById(String query) {
    searchCalls += 1;
    lastSearchQuery = query;
    state = EmployeeState.success(
      state.employees,
      searchQuery: query,
      nameFilter: state.nameFilter,
      emailFilter: state.emailFilter,
      mobileFilter: state.mobileFilter,
      countryFilter: state.countryFilter,
    );
  }

  @override
  void updateFilters({String? name, String? email, String? mobile, String? country}) {
    updateFiltersCalls += 1;
    state = EmployeeState.success(
      state.employees,
      searchQuery: state.searchQuery,
      nameFilter: name ?? state.nameFilter,
      emailFilter: email ?? state.emailFilter,
      mobileFilter: mobile ?? state.mobileFilter,
      countryFilter: country ?? state.countryFilter,
    );
  }

  @override
  Future<bool> deleteEmployee(String id) async {
    deleteCalls += 1;
    lastDeletedId = id;
    state = EmployeeState.success(
      state.employees.where((employee) => employee.id != id).toList(),
      searchQuery: state.searchQuery,
      nameFilter: state.nameFilter,
      emailFilter: state.emailFilter,
      mobileFilter: state.mobileFilter,
      countryFilter: state.countryFilter,
    );
    return true;
  }

  @override
  Future<Employee?> createEmployee(Employee employee) async {
    createCalls += 1;
    lastCreatedEmployee = employee;
    final createdEmployee = employee.copyWith(id: 'created-id');
    state = EmployeeState.success(
      [...state.employees, createdEmployee],
      searchQuery: state.searchQuery,
      nameFilter: state.nameFilter,
      emailFilter: state.emailFilter,
      mobileFilter: state.mobileFilter,
      countryFilter: state.countryFilter,
    );
    return createdEmployee;
  }

  @override
  Future<Employee?> updateEmployee(Employee employee) async {
    updateCalls += 1;
    lastUpdatedEmployee = employee;
    state = EmployeeState.success(
      state.employees
          .map((item) => item.id == employee.id ? employee : item)
          .toList(),
      searchQuery: state.searchQuery,
      nameFilter: state.nameFilter,
      emailFilter: state.emailFilter,
      mobileFilter: state.mobileFilter,
      countryFilter: state.countryFilter,
    );
    return employee;
  }
}

const sampleCountry = CountryModel(id: 'c1', country: 'India');

const sampleEmployee = Employee(
  id: '1',
  name: 'Alice',
  email: 'alice@example.com',
  mobile: '9876543210',
  country: 'India',
  countryId: 'c1',
  state: 'Karnataka',
  district: 'Bengaluru',
  avatar: null,
);

const secondEmployee = Employee(
  id: '2',
  name: 'Bob',
  email: 'bob@example.com',
  mobile: '9123456780',
  country: 'USA',
  countryId: 'c2',
  state: 'California',
  district: 'San Jose',
  avatar: null,
);
