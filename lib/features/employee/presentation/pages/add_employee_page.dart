import 'package:employee_management_app/core/error/validators.dart';
import 'package:employee_management_app/core/utils/app_snackbar.dart';
import 'package:employee_management_app/core/widgets/app_text_field.dart';
import 'package:go_router/go_router.dart';
import 'package:employee_management_app/app/providers/employee_providers.dart';
import 'package:employee_management_app/features/models/country_model.dart';
import 'package:employee_management_app/features/models/employee_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class AddEmployeePage extends ConsumerStatefulWidget {
  final Employee? employee;

  const AddEmployeePage({this.employee, super.key});

  bool get isEditMode => employee != null;

  @override
  ConsumerState<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends ConsumerState<AddEmployeePage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _stateController = TextEditingController();
  final _districtController = TextEditingController();

  CountryModel? _selectedCountry;
  bool _isSaving = false;

  bool _isLoadingCountries = true;
  List<CountryModel> _countries = [];

  @override
  void initState() {
    super.initState();
    final employee = widget.employee;

    if (employee != null) {
      _nameController.text = employee.name;
      _emailController.text = employee.email;
      _mobileController.text = employee.mobile;
      _stateController.text = employee.state;
      _districtController.text = employee.district;
    }
    _loadCountries();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _stateController.dispose();
    _districtController.dispose();

    super.dispose();
  }

  Future<void> _loadCountries() async {
    try {
      final getCountries = ref.read(getCountriesProvider);
      final countries = await getCountries();

      if (!mounted) return;
      CountryModel? selectedCountry;

      if (widget.employee != null) {
        for (final country in countries) {
          if (country.id == widget.employee!.countryId || (country.country == widget.employee!.country)) {
            selectedCountry = country;
            break;
          }
        }
      }

      setState(() {
        _countries = countries;
        _isLoadingCountries = false;
        _selectedCountry = selectedCountry;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !widget.isEditMode) return;
        _updateFormValidity();
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoadingCountries = false;
      });
    }
  }

  Future<void> _saveEmployee() async {
    if (!_formKey.currentState!.validate() || _isSaving) {
      return;
    }

    if (_selectedCountry == null) {
      AppSnackbar.show('Please select a country.');
      return;
    }
    setState(() {
      _isSaving = true;
    });
    final notifier = ref.read(employeeNotifierProvider.notifier);

    final employee = Employee(
      id: '',
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      mobile: _mobileController.text.trim(),
      country: _selectedCountry!.country,
      countryId: _selectedCountry!.id,
      state: _stateController.text.trim(),
      district: _districtController.text.trim(),
    );

    final Employee? result;
    if (widget.isEditMode) {
      final updatedEmployee = employee.copyWith(id: widget.employee!.id);
      result = await notifier.updateEmployee(updatedEmployee);
    } else {
      result = await notifier.createEmployee(employee);
    }
    if (!mounted) return;

    if (result != null) {
      AppSnackbar.success(widget.isEditMode ? 'Employee updated successfully.' : 'Employee created successfully.');
      context.pop();
    } else {
      final state = ref.read(employeeNotifierProvider);
      AppSnackbar.error(state.message ?? 'Unable to create employee.');
    }
    setState(() {
      _isSaving = false;
    });
  }

  bool _isFormValid = false;
  
  void _updateFormValidity() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (isValid != _isFormValid && mounted) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditMode ? 'Edit Employee' : 'Add Employee'),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 1000,
                  ),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                      child: Form(
                        key: _formKey,
                        child: _buildForm(context),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 16.0;
        const minFieldWidth = 300.0;

        final columns = (constraints.maxWidth / (minFieldWidth + spacing)).floor().clamp(1, 3);

        final fieldWidth = (constraints.maxWidth - (columns - 1) * spacing) / columns;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                SizedBox(
                  width: fieldWidth,
                  child: _buildNameField(),
                ),
                SizedBox(
                  width: fieldWidth,
                  child: _buildEmailField(),
                ),
                SizedBox(
                  width: fieldWidth,
                  child: _buildMobileField(),
                ),
                SizedBox(
                  width: fieldWidth,
                  child: Column(
                    children: [
                      _buildCountryField(),
                      if(_isLoadingCountries)...[
                        const SizedBox(height: 8),
                        LinearProgressIndicator()
                      ],
                    ],
                  ),
                ),
                SizedBox(
                  width: fieldWidth,
                  child: _buildStateField(),
                ),
                SizedBox(
                  width: fieldWidth,
                  child: _buildDistrictField(),
                ),
              ],
            ),

            const SizedBox(height: 32),

            _buildActions(),
          ],
        );
      },
    );
  }

  Widget _buildNameField() {
    return TextControl(
      controller: _nameController,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Name',
        hintText: 'Enter employee name',
        prefixIcon: Icon(Icons.person_outline),
      ),
      validator: (value) => nameValidator(value, 'Name', isRequired: true),
      onChanged: (value) => _updateFormValidity(),
    );
  }

  Widget _buildEmailField() {
    return TextControl(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Email',
        hintText: 'Enter employee email',
        prefixIcon: Icon(Icons.email_outlined),
      ),
      validator: emailValidator,
      onChanged: (value) => _updateFormValidity(),
    );
  }

  Widget _buildMobileField() {
    return TextControl(
      controller: _mobileController,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      maxLength: 10,
      decoration: const InputDecoration(
        labelText: 'Mobile',
        hintText: 'Enter 10-digit mobile',
        prefixIcon: Icon(Icons.phone_outlined),
      ),
      validator: mobileValidator,
      onChanged: (value) => _updateFormValidity(),
    );
  }

  Widget _buildCountryField() {
    return DropdownButtonFormField<CountryModel>(
      key: ValueKey(_selectedCountry?.id),
      initialValue: _selectedCountry,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Country',
        prefixIcon: Icon(Icons.public),
        border: OutlineInputBorder(),
        isDense: true,
      ),
      items: _countries.map((country) {
        return DropdownMenuItem<CountryModel>(
          value: country,
          child: Text(country.country, overflow: TextOverflow.ellipsis),
        );
      }).toList(),
      onChanged: (country) {
        setState(() {
          _selectedCountry = country;
        });
        _updateFormValidity();
      },
      validator: (value) {
        if (value == null) {
          return 'Country is required';
        }
        return null;
      },
    );
  }

  Widget _buildStateField() {
    return TextControl(
      controller: _stateController,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'State',
        hintText: 'Enter state',
        prefixIcon: Icon(Icons.location_on_outlined),
      ),
      validator: (value) => nameValidator(value, 'State', isRequired: true),
      onChanged: (value) => _updateFormValidity(),
    );
  }

  Widget _buildDistrictField() {
    return TextControl(
      controller: _districtController,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        labelText: 'District',
        hintText: 'Enter district',
        prefixIcon: Icon(Icons.location_city_outlined),
      ),
      validator: (value) => nameValidator(value, 'District', isRequired: true),
      onChanged: (value) => _updateFormValidity(),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () {
            context.pop();
          },
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 12),
        FilledButton.icon(
          onPressed: _buttonDisabled ? null : _saveEmployee,
          icon: _isSaving ? const SizedBox.square(dimension: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.save_outlined),
          label: Text(_isSaving ? 'Saving...' : widget.isEditMode ? 'Update Employee' : 'Save Employee'),
        ),
      ],
    );
  }

  bool get _buttonDisabled => _isSaving || !_isFormValid;
}
