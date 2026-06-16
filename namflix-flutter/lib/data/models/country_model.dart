import '../../domain/entities/country.dart';

class CountryModel extends Country {
  const CountryModel({required super.code, required super.name, super.flag});

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
    code: (json['code'] as String? ?? '').toLowerCase(),
    name: json['name'] as String? ?? '',
    flag: json['flag'] as String?,
  );

  Map<String, dynamic> toJson() => {'code': code, 'name': name, 'flag': flag};
}
