import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_recument/screens/job_apply_screen.dart';
import 'package:smart_recument/screens/job_rank_screen.dart';

class JobDetailScreen extends StatelessWidget {
  final String imageUrl; // L'URL de l'image qui vient du dossier lib/assets/
  final String title;
  final String companyName;
  final String employmentStatus;
  final String vacancy;
  final String gender;
  final String details;
  final String responsibilities;
  final String experience;
  final String otherBenefits;
  final String jobLocation;
  final String salary;
  final String applicationDeadline;
  final int jobId; // Ajout de l'ID de l'emploi
  static const String jobSingleImageUrl = 'lib/assets/job_single_img_1.jpg';

  JobDetailScreen({
    required this.imageUrl,
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
    required this.applicationDeadline,
    required this.jobId, // Initialisez l'ID de l'emploi ici
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              SizedBox(height: 20),
              // Add the image here
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(jobSingleImageUrl),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Color(0xF8F9FA), // Set the background color to #F8F9FA
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Job Summary',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Published on: April 14, 2019',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      Text(
                        'Vacancy: $vacancy',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      Text(
                        'Employment Status: $employmentStatus',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      Text(
                        'Experience: $experience',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      Text(
                        'Job Location: $jobLocation',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      Text(
                        'Salary: $salary',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      Text(
                        'Gender: $gender',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                      Text(
                        'Application Deadline: $applicationDeadline',
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),

              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Share',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.facebook,
                          size: 30,
                          color: Colors.blue,
                        ),
                        SvgPicture.asset(
                          'assets/twitter_icon.gif',
                          height: 30,
                          width: 30,
                          color: Colors.lightBlue,
                        ),
                        SvgPicture.asset(
                          'assets/linkedin_icon.svg',
                          height: 30,
                          width: 30,
                          color: Colors.blueAccent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobRankScreen(
                          jobId:
                              jobId), // Passer l'ID de l'emploi à JobRankScreen
                    ),
                  );
                },
                child: Text("See Rank"),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobApplyScreen(
                        company: companyName,
                        title: title,
                      ),
                    ),
                  );
                },
                child: Text("Apply Now"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
