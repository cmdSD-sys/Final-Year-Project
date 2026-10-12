/// Data models for MSBTE Monitoring Report Sections 2 through 11
/// Matching sampleScreen reference PDFs for Computer Technology (CM) Department.
library;

class AdmissionSectionData {
  final int iYearEnrolled;
  final int iYearReAdmitted;
  final int iiYearPassOut;
  final int iiYearDirect;
  final int iiYearChangeBranch;
  final int iiYearLastYearDc;
  final int iiiYearPassOut;
  final int iiiYearLastYearDc;
  final int pct35to59;
  final int pct60to79;
  final int pct80plus;
  final String remark;

  const AdmissionSectionData({
    this.iYearEnrolled = 203,
    this.iYearReAdmitted = 1,
    this.iiYearPassOut = 184,
    this.iiYearDirect = 31,
    this.iiYearChangeBranch = 0,
    this.iiYearLastYearDc = 2,
    this.iiiYearPassOut = 214,
    this.iiiYearLastYearDc = 4,
    this.pct35to59 = 1,
    this.pct60to79 = 35,
    this.pct80plus = 167,
    this.remark = 'Change of Institute-01',
  });

  factory AdmissionSectionData.defaultSample() => const AdmissionSectionData();

  AdmissionSectionData copyWith({
    int? iYearEnrolled,
    int? iYearReAdmitted,
    int? iiYearPassOut,
    int? iiYearDirect,
    int? iiYearChangeBranch,
    int? iiYearLastYearDc,
    int? iiiYearPassOut,
    int? iiiYearLastYearDc,
    int? pct35to59,
    int? pct60to79,
    int? pct80plus,
    String? remark,
  }) {
    return AdmissionSectionData(
      iYearEnrolled: iYearEnrolled ?? this.iYearEnrolled,
      iYearReAdmitted: iYearReAdmitted ?? this.iYearReAdmitted,
      iiYearPassOut: iiYearPassOut ?? this.iiYearPassOut,
      iiYearDirect: iiYearDirect ?? this.iiYearDirect,
      iiYearChangeBranch: iiYearChangeBranch ?? this.iiYearChangeBranch,
      iiYearLastYearDc: iiYearLastYearDc ?? this.iiYearLastYearDc,
      iiiYearPassOut: iiiYearPassOut ?? this.iiiYearPassOut,
      iiiYearLastYearDc: iiiYearLastYearDc ?? this.iiiYearLastYearDc,
      pct35to59: pct35to59 ?? this.pct35to59,
      pct60to79: pct60to79 ?? this.pct60to79,
      pct80plus: pct80plus ?? this.pct80plus,
      remark: remark ?? this.remark,
    );
  }

  Map<String, dynamic> toJson() => {
        'iYearEnrolled': iYearEnrolled,
        'iYearReAdmitted': iYearReAdmitted,
        'iiYearPassOut': iiYearPassOut,
        'iiYearDirect': iiYearDirect,
        'iiYearChangeBranch': iiYearChangeBranch,
        'iiYearLastYearDc': iiYearLastYearDc,
        'iiiYearPassOut': iiiYearPassOut,
        'iiiYearLastYearDc': iiiYearLastYearDc,
        'pct35to59': pct35to59,
        'pct60to79': pct60to79,
        'pct80plus': pct80plus,
        'remark': remark,
      };

  factory AdmissionSectionData.fromJson(Map<String, dynamic> json) =>
      AdmissionSectionData(
        iYearEnrolled: json['iYearEnrolled'] as int? ?? 203,
        iYearReAdmitted: json['iYearReAdmitted'] as int? ?? 1,
        iiYearPassOut: json['iiYearPassOut'] as int? ?? 184,
        iiYearDirect: json['iiYearDirect'] as int? ?? 31,
        iiYearChangeBranch: json['iiYearChangeBranch'] as int? ?? 0,
        iiYearLastYearDc: json['iiYearLastYearDc'] as int? ?? 2,
        iiiYearPassOut: json['iiiYearPassOut'] as int? ?? 214,
        iiiYearLastYearDc: json['iiiYearLastYearDc'] as int? ?? 4,
        pct35to59: json['pct35to59'] as int? ?? 1,
        pct60to79: json['pct60to79'] as int? ?? 35,
        pct80plus: json['pct80plus'] as int? ?? 167,
        remark: json['remark'] as String? ?? 'Change of Institute-01',
      );
}

class FacultyStrengthSectionData {
  final int hodRequired;
  final int lecturerDesirable;
  final int lecturerEssential;
  final String hodAvailability;
  final int filledRegular;
  final int filledAdhoc;
  final int filledContract;
  final int filledVisiting;
  final String vacancyStatus;
  final String notes;

  int get lecturerRegular => filledRegular;
  int get lecturerAdhoc => filledAdhoc;
  int get lecturerContract => filledContract;
  int get lecturerVisiting => filledVisiting;

  const FacultyStrengthSectionData({
    this.hodRequired = 1,
    this.lecturerDesirable = 16,
    this.lecturerEssential = 14,
    this.hodAvailability = 'Incharge',
    int filledRegular = 8,
    int filledAdhoc = 13,
    int filledContract = 0,
    int filledVisiting = 0,
    int? lecturerRegular,
    int? lecturerAdhoc,
    int? lecturerContract,
    int? lecturerVisiting,
    this.vacancyStatus = 'Overall Available',
    this.notes =
        'Regular staff means the staff whose appointment is approved by competent authority. (Note- Office orders to be verified).',
  })  : filledRegular = lecturerRegular ?? filledRegular,
        filledAdhoc = lecturerAdhoc ?? filledAdhoc,
        filledContract = lecturerContract ?? filledContract,
        filledVisiting = lecturerVisiting ?? filledVisiting;

  factory FacultyStrengthSectionData.defaultSample() =>
      const FacultyStrengthSectionData();

  FacultyStrengthSectionData copyWith({
    int? hodRequired,
    int? lecturerDesirable,
    int? lecturerEssential,
    String? hodAvailability,
    int? filledRegular,
    int? filledAdhoc,
    int? filledContract,
    int? filledVisiting,
    int? lecturerRegular,
    int? lecturerAdhoc,
    int? lecturerContract,
    int? lecturerVisiting,
    String? vacancyStatus,
    String? notes,
  }) =>
      FacultyStrengthSectionData(
        hodRequired: hodRequired ?? this.hodRequired,
        lecturerDesirable: lecturerDesirable ?? this.lecturerDesirable,
        lecturerEssential: lecturerEssential ?? this.lecturerEssential,
        hodAvailability: hodAvailability ?? this.hodAvailability,
        filledRegular: lecturerRegular ?? filledRegular ?? this.filledRegular,
        filledAdhoc: lecturerAdhoc ?? filledAdhoc ?? this.filledAdhoc,
        filledContract:
            lecturerContract ?? filledContract ?? this.filledContract,
        filledVisiting:
            lecturerVisiting ?? filledVisiting ?? this.filledVisiting,
        vacancyStatus: vacancyStatus ?? this.vacancyStatus,
        notes: notes ?? this.notes,
      );

  Map<String, dynamic> toJson() => {
        'hodRequired': hodRequired,
        'lecturerDesirable': lecturerDesirable,
        'lecturerEssential': lecturerEssential,
        'hodAvailability': hodAvailability,
        'filledRegular': filledRegular,
        'filledAdhoc': filledAdhoc,
        'filledContract': filledContract,
        'filledVisiting': filledVisiting,
        'vacancyStatus': vacancyStatus,
        'notes': notes,
      };

  factory FacultyStrengthSectionData.fromJson(Map<String, dynamic> json) =>
      FacultyStrengthSectionData(
        hodRequired: json['hodRequired'] as int? ?? 1,
        lecturerDesirable: json['lecturerDesirable'] as int? ?? 16,
        lecturerEssential: json['lecturerEssential'] as int? ?? 14,
        hodAvailability: json['hodAvailability'] as String? ?? 'Incharge',
        filledRegular: json['filledRegular'] as int? ??
            json['lecturerRegular'] as int? ??
            8,
        filledAdhoc:
            json['filledAdhoc'] as int? ?? json['lecturerAdhoc'] as int? ?? 13,
        filledContract: json['filledContract'] as int? ??
            json['lecturerContract'] as int? ??
            0,
        filledVisiting: json['filledVisiting'] as int? ??
            json['lecturerVisiting'] as int? ??
            0,
        vacancyStatus: json['vacancyStatus'] as String? ?? 'Overall Available',
        notes: json['notes'] as String? ?? '',
      );
}

class FacultyMemberItem {
  final int srNo;
  final String name;
  final String designation;
  final String qualification;
  final int expTeaching;
  final int expIndustry;
  final int trainingsAttended;
  final int confAttended;
  final int papersPublished;
  final int researchProjects;

  const FacultyMemberItem({
    required this.srNo,
    required this.name,
    required this.designation,
    required this.qualification,
    required this.expTeaching,
    required this.expIndustry,
    required this.trainingsAttended,
    required this.confAttended,
    required this.papersPublished,
    required this.researchProjects,
  });

  FacultyMemberItem copyWith({
    int? srNo,
    String? name,
    String? designation,
    String? qualification,
    int? expTeaching,
    int? expIndustry,
    int? trainingsAttended,
    int? confAttended,
    int? papersPublished,
    int? researchProjects,
  }) =>
      FacultyMemberItem(
        srNo: srNo ?? this.srNo,
        name: name ?? this.name,
        designation: designation ?? this.designation,
        qualification: qualification ?? this.qualification,
        expTeaching: expTeaching ?? this.expTeaching,
        expIndustry: expIndustry ?? this.expIndustry,
        trainingsAttended: trainingsAttended ?? this.trainingsAttended,
        confAttended: confAttended ?? this.confAttended,
        papersPublished: papersPublished ?? this.papersPublished,
        researchProjects: researchProjects ?? this.researchProjects,
      );

  Map<String, dynamic> toJson() => {
        'srNo': srNo,
        'name': name,
        'designation': designation,
        'qualification': qualification,
        'expTeaching': expTeaching,
        'expIndustry': expIndustry,
        'trainingsAttended': trainingsAttended,
        'confAttended': confAttended,
        'papersPublished': papersPublished,
        'researchProjects': researchProjects,
      };

  factory FacultyMemberItem.fromJson(Map<String, dynamic> json) =>
      FacultyMemberItem(
        srNo: json['srNo'] as int? ?? 1,
        name: json['name'] as String? ?? '',
        designation: json['designation'] as String? ?? 'Lecturer',
        qualification: json['qualification'] as String? ?? 'BE',
        expTeaching: json['expTeaching'] as int? ?? 0,
        expIndustry: json['expIndustry'] as int? ?? 0,
        trainingsAttended: json['trainingsAttended'] as int? ?? 0,
        confAttended: json['confAttended'] as int? ?? 0,
        papersPublished: json['papersPublished'] as int? ?? 0,
        researchProjects: json['researchProjects'] as int? ?? 0,
      );
}

class SupportStaffItem {
  final int srNo;
  final String name;
  final String designation;
  final String qualification;

  const SupportStaffItem({
    required this.srNo,
    required this.name,
    required this.designation,
    this.qualification = 'DIPLOMA',
  });

  SupportStaffItem copyWith({
    int? srNo,
    String? name,
    String? designation,
    String? qualification,
  }) =>
      SupportStaffItem(
        srNo: srNo ?? this.srNo,
        name: name ?? this.name,
        designation: designation ?? this.designation,
        qualification: qualification ?? this.qualification,
      );

  Map<String, dynamic> toJson() => {
        'srNo': srNo,
        'name': name,
        'designation': designation,
        'qualification': qualification,
      };

  factory SupportStaffItem.fromJson(Map<String, dynamic> json) =>
      SupportStaffItem(
        srNo: json['srNo'] as int? ?? 1,
        name: json['name'] as String? ?? '',
        designation: json['designation'] as String? ?? 'Technical Assistant',
        qualification: json['qualification'] as String? ?? 'DIPLOMA',
      );
}

class FacultyProfileSectionData {
  final List<FacultyMemberItem> teachingFaculties;
  final List<SupportStaffItem> supportStaff;

  const FacultyProfileSectionData({
    required this.teachingFaculties,
    required this.supportStaff,
  });

