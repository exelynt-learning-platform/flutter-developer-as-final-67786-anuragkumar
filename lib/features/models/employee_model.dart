import 'package:flutter/foundation.dart';

@immutable
class Employee {
  const Employee({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.country,
    required this.state,
    required this.district,
    this.countryId,
    this.avatar,
  });

  final String id;
  final String name;
  final String email;
  final String mobile;
  final String country;
  final String state;
  final String district;
  final String? countryId;
  final String? avatar;

  Employee copyWith({
    String? id,
    String? name,
    String? email,
    String? mobile,
    String? country,
    String? state,
    String? district,
    String? countryId,
    String? avatar,
  }) {
    return Employee(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      country: country ?? this.country,
      state: state ?? this.state,
      district: district ?? this.district,
      countryId: countryId ?? this.countryId,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Employee &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            name == other.name &&
            email == other.email &&
            mobile == other.mobile &&
            country == other.country &&
            state == other.state &&
            district == other.district &&
            countryId == other.countryId &&
            avatar == other.avatar;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      email,
      mobile,
      country,
      state,
      district,
      countryId,
      avatar,
    );
  }
}


class EmployeeModel {
  const EmployeeModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.country,
    required this.state,
    required this.district,
    this.countryId,
    this.avatar,
    this.createdAt,
  });

  final String id;
  final String name;
  final String email;
  final String mobile;
  final String country;
  final String state;
  final String district;
  final String? countryId;
  final String? avatar;
  final DateTime? createdAt;

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? json['emailId']?.toString() ?? '',
      mobile: json['mobile']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      district: json['district']?.toString() ?? '',
      countryId: json['countryId']?.toString(),
      avatar: json['avatar']?.toString(),
      createdAt: DateTime.tryParse(
        json['createdAt']?.toString() ?? '',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'mobile': mobile,
      'country': country,
      'state': state,
      'district': district,
      if (countryId != null) 'countryId': countryId,
      if (avatar != null) 'avatar': avatar,
    };
  }

  Employee toEntity() {
    return Employee(
      id: id,
      name: name,
      email: email,
      mobile: mobile,
      country: country,
      state: state,
      district: district,
      countryId: countryId,
      avatar: avatar,
    );
  }

  factory EmployeeModel.fromEntity(Employee employee) {
    return EmployeeModel(
      id: employee.id,
      name: employee.name,
      email: employee.email,
      mobile: employee.mobile,
      country: employee.country,
      state: employee.state,
      district: employee.district,
      countryId: employee.countryId,
      avatar: employee.avatar,
    );
  }
}
