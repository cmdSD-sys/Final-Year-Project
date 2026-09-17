# K.K. Wagh Polytechnic, Nashik — Internal Institute Academic Monitoring System

A modern, cross-platform Flutter application engineered for educational institutions to automate, validate, and manage academic monitoring formats, faculty contact hours, and curriculum compliance.

---

## 🌟 Key Features

### 1. Role-Based Access & Dashboards
- **Administrator Dashboard**: Complete overview of submissions, bulk actions, Excel catalog uploads, faculty management, and global reset capabilities.
- **Faculty User Dashboard**: Dedicated view for faculty members to review program submissions and export reports.
- **Profile & Identity**: Custom user profile photo upload (`.png`, `.jpg`, `.jpeg`, `.webp`), editable display names, and authority badges.

### 2. Multi-Year Academic Monitoring Format
- **3-Year Academic Term Flexibility**: Independent week selectors for:
  - 1st Year (1st & 2nd Semesters)
  - 2nd Year (3rd & 4th Semesters)
  - 3rd Year (5th & 6th Semesters)
- **Automatic Contact Hour Calculations**:
  - Theory (TH), Practical (PR), and Tutorial (TU) prescribed hours dynamically multiplied by completed weeks.
  - Handles non-applicable components smoothly (`NA`).
- **Duplicate Faculty Detection**: Live indicator alerts when a faculty member is assigned to multiple rows, with tooltips pinpointing exact row occurrences.

### 3. Dynamic Curriculum & Faculty Catalog
- **Department-Wise Faculty Filtering**: Filter faculty members by academic department/program.
- **Dynamic Semester Subject Filtering**: Filter subjects by department and active semester.
- **Excel Master Sheet Import**: Fast uploading and parsing of faculty rosters and curriculum sheets with built-in validation.
- **Sample Excel Template Downloads**: Instant generation of sample faculty and curriculum sheets directly from the app.

### 4. Institutional DOCX Report Export
- Generate official academic monitoring documents matching institutional guidelines.
- Flexible export options:
  - **Save to Custom Location**: Desktop file picker to choose destination folder and filename.
  - **Quick Save to Downloads**: Automatic direct save to default system downloads folder.
  - In-app **Copy Path** and **Show in Folder** actions for quick access.

### 5. Institutional UI & Theme
- **Dual-Theme Support**: Clean Institutional Navy Light Theme and Deep Midnight Dark Theme.
- **Modern Floating SnackBars**: Custom styled status notifications matching institutional aesthetics.
- **Unified Preview**: Comprehensive submission detail dialogs with dark mode optimization and responsive metadata chips.

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.24.0 or higher recommended)
- [Dart SDK](https://dart.dev/get-dart)
- Chrome / Edge (for Web) or Visual Studio C++ Build Tools (for Windows Desktop)

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/cmdSD-sys/Final-Year-Project.git
   cd Final-Year-Project
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   # Run in Chrome (Web)
   flutter run -d chrome

   # Run on Windows Desktop
   flutter run -d windows
   ```

---

## 🧪 Testing & Static Analysis

Run the automated test suite:
```bash
flutter test
```

Run static analysis:
```bash
flutter analyze
```

---

## 🛠️ Tech Stack & Packages
- **Framework**: Flutter / Dart
- **Architecture**: Layered service-state pattern with `AppState` ChangeNotifier
- **Excel Processing**: `excel: ^4.0.6`
- **File System & Pickers**: `file_picker: ^8.1.6`, `path_provider: ^2.1.5`
- **Document Templating**: `docx_template: ^0.4.1`, `archive: ^3.6.1`
- **Formatting & Utilities**: `intl: ^0.19.0`
