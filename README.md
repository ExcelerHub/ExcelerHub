# 🚀 ExcelerHub – Learning & Internship Management Platform

### Learn • Grow • Connect

ExcelerHub is a complete, real-world **cross-platform Learning & Internship Management Platform** mobile application built using Flutter, Dart, and Material 3. It features clean architecture, reusable UI widgets, and a dynamic local state management system powered by mock database repositories.

---

## 📱 Features

1. **🔐 Authentication Flow**:
   - **Splash Screen**: Interactive fade/scale animated app branding.
   - **Login Screen**: Secure user session validation matching local database credentials.
   - **Register Screen**: Fully validated signup (Full Name, Email, Password length check, and Confirm Password matching) to register dynamic learners.

2. **🏠 Interactive Dashboard**:
   - Personalized welcome banner dynamically rendering the logged-in learner's name.
   - Overall completion metrics and progress bar showing completed vs. total tasks.
   - Grid layout for quick access (Programs, Tasks, Profile, Announcements).
   - Upcoming internship events slide list.
   - Recent announcements and notifications preview.
   - Search bar linking directly to filterable programs.

3. **📚 Program Browser & Directory**:
   - Detailed program cards with cover images, durations, start dates, and mentor details.
   - Live search bar filtering by titles, mentors, or skills.
   - Category filter chips (All, Joined, Mobile, Data & AI, Design).

4. **📄 Program Detail & Joining**:
   - Cover view, program details, mentor biography, eligibility criteria, and skill competencies.
   - **Join Program**: Enrolls user, dynamically updates the profile screen, initializes program-specific checklists in the Task Tracker, and shows immediate Snackbar confirmation.

5. **✅ Task Tracker Checklist**:
   - Interactive checklist with custom animated checkbox tiles.
   - Filter tabs (All, Pending, Done).
   - Dynamic progress updates recalculating user completion statistics instantly.

6. **📝 Program Feedback System**:
   - Interactive 5-star ratings.
   - Questionnaire details (satisfaction levels, learning outcomes, suggestions).
   - Instant snackbar feedback and return navigation.

7. **👤 Profile Management**:
   - Edit dialog to dynamically update Name and Email in-session.
   - Dynamic gamified badge list for achievements (e.g. Enrolled in Cohort, Completed Program).
   - Enrolled programs tracking section with status indicator chips.
   - Secure Logout action.

8. **📢 Announcements & Alert Inbox**:
   - Category-filtered tabs (General Feed and Notification Warnings/Alerts).
   - Custom category icons matching types (Opportunities, Schedule, Deadline, Webinar, System).

---

## 📐 Folder Structure

The project conforms to a Clean Architecture folder structure:

```
lib/
├── main.dart                      # App initialization & global theme routing
├── models/
│   ├── user_model.dart            # User configuration (id, joined/completed progs, achievements)
│   ├── program_model.dart         # Internship detail attributes
│   ├── task_model.dart            # Checklist status properties
│   ├── announcement_model.dart    # Feed alerts schemas
│   └── feedback_model.dart        # Submissions metadata
├── data/
│   ├── dummy_users.dart           # Default mock users
│   ├── dummy_programs.dart        # Mock internship listings
│   ├── dummy_tasks.dart           # Pre-configured tasks per learner
│   ├── dummy_announcements.dart   # System notification feeds
│   └── dummy_feedback.dart        # Pre-seeded ratings data
├── services/
│   ├── auth_service.dart          # Singleton handling session auth state
│   └── mock_database.dart         # Singleton serving as in-memory state repository
├── utils/
│   ├── app_colors.dart            # Centralized brand primary/secondary palettes
│   ├── app_theme.dart             # Material 3 theme configuration
│   └── constants.dart             # Layout measurements, taglines & placeholders
└── widgets/
    ├── custom_button.dart         # Gradient elevated/outlined buttons
    ├── custom_textfield.dart      # Standard input decoration with obscure capability
    ├── program_card.dart          # Visual thumbnail summary for programs
    ├── progress_card.dart         # Linear progress bar overlay
    ├── task_tile.dart             # Custom checkbox tile
    ├── announcement_card.dart     # System message component
    ├── skill_chip.dart            # Skill tag indicator
    └── custom_app_bar.dart        # Consistent header with iOS styled back chevron
```

---

## 🛠️ Technology Stack

* **Core Framework:** Flutter (Null Safety, Material 3)
* **Programming Language:** Dart
* **Architecture:** Clean Architecture with Single Source of Truth Repository singles
* **State Management:** Reactive Local State using `ListenableBuilder` and singletons extending `ChangeNotifier`
* **Styling:** Custom Material 3 theme tokens

---

## ⚙️ Installation & Setup

Ensure Flutter is installed on your local computer.

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/ExcelerateOrg/excelerhub.git
   cd excelerhub
   ```

2. **Retrieve Dependencies**:
   ```bash
   flutter pub get
   ```

3. **Verify Code Quality**:
   ```bash
   flutter analyze
   ```

4. **Launch Application**:
   ```bash
   flutter run
   ```

---

## 📌 Suggested Git Commit Messages

To preserve clean release tracking, use the following chronological commit structure:

1. `Initial Flutter Project Setup` - Initial project folders, package config, and setup.
2. `Added Authentication Screens` - Implemented Splash, Login, and Registration screens with validation.
3. `Implemented Dashboard UI` - Completed Dashboard sections, events slider, progress indicators.
4. `Added Program Listing Feature` - Created ProgramListingScreen with category chips filter.
5. `Implemented Program Details Screen` - Implemented detail banner, skills chips, and Join logic.
6. `Added Task Tracker Module` - Implemented interactive task toggle checkmarks and progress values.
7. `Implemented Profile Management` - Added Profile avatar, badges list, and edit bottom sheet.
8. `Added Announcements Module` - Wired search filters, General feed, and Alert notifications.
9. `Integrated Navigation Flow` - Linked back chevron navigation and route bindings.
10. `Completed ExcelerHub MVP` - Done final code refactoring and validation checks.

---

## 🔮 Future Enhancements

* **Database Engine**: Transition Mock repositories into SQLite (local database persistence) or Firebase Cloud Firestore.
* **Push Notifications**: Integrate Firebase Cloud Messaging (FCM) for deadline reminders.
* **Document Upload**: Support uploading PDFs/GitHub repository links for assignment task completions.
* **Calendar Syncing**: Auto-add mentor meetings to user Google/Apple Calendar.