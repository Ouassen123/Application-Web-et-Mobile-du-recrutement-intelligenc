import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_recument/NavBar.dart';
import 'package:smart_recument/screens/job_detail_screen.dart';
import 'dart:async';
import 'package:smart_recument/screens/favorites_page.dart';
import 'dart:ui';

// Début de la classe HomeScreen
class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> arguments;

  HomeScreen({required this.arguments});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String candidates = '0';
  String jobPosted = '0';
  String jobsFilled = '0';
  String companies = '0';
  List<JobListing> jobListings = [];
  List<JobListing> favoriteJobListings = [];
  bool isSearchDialogVisible = false;

  TextEditingController _titleController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  String _selectedStatus = 'Part Time';

  void _openFavoritesPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            FavoritesPage(favoriteJobListings: favoriteJobListings),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchSiteStats();
    fetchData();
  }

  Future<void> fetchSiteStats() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:8000/api/site_stats/'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          candidates = data['total_users'].toString();
          jobPosted = data['total_jobs'].toString();
          jobsFilled = '40';
          companies = data['total_companies'].toString();
        });
      } else {
        throw Exception('Failed to fetch site stats from API');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchData() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:8000/api/job_list/'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          jobListings = data.map((item) => JobListing.fromJson(item)).toList();
        });
      } else {
        throw Exception('Failed to fetch data from API');
      }
    } catch (e) {
      print('Error: $e');
    }
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

        // Afficher la boîte de dialogue uniquement si elle n'est pas visible
        if (!isSearchDialogVisible) {
          _showSearchDialog();
          isSearchDialogVisible = true;
        }
      } else {
        throw Exception('Failed to fetch search results from API');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: AlertDialog(
            title: Text('Search Job'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Job Title',
                  ),
                ),
                TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    labelText: 'Job Location',
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
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  _searchJobs();
                  Navigator.pop(context);
                },
                child: Text('Search'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          title,
          style: TextStyle(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteJobListings(List<JobListing> favoriteJobListings) {
    return Container(
      padding: EdgeInsets.all(16.0),
      color: Colors.lightBlue.withOpacity(0.2),
      child: Column(
        children: [
          Text(
            'Favorite Job Listings',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.0),
          ListView.builder(
            shrinkWrap: true,
            itemCount: favoriteJobListings.length,
            itemBuilder: (context, index) {
              return _buildJobListingItem(favoriteJobListings[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildJobListingItem(JobListing job) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobDetailScreen(
              imageUrl: job.imageUrl,
              title: job.title,
              companyName: job.companyName,
              employmentStatus: job.employmentStatus,
              vacancy: job.vacancy,
              gender: job.gender,
              details: job.details,
              responsibilities: job.responsibilities,
              experience: job.experience,
              otherBenefits: job.otherBenefits,
              jobLocation: job.jobLocation,
              salary: job.salary,
              applicationDeadline: job.applicationDeadline,
              jobId: job.id,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        elevation: 2.0,
        padding: EdgeInsets.all(16.0),
        primary: Colors.white,
        onPrimary: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              // Use the AssetImage to load the local image
              Image.asset(
                'lib/assets/job_logo_1.jpg',
                width: 80.0,
                height: 80.0,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 16.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(job.companyName),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  job.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: job.isFavorite ? Colors.red : null,
                ),
                onPressed: () {
                  setState(() {
                    job.isFavorite = !job.isFavorite;
                    if (job.isFavorite) {
                      favoriteJobListings.add(job);
                    } else {
                      favoriteJobListings.remove(job);
                    }
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 16.0),
          Text(job.jobLocation),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(job.employmentStatus),
              Text(job.salary),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String username = widget.arguments['username'];
    final String email = widget.arguments['email'];

    return Scaffold(
      appBar: AppBar(
        title: Text('JobBoard'),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _openDrawer();
            },
          ),
        ],
      ),
      drawer: NavBar(
        username: username,
        email: email,
        favoriteJobListings: favoriteJobListings,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/hero_1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(height: 50.0),
                  Text(
                    'A Powerful Career Website',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Find your dream jobs in our powerful career website',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24.0),
                  ElevatedButton(
                    onPressed: () {
                      _showSearchDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF89BA16),
                    ),
                    child: Text(
                      'Search Job',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Color(0xFF89BA16),
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'JobBoard Site Stats',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Set text color to white
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('Candidates', candidates),
                      _buildStatItem('Job Posted', jobPosted),
                      _buildStatItem('Jobs Filled', jobsFilled),
                      _buildStatItem('Companies', companies),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              color: Colors.lightBlue.withOpacity(0.2),
              child: Column(
                children: [
                  Text(
                    '${jobListings.length} Job Listed',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: jobListings.length,
                    itemBuilder: (context, index) {
                      return _buildJobListingItem(jobListings[index]);
                    },
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'Looking For A Job?',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF89BA16),
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 24.0),
              child: Carousel(
                images: [
                  'lib/assets/person_transparent_2.png',
                  'lib/assets/person_transparent.png',
                ],
                quotes: [
                  "“Soluta quasi cum delectus eum facilis...” - Corey Woods, @Dribbble",
                  "“Soluta quasi cum delectus eum facilis...” - Chris Peters, @Google",
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDrawer() {
    Scaffold.of(context).openEndDrawer();
  }
}

class Carousel extends StatefulWidget {
  final List<String> images;
  final List<String> quotes;

  Carousel({required this.images, required this.quotes});

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Image.asset(
            widget.images[currentIndex],
            height: 200.0,
            width: 200.0,
          ),
          SizedBox(height: 16.0),
          Text(
            widget.quotes[currentIndex],
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.images.length, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    currentIndex = index;
                  });
                },
                child: Container(
                  margin: EdgeInsets.all(4.0),
                  width: 12.0,
                  height: 12.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentIndex == index ? Colors.black : Colors.grey,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class JobListing {
  final int id;
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
  final dynamic user;
  final String imageUrl;
  bool isFavorite;

  JobListing({
    required this.id,
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
    required this.user,
    required this.imageUrl,
    required this.isFavorite,
  });

  factory JobListing.fromJson(Map<String, dynamic> json) {
    return JobListing(
      id: json['id'],
      title: json['title'] ?? '',
      companyName: json['company_name'] ?? '',
      employmentStatus: json['employment_status'] ?? '',
      vacancy: json['vacancy'] ?? '',
      gender: json['gender'] ?? '',
      details: json['details'] ?? '',
      responsibilities: json['responsibilities'] ?? '',
      experience: json['experience'] ?? '',
      otherBenefits: json['other_benefits'] ?? '',
      jobLocation: json['job_location'] ?? '',
      salary: json['salary'] ?? '',
      applicationDeadline: json['application_deadline'] ?? '',
      user: json['user'],
      imageUrl: json['imageUrl'] ?? '',
      isFavorite: false,
    );
  }
}
