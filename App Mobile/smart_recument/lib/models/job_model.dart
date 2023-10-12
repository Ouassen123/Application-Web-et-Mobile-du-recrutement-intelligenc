class Job {
  String id;
  String title;
  String description;
  String company;
  // Add any other properties related to a job here

  Job({
    required this.id,
    required this.title,
    required this.description,
    required this.company,
    // Initialize other properties here
  });

  // You can also add factory constructors or other methods related to the Job class

  // Example factory constructor:
  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      company: json['company'],
      // Map other properties from JSON here
    );
  }
}
