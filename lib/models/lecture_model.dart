enum LectureType { video, pdf, image, doc }

class LectureModel {
  final String id, title, resourceUrl;
  final LectureType type;
  final int order;

  LectureModel({
    required this.id,
    required this.title,
    required this.resourceUrl,
    required this.type,
    required this.order,
  });

  factory LectureModel.fromJson(Map<String, dynamic> json) => LectureModel(
    id: json['id'],
    title: json['title'],
    resourceUrl: json['resourceUrl'],
    type: LectureType.values.firstWhere(
      (e) => e.toString() == 'LectureType.${json['type']}',
    ),
    order: json['order'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'resourceUrl': resourceUrl,
    'type': type.toString().split('.').last,
    'order': order,
  };
}
