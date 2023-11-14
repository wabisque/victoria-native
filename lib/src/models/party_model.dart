import '../model.dart';

class PartyModel extends Model {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PartyModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PartyModel.fromJson(Map<String, dynamic> json) => PartyModel(
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