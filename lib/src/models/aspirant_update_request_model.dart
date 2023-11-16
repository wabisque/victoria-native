import '../model.dart';
import 'aspirant_model.dart';
import 'constituency_model.dart';
import 'party_model.dart';
import 'position_model.dart';

class AspirantUpdateRequestModel extends Model {
  final int id;
  final String address;
  final Uri flyer;
  final DateTime createdAt;
  final DateTime updatedAt;
  final AspirantModel? aspirant;
  final ConstituencyModel? constituency;
  final PartyModel? party;
  final PositionModel? position;

  const AspirantUpdateRequestModel({
    required this.id,
    required this.address,
    required this.flyer,
    required this.createdAt,
    required this.updatedAt,
    this.aspirant,
    this.constituency,
    this.party,
    this.position
  });

  factory AspirantUpdateRequestModel.fromJson(Map<String, dynamic> json) => AspirantUpdateRequestModel(
    id: json['id'],
    address: json['address'],
    flyer: Uri.parse(json['flyer']),
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
    aspirant: json['aspirant'] != null ? AspirantModel.fromJson(json['aspirant']) : null,
    constituency: json['constituency'] != null ? ConstituencyModel.fromJson(json['constituency']) : null,
    party: json['party'] != null ? PartyModel.fromJson(json['party']) : null,
    position: json['position'] != null ? PositionModel.fromJson(json['position']) : null
  );

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'address': address,
    'flyer': flyer.toString(),
    'created_at': createdAt.toString(),
    'updated_at': updatedAt.toString(),
    'aspirant': aspirant,
    'constituency': constituency,
    'party': party,
    'position': position
  };
}
