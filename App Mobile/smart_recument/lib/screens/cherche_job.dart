import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChercheJobPage extends StatefulWidget {
  @override
  _ChercheJobPageState createState() => _ChercheJobPageState();
}

class _ChercheJobPageState extends State<ChercheJobPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  String _selectedStatus = 'All';
  List<JobListing> jobListings = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rechercher un emploi'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/hero_1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SizedBox(height: 20.0),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Job Title',
                      hintText: 'Enter job title',
                    ),
                  ),
                  TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      labelText: 'Job Location',
                      hintText: 'Enter job location',
                    ),
                  ),
                  DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    onChanged: (value) {
                      setState(() {
                        _selectedStatus = value!;
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: 'All',
                        child: Text('All'),
                      ),
                      DropdownMenuItem(
                        value: 'Part Time',
                        child: Text('Part Time'),
                      ),
                      DropdownMenuItem(
                        value: 'Full Time',
                        child: Text('Full Time'),
                      ),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Employment Status',
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _searchJobs();
                    },
                    child: Text('Rechercher'),
                  ),
                ],
              ),
            ),
            // Afficher la liste des offres d'emploi filtrées ici
            Column(
              children: jobListings.map((job) {
                return ListTile(
                  title: Text(job.title),
                  subtitle: Text(job.companyName),
                  // Vous pouvez afficher d'autres détails de l'offre d'emploi ici
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _searchJobs() async {
    String title = _titleController.text;
    String location = _locationController.text;
    String employmentStatus = _selectedStatus;

    try {
      final response = await http.get(Uri.parse(
        'http://127.0.0.1:8000/api/search-jobs/?title=$title&job_location=$location&employment_status=$employmentStatus',
      ));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          jobListings = data.map((item) => JobListing.fromJson(item)).toList();
        });
      } else {
        throw Exception('Failed to fetch search results from API');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

class JobListing {
  final String title;
  final String companyName;

  // Ajoutez d'autres propriétés d'offre d'emploi ici

  JobListing({
    required this.title,
    required this.companyName,
    // Initialisez les autres propriétés ici
  });

  factory JobListing.fromJson(Map<String, dynamic> json) {
    return JobListing(
      title: json['title'] ?? '',
      companyName: json['company_name'] ?? '',
      // Ajoutez le décodage des autres propriétés ici
    );
  }
}
