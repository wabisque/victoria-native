import '../model.dart';
import 'aspirant_model.dart';

class PostModel extends Model {
  final int id;
  final String title;
  final String body;
  final DateTime createdAt;
  final DateTime updatedAt;
  final AspirantModel? aspirant;

  const PostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
    this.aspirant
  });

  factory PostModel.fromJson(Map<String, dynamic> json) => PostModel(
    id: json['id'],
    title: json['title'],
    body: json['body'],
    createdAt: DateTime.parse(json['created_at']),
    updatedAt: DateTime.parse(json['updated_at']),
    aspirant: json['aspirant'] != null ? AspirantModel.fromJson(json['aspirant']) : null
  );

  @override
  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'body': body,
    'created_at': createdAt.toString(),
    'updated_at': updatedAt.toString(),
    'aspirant': aspirant
  };
}
