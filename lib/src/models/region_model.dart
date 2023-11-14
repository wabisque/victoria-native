import '../model.dart';

class RegionModel extends Model {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RegionModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) => RegionModel(
    id: json['id'],
    name: json['name'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at'])
  );

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'created_at': createdAt.toString(),
    'updated_at': updatedAt.toString()
  };
}
