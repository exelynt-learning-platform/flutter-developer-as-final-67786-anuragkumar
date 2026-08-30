import 'package:employee_management_app/features/models/employee_model.dart';
import 'package:employee_management_app/features/employee/presentation/widgets/employee_card.dart';
import 'package:flutter/material.dart';


class EmployeeList extends StatelessWidget {
  const EmployeeList({
    required this.employees,
    required this.onDelete,
    required this.onEdit,
    super.key,
  });

  final List<Employee> employees;
  final ValueChanged<Employee> onDelete;
  final ValueChanged<Employee> onEdit;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 900;

        if (isDesktop) {
          return _DesktopEmployeeTable(employees: employees, onDelete: onDelete, onEdit: onEdit);
        }

        return _MobileEmployeeList(employees: employees, onDelete: onDelete, onEdit: onEdit);
      },
    );
  }
}

class _MobileEmployeeList extends StatelessWidget {
  const _MobileEmployeeList({
    required this.employees,
    required this.onDelete,
    required this.onEdit,
  });

  final List<Employee> employees;
  final ValueChanged<Employee> onDelete;
  final ValueChanged<Employee> onEdit;
  
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: employees.length,
      separatorBuilder: (_, _) => const SizedBox(height: 0),
      itemBuilder: (context, index) {
        return EmployeeCard(employee: employees[index], onDelete: onDelete, onEdit: onEdit);
      },
    );
  }
}

class _DesktopEmployeeTable extends StatelessWidget {
  const _DesktopEmployeeTable({
    required this.employees,
    required this.onDelete,
    required this.onEdit,
  });

  final List<Employee> employees;
  final ValueChanged<Employee> onDelete;
  final ValueChanged<Employee> onEdit;
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 20,
            horizontalMargin: 16,
            columns: const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Mobile')),
              DataColumn(label: Text('Country')),
              DataColumn(label: Text('State')),
              DataColumn(label: Text('District')),
              DataColumn(label: Text('Actions')),
            ],
            rows: employees.map((employee) {
              return DataRow(
                cells: [
                  DataCell(Text(employee.id)),
                  DataCell(Text(employee.name)),
                  DataCell(Text(employee.email)),
                  DataCell(Text(employee.mobile)),
                  DataCell(Text(employee.country)),
                  DataCell(Text(employee.state)),
                  DataCell(Text(employee.district)),
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          tooltip: 'Edit employee',
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          onPressed: () => onEdit(employee),
                          color: ThemeData().colorScheme.primary,
                        ),
                        IconButton(
                          tooltip: 'Delete employee',
                          icon: const Icon(Icons.delete_outline, size: 18),
                          onPressed: () => onDelete(employee),
                          color: ThemeData().colorScheme.error,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
