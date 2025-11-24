import '../models/madrassa_model.dart';

final List<MadrassaModel> mockMadrassas = [
  MadrassaModel(
    id: 'madrassa-1',
    name: 'Darul Uloom Karachi',
    address: 'Karachi, Pakistan',
    studentIds: const ['student-1', 'student-2'],
    approvedCourseIds: const ['1', '3'],
  ),
  MadrassaModel(
    id: 'madrassa-2',
    name: 'Jamia Hafsa',
    address: 'Islamabad, Pakistan',
    studentIds: const ['student-3'],
    approvedCourseIds: const ['2'],
  ),
];
