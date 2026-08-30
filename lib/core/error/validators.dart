const nameRegex = r"^[a-zA-Z]+(?:[ '-][a-zA-Z]+)*$";
const emailRegex = r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)+$";
  
  String? nameValidator(String? value, String label, {bool isRequired = false, int max = 50}) {
    final name = value?.trim() ?? '';

    if (name.isEmpty && isRequired) return '$label is required';
    if (name.length < 2) return '$label must be at least 2 characters';
    if (name.length > max) return '$label must not exceed $max characters';
    final regex = RegExp(nameRegex);
    if (!regex.hasMatch(name)) return 'Enter a valid $label';
    return null;
  }

  String? emailValidator(String? value) {
    final email = value?.trim() ?? '';

    if (email.isEmpty) return 'Email is required';
    final regex = RegExp(emailRegex);
    if (!regex.hasMatch(email)) return 'Enter a valid email address';
    return null;
  }

  String? mobileValidator(String? value) {
    final mobile = value?.trim() ?? '';
    if (mobile.isEmpty) return 'Mobile is required';
    if (!RegExp(r'^\d{10}$').hasMatch(mobile)) return 'Enter a valid 10-digit mobile number';
    return null;
  }
