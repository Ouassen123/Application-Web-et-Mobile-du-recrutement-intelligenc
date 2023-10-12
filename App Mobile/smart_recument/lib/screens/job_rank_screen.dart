import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Candidate {
  final int rank;
  final String name;
  final double score;

  Candidate({required this.rank, required this.name, required this.score});
}

class JobRankScreen extends StatefulWidget {
  final int jobId;

  JobRankScreen({required this.jobId});

  @override
  _JobRankScreenState createState() => _JobRankScreenState();
}

class _JobRankScreenState extends State<JobRankScreen> {
  List<Candidate> candidates = [];

  // Méthode pour récupérer les informations des candidats depuis l'API
  Future<void> fetchCandidates() async {
    final url =
        'http://127.0.0.1:8000/api/job_rank/${widget.jobId}/'; // Remplacez par l'URL de votre API
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      candidates = List<Candidate>.from(jsonData.map((data) => Candidate(
            rank: data['rank'],
            name: data['name'],
            score: data['score'],
          )));
      setState(
          () {}); // Rafraîchir l'interface après la récupération des données
    } else {
      // Gérer les erreurs en cas de problème avec l'API
      print('Failed to load candidates');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCandidates(); // Appeler la méthode pour récupérer les candidats au chargement de l'écran
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shortlisted Candidates'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shortlisted Candidates:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            DataTable(
              columns: [
                DataColumn(label: Text('Rank')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Score (KNN distance)')),
              ],
              rows: candidates
                  .map(
                    (candidate) => DataRow(cells: [
                      DataCell(Text(candidate.rank.toString())),
                      DataCell(Text(candidate.name)),
                      DataCell(Text(candidate.score.toString())),
                    ]),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
