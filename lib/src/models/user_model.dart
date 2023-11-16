import '../model.dart';
import 'aspirant_model.dart';
import 'role_model.dart';

class UserModel extends Model {
  final int id;
  final String name;
  final String email;
  final String phoneNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool hasAspirantCreationRequest;
  final bool hasAspirantUpdateRequest;
  final AspirantModel? aspirant;
  final RoleModel? role;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.hasAspirantCreationRequest,
    required this.hasAspirantUpdateRequest,
    this.aspirant,
    this.role
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    phoneNumber: json['phone_number'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
    hasAspirantCreationRequest: json['has_aspirant_creation_request'],
    hasAspirantUpdateRequest: json['has_aspirant_update_request'],
    aspirant: json['aspirant'] != null ? AspirantModel.fromJson(json['aspirant']) : null,
    role: json['role'] != null ? RoleModel.fromJson(json['role']) : null
  );

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'email': email,
    'phone_number': phoneNumber,
    'created_at': createdAt.toString(),
    'updated_at': updatedAt.toString(),
    'has_aspirant_creation_request': hasAspirantCreationRequest,
    'has_aspirant_update_request': hasAspirantUpdateRequest,
    'aspirant': aspirant,
    'role': role
  };
}
