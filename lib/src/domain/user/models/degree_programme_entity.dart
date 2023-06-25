import 'package:equatable/equatable.dart';

class DegreeProgrammeEntity implements Equatable {
  const DegreeProgrammeEntity({
    required this.id,
    required this.type,
    required this.name,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String type;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DegreeProgrammeEntity.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        type = json['type'],
        name = json['name'],
        createdAt = DateTime.tryParse(json['created_at'].toString()),
        updatedAt = DateTime.tryParse(json['updated_at'].toString());

  @override
  String toString() {
    return name;
  }

  @override
  List<Object?> get props => [id, type, name];

  @override
  bool? get stringify => true;
}
