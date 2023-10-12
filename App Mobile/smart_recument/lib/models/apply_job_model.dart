// models/apply_job_model.dart

enum CandidateGender {
  Male,
  Female,
}

class ApplyJob {
  String name;
  String email;
  CandidateGender gender;
  double experience;
  String cv;
  String coverLetter;
  String companyName;
  String title;

  ApplyJob({
    required this.name,
    required this.email,
    required this.gender,
    required this.experience,
    required this.cv,
    required this.coverLetter,
    required this.companyName,
    required this.title,
  });

  @override
  String toString() {
    return name;
  }
}
