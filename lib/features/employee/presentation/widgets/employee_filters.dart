import 'package:employee_management_app/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';

class EmployeeFilters extends StatelessWidget {
  const EmployeeFilters({
    required this.nameController,
    required this.emailController,
    required this.mobileController,
    required this.countryController,
    required this.onChanged,
    super.key,
  });

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController mobileController;
  final TextEditingController countryController;

  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextControl(
          controller: nameController,
          decoration: const InputDecoration(
            labelText: 'Name',
            prefixIcon: Icon(Icons.person_outline),
          ),
          onChanged: (_) => onChanged(),
        ),

        const SizedBox(height: 12),

        TextControl(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email_outlined),
          ),
          onChanged: (_) => onChanged(),
        ),

        const SizedBox(height: 12),

        TextControl(
          controller: mobileController,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Mobile',
            prefixIcon: Icon(Icons.phone_outlined),
          ),
          onChanged: (_) => onChanged(),
        ),

        const SizedBox(height: 12),

        TextControl(
          controller: countryController,
          decoration: const InputDecoration(
            labelText: 'Country',
            prefixIcon: Icon(Icons.public),
          ),
          onChanged: (_) => onChanged(),
        ),
      ],
    );
  }
}