  factory FacultyProfileSectionData.defaultSample() =>
      FacultyProfileSectionData(
        teachingFaculties: const [
          FacultyMemberItem(
              srNo: 1,
              name: 'BHOSALE MANJUSHA PANKAJ',
              designation: 'Incharge HOD',
              qualification: 'BE ME',
              expTeaching: 18,
              expIndustry: 0,
              trainingsAttended: 7,
              confAttended: 5,
              papersPublished: 5,
              researchProjects: 0),
          FacultyMemberItem(
              srNo: 2,
              name: 'CHAVAN PURUSHOTTAM SHUKLESHWAR',
              designation: 'Lecturer',
              qualification: 'BE ME',
              expTeaching: 19,
              expIndustry: 0,
              trainingsAttended: 6,
              confAttended: 4,
              papersPublished: 5,
              researchProjects: 0),
          FacultyMemberItem(
              srNo: 3,
              name: 'MAHAJAN SACHIN KISHOR',
              designation: 'Lecturer',
              qualification: 'BE ME',
              expTeaching: 16,
              expIndustry: 0,
              trainingsAttended: 7,
              confAttended: 2,
              papersPublished: 4,
              researchProjects: 0),
          FacultyMemberItem(
              srNo: 4,
              name: 'SHINDE GIRISH RANGNATH',
              designation: 'Lecturer',
              qualification: 'BE ME',
              expTeaching: 13,
              expIndustry: 0,
              trainingsAttended: 4,
              confAttended: 5,
              papersPublished: 5,
              researchProjects: 0),
          FacultyMemberItem(
              srNo: 5,
              name: 'TALOLE ANIRUDDHA DADASAHEB',
              designation: 'Lecturer',
              qualification: 'BE ME',
              expTeaching: 16,
              expIndustry: 0,
              trainingsAttended: 7,
              confAttended: 5,
              papersPublished: 5,
              researchProjects: 0),
          FacultyMemberItem(
              srNo: 6,
              name: 'PATEL KHAN ABDUL AZIZ ABDUL RASHID',
              designation: 'Lecturer',
              qualification: 'BE',
              expTeaching: 17,
              expIndustry: 0,
              trainingsAttended: 7,
              confAttended: 5,
              papersPublished: 5,
              researchProjects: 0),
          FacultyMemberItem(
              srNo: 7,
              name: 'KADAM YOGITA UTTAMRAO',
              designation: 'Lecturer',
              qualification: 'BE',
              expTeaching: 16,
              expIndustry: 0,
              trainingsAttended: 1,
              confAttended: 2,
              papersPublished: 2,
              researchProjects: 0),
          FacultyMemberItem(
              srNo: 8,
              name: 'AHIRE KAVITA NIKHIL',
              designation: 'Lecturer',
              qualification: 'BE ME',
              expTeaching: 8,
              expIndustry: 1,
              trainingsAttended: 4,
              confAttended: 1,
              papersPublished: 5,
              researchProjects: 0),
          FacultyMemberItem(
              srNo: 9,
              name: 'GAIKWAD SEEMANTINI SANTOSH',
              designation: 'Lecturer',
              qualification: 'BE ME',
              expTeaching: 15,
              expIndustry: 0,
              trainingsAttended: 3,
              confAttended: 0,
              papersPublished: 0,
              researchProjects: 0),
          FacultyMemberItem(
              srNo: 10,
              name: 'USHIR ROHINI KESHAV',
              designation: 'Lecturer',
              qualification: 'BE MBA',
              expTeaching: 4,
              expIndustry: 0,
              trainingsAttended: 1,
              confAttended: 1,
              papersPublished: 1,
              researchProjects: 0),
          FacultyMemberItem(
              srNo: 11,
              name: 'JADHAV MILIND NAMDEORAO',
              designation: 'Lecturer',
              qualification: 'BE ME',
              expTeaching: 29,
              expIndustry: 0,
              trainingsAttended: 7,
              confAttended: 5,
              papersPublished: 5,
              researchProjects: 0),
          FacultyMemberItem(
              srNo: 12,
              name: 'WAGHCHOURE VIDYA NILESH',
              designation: 'Lecturer',
              qualification: 'BE ME',
              expTeaching: 21,
              expIndustry: 1,
              trainingsAttended: 4,
              confAttended: 5,
              papersPublished: 5,
              researchProjects: 0),
          FacultyMemberItem(
              srNo: 13,
              name: 'BIJALPURE VAISHNAVI ANIL',
              designation: 'Lecturer',
              qualification: 'BE',
              expTeaching: 3,
              expIndustry: 0,
              trainingsAttended: 2,
              confAttended: 0,
              papersPublished: 0,
              researchProjects: 0),
          FacultyMemberItem(
              srNo: 14,
              name: 'SUSLADE PALLAVI JAYESH',
              designation: 'Lecturer',
              qualification: 'BE',
              expTeaching: 3,
              expIndustry: 0,
              trainingsAttended: 1,
              confAttended: 1,
              papersPublished: 2,
              researchProjects: 1),
          FacultyMemberItem(
              srNo: 15,
              name: 'SALVE PRANJALI GOPINATH',
              designation: 'Lecturer',
              qualification: 'BE',
              expTeaching: 2,
              expIndustry: 0,
              trainingsAttended: 1,
              confAttended: 3,
              papersPublished: 2,
              researchProjects: 1),
          FacultyMemberItem(
              srNo: 16,
              name: 'WABLE VRUSHALI RAHUL',
              designation: 'Lecturer',
              qualification: 'BE',
              expTeaching: 1,
              expIndustry: 2,
              trainingsAttended: 2,
              confAttended: 2,
              papersPublished: 1,
              researchProjects: 0),
          FacultyMemberItem(
              srNo: 17,
              name: 'JADHAV HEMANGI PRAVIN',
              designation: 'Lecturer',
              qualification: 'BE',
              expTeaching: 1,
              expIndustry: 0,
              trainingsAttended: 2,
              confAttended: 0,
              papersPublished: 1,
              researchProjects: 0),
          FacultyMemberItem(
              srNo: 18,
              name: 'NIKAM SAMRUDDHI RAVINDRA',
              designation: 'Lecturer',
              qualification: 'BE',
              expTeaching: 1,
              expIndustry: 0,
              trainingsAttended: 0,
              confAttended: 1,
              papersPublished: 1,
              researchProjects: 0),
          FacultyMemberItem(
              srNo: 19,
              name: 'JAGTAP SONALI RAHUL',
              designation: 'Lecturer',
              qualification: 'BE',
              expTeaching: 4,
              expIndustry: 0,
              trainingsAttended: 0,
              confAttended: 0,
              papersPublished: 0,
              researchProjects: 0),
          FacultyMemberItem(
              srNo: 20,
              name: 'HIRE RUTUJA RAVINDRA',
              designation: 'Lecturer',
              qualification: 'BE',
              expTeaching: 4,
              expIndustry: 0,
              trainingsAttended: 0,
              confAttended: 0,
              papersPublished: 0,
              researchProjects: 0),
          FacultyMemberItem(
              srNo: 21,
              name: 'DONGARE ANUSHKA RAVINDRA',
              designation: 'Lecturer',
              qualification: 'BE',
              expTeaching: 4,
              expIndustry: 0,
              trainingsAttended: 0,
              confAttended: 0,
              papersPublished: 0,
              researchProjects: 0),
        ],
        supportStaff: const [
          SupportStaffItem(
              srNo: 1,
              name: 'PATIL SUREKHA ATULKUMAR',
              designation: 'Technical Assistant'),
          SupportStaffItem(
              srNo: 2,
              name: 'SONAWANE KAVITA PRABHAKAR',
              designation: 'Technical Assistant'),
          SupportStaffItem(
              srNo: 3,
              name: 'GAWANDE DEEPALI KEYUR',
              designation: 'Technical Assistant'),
          SupportStaffItem(
              srNo: 4,
              name: 'BHANDARE SONALI SANJAY',
              designation: 'Technical Assistant'),
          SupportStaffItem(
              srNo: 5,
              name: 'JADHAV DHANSHREE YOGESH',
              designation: 'Technical Assistant'),
          SupportStaffItem(
              srNo: 6,
              name: 'GHODKE YASH YOGESH',
              designation: 'Technical Assistant'),
        ],
      );

  Map<String, dynamic> toJson() => {
        'teachingFaculties': teachingFaculties.map((f) => f.toJson()).toList(),
        'supportStaff': supportStaff.map((s) => s.toJson()).toList(),
      };

