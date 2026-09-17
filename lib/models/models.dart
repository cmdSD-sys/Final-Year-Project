class ProgramInfo {
  final String code;
  final String name;

  const ProgramInfo({
    required this.code,
    required this.name,
  });

  Map<String, dynamic> toJson() => {
        'code': code,
        'name': name,
      };

  factory ProgramInfo.fromJson(Map<String, dynamic> json) => ProgramInfo(
        code: json['code'] as String,
        name: json['name'] as String,
      );

  @override
  String toString() => '$name ($code)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProgramInfo &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}

class FacultyInfo {
  final String name;
  final String programCode;
  final String qualification;
  final String approvalStatus;

  const FacultyInfo({
    required this.name,
    required this.programCode,
    required this.qualification,
    required this.approvalStatus,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'programCode': programCode,
        'qualification': qualification,
        'approvalStatus': approvalStatus,
      };

  factory FacultyInfo.fromJson(Map<String, dynamic> json) => FacultyInfo(
        name: json['name'] as String,
        programCode: json['programCode'] as String,
        qualification: json['qualification'] as String,
        approvalStatus: json['approvalStatus'] as String,
      );
}

class CourseInfo {
  final String programCode;
  final int semester; // 1 to 6
  final String courseCodeAndAbbr; // e.g., "DCN-3111", "BMS-3112"
  final String thPrescribed;
  final String prPrescribed;
  final String tuPrescribed;

  const CourseInfo({
    required this.programCode,
    required this.semester,
    required this.courseCodeAndAbbr,
    this.thPrescribed = '4',
    this.prPrescribed = 'NA',
    this.tuPrescribed = 'NA',
  });

  Map<String, dynamic> toJson() => {
        'programCode': programCode,
        'semester': semester,
        'courseCodeAndAbbr': courseCodeAndAbbr,
        'thPrescribed': thPrescribed,
        'prPrescribed': prPrescribed,
        'tuPrescribed': tuPrescribed,
      };

  factory CourseInfo.fromJson(Map<String, dynamic> json) => CourseInfo(
        programCode: json['programCode'] as String,
        semester: json['semester'] as int,
        courseCodeAndAbbr: json['courseCodeAndAbbr'] as String,
        thPrescribed: json['thPrescribed'] as String? ?? '4',
        prPrescribed: json['prPrescribed'] as String? ?? 'NA',
        tuPrescribed: json['tuPrescribed'] as String? ?? 'NA',
      );
}

class MonitoringRowEntry {
  int srNo;
  String facultyName;
  String branchSemScheme; // e.g. CM1K, ME3K
  String qualification;
  String facultyApproved;
  String courseAbbreviationCode;
  String k1; // 'Yes' or 'No'
  String k2; // 'Yes' or 'No'
  String k3; // 'Yes' or 'No'
  String k6; // 'Records Checked' or 'Records Not Checked'
  String k7; // 'Yes' or 'No' for K-7 CT-1
  String studentFeedback; // keep blank by default
  String thPrescribed;
  String prPrescribed;
  String tuPrescribed;
  String thActual;
  String prActual;
  String tuActual;
  String remarks;

  MonitoringRowEntry({
    required this.srNo,
    this.facultyName = '',
    this.branchSemScheme = '',
    this.qualification = '',
    this.facultyApproved = '',
    this.courseAbbreviationCode = '',
    this.k1 = 'Yes',
    this.k2 = 'Yes',
    this.k3 = 'Yes',
    this.k6 = 'Records Checked',
    this.k7 = 'Yes',
    this.studentFeedback = '',
    this.thPrescribed = '',
    this.prPrescribed = '',
    this.tuPrescribed = '',
    this.thActual = '',
    this.prActual = '',
    this.tuActual = '',
    this.remarks = '',
  });

  MonitoringRowEntry copyWith({
    int? srNo,
    String? facultyName,
    String? branchSemScheme,
    String? qualification,
    String? facultyApproved,
    String? courseAbbreviationCode,
    String? k1,
    String? k2,
    String? k3,
    String? k6,
    String? k7,
    String? studentFeedback,
    String? thPrescribed,
    String? prPrescribed,
    String? tuPrescribed,
    String? thActual,
    String? prActual,
    String? tuActual,
    String? remarks,
  }) {
    return MonitoringRowEntry(
      srNo: srNo ?? this.srNo,
      facultyName: facultyName ?? this.facultyName,
      branchSemScheme: branchSemScheme ?? this.branchSemScheme,
      qualification: qualification ?? this.qualification,
      facultyApproved: facultyApproved ?? this.facultyApproved,
      courseAbbreviationCode:
          courseAbbreviationCode ?? this.courseAbbreviationCode,
      k1: k1 ?? this.k1,
      k2: k2 ?? this.k2,
      k3: k3 ?? this.k3,
      k6: k6 ?? this.k6,
      k7: k7 ?? this.k7,
      studentFeedback: studentFeedback ?? this.studentFeedback,
      thPrescribed: thPrescribed ?? this.thPrescribed,
      prPrescribed: prPrescribed ?? this.prPrescribed,
      tuPrescribed: tuPrescribed ?? this.tuPrescribed,
      thActual: thActual ?? this.thActual,
      prActual: prActual ?? this.prActual,
      tuActual: tuActual ?? this.tuActual,
      remarks: remarks ?? this.remarks,
    );
  }

  Map<String, dynamic> toJson() => {
        'srNo': srNo,
        'facultyName': facultyName,
        'branchSemScheme': branchSemScheme,
        'qualification': qualification,
        'facultyApproved': facultyApproved,
        'courseAbbreviationCode': courseAbbreviationCode,
        'k1': k1,
        'k2': k2,
        'k3': k3,
        'k6': k6,
        'k7': k7,
        'studentFeedback': studentFeedback,
        'thPrescribed': thPrescribed,
        'prPrescribed': prPrescribed,
        'tuPrescribed': tuPrescribed,
        'thActual': thActual,
        'prActual': prActual,
        'tuActual': tuActual,
        'remarks': remarks,
      };

  factory MonitoringRowEntry.fromJson(Map<String, dynamic> json) =>
      MonitoringRowEntry(
        srNo: json['srNo'] as int,
        facultyName: json['facultyName'] as String? ?? '',
        branchSemScheme: json['branchSemScheme'] as String? ?? '',
        qualification: json['qualification'] as String? ?? '',
        facultyApproved: json['facultyApproved'] as String? ?? '',
        courseAbbreviationCode:
            json['courseAbbreviationCode'] as String? ?? '',
        k1: json['k1'] as String? ?? 'Yes',
        k2: json['k2'] as String? ?? 'Yes',
        k3: json['k3'] as String? ?? 'Yes',
        k6: json['k6'] as String? ?? 'Records Checked',
        k7: json['k7'] as String? ?? 'Yes',
        studentFeedback: json['studentFeedback'] as String? ?? '',
        thPrescribed: json['thPrescribed'] as String? ?? '',
        prPrescribed: json['prPrescribed'] as String? ?? '',
        tuPrescribed: json['tuPrescribed'] as String? ?? '',
        thActual: json['thActual'] as String? ?? '',
        prActual: json['prActual'] as String? ?? '',
        tuActual: json['tuActual'] as String? ?? '',
        remarks: json['remarks'] as String? ?? '',
      );

  int get semesterNumber {
    final match = RegExp(r'\d+').firstMatch(branchSemScheme);
    if (match != null) {
      return int.tryParse(match.group(0)!) ?? 1;
    }
    return 1;
  }

  int get academicYear {
    final s = semesterNumber;
    if (s <= 2) return 1;
    if (s <= 4) return 2;
    return 3;
  }
}

class MonitoringSubmission {
  final String id;
  final String programName;
  final String programCode;
  final String semesterType; // 'ODD' or 'EVEN'
  final String nbaStatus; // 'Accredited', 'Applied', 'Not Applied'
  final int weeksDone; // 1 to 26 weeks (fallback / default)
  final int weeksDoneYear1; // 1st year (1st and 2nd sem)
  final int weeksDoneYear2; // 2nd year (3rd and 4th sem)
  final int weeksDoneYear3; // 3rd year (5th and 6th sem)
  final DateTime submittedAt;
  final List<MonitoringRowEntry> rows;

  MonitoringSubmission({
    required this.id,
    required this.programName,
    required this.programCode,
    required this.semesterType,
    this.nbaStatus = 'Accredited',
    int? weeksDone,
    int? weeksDoneYear1,
    int? weeksDoneYear2,
    int? weeksDoneYear3,
    required this.submittedAt,
    required this.rows,
  })  : weeksDone = weeksDone ?? 10,
        weeksDoneYear1 = weeksDoneYear1 ?? (weeksDone ?? 10),
        weeksDoneYear2 = weeksDoneYear2 ?? (weeksDone ?? 10),
        weeksDoneYear3 = weeksDoneYear3 ?? (weeksDone ?? 10);

  int getWeeksDoneForEntry(MonitoringRowEntry entry) {
    final yr = entry.academicYear;
    if (yr == 1) return weeksDoneYear1;
    if (yr == 2) return weeksDoneYear2;
    return weeksDoneYear3;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'programName': programName,
        'programCode': programCode,
        'semesterType': semesterType,
        'nbaStatus': nbaStatus,
        'weeksDone': weeksDone,
        'weeksDoneYear1': weeksDoneYear1,
        'weeksDoneYear2': weeksDoneYear2,
        'weeksDoneYear3': weeksDoneYear3,
        'submittedAt': submittedAt.toIso8601String(),
        'rows': rows.map((r) => r.toJson()).toList(),
      };

  factory MonitoringSubmission.fromJson(Map<String, dynamic> json) {
    final legacyWeeks = json['weeksDone'] as int? ?? 10;
    return MonitoringSubmission(
      id: json['id'] as String,
      programName: json['programName'] as String,
      programCode: json['programCode'] as String,
      semesterType: json['semesterType'] as String,
      nbaStatus: json['nbaStatus'] as String? ?? 'Accredited',
      weeksDone: legacyWeeks,
      weeksDoneYear1: json['weeksDoneYear1'] as int? ?? legacyWeeks,
      weeksDoneYear2: json['weeksDoneYear2'] as int? ?? legacyWeeks,
      weeksDoneYear3: json['weeksDoneYear3'] as int? ?? legacyWeeks,
      submittedAt: DateTime.parse(json['submittedAt'] as String),
      rows: (json['rows'] as List<dynamic>)
          .map((r) => MonitoringRowEntry.fromJson(r as Map<String, dynamic>))
          .toList(),
    );
  }
}

