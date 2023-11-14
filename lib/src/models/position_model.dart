import '../model.dart';

class PositionModel extends Model {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PositionModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PositionModel.fromJson(Map<String, dynamic> json) => PositionModel(
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