import 'package:employee_management_app/features/models/employee_model.dart';
import 'package:employee_management_app/widgets/employee_card.dart';
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: Table(
                  border: TableBorder(
                    horizontalInside: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                  columnWidths: const {
                    0: FixedColumnWidth(60),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(3),
                    3: FlexColumnWidth(2),
                    4: FlexColumnWidth(2),
                    5: FlexColumnWidth(2),
                    6: FlexColumnWidth(2),
                    7: FixedColumnWidth(100),// Actions
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(3),
                      ),
                      children: const [
                        Padding(padding: EdgeInsets.all(12), child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold))),
                        Padding(padding: EdgeInsets.all(12), child: Text('Name', style: TextStyle(fontWeight: FontWeight.bold))),
                        Padding(padding: EdgeInsets.all(12), child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                        Padding(padding: EdgeInsets.all(12), child: Text('Mobile', style: TextStyle(fontWeight: FontWeight.bold))),
                        Padding(padding: EdgeInsets.all(12), child: Text('Country', style: TextStyle(fontWeight: FontWeight.bold))),
                        Padding(padding: EdgeInsets.all(12), child: Text('State', style: TextStyle(fontWeight: FontWeight.bold))),
                        Padding(padding: EdgeInsets.all(12), child: Text('District', style: TextStyle(fontWeight: FontWeight.bold))),
                        Padding(padding: EdgeInsets.all(12), child: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                    ),
                    ...employees.map((employee) {
                      return TableRow(
                        children: [
                          Padding(padding: const EdgeInsets.all(12), child: Text(employee.id)),
                          Padding(padding: const EdgeInsets.all(12), child: Text(employee.name)),
                          Padding(padding: const EdgeInsets.all(12), child: Text(employee.email)),
                          Padding(padding: const EdgeInsets.all(12), child: Text(employee.mobile)),
                          Padding(padding: const EdgeInsets.all(12), child: Text(employee.country)),
                          Padding(padding: const EdgeInsets.all(12), child: Text(employee.state)),
                          Padding(padding: const EdgeInsets.all(12), child: Text(employee.district)),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
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
                    }),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