  factory FacultyProfileSectionData.fromJson(Map<String, dynamic> json) =>
      FacultyProfileSectionData(
        teachingFaculties: (json['teachingFaculties'] as List<dynamic>?)
                ?.map((e) =>
                    FacultyMemberItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            FacultyProfileSectionData.defaultSample().teachingFaculties,
        supportStaff: (json['supportStaff'] as List<dynamic>?)
                ?.map((e) =>
                    SupportStaffItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            FacultyProfileSectionData.defaultSample().supportStaff,
      );
}

class LaboratoryItem {
  final int srNo;
  final String name;
  final int majorEquipmentsCount;
  final int totalCost;

  const LaboratoryItem({
    required this.srNo,
    required this.name,
    required this.majorEquipmentsCount,
    required this.totalCost,
  });

  LaboratoryItem copyWith({
    int? srNo,
    String? name,
    int? majorEquipmentsCount,
    int? totalCost,
  }) =>
      LaboratoryItem(
        srNo: srNo ?? this.srNo,
        name: name ?? this.name,
        majorEquipmentsCount: majorEquipmentsCount ?? this.majorEquipmentsCount,
        totalCost: totalCost ?? this.totalCost,
      );

  Map<String, dynamic> toJson() => {
        'srNo': srNo,
        'name': name,
        'majorEquipmentsCount': majorEquipmentsCount,
        'totalCost': totalCost,
      };

  factory LaboratoryItem.fromJson(Map<String, dynamic> json) => LaboratoryItem(
        srNo: json['srNo'] as int? ?? 1,
        name: json['name'] as String? ?? '',
        majorEquipmentsCount: json['majorEquipmentsCount'] as int? ?? 0,
        totalCost: json['totalCost'] as int? ?? 0,
      );
}

class LaboratorySectionData {
  final List<LaboratoryItem> laboratories;
  final int equipmentAvailabilitySyllabusPct;
  final int labsRequiredNorms;
  final int labsActuallyAvailable;

  const LaboratorySectionData({
    required this.laboratories,
    this.equipmentAvailabilitySyllabusPct = 100,
    this.labsRequiredNorms = 6,
    this.labsActuallyAvailable = 7,
  });

  factory LaboratorySectionData.defaultSample() => const LaboratorySectionData(
        laboratories: [
          LaboratoryItem(
              srNo: 1,
              name: 'WEB APPLICATION LABORATORY',
              majorEquipmentsCount: 15,
              totalCost: 1150396),
          LaboratoryItem(
              srNo: 2,
              name: 'NETWORK LABORATORY',
              majorEquipmentsCount: 22,
              totalCost: 1305562),
          LaboratoryItem(
              srNo: 3,
              name: 'PROGRAMMING LABORATORY',
              majorEquipmentsCount: 22,
              totalCost: 2202199),
          LaboratoryItem(
              srNo: 4,
              name: 'MULTIMEDIA LABORATORY',
              majorEquipmentsCount: 25,
              totalCost: 1836585),
          LaboratoryItem(
              srNo: 5,
              name: 'ADVANCED PROGRAMMING LABORATORY',
              majorEquipmentsCount: 23,
              totalCost: 1453621),
          LaboratoryItem(
              srNo: 6,
              name: 'MICROPROCESSOR LABORATORY',
              majorEquipmentsCount: 21,
              totalCost: 941566),
          LaboratoryItem(
              srNo: 7,
              name: 'COMPUTER HARDWARE LABORATORY',
              majorEquipmentsCount: 33,
              totalCost: 2489079),
          LaboratoryItem(
              srNo: 8,
              name: 'COMPUTER CENTER',
              majorEquipmentsCount: 25,
              totalCost: 1335310),
        ],
        equipmentAvailabilitySyllabusPct: 100,
        labsRequiredNorms: 6,
        labsActuallyAvailable: 7,
      );

  Map<String, dynamic> toJson() => {
        'laboratories': laboratories.map((l) => l.toJson()).toList(),
        'equipmentAvailabilitySyllabusPct': equipmentAvailabilitySyllabusPct,
        'labsRequiredNorms': labsRequiredNorms,
        'labsActuallyAvailable': labsActuallyAvailable,
      };

  factory LaboratorySectionData.fromJson(Map<String, dynamic> json) =>
      LaboratorySectionData(
        laboratories: (json['laboratories'] as List<dynamic>?)
                ?.map(
                    (e) => LaboratoryItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            LaboratorySectionData.defaultSample().laboratories,
        equipmentAvailabilitySyllabusPct:
            json['equipmentAvailabilitySyllabusPct'] as int? ?? 100,
        labsRequiredNorms: json['labsRequiredNorms'] as int? ?? 6,
        labsActuallyAvailable: json['labsActuallyAvailable'] as int? ?? 7,
      );
}

typedef SubjectCurriculumItem = CurriculumSubjectItem;

class CurriculumSubjectItem {
  final int srNo;
  final int semester;
  final String subjectCode;
  final String subjectName;
  final int periodsAvailable;
  final int periodsEngaged;
  final int percentCovered;
  final String continuousAssessmentTw;
  final String continuousAssessmentPr;

  int get sem => semester;
  int get curriculumCoveredPct => percentCovered;

  const CurriculumSubjectItem({
    required this.srNo,
    int? semester,
    int? sem,
    required this.subjectCode,
    required this.subjectName,
    required this.periodsAvailable,
    required this.periodsEngaged,
    int? percentCovered,
    int? curriculumCoveredPct,
    this.continuousAssessmentTw = 'N',
    this.continuousAssessmentPr = 'N',
  })  : semester = semester ?? sem ?? 1,
        percentCovered = percentCovered ?? curriculumCoveredPct ?? 0;

  CurriculumSubjectItem copyWith({
    int? srNo,
    int? semester,
    int? sem,
    String? subjectCode,
    String? subjectName,
    int? periodsAvailable,
    int? periodsEngaged,
    int? percentCovered,
    int? curriculumCoveredPct,
    String? continuousAssessmentTw,
    String? continuousAssessmentPr,
  }) =>
      CurriculumSubjectItem(
        srNo: srNo ?? this.srNo,
        semester: semester ?? sem ?? this.semester,
        subjectCode: subjectCode ?? this.subjectCode,
        subjectName: subjectName ?? this.subjectName,
        periodsAvailable: periodsAvailable ?? this.periodsAvailable,
        periodsEngaged: periodsEngaged ?? this.periodsEngaged,
        percentCovered:
            percentCovered ?? curriculumCoveredPct ?? this.percentCovered,
        continuousAssessmentTw:
            continuousAssessmentTw ?? this.continuousAssessmentTw,
        continuousAssessmentPr:
            continuousAssessmentPr ?? this.continuousAssessmentPr,
      );

  Map<String, dynamic> toJson() => {
        'srNo': srNo,
        'semester': semester,
        'subjectCode': subjectCode,
        'subjectName': subjectName,
        'periodsAvailable': periodsAvailable,
        'periodsEngaged': periodsEngaged,
        'percentCovered': percentCovered,
        'continuousAssessmentTw': continuousAssessmentTw,
        'continuousAssessmentPr': continuousAssessmentPr,
      };

  factory CurriculumSubjectItem.fromJson(Map<String, dynamic> json) =>
      CurriculumSubjectItem(
        srNo: json['srNo'] as int? ?? 1,
        semester: json['semester'] as int? ?? 1,
        subjectCode: json['subjectCode'] as String? ?? '',
        subjectName: json['subjectName'] as String? ?? '',
        periodsAvailable: json['periodsAvailable'] as int? ?? 0,
        periodsEngaged: json['periodsEngaged'] as int? ?? 0,
        percentCovered: json['percentCovered'] as int? ?? 100,
        continuousAssessmentTw:
            json['continuousAssessmentTw'] as String? ?? 'N',
        continuousAssessmentPr:
            json['continuousAssessmentPr'] as String? ?? 'N',
      );
}

class CurriculumSectionData {
  final int totalWeeksScheme;
  final String weeksAvailableUptoDate;
  final int weeksAvailableCount;
  final int facultiesPptPct;
  final int lessonPlanPreparedPct;
  final int labPlanPreparedPct;
  final int lecturesCoveredPct;
  final String refresherCourses;
  final int studentFeedbackPct;
  final List<CurriculumSubjectItem> subjects;

  const CurriculumSectionData({
    this.totalWeeksScheme = 15,
    this.weeksAvailableUptoDate = '30/09/2026',
    this.weeksAvailableCount = 11,
    this.facultiesPptPct = 100,
    this.lessonPlanPreparedPct = 100,
    this.labPlanPreparedPct = 100,
    this.lecturesCoveredPct = 100,
    this.refresherCourses = 'Yes',
    this.studentFeedbackPct = 100,
    required this.subjects,
  });

  factory CurriculumSectionData.defaultSample() => CurriculumSectionData(
        totalWeeksScheme: 15,
        weeksAvailableUptoDate: '30/09/2026',
        weeksAvailableCount: 11,
        facultiesPptPct: 100,
        lessonPlanPreparedPct: 100,
        labPlanPreparedPct: 100,
        lecturesCoveredPct: 100,
        refresherCourses: 'Yes',
        studentFeedbackPct: 100,
        subjects: const [
          SubjectCurriculumItem(srNo: 1, sem: 1, subjectCode: '17001', subjectName: 'ENGINEERING GRAPHICS', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 2, sem: 1, subjectCode: '17002', subjectName: 'COMPUTER FUNDAMENTALS', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 3, sem: 1, subjectCode: '17007', subjectName: 'BASIC WORKSHOP PRACTICE(COMPUTER GROUP)', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 4, sem: 1, subjectCode: '17101', subjectName: 'ENGLISH', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 5, sem: 1, subjectCode: '17102', subjectName: 'BASIC SCIENCE (PHYSICS)', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 6, sem: 1, subjectCode: '17103', subjectName: 'BASIC SCIENCE (CHEMISTRY)', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 7, sem: 1, subjectCode: '17104', subjectName: 'BASIC MATHEMATICS', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 8, sem: 1, subjectCode: '22001', subjectName: 'FUNDAMENTALS OF ICT', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 9, sem: 1, subjectCode: '22003', subjectName: 'ENGINEERING GRAPHICS', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 10, sem: 1, subjectCode: '22005', subjectName: 'WORKSHOP PRACTICE', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 11, sem: 1, subjectCode: '22101', subjectName: 'ENGLISH', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 12, sem: 1, subjectCode: '22102', subjectName: 'BASIC SCIENCE', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 13, sem: 1, subjectCode: '22103', subjectName: 'BASIC MATHEMATICS', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 14, sem: 1, subjectCode: '311001', subjectName: 'FUNDAMENTALS OF ICT', periodsAvailable: 9, periodsEngaged: 9, curriculumCoveredPct: 100, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 15, sem: 1, subjectCode: '311002', subjectName: 'ENGINEERING WORKSHOP PRACTICE', periodsAvailable: 9, periodsEngaged: 9, curriculumCoveredPct: 100, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 16, sem: 1, subjectCode: '311003', subjectName: 'YOGA AND MEDITATION', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 17, sem: 1, subjectCode: '311008', subjectName: 'ENGINEERING GRAPHICS', periodsAvailable: 18, periodsEngaged: 18, curriculumCoveredPct: 100, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 18, sem: 1, subjectCode: '311302', subjectName: 'BASIC MATHEMATICS', periodsAvailable: 36, periodsEngaged: 38, curriculumCoveredPct: 100, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 19, sem: 1, subjectCode: '311303', subjectName: 'COMMUNICATION SKILLS (ENGLISH)', periodsAvailable: 27, periodsEngaged: 30, curriculumCoveredPct: 100, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 20, sem: 1, subjectCode: '311305', subjectName: 'BASIC SCIENCE', periodsAvailable: 36, periodsEngaged: 40, curriculumCoveredPct: 100, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 21, sem: 1, subjectCode: '901150', subjectName: 'BASIC SCIENCE', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 22, sem: 2, subjectCode: '17010', subjectName: 'DEVELOPMENT OF LIFE SKILLS', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 23, sem: 2, subjectCode: '17013', subjectName: 'WEB PAGE DESIGNING', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 24, sem: 2, subjectCode: '17201', subjectName: 'COMMUNICATION SKILLS', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 25, sem: 2, subjectCode: '17210', subjectName: 'APPLIED SCIENCE (PHYSICS)', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 26, sem: 2, subjectCode: '17211', subjectName: 'APPLIED SCIENCE (CHEMISTRY)', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 27, sem: 2, subjectCode: '17212', subjectName: 'PROGRAMMING IN \'C\'', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 28, sem: 2, subjectCode: '17213', subjectName: 'BASIC ELECTRONICS', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 29, sem: 2, subjectCode: '17216', subjectName: 'ENGINEERING MATHEMATICS', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 30, sem: 2, subjectCode: '22009', subjectName: 'BUSINESS COMMUNICATION USING COMPUTERS', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 31, sem: 2, subjectCode: '22013', subjectName: 'COMPUTER PERIPHERAL AND HARDWARE MAINTENANCE', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 32, sem: 2, subjectCode: '22014', subjectName: 'WEB PAGE DESIGNING WITH HTML', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 33, sem: 2, subjectCode: '22215', subjectName: 'ELEMENTS OF ELECTRICAL ENGINEERING', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 34, sem: 2, subjectCode: '22224', subjectName: 'APPLIED MATHEMATICS', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 35, sem: 2, subjectCode: '22225', subjectName: 'BASIC ELECTRONICS', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 36, sem: 2, subjectCode: '22226', subjectName: 'PROGRAMMING IN \'C\'', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 37, sem: 2, subjectCode: '312001', subjectName: 'LINUX BASICS', periodsAvailable: 22, periodsEngaged: 22, curriculumCoveredPct: 100, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 38, sem: 2, subjectCode: '312002', subjectName: 'PROFESSIONAL COMMUNICATION', periodsAvailable: 0, periodsEngaged: 85, curriculumCoveredPct: 100, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 39, sem: 2, subjectCode: '312003', subjectName: 'SOCIAL AND LIFE SKILLS', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 40, sem: 2, subjectCode: '312004', subjectName: 'WEB PAGE DESIGNING', periodsAvailable: 22, periodsEngaged: 22, curriculumCoveredPct: 100, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 41, sem: 2, subjectCode: '312301', subjectName: 'APPLIED MATHEMATICS', periodsAvailable: 33, periodsEngaged: 37, curriculumCoveredPct: 100, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 42, sem: 2, subjectCode: '312302', subjectName: 'BASIC ELECTRICAL AND ELECTRONICS ENGINEERING', periodsAvailable: 22, periodsEngaged: 22, curriculumCoveredPct: 100, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 43, sem: 2, subjectCode: '312303', subjectName: 'PROGRAMMING IN C', periodsAvailable: 44, periodsEngaged: 44, curriculumCoveredPct: 100, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 44, sem: 2, subjectCode: '901162', subjectName: 'APPLIED SCIENCE', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 45, sem: 3, subjectCode: '17026', subjectName: 'GRAPHICAL USER INTERFACE (GUI) PROGRAMMING', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 46, sem: 3, subjectCode: '17027', subjectName: 'PROFESSIONAL PRACTICES-I', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 47, sem: 3, subjectCode: '17301', subjectName: 'APPLIED MATHEMATICS', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 48, sem: 3, subjectCode: '17330', subjectName: 'DATA STRUCTURE USING \'C\'', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 49, sem: 3, subjectCode: '17331', subjectName: 'ELECTRICAL TECHNOLOGY', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 50, sem: 3, subjectCode: '17332', subjectName: 'RELATIONAL DATABASE MANAGEMENT SYSTEM', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 51, sem: 3, subjectCode: '17333', subjectName: 'DIGITAL TECHNIQUES', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 52, sem: 3, subjectCode: '22316', subjectName: 'OBJECT ORIENTED PROGRAMMING USING C++', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 53, sem: 3, subjectCode: '22317', subjectName: 'DATA STRUCTURE USING \'C\'', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 54, sem: 3, subjectCode: '22318', subjectName: 'COMPUTER GRAPHICS', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 55, sem: 3, subjectCode: '22319', subjectName: 'DATABASE MANAGEMENT SYSTEM', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 56, sem: 3, subjectCode: '22320', subjectName: 'DIGITAL TECHNIQUES', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 57, sem: 3, subjectCode: '313001', subjectName: 'COMPUTER GRAPHICS', periodsAvailable: 13, periodsEngaged: 13, curriculumCoveredPct: 100, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 58, sem: 3, subjectCode: '313002', subjectName: 'ESSENCE OF INDIAN CONSTITUTION', periodsAvailable: 13, periodsEngaged: 14, curriculumCoveredPct: 100, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 59, sem: 3, subjectCode: '313301', subjectName: 'DATA STRUCTURE USING C', periodsAvailable: 39, periodsEngaged: 40, curriculumCoveredPct: 100, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 60, sem: 3, subjectCode: '313302', subjectName: 'DATABASE MANAGEMENT SYSTEM', periodsAvailable: 39, periodsEngaged: 41, curriculumCoveredPct: 100, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 61, sem: 3, subjectCode: '313303', subjectName: 'DIGITAL TECHNIQUES', periodsAvailable: 39, periodsEngaged: 40, curriculumCoveredPct: 100, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 62, sem: 3, subjectCode: '313304', subjectName: 'OBJECT ORIENTED PROGRAMMING USING C++', periodsAvailable: 39, periodsEngaged: 40, curriculumCoveredPct: 100, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 63, sem: 4, subjectCode: '17042', subjectName: 'PROFESSIONAL PRACTICES-II', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 64, sem: 4, subjectCode: '17056', subjectName: 'COMPUTER GRAPHICS', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 65, sem: 4, subjectCode: '17401', subjectName: 'ENVIRONMENTAL STUDIES', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 66, sem: 4, subjectCode: '17428', subjectName: 'COMPUTER HARDWARE & MAINTENANCE', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 67, sem: 4, subjectCode: '17429', subjectName: 'COMPUTER NETWORK', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 68, sem: 4, subjectCode: '17431', subjectName: 'MICROPROCESSOR & PROGRAMMING', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 69, sem: 4, subjectCode: '17432', subjectName: 'OBJECT ORIENTED PROGRAMMING', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 70, sem: 4, subjectCode: '22034', subjectName: 'GUI APPLICATION DEVELOPMENT USING VB.NET', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 71, sem: 4, subjectCode: '22412', subjectName: 'JAVA PROGRAMMING', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 72, sem: 4, subjectCode: '22413', subjectName: 'SOFTWARE ENGINEERING', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 73, sem: 4, subjectCode: '22414', subjectName: 'DATA COMMUNICATION AND COMPUTER NETWORK', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 74, sem: 4, subjectCode: '22415', subjectName: 'MICROPROCESSORS', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 75, sem: 4, subjectCode: '314004', subjectName: 'PYTHON PROGRAMMING', periodsAvailable: 22, periodsEngaged: 22, curriculumCoveredPct: 100, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 76, sem: 4, subjectCode: '314005', subjectName: 'UI/UX DESIGN', periodsAvailable: 11, periodsEngaged: 11, curriculumCoveredPct: 100, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 77, sem: 4, subjectCode: '314301', subjectName: 'ENVIRONMENTAL EDUCATION AND SUSTAINABILITY', periodsAvailable: 33, periodsEngaged: 33, curriculumCoveredPct: 100, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 78, sem: 4, subjectCode: '314317', subjectName: 'JAVA PROGRAMMING', periodsAvailable: 44, periodsEngaged: 44, curriculumCoveredPct: 100, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 79, sem: 4, subjectCode: '314318', subjectName: 'DATA COMMUNICATION AND COMPUTER NETWORK', periodsAvailable: 33, periodsEngaged: 33, curriculumCoveredPct: 100, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 80, sem: 4, subjectCode: '314321', subjectName: 'MICROPROCESSOR PROGRAMMING', periodsAvailable: 33, periodsEngaged: 33, curriculumCoveredPct: 100, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 81, sem: 5, subjectCode: '17061', subjectName: 'NETWORK MANAGEMENT & ADMINISTRATION', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 82, sem: 5, subjectCode: '17062', subjectName: 'PROFESSIONAL PRACTICES-III / INDUSTRIAL TRAINING (OPTIONAL)', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 83, sem: 5, subjectCode: '17075', subjectName: 'BEHAVIOURAL SCIENCE', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 84, sem: 5, subjectCode: '17512', subjectName: 'OPERATING SYSTEM', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 85, sem: 5, subjectCode: '17513', subjectName: 'SOFTWARE ENGINEERING', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 86, sem: 5, subjectCode: '17514', subjectName: 'COMPUTER SECURITY', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 87, sem: 5, subjectCode: '17515', subjectName: 'JAVA PROGRAMMING', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 88, sem: 5, subjectCode: '17517', subjectName: 'SYSTEM PROGRAMMING', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 89, sem: 5, subjectCode: '22057', subjectName: 'INDUSTRIAL TRAINING', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 90, sem: 5, subjectCode: '22058', subjectName: 'CAPSTONE PROJECT PLANNING', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 91, sem: 5, subjectCode: '22447', subjectName: 'ENVIRONMENTAL STUDIES', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 92, sem: 5, subjectCode: '22516', subjectName: 'OPERATING SYSTEMS', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 93, sem: 5, subjectCode: '22517', subjectName: 'ADVANCED JAVA PROGRAMMING', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 94, sem: 5, subjectCode: '22518', subjectName: 'SOFTWARE TESTING', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 95, sem: 5, subjectCode: '22519', subjectName: 'CLIENT SIDE SCRIPTING LANGUAGE (ELECTIVE-I)', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 96, sem: 5, subjectCode: '22520', subjectName: 'ADVANCED COMPUTER NETWORK (ELECTIVE-I)', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 97, sem: 5, subjectCode: '22521', subjectName: 'ADVANCED DATABASE MANAGEMENT SYSTEMS (ELECTIVE-I)', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 98, sem: 5, subjectCode: '315002', subjectName: 'ENTREPRENEURSHIP DEVELOPMENT AND STARTUPS', periodsAvailable: 14, periodsEngaged: 15, curriculumCoveredPct: 100, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 99, sem: 5, subjectCode: '315003', subjectName: 'SEMINAR AND PROJECT INITIATION COURSE', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 100, sem: 5, subjectCode: '315004', subjectName: 'INTERNSHIP(12 WEEKS)', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 101, sem: 5, subjectCode: '315319', subjectName: 'OPERATING SYSTEM', periodsAvailable: 35, periodsEngaged: 35, curriculumCoveredPct: 100, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 102, sem: 5, subjectCode: '315321', subjectName: 'ADVANCE COMPUTER NETWORK', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 103, sem: 5, subjectCode: '315323', subjectName: 'SOFTWARE ENGINEERING', periodsAvailable: 28, periodsEngaged: 27, curriculumCoveredPct: 100, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 104, sem: 5, subjectCode: '315325', subjectName: 'CLOUD COMPUTING', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 105, sem: 5, subjectCode: '315326', subjectName: 'DATA ANALYTICS', periodsAvailable: 28, periodsEngaged: 30, curriculumCoveredPct: 100, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 106, sem: 6, subjectCode: '17600', subjectName: 'SESSIONAL WORK', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 107, sem: 6, subjectCode: '17601', subjectName: 'MANAGEMENT', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 108, sem: 6, subjectCode: '17624', subjectName: 'SOFTWARE TESTING', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 109, sem: 6, subjectCode: '17625', subjectName: 'ADVANCED JAVA PROGRAMMING', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 110, sem: 6, subjectCode: '17630', subjectName: 'OBJECT ORIENTED MODELLING AND DESIGN', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 111, sem: 6, subjectCode: '17631', subjectName: 'ADVANCED DATABASE MANAGEMENT', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 112, sem: 6, subjectCode: '17816', subjectName: 'LINUX PROGRAMMING', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 113, sem: 6, subjectCode: '17817', subjectName: 'INDUSTRIAL PROJECT', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 114, sem: 6, subjectCode: '17818', subjectName: 'ENTREPERNEURSHIP DEVELOPMENT', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 115, sem: 6, subjectCode: '22032', subjectName: 'ENTERPRENURESHIP DEVELOPMENT', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 116, sem: 6, subjectCode: '22060', subjectName: 'CAPSTONE PROJECT - EXECUTION & REPORT WRITING', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 117, sem: 6, subjectCode: '22509', subjectName: 'MANAGEMENT', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 118, sem: 6, subjectCode: '22616', subjectName: 'PROGRAMMING WITH PYTHON', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 119, sem: 6, subjectCode: '22617', subjectName: 'MOBILE APPLICATION DEVELOPMENT', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 120, sem: 6, subjectCode: '22618', subjectName: 'EMERGING TRENDS IN COMPUTER AND INFORMATION TECHNOLGY', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 121, sem: 6, subjectCode: '22619', subjectName: 'WEB BASED APPLICATION DEVELOPMENT USING PHP', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 122, sem: 6, subjectCode: '22620', subjectName: 'NETWORK AND INFORMATION SECURITY', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 123, sem: 6, subjectCode: '22621', subjectName: 'DATA WAREHOUSING WITH MINING TECHNIQUES', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 124, sem: 6, subjectCode: '315301', subjectName: 'MANAGEMENT', periodsAvailable: 33, periodsEngaged: 33, curriculumCoveredPct: 100, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 125, sem: 6, subjectCode: '316004', subjectName: 'CAPSTONE PROJECT', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 126, sem: 6, subjectCode: '316005', subjectName: 'CLIENT SIDE SCRIPTING', periodsAvailable: 22, periodsEngaged: 22, curriculumCoveredPct: 100, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 127, sem: 6, subjectCode: '316006', subjectName: 'MOBILE APPLICATION DEVELOPMENT', periodsAvailable: 22, periodsEngaged: 22, curriculumCoveredPct: 100, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 128, sem: 6, subjectCode: '316313', subjectName: 'EMERGING TRENDS IN COMPUTER ENGINEERING AND INFORMATION TECHNOLOGY', periodsAvailable: 33, periodsEngaged: 35, curriculumCoveredPct: 100, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 129, sem: 6, subjectCode: '316314', subjectName: 'SOFTWARE TESTING', periodsAvailable: 33, periodsEngaged: 33, curriculumCoveredPct: 100, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 130, sem: 6, subjectCode: '316315', subjectName: 'DIGITAL FORENSIC AND HACKING TECHNIQUES', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
          SubjectCurriculumItem(srNo: 131, sem: 6, subjectCode: '316316', subjectName: 'MACHINE LEARNING', periodsAvailable: 33, periodsEngaged: 34, curriculumCoveredPct: 100, continuousAssessmentTw: 'Y', continuousAssessmentPr: 'Y'),
          SubjectCurriculumItem(srNo: 132, sem: 6, subjectCode: '316317', subjectName: 'NETWORK AND INFORMATION SECURITY', periodsAvailable: 0, periodsEngaged: 0, curriculumCoveredPct: 0, continuousAssessmentTw: 'N', continuousAssessmentPr: 'N'),
        ],
      );

  Map<String, dynamic> toJson() => {
        'totalWeeksScheme': totalWeeksScheme,
        'weeksAvailableUptoDate': weeksAvailableUptoDate,
        'weeksAvailableCount': weeksAvailableCount,
        'facultiesPptPct': facultiesPptPct,
        'lessonPlanPreparedPct': lessonPlanPreparedPct,
        'labPlanPreparedPct': labPlanPreparedPct,
        'lecturesCoveredPct': lecturesCoveredPct,
        'refresherCourses': refresherCourses,
        'studentFeedbackPct': studentFeedbackPct,
        'subjects': subjects.map((s) => s.toJson()).toList(),
      };

  factory CurriculumSectionData.fromJson(Map<String, dynamic> json) =>
      CurriculumSectionData(
        totalWeeksScheme: json['totalWeeksScheme'] as int? ?? 15,
        weeksAvailableUptoDate:
            json['weeksAvailableUptoDate'] as String? ?? '30/09/2026',
        weeksAvailableCount: json['weeksAvailableCount'] as int? ?? 11,
        facultiesPptPct: json['facultiesPptPct'] as int? ?? 100,
        lessonPlanPreparedPct: json['lessonPlanPreparedPct'] as int? ?? 100,
        labPlanPreparedPct: json['labPlanPreparedPct'] as int? ?? 100,
        lecturesCoveredPct: json['lecturesCoveredPct'] as int? ?? 100,
        refresherCourses: json['refresherCourses'] as String? ?? 'Yes',
        studentFeedbackPct: json['studentFeedbackPct'] as int? ?? 100,
        subjects: (json['subjects'] as List<dynamic>?)
                ?.map((e) =>
                    CurriculumSubjectItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            CurriculumSectionData.defaultSample().subjects,
      );
}

class AttendanceSubjectItem {
  final int srNo;
  final int semester;
  final String subjectCode;
  final String subjectName;
  final String avgTheoryAttendance;
  final String avgPracticalAttendance;

  int get sem => semester;

  const AttendanceSubjectItem({
    required this.srNo,
    int? semester,
    int? sem,
    required this.subjectCode,
    required this.subjectName,
    this.avgTheoryAttendance = '',
    this.avgPracticalAttendance = '',
  }) : semester = semester ?? sem ?? 1;

  AttendanceSubjectItem copyWith({
    int? srNo,
    int? semester,
    int? sem,
    String? subjectCode,
    String? subjectName,
    String? avgTheoryAttendance,
    String? avgPracticalAttendance,
  }) =>
      AttendanceSubjectItem(
        srNo: srNo ?? this.srNo,
        semester: semester ?? sem ?? this.semester,
        subjectCode: subjectCode ?? this.subjectCode,
        subjectName: subjectName ?? this.subjectName,
        avgTheoryAttendance: avgTheoryAttendance ?? this.avgTheoryAttendance,
        avgPracticalAttendance:
            avgPracticalAttendance ?? this.avgPracticalAttendance,
      );

  Map<String, dynamic> toJson() => {
        'srNo': srNo,
        'semester': semester,
        'subjectCode': subjectCode,
        'subjectName': subjectName,
        'avgTheoryAttendance': avgTheoryAttendance,
        'avgPracticalAttendance': avgPracticalAttendance,
      };

  factory AttendanceSubjectItem.fromJson(Map<String, dynamic> json) =>
      AttendanceSubjectItem(
        srNo: json['srNo'] as int? ?? 1,
        semester: json['semester'] as int? ?? 1,
        subjectCode: json['subjectCode'] as String? ?? '',
        subjectName: json['subjectName'] as String? ?? '',
        avgTheoryAttendance: json['avgTheoryAttendance']?.toString() ?? '',
        avgPracticalAttendance: json['avgPracticalAttendance']?.toString() ?? '',
      );
}

class StudentAttendanceSectionData {
  final String monitoringDate;
  final List<AttendanceSubjectItem> subjects;

  const StudentAttendanceSectionData({
    this.monitoringDate = '30/09/2026',
    required this.subjects,
  });

  factory StudentAttendanceSectionData.defaultSample() =>
      const StudentAttendanceSectionData(
        monitoringDate: '30/09/2026',
        subjects: [
          AttendanceSubjectItem(srNo: 1, sem: 1, subjectCode: '17001', subjectName: 'ENGINEERING GRAPHICS', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 2, sem: 1, subjectCode: '17002', subjectName: 'COMPUTER FUNDAMENTALS', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 3, sem: 1, subjectCode: '17007', subjectName: 'BASIC WORKSHOP PRACTICE(COMPUTER GROUP)', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 4, sem: 1, subjectCode: '17101', subjectName: 'ENGLISH', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 5, sem: 1, subjectCode: '17102', subjectName: 'BASIC SCIENCE (PHYSICS)', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 6, sem: 1, subjectCode: '17103', subjectName: 'BASIC SCIENCE (CHEMISTRY)', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 7, sem: 1, subjectCode: '17104', subjectName: 'BASIC MATHEMATICS', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 8, sem: 1, subjectCode: '22001', subjectName: 'FUNDAMENTALS OF ICT', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 9, sem: 1, subjectCode: '22003', subjectName: 'ENGINEERING GRAPHICS', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 10, sem: 1, subjectCode: '22005', subjectName: 'WORKSHOP PRACTICE', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 11, sem: 1, subjectCode: '22101', subjectName: 'ENGLISH', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 12, sem: 1, subjectCode: '22102', subjectName: 'BASIC SCIENCE', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 13, sem: 1, subjectCode: '22103', subjectName: 'BASIC MATHEMATICS', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 14, sem: 1, subjectCode: '311001', subjectName: 'FUNDAMENTALS OF ICT', avgTheoryAttendance: '86.99', avgPracticalAttendance: '85.22'),
          AttendanceSubjectItem(srNo: 15, sem: 1, subjectCode: '311002', subjectName: 'ENGINEERING WORKSHOP PRACTICE', avgTheoryAttendance: 'NA', avgPracticalAttendance: '86.67'),
          AttendanceSubjectItem(srNo: 16, sem: 1, subjectCode: '311003', subjectName: 'YOGA AND MEDITATION', avgTheoryAttendance: 'NA', avgPracticalAttendance: 'NA'),
          AttendanceSubjectItem(srNo: 17, sem: 1, subjectCode: '311008', subjectName: 'ENGINEERING GRAPHICS', avgTheoryAttendance: '90.93', avgPracticalAttendance: '86.26'),
          AttendanceSubjectItem(srNo: 18, sem: 1, subjectCode: '311302', subjectName: 'BASIC MATHEMATICS', avgTheoryAttendance: '85.65', avgPracticalAttendance: 'NA'),
          AttendanceSubjectItem(srNo: 19, sem: 1, subjectCode: '311303', subjectName: 'COMMUNICATION SKILLS (ENGLISH)', avgTheoryAttendance: '84.81', avgPracticalAttendance: '85.91'),
          AttendanceSubjectItem(srNo: 20, sem: 1, subjectCode: '311305', subjectName: 'BASIC SCIENCE', avgTheoryAttendance: '84.63', avgPracticalAttendance: '83.78'),
          AttendanceSubjectItem(srNo: 21, sem: 1, subjectCode: '901150', subjectName: 'BASIC SCIENCE', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 22, sem: 2, subjectCode: '17010', subjectName: 'DEVELOPMENT OF LIFE SKILLS', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 23, sem: 2, subjectCode: '17013', subjectName: 'WEB PAGE DESIGNING', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 24, sem: 2, subjectCode: '17201', subjectName: 'COMMUNICATION SKILLS', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 25, sem: 2, subjectCode: '17210', subjectName: 'APPLIED SCIENCE (PHYSICS)', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 26, sem: 2, subjectCode: '17211', subjectName: 'APPLIED SCIENCE (CHEMISTRY)', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 27, sem: 2, subjectCode: '17212', subjectName: 'PROGRAMMING IN \'C\'', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 28, sem: 2, subjectCode: '17213', subjectName: 'BASIC ELECTRONICS', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 29, sem: 2, subjectCode: '17216', subjectName: 'ENGINEERING MATHEMATICS', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 30, sem: 2, subjectCode: '22009', subjectName: 'BUSINESS COMMUNICATION USING COMPUTERS', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 31, sem: 2, subjectCode: '22013', subjectName: 'COMPUTER PERIPHERAL AND HARDWARE MAINTENANCE', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 32, sem: 2, subjectCode: '22014', subjectName: 'WEB PAGE DESIGNING WITH HTML', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 33, sem: 2, subjectCode: '22215', subjectName: 'ELEMENTS OF ELECTRICAL ENGINEERING', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 34, sem: 2, subjectCode: '22224', subjectName: 'APPLIED MATHEMATICS', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 35, sem: 2, subjectCode: '22225', subjectName: 'BASIC ELECTRONICS', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 36, sem: 2, subjectCode: '22226', subjectName: 'PROGRAMMING IN \'C\'', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 37, sem: 2, subjectCode: '312001', subjectName: 'LINUX BASICS', avgTheoryAttendance: '88.19', avgPracticalAttendance: '82.42'),
          AttendanceSubjectItem(srNo: 38, sem: 2, subjectCode: '312002', subjectName: 'PROFESSIONAL COMMUNICATION', avgTheoryAttendance: 'NA', avgPracticalAttendance: '81.20'),
          AttendanceSubjectItem(srNo: 39, sem: 2, subjectCode: '312003', subjectName: 'SOCIAL AND LIFE SKILLS', avgTheoryAttendance: 'NA', avgPracticalAttendance: 'NA'),
          AttendanceSubjectItem(srNo: 40, sem: 2, subjectCode: '312004', subjectName: 'WEB PAGE DESIGNING', avgTheoryAttendance: '90.55', avgPracticalAttendance: '95.23'),
          AttendanceSubjectItem(srNo: 41, sem: 2, subjectCode: '312301', subjectName: 'APPLIED MATHEMATICS', avgTheoryAttendance: '84.14', avgPracticalAttendance: '82.77'),
          AttendanceSubjectItem(srNo: 42, sem: 2, subjectCode: '312302', subjectName: 'BASIC ELECTRICAL AND ELECTRONICS ENGINEERING', avgTheoryAttendance: '81.33', avgPracticalAttendance: '83.12'),
          AttendanceSubjectItem(srNo: 43, sem: 2, subjectCode: '312303', subjectName: 'PROGRAMMING IN C', avgTheoryAttendance: '88.12', avgPracticalAttendance: '89.20'),
          AttendanceSubjectItem(srNo: 44, sem: 2, subjectCode: '901162', subjectName: 'APPLIED SCIENCE', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 45, sem: 3, subjectCode: '17026', subjectName: 'GRAPHICAL USER INTERFACE (GUI) PROGRAMMING', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 46, sem: 3, subjectCode: '17027', subjectName: 'PROFESSIONAL PRACTICES-I', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 47, sem: 3, subjectCode: '17301', subjectName: 'APPLIED MATHEMATICS', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 48, sem: 3, subjectCode: '17330', subjectName: 'DATA STRUCTURE USING \'C\'', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 49, sem: 3, subjectCode: '17331', subjectName: 'ELECTRICAL TECHNOLOGY', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 50, sem: 3, subjectCode: '17332', subjectName: 'RELATIONAL DATABASE MANAGEMENT SYSTEM', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 51, sem: 3, subjectCode: '17333', subjectName: 'DIGITAL TECHNIQUES', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 52, sem: 3, subjectCode: '22316', subjectName: 'OBJECT ORIENTED PROGRAMMING USING C++', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 53, sem: 3, subjectCode: '22317', subjectName: 'DATA STRUCTURE USING \'C\'', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 54, sem: 3, subjectCode: '22318', subjectName: 'COMPUTER GRAPHICS', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 55, sem: 3, subjectCode: '22319', subjectName: 'DATABASE MANAGEMENT SYSTEM', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 56, sem: 3, subjectCode: '22320', subjectName: 'DIGITAL TECHNIQUES', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 57, sem: 3, subjectCode: '313001', subjectName: 'COMPUTER GRAPHICS', avgTheoryAttendance: '81.66', avgPracticalAttendance: '80.03'),
          AttendanceSubjectItem(srNo: 58, sem: 3, subjectCode: '313002', subjectName: 'ESSENCE OF INDIAN CONSTITUTION', avgTheoryAttendance: '83.20', avgPracticalAttendance: 'NA'),
          AttendanceSubjectItem(srNo: 59, sem: 3, subjectCode: '313301', subjectName: 'DATA STRUCTURE USING C', avgTheoryAttendance: '81.34', avgPracticalAttendance: '82.33'),
          AttendanceSubjectItem(srNo: 60, sem: 3, subjectCode: '313302', subjectName: 'DATABASE MANAGEMENT SYSTEM', avgTheoryAttendance: '80.86', avgPracticalAttendance: '83.12'),
          AttendanceSubjectItem(srNo: 61, sem: 3, subjectCode: '313303', subjectName: 'DIGITAL TECHNIQUES', avgTheoryAttendance: '82.55', avgPracticalAttendance: '81.22'),
          AttendanceSubjectItem(srNo: 62, sem: 3, subjectCode: '313304', subjectName: 'OBJECT ORIENTED PROGRAMMING USING C++', avgTheoryAttendance: '81.33', avgPracticalAttendance: '83.22'),
          AttendanceSubjectItem(srNo: 63, sem: 4, subjectCode: '17042', subjectName: 'PROFESSIONAL PRACTICES-II', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 64, sem: 4, subjectCode: '17056', subjectName: 'COMPUTER GRAPHICS', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 65, sem: 4, subjectCode: '17401', subjectName: 'ENVIRONMENTAL STUDIES', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 66, sem: 4, subjectCode: '17428', subjectName: 'COMPUTER HARDWARE & MAINTENANCE', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 67, sem: 4, subjectCode: '17429', subjectName: 'COMPUTER NETWORK', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 68, sem: 4, subjectCode: '17431', subjectName: 'MICROPROCESSOR & PROGRAMMING', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 69, sem: 4, subjectCode: '17432', subjectName: 'OBJECT ORIENTED PROGRAMMING', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 70, sem: 4, subjectCode: '22034', subjectName: 'GUI APPLICATION DEVELOPMENT USING VB.NET', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 71, sem: 4, subjectCode: '22412', subjectName: 'JAVA PROGRAMMING', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 72, sem: 4, subjectCode: '22413', subjectName: 'SOFTWARE ENGINEERING', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 73, sem: 4, subjectCode: '22414', subjectName: 'DATA COMMUNICATION AND COMPUTER NETWORK', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 74, sem: 4, subjectCode: '22415', subjectName: 'MICROPROCESSORS', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 75, sem: 4, subjectCode: '314004', subjectName: 'PYTHON PROGRAMMING', avgTheoryAttendance: '83.45', avgPracticalAttendance: '86.95'),
          AttendanceSubjectItem(srNo: 76, sem: 4, subjectCode: '314005', subjectName: 'UI/UX DESIGN', avgTheoryAttendance: '80.55', avgPracticalAttendance: '82.63'),
          AttendanceSubjectItem(srNo: 77, sem: 4, subjectCode: '314301', subjectName: 'ENVIRONMENTAL EDUCATION AND SUSTAINABILITY', avgTheoryAttendance: '81.25', avgPracticalAttendance: '82.33'),
          AttendanceSubjectItem(srNo: 78, sem: 4, subjectCode: '314317', subjectName: 'JAVA PROGRAMMING', avgTheoryAttendance: '85.12', avgPracticalAttendance: '86.27'),
          AttendanceSubjectItem(srNo: 79, sem: 4, subjectCode: '314318', subjectName: 'DATA COMMUNICATION AND COMPUTER NETWORK', avgTheoryAttendance: '83.56', avgPracticalAttendance: '86.29'),
          AttendanceSubjectItem(srNo: 80, sem: 4, subjectCode: '314321', subjectName: 'MICROPROCESSOR PROGRAMMING', avgTheoryAttendance: '82.82', avgPracticalAttendance: '83.10'),
          AttendanceSubjectItem(srNo: 81, sem: 5, subjectCode: '17061', subjectName: 'NETWORK MANAGEMENT & ADMINISTRATION', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 82, sem: 5, subjectCode: '17062', subjectName: 'PROFESSIONAL PRACTICES-III / INDUSTRIAL TRAINING (OPTIONAL)', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 83, sem: 5, subjectCode: '17075', subjectName: 'BEHAVIOURAL SCIENCE', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 84, sem: 5, subjectCode: '17512', subjectName: 'OPERATING SYSTEM', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 85, sem: 5, subjectCode: '17513', subjectName: 'SOFTWARE ENGINEERING', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 86, sem: 5, subjectCode: '17514', subjectName: 'COMPUTER SECURITY', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 87, sem: 5, subjectCode: '17515', subjectName: 'JAVA PROGRAMMING', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 88, sem: 5, subjectCode: '17517', subjectName: 'SYSTEM PROGRAMMING', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 89, sem: 5, subjectCode: '22057', subjectName: 'INDUSTRIAL TRAINING', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 90, sem: 5, subjectCode: '22058', subjectName: 'CAPSTONE PROJECT PLANNING', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 91, sem: 5, subjectCode: '22447', subjectName: 'ENVIRONMENTAL STUDIES', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 92, sem: 5, subjectCode: '22516', subjectName: 'OPERATING SYSTEMS', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 93, sem: 5, subjectCode: '22517', subjectName: 'ADVANCED JAVA PROGRAMMING', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 94, sem: 5, subjectCode: '22518', subjectName: 'SOFTWARE TESTING', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 95, sem: 5, subjectCode: '22519', subjectName: 'CLIENT SIDE SCRIPTING LANGUAGE (ELECTIVE-I)', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 96, sem: 5, subjectCode: '22520', subjectName: 'ADVANCED COMPUTER NETWORK (ELECTIVE-I)', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 97, sem: 5, subjectCode: '22521', subjectName: 'ADVANCED DATABASE MANAGEMENT SYSTEMS (ELECTIVE-I)', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 98, sem: 5, subjectCode: '315002', subjectName: 'ENTREPRENEURSHIP DEVELOPMENT AND STARTUPS', avgTheoryAttendance: '80.92', avgPracticalAttendance: '80.45'),
          AttendanceSubjectItem(srNo: 99, sem: 5, subjectCode: '315003', subjectName: 'SEMINAR AND PROJECT INITIATION COURSE', avgTheoryAttendance: 'NA', avgPracticalAttendance: '90.03'),
          AttendanceSubjectItem(srNo: 100, sem: 5, subjectCode: '315004', subjectName: 'INTERNSHIP(12 WEEKS)', avgTheoryAttendance: 'NA', avgPracticalAttendance: 'NA'),
          AttendanceSubjectItem(srNo: 101, sem: 5, subjectCode: '315319', subjectName: 'OPERATING SYSTEM', avgTheoryAttendance: '83.52', avgPracticalAttendance: '81.24'),
          AttendanceSubjectItem(srNo: 102, sem: 5, subjectCode: '315321', subjectName: 'ADVANCE COMPUTER NETWORK', avgTheoryAttendance: 'NA', avgPracticalAttendance: 'NA'),
          AttendanceSubjectItem(srNo: 103, sem: 5, subjectCode: '315323', subjectName: 'SOFTWARE ENGINEERING', avgTheoryAttendance: '84.83', avgPracticalAttendance: '85.22'),
          AttendanceSubjectItem(srNo: 104, sem: 5, subjectCode: '315325', subjectName: 'CLOUD COMPUTING', avgTheoryAttendance: 'NA', avgPracticalAttendance: 'NA'),
          AttendanceSubjectItem(srNo: 105, sem: 5, subjectCode: '315326', subjectName: 'DATA ANALYTICS', avgTheoryAttendance: '83.56', avgPracticalAttendance: '84.36'),
          AttendanceSubjectItem(srNo: 106, sem: 6, subjectCode: '17600', subjectName: 'SESSIONAL WORK', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 107, sem: 6, subjectCode: '17601', subjectName: 'MANAGEMENT', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 108, sem: 6, subjectCode: '17624', subjectName: 'SOFTWARE TESTING', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 109, sem: 6, subjectCode: '17625', subjectName: 'ADVANCED JAVA PROGRAMMING', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 110, sem: 6, subjectCode: '17630', subjectName: 'OBJECT ORIENTED MODELLING AND DESIGN', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 111, sem: 6, subjectCode: '17631', subjectName: 'ADVANCED DATABASE MANAGEMENT', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 112, sem: 6, subjectCode: '17816', subjectName: 'LINUX PROGRAMMING', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 113, sem: 6, subjectCode: '17817', subjectName: 'INDUSTRIAL PROJECT', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 114, sem: 6, subjectCode: '17818', subjectName: 'ENTREPERNEURSHIP DEVELOPMENT', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 115, sem: 6, subjectCode: '22032', subjectName: 'ENTERPRENURESHIP DEVELOPMENT', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 116, sem: 6, subjectCode: '22060', subjectName: 'CAPSTONE PROJECT - EXECUTION & REPORT WRITING', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 117, sem: 6, subjectCode: '22509', subjectName: 'MANAGEMENT', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 118, sem: 6, subjectCode: '22616', subjectName: 'PROGRAMMING WITH PYTHON', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 119, sem: 6, subjectCode: '22617', subjectName: 'MOBILE APPLICATION DEVELOPMENT', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 120, sem: 6, subjectCode: '22618', subjectName: 'EMERGING TRENDS IN COMPUTER AND INFORMATION TECHNOLGY', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 121, sem: 6, subjectCode: '22619', subjectName: 'WEB BASED APPLICATION DEVELOPMENT USING PHP', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 122, sem: 6, subjectCode: '22620', subjectName: 'NETWORK AND INFORMATION SECURITY', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 123, sem: 6, subjectCode: '22621', subjectName: 'DATA WAREHOUSING WITH MINING TECHNIQUES', avgTheoryAttendance: '', avgPracticalAttendance: ''),
          AttendanceSubjectItem(srNo: 124, sem: 6, subjectCode: '315301', subjectName: 'MANAGEMENT', avgTheoryAttendance: '81.55', avgPracticalAttendance: 'NA'),
          AttendanceSubjectItem(srNo: 125, sem: 6, subjectCode: '316004', subjectName: 'CAPSTONE PROJECT', avgTheoryAttendance: 'NA', avgPracticalAttendance: '88.28'),
          AttendanceSubjectItem(srNo: 126, sem: 6, subjectCode: '316005', subjectName: 'CLIENT SIDE SCRIPTING', avgTheoryAttendance: '85.65', avgPracticalAttendance: '86.45'),
          AttendanceSubjectItem(srNo: 127, sem: 6, subjectCode: '316006', subjectName: 'MOBILE APPLICATION DEVELOPMENT', avgTheoryAttendance: '82.56', avgPracticalAttendance: '81.39'),
          AttendanceSubjectItem(srNo: 128, sem: 6, subjectCode: '316313', subjectName: 'EMERGING TRENDS IN COMPUTER ENGINEERING AND INFORMATION TECHNOLOGY', avgTheoryAttendance: '91.22', avgPracticalAttendance: 'NA'),
          AttendanceSubjectItem(srNo: 129, sem: 6, subjectCode: '316314', subjectName: 'SOFTWARE TESTING', avgTheoryAttendance: '85.12', avgPracticalAttendance: '86.24'),
          AttendanceSubjectItem(srNo: 130, sem: 6, subjectCode: '316315', subjectName: 'DIGITAL FORENSIC AND HACKING TECHNIQUES', avgTheoryAttendance: 'NA', avgPracticalAttendance: 'NA'),
          AttendanceSubjectItem(srNo: 131, sem: 6, subjectCode: '316316', subjectName: 'MACHINE LEARNING', avgTheoryAttendance: '85.65', avgPracticalAttendance: '81.67'),
          AttendanceSubjectItem(srNo: 132, sem: 6, subjectCode: '316317', subjectName: 'NETWORK AND INFORMATION SECURITY', avgTheoryAttendance: 'NA', avgPracticalAttendance: 'NA'),
        ],
      );

  Map<String, dynamic> toJson() => {
        'monitoringDate': monitoringDate,
        'subjects': subjects.map((s) => s.toJson()).toList(),
      };

  factory StudentAttendanceSectionData.fromJson(Map<String, dynamic> json) =>
      StudentAttendanceSectionData(
        monitoringDate: json['monitoringDate'] as String? ?? '30/09/2026',
        subjects: (json['subjects'] as List<dynamic>?)
                ?.map((e) =>
                    AttendanceSubjectItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            StudentAttendanceSectionData.defaultSample().subjects,
      );
}

class SemesterResultItem {
  final String semYear;
  final int appeared;
  final int clearPassed;
  final int failed;
  final int atkt;
  final double passingPct;

  const SemesterResultItem({
    required this.semYear,
    required this.appeared,
    required this.clearPassed,
    required this.failed,
    required this.atkt,
    required this.passingPct,
  });

  SemesterResultItem copyWith({
    String? semYear,
    int? appeared,
    int? clearPassed,
    int? failed,
    int? atkt,
    double? passingPct,
  }) =>
      SemesterResultItem(
        semYear: semYear ?? this.semYear,
        appeared: appeared ?? this.appeared,
        clearPassed: clearPassed ?? this.clearPassed,
        failed: failed ?? this.failed,
        atkt: atkt ?? this.atkt,
        passingPct: passingPct ?? this.passingPct,
      );

  Map<String, dynamic> toJson() => {
        'semYear': semYear,
        'appeared': appeared,
        'clearPassed': clearPassed,
        'failed': failed,
        'atkt': atkt,
        'passingPct': passingPct,
      };

  factory SemesterResultItem.fromJson(Map<String, dynamic> json) =>
      SemesterResultItem(
        semYear: json['semYear'] as String? ?? 'I',
        appeared: json['appeared'] as int? ?? 0,
        clearPassed: json['clearPassed'] as int? ?? 0,
        failed: json['failed'] as int? ?? 0,
        atkt: json['atkt'] as int? ?? 0,
        passingPct: (json['passingPct'] as num?)?.toDouble() ?? 0.0,
      );
}

class ResultAnalysisSectionData {
  final List<SemesterResultItem> semesterResults;
  final String extraClassesConducted;
  final String questionPapersSolved;
  final String personalAttentionToAverage;
  final String libraryFacilityProvided;
  final int retrospectiveStudents1stYr;
  final int retrospectiveStudents2ndYr;
  final int retrospectiveStudentsFinalYr;
  final int finalYearStudentsCount;
  final int averageResultLast3Years;
  final int percentFirstDivision;

  // Additional MSBTE metrics from 8 Result Analysis.pdf
  final int enrolled1stYr;
  final int appeared1stYr;
  final int pctAppeared1stYr;
  final int enrolled2ndYr;
  final int appeared2ndYr;
  final int pctAppeared2ndYr;
  final int enrolled3rdYr;
  final int appeared3rdYr;
  final int pctAppeared3rdYr;
  final int avgPctAppearedAllYr;
  final String attainmentTargetSet;
  final String mappingCoPoDone;
  final String attainmentCalculated;
  final String attainmentAchieved;
  final String actionTakenReportDone;
  final String apiThirdYear;
  final String apiSecondYear;
  final String apiFirstYear;
  final String siWithoutBacklogs;
  final String siWithBacklogs;
  final String diffProgressiveAndEse;
  final String placementHigherStudiesIndex;

  const ResultAnalysisSectionData({
    required this.semesterResults,
    this.extraClassesConducted = 'Yes',
    this.questionPapersSolved = 'Yes',
    this.personalAttentionToAverage = 'Yes',
    this.libraryFacilityProvided = 'Yes',
    this.retrospectiveStudents1stYr = 185,
    this.retrospectiveStudents2ndYr = 174,
    this.retrospectiveStudentsFinalYr = 171,
    this.finalYearStudentsCount = 204,
    this.averageResultLast3Years = 97,
    this.percentFirstDivision = 99,
    this.enrolled1stYr = 199,
    this.appeared1stYr = 194,
    this.pctAppeared1stYr = 97,
    this.enrolled2ndYr = 227,
    this.appeared2ndYr = 225,
    this.pctAppeared2ndYr = 99,
    this.enrolled3rdYr = 205,
    this.appeared3rdYr = 204,
    this.pctAppeared3rdYr = 100,
    this.avgPctAppearedAllYr = 99,
    this.attainmentTargetSet = 'Yes',
    this.mappingCoPoDone = 'Yes',
    this.attainmentCalculated = 'Yes',
    this.attainmentAchieved = 'Yes',
    this.actionTakenReportDone = 'Yes',
    this.apiThirdYear = '12.23',
    this.apiSecondYear = '14.55',
    this.apiFirstYear = '17.93',
    this.siWithoutBacklogs = '26.40',
    this.siWithBacklogs = '16.6',
    this.diffProgressiveAndEse = 'NA',
    this.placementHigherStudiesIndex = '35.60',
  });

  ResultAnalysisSectionData copyWith({
    List<SemesterResultItem>? semesterResults,
    String? extraClassesConducted,
    String? questionPapersSolved,
    String? personalAttentionToAverage,
    String? libraryFacilityProvided,
    int? retrospectiveStudents1stYr,
    int? retrospectiveStudents2ndYr,
    int? retrospectiveStudentsFinalYr,
    int? finalYearStudentsCount,
    int? averageResultLast3Years,
    int? percentFirstDivision,
    int? enrolled1stYr,
    int? appeared1stYr,
    int? pctAppeared1stYr,
    int? enrolled2ndYr,
    int? appeared2ndYr,
    int? pctAppeared2ndYr,
    int? enrolled3rdYr,
    int? appeared3rdYr,
    int? pctAppeared3rdYr,
    int? avgPctAppearedAllYr,
    String? attainmentTargetSet,
    String? mappingCoPoDone,
    String? attainmentCalculated,
    String? attainmentAchieved,
    String? actionTakenReportDone,
    String? apiThirdYear,
    String? apiSecondYear,
    String? apiFirstYear,
    String? siWithoutBacklogs,
    String? siWithBacklogs,
    String? diffProgressiveAndEse,
    String? placementHigherStudiesIndex,
  }) =>
      ResultAnalysisSectionData(
        semesterResults: semesterResults ?? this.semesterResults,
        extraClassesConducted:
            extraClassesConducted ?? this.extraClassesConducted,
        questionPapersSolved: questionPapersSolved ?? this.questionPapersSolved,
        personalAttentionToAverage:
            personalAttentionToAverage ?? this.personalAttentionToAverage,
        libraryFacilityProvided:
            libraryFacilityProvided ?? this.libraryFacilityProvided,
        retrospectiveStudents1stYr:
            retrospectiveStudents1stYr ?? this.retrospectiveStudents1stYr,
        retrospectiveStudents2ndYr:
            retrospectiveStudents2ndYr ?? this.retrospectiveStudents2ndYr,
        retrospectiveStudentsFinalYr:
            retrospectiveStudentsFinalYr ?? this.retrospectiveStudentsFinalYr,
        finalYearStudentsCount:
            finalYearStudentsCount ?? this.finalYearStudentsCount,
        averageResultLast3Years:
            averageResultLast3Years ?? this.averageResultLast3Years,
        percentFirstDivision:
            percentFirstDivision ?? this.percentFirstDivision,
        enrolled1stYr: enrolled1stYr ?? this.enrolled1stYr,
        appeared1stYr: appeared1stYr ?? this.appeared1stYr,
        pctAppeared1stYr: pctAppeared1stYr ?? this.pctAppeared1stYr,
        enrolled2ndYr: enrolled2ndYr ?? this.enrolled2ndYr,
        appeared2ndYr: appeared2ndYr ?? this.appeared2ndYr,
        pctAppeared2ndYr: pctAppeared2ndYr ?? this.pctAppeared2ndYr,
        enrolled3rdYr: enrolled3rdYr ?? this.enrolled3rdYr,
        appeared3rdYr: appeared3rdYr ?? this.appeared3rdYr,
        pctAppeared3rdYr: pctAppeared3rdYr ?? this.pctAppeared3rdYr,
        avgPctAppearedAllYr: avgPctAppearedAllYr ?? this.avgPctAppearedAllYr,
        attainmentTargetSet: attainmentTargetSet ?? this.attainmentTargetSet,
        mappingCoPoDone: mappingCoPoDone ?? this.mappingCoPoDone,
        attainmentCalculated:
            attainmentCalculated ?? this.attainmentCalculated,
        attainmentAchieved: attainmentAchieved ?? this.attainmentAchieved,
        actionTakenReportDone:
            actionTakenReportDone ?? this.actionTakenReportDone,
        apiThirdYear: apiThirdYear ?? this.apiThirdYear,
        apiSecondYear: apiSecondYear ?? this.apiSecondYear,
        apiFirstYear: apiFirstYear ?? this.apiFirstYear,
        siWithoutBacklogs: siWithoutBacklogs ?? this.siWithoutBacklogs,
        siWithBacklogs: siWithBacklogs ?? this.siWithBacklogs,
        diffProgressiveAndEse:
            diffProgressiveAndEse ?? this.diffProgressiveAndEse,
        placementHigherStudiesIndex:
            placementHigherStudiesIndex ?? this.placementHigherStudiesIndex,
      );

  factory ResultAnalysisSectionData.defaultSample() =>
      const ResultAnalysisSectionData(
        semesterResults: [
          SemesterResultItem(
              semYear: 'I',
              appeared: 194,
              clearPassed: 162,
              failed: 9,
              atkt: 23,
              passingPct: 83.0),
          SemesterResultItem(
              semYear: 'II',
              appeared: 189,
              clearPassed: 160,
              failed: 20,
              atkt: 9,
              passingPct: 84.0),
          SemesterResultItem(
              semYear: 'III',
              appeared: 225,
              clearPassed: 196,
              failed: 13,
              atkt: 16,
              passingPct: 87.0),
          SemesterResultItem(
              semYear: 'IV',
              appeared: 216,
              clearPassed: 197,
              failed: 6,
              atkt: 13,
              passingPct: 91.0),
          SemesterResultItem(
              semYear: 'V',
              appeared: 204,
              clearPassed: 202,
              failed: 1,
              atkt: 1,
              passingPct: 99.0),
          SemesterResultItem(
              semYear: 'VI',
              appeared: 204,
              clearPassed: 204,
              failed: 0,
              atkt: 0,
              passingPct: 100.0),
        ],
      );

  Map<String, dynamic> toJson() => {
        'semesterResults': semesterResults.map((s) => s.toJson()).toList(),
        'extraClassesConducted': extraClassesConducted,
        'questionPapersSolved': questionPapersSolved,
        'personalAttentionToAverage': personalAttentionToAverage,
        'libraryFacilityProvided': libraryFacilityProvided,
        'retrospectiveStudents1stYr': retrospectiveStudents1stYr,
        'retrospectiveStudents2ndYr': retrospectiveStudents2ndYr,
        'retrospectiveStudentsFinalYr': retrospectiveStudentsFinalYr,
        'finalYearStudentsCount': finalYearStudentsCount,
        'averageResultLast3Years': averageResultLast3Years,
        'percentFirstDivision': percentFirstDivision,
        'enrolled1stYr': enrolled1stYr,
        'appeared1stYr': appeared1stYr,
        'pctAppeared1stYr': pctAppeared1stYr,
        'enrolled2ndYr': enrolled2ndYr,
        'appeared2ndYr': appeared2ndYr,
        'pctAppeared2ndYr': pctAppeared2ndYr,
        'enrolled3rdYr': enrolled3rdYr,
        'appeared3rdYr': appeared3rdYr,
        'pctAppeared3rdYr': pctAppeared3rdYr,
        'avgPctAppearedAllYr': avgPctAppearedAllYr,
        'attainmentTargetSet': attainmentTargetSet,
        'mappingCoPoDone': mappingCoPoDone,
        'attainmentCalculated': attainmentCalculated,
        'attainmentAchieved': attainmentAchieved,
        'actionTakenReportDone': actionTakenReportDone,
        'apiThirdYear': apiThirdYear,
        'apiSecondYear': apiSecondYear,
        'apiFirstYear': apiFirstYear,
        'siWithoutBacklogs': siWithoutBacklogs,
        'siWithBacklogs': siWithBacklogs,
        'diffProgressiveAndEse': diffProgressiveAndEse,
        'placementHigherStudiesIndex': placementHigherStudiesIndex,
      };

  factory ResultAnalysisSectionData.fromJson(Map<String, dynamic> json) =>
      ResultAnalysisSectionData(
        semesterResults: (json['semesterResults'] as List<dynamic>?)
                ?.map((e) =>
                    SemesterResultItem.fromJson(e as Map<String, dynamic>))
                .toList() ??
            ResultAnalysisSectionData.defaultSample().semesterResults,
        extraClassesConducted:
            json['extraClassesConducted'] as String? ?? 'Yes',
        questionPapersSolved: json['questionPapersSolved'] as String? ?? 'Yes',
        personalAttentionToAverage:
            json['personalAttentionToAverage'] as String? ?? 'Yes',
        libraryFacilityProvided:
            json['libraryFacilityProvided'] as String? ?? 'Yes',
        retrospectiveStudents1stYr:
            json['retrospectiveStudents1stYr'] as int? ?? 185,
        retrospectiveStudents2ndYr:
            json['retrospectiveStudents2ndYr'] as int? ?? 174,
        retrospectiveStudentsFinalYr:
            json['retrospectiveStudentsFinalYr'] as int? ?? 171,
        finalYearStudentsCount: json['finalYearStudentsCount'] as int? ?? 204,
        averageResultLast3Years: json['averageResultLast3Years'] as int? ?? 97,
        percentFirstDivision: json['percentFirstDivision'] as int? ?? 99,
        enrolled1stYr: json['enrolled1stYr'] as int? ?? 199,
        appeared1stYr: json['appeared1stYr'] as int? ?? 194,
        pctAppeared1stYr: json['pctAppeared1stYr'] as int? ?? 97,
        enrolled2ndYr: json['enrolled2ndYr'] as int? ?? 227,
        appeared2ndYr: json['appeared2ndYr'] as int? ?? 225,
        pctAppeared2ndYr: json['pctAppeared2ndYr'] as int? ?? 99,
        enrolled3rdYr: json['enrolled3rdYr'] as int? ?? 205,
        appeared3rdYr: json['appeared3rdYr'] as int? ?? 204,
        pctAppeared3rdYr: json['pctAppeared3rdYr'] as int? ?? 100,
        avgPctAppearedAllYr: json['avgPctAppearedAllYr'] as int? ?? 99,
        attainmentTargetSet: json['attainmentTargetSet'] as String? ?? 'Yes',
        mappingCoPoDone: json['mappingCoPoDone'] as String? ?? 'Yes',
        attainmentCalculated: json['attainmentCalculated'] as String? ?? 'Yes',
        attainmentAchieved: json['attainmentAchieved'] as String? ?? 'Yes',
        actionTakenReportDone:
            json['actionTakenReportDone'] as String? ?? 'Yes',
        apiThirdYear: json['apiThirdYear'] as String? ?? '12.23',
        apiSecondYear: json['apiSecondYear'] as String? ?? '14.55',
        apiFirstYear: json['apiFirstYear'] as String? ?? '17.93',
        siWithoutBacklogs: json['siWithoutBacklogs'] as String? ?? '26.40',
        siWithBacklogs: json['siWithBacklogs'] as String? ?? '16.6',
        diffProgressiveAndEse:
            json['diffProgressiveAndEse'] as String? ?? 'NA',
        placementHigherStudiesIndex:
            json['placementHigherStudiesIndex'] as String? ?? '35.60',
      );
}

class ResourcesSectionData {
  final int cdDvdAvailable;
  final int cdDvdAdded;
  final int pptsAvailable;
  final int pptsAdded;
  final int flashAvailable;
  final int flashAdded;
  final int lcdAvailable;
  final int lcdAdded;
  final int interactiveBoardAvailable;
  final int interactiveBoardAdded;
  final int vlcAvailable;
  final int vlcAdded;
  final String remark;

  const ResourcesSectionData({
    this.cdDvdAvailable = 10,
    this.cdDvdAdded = 8,
    this.pptsAvailable = 650,
    this.pptsAdded = 140,
    this.flashAvailable = 5,
    this.flashAdded = 2,
    this.lcdAvailable = 7,
    this.lcdAdded = 0,
    this.interactiveBoardAvailable = 1,
    this.interactiveBoardAdded = 1,
    this.vlcAvailable = 0,
    this.vlcAdded = 0,
    this.remark =
        '1. NDL- National Digital Library Access for E-Learning for students and staff\n2. MKCL LMS ERA Tools implemented for syllabus resources.',
  });

  factory ResourcesSectionData.defaultSample() => const ResourcesSectionData();

  ResourcesSectionData copyWith({
    int? cdDvdAvailable,
    int? cdDvdAdded,
    int? pptsAvailable,
    int? pptsAdded,
    int? flashAvailable,
    int? flashAdded,
    int? lcdAvailable,
    int? lcdAdded,
    int? interactiveBoardAvailable,
    int? interactiveBoardAdded,
    int? vlcAvailable,
    int? vlcAdded,
    String? remark,
  }) =>
      ResourcesSectionData(
        cdDvdAvailable: cdDvdAvailable ?? this.cdDvdAvailable,
        cdDvdAdded: cdDvdAdded ?? this.cdDvdAdded,
        pptsAvailable: pptsAvailable ?? this.pptsAvailable,
        pptsAdded: pptsAdded ?? this.pptsAdded,
        flashAvailable: flashAvailable ?? this.flashAvailable,
        flashAdded: flashAdded ?? this.flashAdded,
        lcdAvailable: lcdAvailable ?? this.lcdAvailable,
        lcdAdded: lcdAdded ?? this.lcdAdded,
        interactiveBoardAvailable:
            interactiveBoardAvailable ?? this.interactiveBoardAvailable,
        interactiveBoardAdded:
            interactiveBoardAdded ?? this.interactiveBoardAdded,
        vlcAvailable: vlcAvailable ?? this.vlcAvailable,
        vlcAdded: vlcAdded ?? this.vlcAdded,
        remark: remark ?? this.remark,
      );

  Map<String, dynamic> toJson() => {
        'cdDvdAvailable': cdDvdAvailable,
        'cdDvdAdded': cdDvdAdded,
        'pptsAvailable': pptsAvailable,
        'pptsAdded': pptsAdded,
        'flashAvailable': flashAvailable,
        'flashAdded': flashAdded,
        'lcdAvailable': lcdAvailable,
        'lcdAdded': lcdAdded,
        'interactiveBoardAvailable': interactiveBoardAvailable,
        'interactiveBoardAdded': interactiveBoardAdded,
        'vlcAvailable': vlcAvailable,
        'vlcAdded': vlcAdded,
        'remark': remark,
      };

  factory ResourcesSectionData.fromJson(Map<String, dynamic> json) =>
      ResourcesSectionData(
        cdDvdAvailable: json['cdDvdAvailable'] as int? ?? 10,
        cdDvdAdded: json['cdDvdAdded'] as int? ?? 8,
        pptsAvailable: json['pptsAvailable'] as int? ?? 650,
        pptsAdded: json['pptsAdded'] as int? ?? 140,
        flashAvailable: json['flashAvailable'] as int? ?? 5,
        flashAdded: json['flashAdded'] as int? ?? 2,
        lcdAvailable: json['lcdAvailable'] as int? ?? 7,
        lcdAdded: json['lcdAdded'] as int? ?? 0,
        interactiveBoardAvailable:
            json['interactiveBoardAvailable'] as int? ?? 1,
        interactiveBoardAdded: json['interactiveBoardAdded'] as int? ?? 1,
        vlcAvailable: json['vlcAvailable'] as int? ?? 0,
        vlcAdded: json['vlcAdded'] as int? ?? 0,
        remark: json['remark'] as String? ?? '',
      );
}

class CoCurricularActivityItem {
  final int srNo;
  final String natureOfActivity;
  final int numberPlanned;
  final int actualArranged;
  final int deficiency;
  final int numberOfBeneficiaries;
  final String remarks;

  const CoCurricularActivityItem({
    required this.srNo,
    required this.natureOfActivity,
    required this.numberPlanned,
    required this.actualArranged,
    this.deficiency = 0,
    required this.numberOfBeneficiaries,
    required this.remarks,
  });

  CoCurricularActivityItem copyWith({
    int? srNo,
    String? natureOfActivity,
    int? numberPlanned,
    int? actualArranged,
    int? deficiency,
    int? numberOfBeneficiaries,
    String? remarks,
  }) =>
      CoCurricularActivityItem(
        srNo: srNo ?? this.srNo,
        natureOfActivity: natureOfActivity ?? this.natureOfActivity,
        numberPlanned: numberPlanned ?? this.numberPlanned,
        actualArranged: actualArranged ?? this.actualArranged,
        deficiency: deficiency ?? this.deficiency,
        numberOfBeneficiaries:
            numberOfBeneficiaries ?? this.numberOfBeneficiaries,
        remarks: remarks ?? this.remarks,
      );

  Map<String, dynamic> toJson() => {
        'srNo': srNo,
        'natureOfActivity': natureOfActivity,
        'numberPlanned': numberPlanned,
        'actualArranged': actualArranged,
        'deficiency': deficiency,
        'numberOfBeneficiaries': numberOfBeneficiaries,
        'remarks': remarks,
      };

  factory CoCurricularActivityItem.fromJson(Map<String, dynamic> json) =>
      CoCurricularActivityItem(
        srNo: json['srNo'] as int? ?? 1,
        natureOfActivity: json['natureOfActivity'] as String? ?? '',
        numberPlanned: json['numberPlanned'] as int? ?? 0,
        actualArranged: json['actualArranged'] as int? ?? 0,
        deficiency: json['deficiency'] as int? ?? 0,
        numberOfBeneficiaries: json['numberOfBeneficiaries'] as int? ?? 0,
        remarks: json['remarks'] as String? ?? '',
      );
}

class CoCurricularSectionData {
  final List<CoCurricularActivityItem> activities;
  final double budgetDemanded;
  final double budgetAllocated;
  final double budgetUtilised;

  const CoCurricularSectionData({
    required this.activities,
    this.budgetDemanded = 52.0,
    this.budgetAllocated = 52.0,
    this.budgetUtilised = 50.57,
  });

  factory CoCurricularSectionData.defaultSample() =>
      const CoCurricularSectionData(
        budgetDemanded: 52.0,
        budgetAllocated: 52.0,
        budgetUtilised: 50.57,
        activities: [
          CoCurricularActivityItem(srNo: 1, natureOfActivity: 'Industrial /Hospital (for Pharmacy) Visits organised during last/ current* academic year.', numberPlanned: 8, actualArranged: 8, deficiency: 0, numberOfBeneficiaries: 954, remarks: 'Sumago Infotech, ESDS Software'),
          CoCurricularActivityItem(srNo: 2, natureOfActivity: 'Industry Experts Lectures involved in academic activities of institute during last/ current* academic year.', numberPlanned: 33, actualArranged: 33, deficiency: 0, numberOfBeneficiaries: 2285, remarks: 'Data Core Solutions, Winjit Tech'),
          CoCurricularActivityItem(srNo: 3, natureOfActivity: 'Industry Based Projects', numberPlanned: 8, actualArranged: 8, deficiency: 0, numberOfBeneficiaries: 34, remarks: 'Smart Bridge, Tech Mahindra'),
          CoCurricularActivityItem(srNo: 4, natureOfActivity: 'Learning Resources Development', numberPlanned: 80, actualArranged: 200, deficiency: 0, numberOfBeneficiaries: 600, remarks: 'ERA LMS, NPTEL videos'),
          CoCurricularActivityItem(srNo: 5, natureOfActivity: 'Industrial Trainings deputations', numberPlanned: 219, actualArranged: 219, deficiency: 0, numberOfBeneficiaries: 219, remarks: 'Calibers Infotech 6-week training'),
          CoCurricularActivityItem(srNo: 6, natureOfActivity: 'Faculties attended trainings for soft skill, Content updation, Industrial Training, Orientation Workshop etc. in last/ current* academic year.', numberPlanned: 5, actualArranged: 11, deficiency: 0, numberOfBeneficiaries: 11, remarks: 'FDP Programs (MSBTE/AICTE)'),
          CoCurricularActivityItem(srNo: 7, natureOfActivity: 'Faculty Trainings Organised', numberPlanned: 2, actualArranged: 2, deficiency: 0, numberOfBeneficiaries: 4, remarks: 'MSBTE Sponsored STTP'),
          CoCurricularActivityItem(srNo: 8, natureOfActivity: 'Faculties deputed/sponsored for the improvement of academic qualification/Higher Education', numberPlanned: 1, actualArranged: 1, deficiency: 0, numberOfBeneficiaries: 1, remarks: 'Deputed for Ph.D Program'),
          CoCurricularActivityItem(srNo: 9, natureOfActivity: 'Project Paper Presentation', numberPlanned: 1, actualArranged: 1, deficiency: 0, numberOfBeneficiaries: 5, remarks: 'CSMSS Poly, Aurangabad'),
          CoCurricularActivityItem(srNo: 10, natureOfActivity: 'Technical Quiz Participations', numberPlanned: 1, actualArranged: 1, deficiency: 0, numberOfBeneficiaries: 5, remarks: 'Brahma Valley / MET Poly'),
          CoCurricularActivityItem(srNo: 11, natureOfActivity: 'Career Fair', numberPlanned: 1, actualArranged: 1, deficiency: 0, numberOfBeneficiaries: 0, remarks: 'Pragyan Career Guidance'),
          CoCurricularActivityItem(srNo: 12, natureOfActivity: 'Project Institute', numberPlanned: 1, actualArranged: 1, deficiency: 0, numberOfBeneficiaries: 19, remarks: 'Scanning and Image Processing'),
          CoCurricularActivityItem(srNo: 13, natureOfActivity: 'Curriculum Development', numberPlanned: 0, actualArranged: 0, deficiency: 0, numberOfBeneficiaries: 15, remarks: 'Bilingual Lab Manual Development'),
          CoCurricularActivityItem(srNo: 14, natureOfActivity: 'Any other social activities - Earn and learn/ NSS/ NCC/ Community services/Student welfare fund etc.', numberPlanned: 2, actualArranged: 2, deficiency: 0, numberOfBeneficiaries: 77, remarks: 'Swachhta Abhiyan, Tree Plantation'),
          CoCurricularActivityItem(srNo: 15, natureOfActivity: 'Programs Conducted for Personality Development during last/current* year', numberPlanned: 2, actualArranged: 2, deficiency: 0, numberOfBeneficiaries: 253, remarks: '2 Days Workshop on Soft Skills'),
          CoCurricularActivityItem(srNo: 16, natureOfActivity: 'Participation in Sports (IDSSA)/ IPA/APTI for Pharmacy', numberPlanned: 5, actualArranged: 6, deficiency: 0, numberOfBeneficiaries: 4, remarks: 'Cricket, Chess, Badminton'),
          CoCurricularActivityItem(srNo: 17, natureOfActivity: 'MOUs with Industry for Participation in Academic Development of the Department', numberPlanned: 10, actualArranged: 10, deficiency: 0, numberOfBeneficiaries: 302, remarks: 'AICTE IDEA Lab, Winjit, ESDS'),
          CoCurricularActivityItem(srNo: 18, natureOfActivity: 'Organizing Technical Quiz / Seminar / Paper Presentation /Project Competition event last /current* year', numberPlanned: 3, actualArranged: 3, deficiency: 0, numberOfBeneficiaries: 122, remarks: 'Technical Event Telekinesis 2026'),
          CoCurricularActivityItem(srNo: 19, natureOfActivity: 'Any Other', numberPlanned: 0, actualArranged: 0, deficiency: 0, numberOfBeneficiaries: 0, remarks: ''),
          CoCurricularActivityItem(srNo: 20, natureOfActivity: 'Social activities, like Blood donation camp/ tree plantation etc.', numberPlanned: 2, actualArranged: 2, deficiency: 0, numberOfBeneficiaries: 154, remarks: 'MMCL, Campus Cleanliness'),
          CoCurricularActivityItem(srNo: 21, natureOfActivity: 'Industry sponsored Final year projects of the students (Min 2)', numberPlanned: 8, actualArranged: 8, deficiency: 0, numberOfBeneficiaries: 40, remarks: 'Real time IoT & Web Applications'),
          CoCurricularActivityItem(srNo: 22, natureOfActivity: 'Application oriented Final year projects of the students (Min 2)', numberPlanned: 9, actualArranged: 9, deficiency: 0, numberOfBeneficiaries: 160, remarks: 'Novel student mobile apps'),
          CoCurricularActivityItem(srNo: 23, natureOfActivity: 'Study based Final year projects of the students', numberPlanned: 4, actualArranged: 3, deficiency: 1, numberOfBeneficiaries: 12, remarks: 'E-Learning Analytics'),
          CoCurricularActivityItem(srNo: 24, natureOfActivity: 'Vacation training organised for students (4 to 6 weeks per year)', numberPlanned: 12, actualArranged: 12, deficiency: 0, numberOfBeneficiaries: 219, remarks: 'Calibers Infotech, Sumago'),
          CoCurricularActivityItem(srNo: 25, natureOfActivity: 'Budget allocation and utilisation (Recurring, Non-recurring & Maintenance) for previous financial year (Rs Lakhs)', numberPlanned: 52, actualArranged: 52, deficiency: 0, numberOfBeneficiaries: 51, remarks: 'Demanded: 52L, Allocated: 52L, Utilised: 50.57L (97.5%)'),
          CoCurricularActivityItem(srNo: 26, natureOfActivity: 'For Pharmacy Only: Number of Field visits completed for applicable subjects as per PCI Norms', numberPlanned: 0, actualArranged: 0, deficiency: 0, numberOfBeneficiaries: 0, remarks: 'NA for Computer Technology'),
        ],
      );

  Map<String, dynamic> toJson() => {
        'activities': activities.map((a) => a.toJson()).toList(),
        'budgetDemanded': budgetDemanded,
        'budgetAllocated': budgetAllocated,
        'budgetUtilised': budgetUtilised,
      };

  factory CoCurricularSectionData.fromJson(Map<String, dynamic> json) =>
      CoCurricularSectionData(
        budgetDemanded: (json['budgetDemanded'] as num?)?.toDouble() ?? 52.0,
        budgetAllocated: (json['budgetAllocated'] as num?)?.toDouble() ?? 52.0,
        budgetUtilised: (json['budgetUtilised'] as num?)?.toDouble() ?? 50.57,
        activities: (json['activities'] as List<dynamic>?)
                ?.map((e) => CoCurricularActivityItem.fromJson(
                    e as Map<String, dynamic>))
                .toList() ??
            CoCurricularSectionData.defaultSample().activities,
      );
}

class AnyOtherSectionData {
  final String qualityOfTestPapers;
  final String ciaanRead;
  final String curriculumWellInterpreted;
  final String ciaanFormatsUsed;
  final String ciaanRecordsMaintained;
  final String additionalInformation;

  String get otherDetails => additionalInformation;

  const AnyOtherSectionData({
    this.qualityOfTestPapers = 'Appropriate coverage',
    this.ciaanRead = 'Yes',
    this.curriculumWellInterpreted = 'Yes',
    this.ciaanFormatsUsed = 'Yes',
    this.ciaanRecordsMaintained = 'Yes',
    String additionalInformation =
        '1. CSI Students Chapter at Department and Students are active members of Computer Society of India(CSI) Student Chapter.\n2. Conducted various technical activities like Expert Talks, Workshops, Hackathons, and Coding Competitions under CSI.\n3. Active collaboration with local industries for internship and technical mentoring.',
    String? otherDetails,
  }) : additionalInformation = otherDetails ?? additionalInformation;

  factory AnyOtherSectionData.defaultSample() => const AnyOtherSectionData();

  AnyOtherSectionData copyWith({
    String? qualityOfTestPapers,
    String? ciaanRead,
    String? curriculumWellInterpreted,
    String? ciaanFormatsUsed,
    String? ciaanRecordsMaintained,
    String? additionalInformation,
    String? otherDetails,
  }) =>
      AnyOtherSectionData(
        qualityOfTestPapers: qualityOfTestPapers ?? this.qualityOfTestPapers,
        ciaanRead: ciaanRead ?? this.ciaanRead,
        curriculumWellInterpreted:
            curriculumWellInterpreted ?? this.curriculumWellInterpreted,
        ciaanFormatsUsed: ciaanFormatsUsed ?? this.ciaanFormatsUsed,
        ciaanRecordsMaintained:
            ciaanRecordsMaintained ?? this.ciaanRecordsMaintained,
        additionalInformation: otherDetails ??
            additionalInformation ??
            this.additionalInformation,
      );

  Map<String, dynamic> toJson() => {
        'qualityOfTestPapers': qualityOfTestPapers,
        'ciaanRead': ciaanRead,
        'curriculumWellInterpreted': curriculumWellInterpreted,
        'ciaanFormatsUsed': ciaanFormatsUsed,
        'ciaanRecordsMaintained': ciaanRecordsMaintained,
        'additionalInformation': additionalInformation,
      };

  factory AnyOtherSectionData.fromJson(Map<String, dynamic> json) =>
      AnyOtherSectionData(
        qualityOfTestPapers: json['qualityOfTestPapers'] as String? ??
            'Appropriate coverage',
        ciaanRead: json['ciaanRead'] as String? ?? 'Yes',
        curriculumWellInterpreted:
            json['curriculumWellInterpreted'] as String? ?? 'Yes',
        ciaanFormatsUsed: json['ciaanFormatsUsed'] as String? ?? 'Yes',
        ciaanRecordsMaintained:
            json['ciaanRecordsMaintained'] as String? ?? 'Yes',
        additionalInformation: json['additionalInformation'] as String? ??
            json['otherDetails'] as String? ??
            '',
      );
}

class CmFullReportSections {
  final AdmissionSectionData admission;
  final FacultyStrengthSectionData facultyStrength;
  final FacultyProfileSectionData facultyProfile;
  final LaboratorySectionData laboratory;
  final CurriculumSectionData curriculum;
  final StudentAttendanceSectionData studentAttendance;
  final ResultAnalysisSectionData resultAnalysis;
  final ResourcesSectionData resources;
  final CoCurricularSectionData coCurricular;
  final AnyOtherSectionData anyOther;

  const CmFullReportSections({
    required this.admission,
    required this.facultyStrength,
    required this.facultyProfile,
    required this.laboratory,
    required this.curriculum,
    required this.studentAttendance,
    required this.resultAnalysis,
    required this.resources,
    required this.coCurricular,
    required this.anyOther,
  });

  factory CmFullReportSections.defaultSample() => CmFullReportSections(
        admission: AdmissionSectionData.defaultSample(),
        facultyStrength: FacultyStrengthSectionData.defaultSample(),
        facultyProfile: FacultyProfileSectionData.defaultSample(),
        laboratory: LaboratorySectionData.defaultSample(),
        curriculum: CurriculumSectionData.defaultSample(),
        studentAttendance: StudentAttendanceSectionData.defaultSample(),
        resultAnalysis: ResultAnalysisSectionData.defaultSample(),
        resources: ResourcesSectionData.defaultSample(),
        coCurricular: CoCurricularSectionData.defaultSample(),
        anyOther: AnyOtherSectionData.defaultSample(),
      );

  Map<String, dynamic> toJson() => {
        'admission': admission.toJson(),
        'facultyStrength': facultyStrength.toJson(),
        'facultyProfile': facultyProfile.toJson(),
        'laboratory': laboratory.toJson(),
        'curriculum': curriculum.toJson(),
        'studentAttendance': studentAttendance.toJson(),
        'resultAnalysis': resultAnalysis.toJson(),
        'resources': resources.toJson(),
        'coCurricular': coCurricular.toJson(),
        'anyOther': anyOther.toJson(),
      };

  factory CmFullReportSections.fromJson(Map<String, dynamic> json) =>
      CmFullReportSections(
        admission: json['admission'] != null
            ? AdmissionSectionData.fromJson(
                json['admission'] as Map<String, dynamic>)
            : AdmissionSectionData.defaultSample(),
        facultyStrength: json['facultyStrength'] != null
            ? FacultyStrengthSectionData.fromJson(
                json['facultyStrength'] as Map<String, dynamic>)
            : FacultyStrengthSectionData.defaultSample(),
        facultyProfile: json['facultyProfile'] != null
            ? FacultyProfileSectionData.fromJson(
                json['facultyProfile'] as Map<String, dynamic>)
            : FacultyProfileSectionData.defaultSample(),
        laboratory: json['laboratory'] != null
            ? LaboratorySectionData.fromJson(
                json['laboratory'] as Map<String, dynamic>)
            : LaboratorySectionData.defaultSample(),
        curriculum: json['curriculum'] != null
            ? CurriculumSectionData.fromJson(
                json['curriculum'] as Map<String, dynamic>)
            : CurriculumSectionData.defaultSample(),
        studentAttendance: json['studentAttendance'] != null
            ? StudentAttendanceSectionData.fromJson(
                json['studentAttendance'] as Map<String, dynamic>)
            : StudentAttendanceSectionData.defaultSample(),
        resultAnalysis: json['resultAnalysis'] != null
            ? ResultAnalysisSectionData.fromJson(
                json['resultAnalysis'] as Map<String, dynamic>)
            : ResultAnalysisSectionData.defaultSample(),
        resources: json['resources'] != null
            ? ResourcesSectionData.fromJson(
                json['resources'] as Map<String, dynamic>)
            : ResourcesSectionData.defaultSample(),
        coCurricular: json['coCurricular'] != null
            ? CoCurricularSectionData.fromJson(
                json['coCurricular'] as Map<String, dynamic>)
            : CoCurricularSectionData.defaultSample(),
        anyOther: json['anyOther'] != null
            ? AnyOtherSectionData.fromJson(
                json['anyOther'] as Map<String, dynamic>)
            : AnyOtherSectionData.defaultSample(),
      );
}
