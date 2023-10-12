import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_recument/screens/home_screen.dart';

class PostJobScreen extends StatefulWidget {
  @override
  _PostJobScreenState createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _vacancyController = TextEditingController();
  final _genderController = TextEditingController();
  final _jobDescriptionController = TextEditingController();
  final _jobResponsibilitiesController = TextEditingController();
  final _experienceController = TextEditingController();
  final _otherBenefitsController = TextEditingController();
  final _jobLocationController = TextEditingController();
  final _salaryController = TextEditingController();
  final _applicationDeadlineController = TextEditingController();
  late String username;
  late String email;

  String _selectedJobType = 'Part Time';
  String _selectedGender = 'Male';

  void _postJob() async {
    if (_formKey.currentState?.validate() ?? false) {
      final url = 'http://127.0.0.1:8000/post_job_api/';
      final headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      final body = {
        'title': _titleController.text,
        'company_name': _companyNameController.text,
        'employment_status': _selectedJobType,
        'vacancy': _vacancyController.text,
        'gender': _selectedGender,
        'details': _jobDescriptionController.text,
        'responsibilities': _jobResponsibilitiesController.text,
        'experience': _experienceController.text,
        'other_benefits': _otherBenefitsController.text,
        'job_location': _jobLocationController.text,
        'salary': _salaryController.text,
        'application_deadline': DateFormat('yyyy-MM-dd')
            .format(DateTime.parse(_applicationDeadlineController.text)),
      };

      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Job posted successfully');

        // Show a success notification
        Fluttertoast.showToast(
          msg: 'Job successfully posted!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        // Use the extracted context to navigate
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              arguments: {
                'username': username,
                'email': email,
              },
            ),
          ),
          (route) => false,
        );
      } else {
        print('Job posting failed');
        // Show an error notification
        Fluttertoast.showToast(
          msg: 'Job posting failed. Please try again later.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  DateTime? _selectedDate; // Variable to store the selected date

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1997),
      lastDate: DateTime(2030, 12, 31),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _applicationDeadlineController.text =
            DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post a Job'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Job Title'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a job title';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _companyNameController,
                decoration: InputDecoration(labelText: 'Company Name'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter a company name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _vacancyController,
                decoration: InputDecoration(labelText: 'Vacancy'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter the number of vacancies';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
                items: <String>['Male', 'Female', 'Both'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Gender'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the gender requirement';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _jobDescriptionController,
                decoration: InputDecoration(labelText: 'Job Description'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter the job description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _jobResponsibilitiesController,
                decoration: InputDecoration(labelText: 'Job Responsibilities'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter the job responsibilities';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _experienceController,
                decoration: InputDecoration(labelText: 'Experience'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter the required experience';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _otherBenefitsController,
                decoration: InputDecoration(labelText: 'Other Benefits'),
                validator: (value) {
                  // Optional field, so no validation needed.
                  return null;
                },
              ),
              TextFormField(
                controller: _jobLocationController,
                decoration: InputDecoration(labelText: 'Job Location'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter the job location';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _salaryController,
                decoration: InputDecoration(labelText: 'Salary'),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Please enter the salary';
                  }
                  return null;
                },
              ),
              // Job Type Dropdown
              DropdownButtonFormField<String>(
                value: _selectedJobType,
                onChanged: (value) {
                  setState(() {
                    _selectedJobType = value!;
                  });
                },
                items: <String>['Part Time', 'Full Time'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: InputDecoration(labelText: 'Job Type'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a job type';
                  }
                  return null;
                },
              ),
              // Application Deadline Date Picker
              TextFormField(
                controller: _applicationDeadlineController,
                onTap: () => _selectDate(
                    context), // Show date picker when field is tapped
                decoration: InputDecoration(labelText: 'Application Deadline'),
                validator: (value) {
                  if (_selectedDate == null) {
                    return 'Please select the application deadline';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _postJob,
                child: Text('Post Job'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
