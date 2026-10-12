class DeptInfoModel {
  final String departmentName;
  final String academicYear;
  final String visionMissionPrepared;
  final String visionMissionApprovalDate;
  final String nbaAccreditation;
  final String nbaValidFrom;
  final String nbaValidTill;
  final String? nbaCertificateFileName;
  final String internalAuditOnce6Months;
  final String internalAuditDate;
  final String internalAuditSuggestions;
  final String internalAuditCorrectiveAction;
  final String newFacilityCreated;
  final String feedbackMechanismAdopted;
  final String feedbackAnalysisDone;
  final String feedbackCorrectiveActionDone;
  final String smartClassroomAvailable;
  final String biometricAttendanceAvailable;
  final String refresherCoursesDirect2ndYear;
  final String professionalActivities;
  final String centerOfExcellence;
  final String moocsCoursesFacility;
  final int techJournalsCount;
  final String remedialLectures;
  final String industrialTrainingAssessment;
  final String incubationWithIndustries;
  final String parentMeet;
  final DateTime lastUpdated;

  const DeptInfoModel({
    this.departmentName = 'Computer Technology',
    this.academicYear = '2024-25',
    this.visionMissionPrepared = 'Yes',
    this.visionMissionApprovalDate = '20/06/2017',
    this.nbaAccreditation = 'Accreditated',
    this.nbaValidFrom = '1-7-2023',
    this.nbaValidTill = '30-6-2026',
    this.nbaCertificateFileName,
    this.internalAuditOnce6Months = 'Yes',
    this.internalAuditDate = '11-09-2026',
    this.internalAuditSuggestions =
        'Improve Faculty participation in FDP/Trainings.',
    this.internalAuditCorrectiveAction =
        'Guided faculty members to register for MSBTE and other FDP Programs',
    this.newFacilityCreated = 'Yes',
    this.feedbackMechanismAdopted = 'Yes',
    this.feedbackAnalysisDone = 'Yes',
    this.feedbackCorrectiveActionDone = 'Yes',
    this.smartClassroomAvailable = 'Yes',
    this.biometricAttendanceAvailable = 'Yes',
    this.refresherCoursesDirect2ndYear = 'Yes',
    this.professionalActivities = 'Yes',
    this.centerOfExcellence = 'No',
    this.moocsCoursesFacility = 'Yes',
    this.techJournalsCount = 6,
    this.remedialLectures = 'Implemented',
    this.industrialTrainingAssessment = '100% Eligible Students',
    this.incubationWithIndustries = 'Yes',
    this.parentMeet = 'Conducted and Documents well maintained',
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? const _DefaultDateTime();

  factory DeptInfoModel.defaultSample() => const DeptInfoModel();

  DeptInfoModel copyWith({
    String? departmentName,
    String? academicYear,
    String? visionMissionPrepared,
    String? visionMissionApprovalDate,
    String? nbaAccreditation,
    String? nbaValidFrom,
    String? nbaValidTill,
    String? nbaCertificateFileName,
    String? internalAuditOnce6Months,
    String? internalAuditDate,
    String? internalAuditSuggestions,
    String? internalAuditCorrectiveAction,
    String? newFacilityCreated,
    String? feedbackMechanismAdopted,
    String? feedbackAnalysisDone,
    String? feedbackCorrectiveActionDone,
    String? smartClassroomAvailable,
    String? biometricAttendanceAvailable,
    String? refresherCoursesDirect2ndYear,
    String? professionalActivities,
    String? centerOfExcellence,
    String? moocsCoursesFacility,
    int? techJournalsCount,
    String? remedialLectures,
    String? industrialTrainingAssessment,
    String? incubationWithIndustries,
    String? parentMeet,
    DateTime? lastUpdated,
  }) {
    return DeptInfoModel(
      departmentName: departmentName ?? this.departmentName,
      academicYear: academicYear ?? this.academicYear,
      visionMissionPrepared:
          visionMissionPrepared ?? this.visionMissionPrepared,
      visionMissionApprovalDate:
          visionMissionApprovalDate ?? this.visionMissionApprovalDate,
      nbaAccreditation: nbaAccreditation ?? this.nbaAccreditation,
      nbaValidFrom: nbaValidFrom ?? this.nbaValidFrom,
      nbaValidTill: nbaValidTill ?? this.nbaValidTill,
      nbaCertificateFileName:
          nbaCertificateFileName ?? this.nbaCertificateFileName,
      internalAuditOnce6Months:
          internalAuditOnce6Months ?? this.internalAuditOnce6Months,
      internalAuditDate: internalAuditDate ?? this.internalAuditDate,
      internalAuditSuggestions:
          internalAuditSuggestions ?? this.internalAuditSuggestions,
      internalAuditCorrectiveAction:
          internalAuditCorrectiveAction ?? this.internalAuditCorrectiveAction,
      newFacilityCreated: newFacilityCreated ?? this.newFacilityCreated,
      feedbackMechanismAdopted:
          feedbackMechanismAdopted ?? this.feedbackMechanismAdopted,
      feedbackAnalysisDone: feedbackAnalysisDone ?? this.feedbackAnalysisDone,
      feedbackCorrectiveActionDone:
          feedbackCorrectiveActionDone ?? this.feedbackCorrectiveActionDone,
      smartClassroomAvailable:
          smartClassroomAvailable ?? this.smartClassroomAvailable,
      biometricAttendanceAvailable:
          biometricAttendanceAvailable ?? this.biometricAttendanceAvailable,
      refresherCoursesDirect2ndYear:
          refresherCoursesDirect2ndYear ?? this.refresherCoursesDirect2ndYear,
      professionalActivities:
          professionalActivities ?? this.professionalActivities,
      centerOfExcellence: centerOfExcellence ?? this.centerOfExcellence,
      moocsCoursesFacility: moocsCoursesFacility ?? this.moocsCoursesFacility,
      techJournalsCount: techJournalsCount ?? this.techJournalsCount,
      remedialLectures: remedialLectures ?? this.remedialLectures,
      industrialTrainingAssessment:
          industrialTrainingAssessment ?? this.industrialTrainingAssessment,
      incubationWithIndustries:
          incubationWithIndustries ?? this.incubationWithIndustries,
      parentMeet: parentMeet ?? this.parentMeet,
      lastUpdated: lastUpdated ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'departmentName': departmentName,
        'academicYear': academicYear,
        'visionMissionPrepared': visionMissionPrepared,
        'visionMissionApprovalDate': visionMissionApprovalDate,
        'nbaAccreditation': nbaAccreditation,
        'nbaValidFrom': nbaValidFrom,
        'nbaValidTill': nbaValidTill,
        'nbaCertificateFileName': nbaCertificateFileName,
        'internalAuditOnce6Months': internalAuditOnce6Months,
        'internalAuditDate': internalAuditDate,
        'internalAuditSuggestions': internalAuditSuggestions,
        'internalAuditCorrectiveAction': internalAuditCorrectiveAction,
        'newFacilityCreated': newFacilityCreated,
        'feedbackMechanismAdopted': feedbackMechanismAdopted,
        'feedbackAnalysisDone': feedbackAnalysisDone,
        'feedbackCorrectiveActionDone': feedbackCorrectiveActionDone,
        'smartClassroomAvailable': smartClassroomAvailable,
        'biometricAttendanceAvailable': biometricAttendanceAvailable,
        'refresherCoursesDirect2ndYear': refresherCoursesDirect2ndYear,
        'professionalActivities': professionalActivities,
        'centerOfExcellence': centerOfExcellence,
        'moocsCoursesFacility': moocsCoursesFacility,
        'techJournalsCount': techJournalsCount,
        'remedialLectures': remedialLectures,
        'industrialTrainingAssessment': industrialTrainingAssessment,
        'incubationWithIndustries': incubationWithIndustries,
        'parentMeet': parentMeet,
        'lastUpdated': lastUpdated.toIso8601String(),
      };

  factory DeptInfoModel.fromJson(Map<String, dynamic> json) => DeptInfoModel(
        departmentName: json['departmentName'] as String? ?? 'Computer Technology',
        academicYear: json['academicYear'] as String? ?? '2024-25',
        visionMissionPrepared: json['visionMissionPrepared'] as String? ?? 'Yes',
        visionMissionApprovalDate:
            json['visionMissionApprovalDate'] as String? ?? '20/06/2017',
        nbaAccreditation:
            json['nbaAccreditation'] as String? ?? 'Accreditated',
        nbaValidFrom: json['nbaValidFrom'] as String? ?? '1-7-2023',
        nbaValidTill: json['nbaValidTill'] as String? ?? '30-6-2026',
        nbaCertificateFileName: json['nbaCertificateFileName'] as String?,
        internalAuditOnce6Months:
            json['internalAuditOnce6Months'] as String? ?? 'Yes',
        internalAuditDate:
            json['internalAuditDate'] as String? ?? '11-09-2026',
        internalAuditSuggestions:
            json['internalAuditSuggestions'] as String? ?? '',
        internalAuditCorrectiveAction:
            json['internalAuditCorrectiveAction'] as String? ?? '',
        newFacilityCreated: json['newFacilityCreated'] as String? ?? 'Yes',
        feedbackMechanismAdopted:
            json['feedbackMechanismAdopted'] as String? ?? 'Yes',
        feedbackAnalysisDone: json['feedbackAnalysisDone'] as String? ?? 'Yes',
        feedbackCorrectiveActionDone:
            json['feedbackCorrectiveActionDone'] as String? ?? 'Yes',
        smartClassroomAvailable:
            json['smartClassroomAvailable'] as String? ?? 'Yes',
        biometricAttendanceAvailable:
            json['biometricAttendanceAvailable'] as String? ?? 'Yes',
        refresherCoursesDirect2ndYear:
            json['refresherCoursesDirect2ndYear'] as String? ?? 'Yes',
        professionalActivities:
            json['professionalActivities'] as String? ?? 'Yes',
        centerOfExcellence: json['centerOfExcellence'] as String? ?? 'No',
        moocsCoursesFacility: json['moocsCoursesFacility'] as String? ?? 'Yes',
        techJournalsCount: json['techJournalsCount'] as int? ?? 6,
        remedialLectures: json['remedialLectures'] as String? ?? 'Implemented',
        industrialTrainingAssessment:
            json['industrialTrainingAssessment'] as String? ??
                '100% Eligible Students',
        incubationWithIndustries:
            json['incubationWithIndustries'] as String? ?? 'Yes',
        parentMeet: json['parentMeet'] as String? ??
            'Conducted and Documents well maintained',
        lastUpdated: json['lastUpdated'] != null
            ? DateTime.tryParse(json['lastUpdated'] as String) ?? DateTime.now()
            : DateTime.now(),
      );
}

class _DefaultDateTime implements DateTime {
  const _DefaultDateTime();
  @override
  bool isAfter(DateTime other) => false;
  @override
  bool isBefore(DateTime other) => false;
  @override
  bool isAtSameMomentAs(DateTime other) => false;
  @override
  int compareTo(DateTime other) => 0;
  @override
  DateTime add(Duration duration) => DateTime.now();
  @override
  DateTime subtract(Duration duration) => DateTime.now();
  @override
  Duration difference(DateTime other) => Duration.zero;
  @override
  int get millisecondsSinceEpoch => 0;
  @override
  int get microsecondsSinceEpoch => 0;
  @override
  String get timeZoneName => 'UTC';
  @override
  Duration get timeZoneOffset => Duration.zero;
  @override
  int get year => 2026;
  @override
  int get month => 10;
  @override
  int get day => 9;
  @override
  int get hour => 12;
  @override
  int get minute => 44;
  @override
  int get second => 43;
  @override
  int get millisecond => 0;
  @override
  int get microsecond => 0;
  @override
  int get weekday => 5;
  @override
  bool get isUtc => false;
  @override
  String toIso8601String() => '2026-10-09T12:44:43.000';
  @override
  DateTime toLocal() => DateTime.now();
  @override
  DateTime toUtc() => DateTime.now();
  @override
  String toString() => '2026-10-09 12:44:43';
}
