import '../models/task_model.dart';

List<TaskModel> getDummyTasks() {
  return [
    TaskModel(
      id: 'task_1',
      userId: 'user_1',
      title: 'Environment Setup',
      isCompleted: true,
      programId: 'prog_1',
    ),
    TaskModel(
      id: 'task_2',
      userId: 'user_1',
      title: 'Profile Creation',
      isCompleted: true,
      programId: 'prog_1',
    ),
    TaskModel(
      id: 'task_3',
      userId: 'user_1',
      title: 'Week 1 Assignment',
      isCompleted: false,
      programId: 'prog_1',
    ),
    TaskModel(
      id: 'task_4',
      userId: 'user_1',
      title: 'Week 2 Assignment',
      isCompleted: false,
      programId: 'prog_1',
    ),
    TaskModel(
      id: 'task_5',
      userId: 'user_1',
      title: 'Mentor Session',
      isCompleted: false,
      programId: 'prog_1',
    ),

    // User 2 (Sneha)
    TaskModel(
      id: 'task_6',
      userId: 'user_2',
      title: 'Environment Setup',
      isCompleted: true,
      programId: 'prog_2',
    ),
    TaskModel(
      id: 'task_7',
      userId: 'user_2',
      title: 'Profile Creation',
      isCompleted: false,
      programId: 'prog_2',
    ),
    TaskModel(
      id: 'task_8',
      userId: 'user_2',
      title: 'Week 1 Assignment',
      isCompleted: false,
      programId: 'prog_2',
    ),
    TaskModel(
      id: 'task_9',
      userId: 'user_2',
      title: 'Week 2 Assignment',
      isCompleted: false,
      programId: 'prog_2',
    ),
    TaskModel(
      id: 'task_10',
      userId: 'user_2',
      title: 'Mentor Session',
      isCompleted: false,
      programId: 'prog_2',
    ),
  ];
}

List<String> getTaskTemplates() {
  return [
    'Environment Setup',
    'Profile Creation',
    'Week 1 Assignment',
    'Week 2 Assignment',
    'Mentor Session',
  ];
}
