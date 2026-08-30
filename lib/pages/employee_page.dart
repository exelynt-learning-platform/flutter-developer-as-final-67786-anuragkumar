import 'package:employee_management_app/core/utils/app_snackbar.dart';
import 'package:employee_management_app/features/models/employee_model.dart';
import 'package:employee_management_app/widgets/responsive_layout.dart';
import 'package:employee_management_app/widgets/responsive_visibility.dart';
import 'package:go_router/go_router.dart';
import 'package:employee_management_app/app/providers/employee_providers.dart';
import 'package:employee_management_app/app/providers/employee_state.dart';
import 'package:employee_management_app/widgets/employee_filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/employee_list.dart';

class EmployeeDashboardPage extends ConsumerStatefulWidget {
  const EmployeeDashboardPage({super.key});

  @override
  ConsumerState<EmployeeDashboardPage> createState() => _EmployeeDashboardPageState();
}

class _EmployeeDashboardPageState extends ConsumerState<EmployeeDashboardPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _countryController = TextEditingController();

  @override
  void initState() {
    super.initState();

    Future.microtask(() => ref.read(employeeNotifierProvider.notifier).loadEmployees());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _countryController.dispose();

    super.dispose();
  }

  void _updateFilters() {
    ref.read(employeeNotifierProvider.notifier).updateFilters(name: _nameController.text, email: _emailController.text, mobile: _mobileController.text, country: _countryController.text);
  }

  void _clearFilters() {
    _nameController.clear();
    _emailController.clear();
    _mobileController.clear();
    _countryController.clear();

    ref.read(employeeNotifierProvider.notifier).updateFilters(name: '', email: '', mobile: '', country: '');
  }

  Future<void> _deleteEmployee(Employee employee) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Employee'),
          content: Text('Are you sure you want to delete ${employee.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                dialogContext.pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                dialogContext.pop(true);
              },
              style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll<Color>(Colors.red),
                backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                  if(states.contains(WidgetState.hovered)){
                    return Colors.red.withAlpha(10); 
                  }
                  return Colors.transparent; 
                })
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true || !mounted) return;

    final success = await ref.read(employeeNotifierProvider.notifier).deleteEmployee(employee.id);

    if (!mounted) return;

    final state = ref.read(employeeNotifierProvider);
    AppSnackbar.show(success ? 'Employee deleted successfully.' : state.message ?? 'Unable to delete employee.');
  }

  void _editEmployee(Employee employee) {
    context.push('/employees/edit/${employee.id}', extra: employee);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(employeeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Employee Management'),
        actionsPadding: EdgeInsets.only(right: 8),
        actions: [
          ResponsiveVisibility(
            mobile: Badge(
              isLabelVisible: state.hasActiveFilters,
              child: IconButton(
                tooltip: 'Filter',
                onPressed: _showMobileFilters,
                icon: const Icon(Icons.filter_list),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Add employee',
            onPressed: () {
              context.push('/employees/add');
            },
            icon: const Icon(Icons.person_add_outlined),
          ),
        ],
      ),
      // body: _buildBody(state),
      body: ResponsiveLayout(
        mobile: _buildMobileBody(state),
        desktop: _buildDesktopBody(state),
      ),
    );
  }

  Widget _buildDesktopBody(EmployeeState state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: _buildSearchField(state),
        ),

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.start,
              children: [
                _buildFilterField(
                  controller: _nameController,
                  label: 'Name',
                  icon: Icons.person,
                ),
                _buildFilterField(
                  controller: _emailController,
                  label: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                _buildFilterField(
                  controller: _mobileController,
                  label: 'Mobile',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                _buildFilterField(
                  controller: _countryController,
                  label: 'Country',
                  icon: Icons.public,
                ),
                OutlinedButton.icon(
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.clear),
                  label: const Text('Clear'),
                ),
              ],
            ),
          ),
        ),

        Expanded(child: _buildEmployeeResults(state)),
      ],
    );
  }

  Widget _buildMobileBody(EmployeeState state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: _buildSearchField(state),
        ),

        Expanded(child: _buildEmployeeResults(state)),
      ],
    );
  }

  Widget _buildSearchField(EmployeeState state) {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Search by Employee ID',
        hintText: 'Enter employee ID',
        prefixIcon: const Icon(Icons.search),
        isDense: true,
        suffixIcon: state.searchQuery.isNotEmpty
            ? IconButton(
                tooltip: 'Clear search',
                onPressed: () {
                  ref.read(employeeNotifierProvider.notifier).searchById('');
                },
                icon: const Icon(Icons.clear),
              )
            : null,
        border: const OutlineInputBorder(),
      ),
      onChanged: (value) {
        ref.read(employeeNotifierProvider.notifier).searchById(value);
      },
    );
  }

  Widget _buildEmployeeResults(EmployeeState state) {
    final employees = state.filteredEmployees;
    if (state.isLoading && !state.hasEmployees) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.employees.isNotEmpty && employees.isEmpty) {
      return Center(
        child: Text('No employee found for the current search/filter.', textAlign: TextAlign.center),
      );
    }

    return RefreshIndicator(
      onRefresh: () {
        return ref.read(employeeNotifierProvider.notifier).loadEmployees();
      },
      child: EmployeeList(employees: employees, onDelete: _deleteEmployee, onEdit: _editEmployee),
    );
  }

  Future<void> _showMobileFilters() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.viewInsetsOf(context).bottom),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Filters', style: Theme.of(context).textTheme.titleLarge),
                      const Spacer(),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  EmployeeFilters(
                    nameController: _nameController,
                    emailController: _emailController,
                    mobileController: _mobileController,
                    countryController: _countryController,
                    onChanged: _updateFilters,
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 8.0,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _clearFilters,
                            child: const Text('Clear filters'),
                          ),
                        ),
                        Expanded(
                          child: FilledButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Apply Filters'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return SizedBox(
      width: 220,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
          isDense: true,
        ),
        onChanged: (_) => _updateFilters(),
      ),
    );
  }
}
