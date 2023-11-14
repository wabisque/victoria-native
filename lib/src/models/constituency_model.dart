import '../model.dart';
import 'region_model.dart';

class ConstituencyModel extends Model {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final RegionModel? region;

  const ConstituencyModel({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.region
  });

  factory ConstituencyModel.fromJson(Map<String, dynamic> json) => ConstituencyModel(
    id: json['id'],
    name: json['name'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
    region: json['region'] != null ? RegionModel.fromJson(json['region']) : null
  );

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'created_at': createdAt.toString(),
    'updated_at': updatedAt.toString(),
    'region': region
  };
}