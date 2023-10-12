import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_recument/models/post_job_model.dart';
import 'package:smart_recument/models/apply_job_model.dart';

class JobService {
  static const String baseUrl =
      'http://127.0.0.1:8000'; // Replace this with your API URL

  // Function to fetch a list of jobs from the API
  static Future<List<PostJob>> fetchJobs() async {
    final response = await http.get(Uri.parse('$baseUrl/jobs'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return jsonResponse.map((jobData) => PostJob.fromJson(jobData)).toList();
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  // Function to fetch job details for a specific job ID
  static Future<PostJob> fetchJobDetails(String jobId) async {
    final response = await http.get(Uri.parse('$baseUrl/jobs/$jobId'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return PostJob.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load job details');
    }
  }

  // Function to submit a job application to the API
  static Future<void> submitJobApplication(ApplyJob applyJob) async {
    // Here, you should implement the logic to send the applyJob data to your API endpoint
    // and handle the response accordingly.
    // This could involve making a POST request to your backend server to save the job application data.

    // For example:
    // final Map<String, dynamic> requestData = {
    //   'id': applyJob.id,
    //   'title': applyJob.title,
    //   'companyName': applyJob.companyName,
    //   'employmentStatus': applyJob.employmentStatus.toString().split('.').last,
    //   'vacancy': applyJob.vacancy,
    //   'gender': applyJob.gender.toString().split('.').last,
    //   'details': applyJob.details,
    //   'responsibilities': applyJob.responsibilities,
    //   'experience': applyJob.experience,
    //   'otherBenefits': applyJob.otherBenefits,
    //   'jobLocation': applyJob.jobLocation,
    //   'salary': applyJob.salary,
    //   'applicationDeadline': applyJob.applicationDeadline?.toIso8601String(),
    // };
    // final response = await http.post(Uri.parse('$baseUrl/apply-job'), body: requestData);

    // If your API returns a success status (e.g., 200), you can consider the application submitted.
    // Otherwise, handle the failure case and show an error message to the user.

    // For demonstration purposes, we will simply print the applyJob details.
    print('Job Application Details:');
    print('Name: ${applyJob.name}');
    print('Email: ${applyJob.email}');
    print('Gender: ${applyJob.gender}');
    print('Experience: ${applyJob.experience}');
    print('CV: ${applyJob.cv}');
    print('Cover Letter: ${applyJob.coverLetter}');
    print('Company Name: ${applyJob.companyName}');
    print('Title: ${applyJob.title}');
  }
}
