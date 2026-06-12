import '../models/announcement_model.dart';

List<AnnouncementModel> getDummyAnnouncements() {
  return [
    AnnouncementModel(
      id: 'ann_1',
      title: 'New Internship Opportunities Available',
      content: 'We have added UI/UX Design and Cybersecurity internship positions for the Summer 2026 cohort. Apply today before slots fill up!',
      date: 'June 12, 2026',
      category: 'Opportunities',
      type: 'Notification',
    ),
    AnnouncementModel(
      id: 'ann_2',
      title: 'Week 2 Submission Deadline',
      content: 'Reminder: The submission deadline for Week 2 Assignments for all running tracks is this Sunday at 11:59 PM. Make sure to push your code to your repositories.',
      date: 'June 11, 2026',
      category: 'Deadline',
      type: 'Reminder',
    ),
    AnnouncementModel(
      id: 'ann_3',
      title: 'Mentor Session Schedule Released',
      content: 'Your weekly 1-on-1 and group mentor sessions have been scheduled. Please check your Dashboard and calendar to join the live video links.',
      date: 'June 10, 2026',
      category: 'Schedule',
      type: 'Update',
    ),
    AnnouncementModel(
      id: 'ann_4',
      title: 'Upcoming Webinar Registration Open',
      content: 'Join us this Friday for an exclusive webinar on "Succeeding in Modern Mobile Architectures" with speakers from Google and Flutter community.',
      date: 'June 09, 2026',
      category: 'Webinar',
      type: 'Update',
    ),
    AnnouncementModel(
      id: 'ann_5',
      title: 'System Maintenance Window',
      content: 'ExcelerHub platform will undergo minor upgrades on Saturday from 2:00 AM to 4:00 AM UTC. Some features might experience brief interruptions.',
      date: 'June 08, 2026',
      category: 'System',
      type: 'System Notifications',
    ),
  ];
}
