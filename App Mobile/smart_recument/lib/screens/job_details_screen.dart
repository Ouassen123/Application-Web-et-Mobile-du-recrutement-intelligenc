import 'package:flutter/material.dart';
import 'package:smart_recument/models/post_job_model.dart';
import 'package:smart_recument/services/job_service.dart';

class JobDetailsScreen extends StatefulWidget {
  final String jobId;

  JobDetailsScreen({required this.jobId});

  @override
  _JobDetailsScreenState createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  PostJob? job;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      PostJob jobDetails = await JobService.fetchJobDetails(widget.jobId);
      setState(() {
        job = jobDetails;
      });
    } catch (e) {
      // Handle error if the API request fails
      print('Error fetching job details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: job != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Title: ${job!.title}'),
                  Text('Company: ${job!.companyName}'),
                  Text(
                      'Employment Status: ${job!.employmentStatus.toString().split('.').last}'),
                  Text('Vacancy: ${job!.vacancy}'),
                  Text('Gender: ${job!.gender.toString().split('.').last}'),
                  Text('Details: ${job!.details}'),
                  Text('Responsibilities: ${job!.responsibilities}'),
                  Text('Experience: ${job!.experience}'),
                  Text('Other Benefits: ${job!.otherBenefits}'),
                  Text('Job Location: ${job!.jobLocation}'),
                  Text('Salary: ${job!.salary}'),
                  if (job!.applicationDeadline != null)
                    Text('Application Deadline: ${job!.applicationDeadline!}'),
                  // Add other details based on the PostJob model
                ],
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
