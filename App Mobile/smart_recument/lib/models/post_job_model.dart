enum JobType {
  PartTime,
  FullTime,
  Freelance,
}

enum Gender {
  Male,
  Female,
  Both,
}

class PostJob {
  String id; // Add the id property
  String title;
  String companyName;
  JobType employmentStatus;
  String vacancy;
  Gender gender;
  String details;
  String responsibilities;
  String experience;
  String otherBenefits;
  String jobLocation;
  String salary;
  DateTime? applicationDeadline;

  PostJob({
    required this.id, // Update the constructor to include id
    required this.title,
    required this.companyName,
    required this.employmentStatus,
    required this.vacancy,
    required this.gender,
    required this.details,
    required this.responsibilities,
    required this.experience,
    required this.otherBenefits,
    required this.jobLocation,
    required this.salary,
    this.applicationDeadline,
  });

  // Add a factory method to deserialize the JSON data
  factory PostJob.fromJson(Map<String, dynamic> json) {
    return PostJob(
      id: json['id'],
      title: json['title'],
      companyName: json['companyName'],
      employmentStatus: _parseJobType(json['employmentStatus']),
      vacancy: json['vacancy'],
      gender: _parseGender(json['gender']),
      details: json['details'],
      responsibilities: json['responsibilities'],
      experience: json['experience'],
      otherBenefits: json['otherBenefits'],
      jobLocation: json['jobLocation'],
      salary: json['salary'],
      applicationDeadline: DateTime.tryParse(json['applicationDeadline']),
    );
  }

  static JobType _parseJobType(String value) {
    switch (value) {
      case 'PartTime':
        return JobType.PartTime;
      case 'FullTime':
        return JobType.FullTime;
      case 'Freelance':
        return JobType.Freelance;
      default:
        return JobType.PartTime;
    }
  }

  static Gender _parseGender(String value) {
    switch (value) {
      case 'Male':
        return Gender.Male;
      case 'Female':
        return Gender.Female;
      case 'Both':
        return Gender.Both;
      default:
        return Gender.Both;
    }
  }

  @override
  String toString() {
    return title;
  }
}
