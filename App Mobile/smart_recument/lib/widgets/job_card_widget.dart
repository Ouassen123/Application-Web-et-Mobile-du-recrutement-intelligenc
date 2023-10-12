import 'package:flutter/material.dart';
import 'package:smart_recument/models/post_job_model.dart';

class JobCardWidget extends StatelessWidget {
  final PostJob postJob;
  final VoidCallback onTap;

  JobCardWidget({required this.postJob, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(postJob.title),
        subtitle: Text(postJob.companyName),
        onTap: onTap,
      ),
    );
  }
}
