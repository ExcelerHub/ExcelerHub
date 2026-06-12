import '../models/user_model.dart';

List<UserModel> getDummyUsers() {
  return [
    UserModel(
      id: 'user_1',
      name: 'Alex Mercer',
      email: 'alex@excelerhub.com',
      password: 'password123',
      joinedPrograms: ['prog_1', 'prog_3'],
      completedPrograms: ['prog_6'],
      achievements: ['UI/UX Mastery', 'Orientation Completed', 'Early Bird Learner'],
    ),
    UserModel(
      id: 'user_2',
      name: 'Sneha Rao',
      email: 'sneha@excelerhub.com',
      password: 'password123',
      joinedPrograms: ['prog_2'],
      completedPrograms: [],
      achievements: ['Quick Starter'],
    ),
  ];
}
