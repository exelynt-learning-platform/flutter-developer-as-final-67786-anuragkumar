import 'package:employee_management_app/features/models/employee_model.dart';
import 'package:flutter/material.dart';


class EmployeeCard extends StatelessWidget {
  const EmployeeCard({
    required this.employee,
    required this.onDelete,
    required this.onEdit,
    super.key,
  });

  final Employee employee;
  final ValueChanged<Employee> onDelete;
  final ValueChanged<Employee> onEdit;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  child: employee.avatar != null && employee.avatar!.isNotEmpty ? ClipOval(
                      child: Image.network(
                        employee.avatar!,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.person, size: 20);
                        },
                      ),
                    ) : Text(employee.name.isNotEmpty ? employee.name[0].toUpperCase() : '?'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'ID: ${employee.id}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
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

            // const SizedBox(height: 12),
            // const Divider(),
            const SizedBox(height: 12),

            _EmployeeInfoGrid(employee: employee),
          ],
        ),
      ),
    );
  }
}

class _EmployeeInfoGrid extends StatelessWidget {
  const _EmployeeInfoGrid({
    required this.employee,
  });

  final Employee employee;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 5,
      runSpacing: 5,
      children: [
        _EmployeeInfoChip(icon: Icons.email_outlined, value: employee.email),
        _EmployeeInfoChip(icon: Icons.phone_outlined, value: employee.mobile),
        _EmployeeInfoChip(icon: Icons.public, label: 'Country', value: employee.country),
        _EmployeeInfoChip(icon: Icons.location_city_outlined, label: 'State', value: employee.state),
        _EmployeeInfoChip(icon: Icons.location_on_outlined, label: 'District', value: employee.district),
      ],
    );
  }
}

class _EmployeeInfoChip extends StatelessWidget {
  const _EmployeeInfoChip({
    required this.icon,
    required this.value,
    this.label,
  });

  final IconData icon;
  final String? label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final color = ThemeData().colorScheme.primary.withValues(alpha: 0.15);
    return Chip(
      backgroundColor: color,
      avatar: Icon(icon, size: 18),
      label: Text(
        label != null && label?.trim() != '' ? '$label: $value' : value,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}