import '../model.dart';
import 'constituency_model.dart';
import 'party_model.dart';
import 'position_model.dart';
import 'user_model.dart';

class AspirantModel extends Model {
  final int id;
  final String address;
  final Uri flyer;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ConstituencyModel? constituency;
  final PartyModel? party;
  final PositionModel? position;
  final UserModel? user;

  const AspirantModel({
    required this.id,
    required this.address,
    required this.flyer,
    required this.createdAt,
    required this.updatedAt,
    this.constituency,
    this.party,
    this.position,
    this.user
  });

  factory AspirantModel.fromJson(Map<String, dynamic> json) => AspirantModel(
    id: json['id'],
    address: json['address'],
    flyer: Uri.parse(json['flyer']),
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
    constituency: json['constituency'] != null ? ConstituencyModel.fromJson(json['constituency']) : null,
    party: json['party'] != null ? PartyModel.fromJson(json['party']) : null,
    position: json['position'] != null ? PositionModel.fromJson(json['position']) : null,
    user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
  );

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'address': address,
    'flyer': flyer.toString(),
    'created_at': createdAt.toString(),
    'updated_at': updatedAt.toString(),
    'constituency': constituency,
    'party': party,
    'position': position,
    'user': user
  };
}
