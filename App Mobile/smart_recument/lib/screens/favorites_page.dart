import 'package:flutter/material.dart';
import 'package:smart_recument/screens/home_screen.dart'; // Importez la classe JobListing ici
import 'package:smart_recument/screens/job_detail_screen.dart';

class FavoritesPage extends StatefulWidget {
  final List<JobListing> favoriteJobListings;

  FavoritesPage({required this.favoriteJobListings});

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Jobs'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/hero_1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: widget.favoriteJobListings.length,
          itemBuilder: (context, index) {
            return _buildAnimatedJobListingItem(
                context, widget.favoriteJobListings[index], index);
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedJobListingItem(
      BuildContext context, JobListing job, int index) {
    final Animation<double> animation =
        Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.1 * index, 1.0, curve: Curves.easeInOut),
    ));

    return FadeTransition(
      opacity: animation,
      child: _buildJobListingItem(context, job),
    );
  }

  Widget _buildJobListingItem(BuildContext context, JobListing job) {
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
                  // Add your favorite logic here
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
}
