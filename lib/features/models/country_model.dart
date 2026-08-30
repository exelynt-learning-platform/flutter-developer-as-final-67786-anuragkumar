import 'package:flutter/foundation.dart';

@immutable
class Country {
  const Country({
    required this.id,
    required this.country,
    this.flag,
  });

  final String id;
  final String country;
  final String? flag;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Country &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            country == other.country &&
            flag == other.flag;
  }

  @override
  int get hashCode => Object.hash(id, country, flag);
}

class CountryModel {
  const CountryModel({
    required this.id,
    required this.country,
    this.flag,
    this.createdAt,
  });

  final String id;
  final String country;
  final String? flag;
  final DateTime? createdAt;

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      id: json['id']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      flag: json['flag']?.toString(),
      createdAt: DateTime.tryParse(
        json['createdAt']?.toString() ?? '',
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'country': country,
      if (flag != null) 'flag': flag,
    };
  }

  Country toEntity() {
    return Country(
      id: id,
      country: country,
      flag: flag,
    );
  }
}
