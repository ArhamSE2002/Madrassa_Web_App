class MadrassaModel {
  final String id, name, address;
  final List<String> studentIds;
  final List<String> approvedCourseIds;

  MadrassaModel({
    required this.id,
    required this.name,
    required this.address,
    this.studentIds = const [],
    this.approvedCourseIds = const [],
  });

  factory MadrassaModel.fromJson(Map<String, dynamic> json) => MadrassaModel(
    id: json['id'],
    name: json['name'],
    address: json['address'],
    studentIds: List<String>.from(json['studentIds'] ?? []),
    approvedCourseIds: List<String>.from(json['approvedCourseIds'] ?? []),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'address': address,
    'studentIds': studentIds,
    'approvedCourseIds': approvedCourseIds,
  };
}
