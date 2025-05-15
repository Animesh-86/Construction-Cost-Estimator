import 'package:constrution_cost_estimator/screens/estimation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> entries = [];

  void openEstimatorForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EstimatorFormScreen()),
    );

    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        entries.add(result);
      });
    }
  }

  void deleteEntry(int index) {
    final removedEntry = entries[index];
    setState(() {
      entries.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Entry deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            setState(() {
              entries.insert(index, removedEntry);
            });
          },
        ),
      ),
    );
  }

  Widget buildEntryCard(Map<String, dynamic> entry, int index) {
    return Dismissible(
      key: Key(entry.hashCode.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => deleteEntry(index),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: ListTile(
          title: Text(
            'Estimated Cost: ₹${(entry['predictedCost'] ?? 0).toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
              'Area: ${entry['area']} sq.ft, Cement: ${entry['cement']} kg, Steel: ${entry['steel']} kg, Labor: ${entry['labor']} hrs\nLocation: ${locationLabel(entry['locationIndex'])}'),
          isThreeLine: true,
          trailing: const Icon(Icons.swipe),
        ),
      ),
    );
  }

  String locationLabel(int index) {
    switch (index) {
      case 0:
        return 'Rural';
      case 1:
        return 'Urban';
      case 2:
        return 'Metro';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Construction Cost Estimator'),
      ),
      body: entries.isEmpty
          ? const Center(
              child: Text(
                'No saved entries yet.\nTap + to add new estimation.', 
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey), 
              ),
            )
          : ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) =>
                  buildEntryCard(entries[index], index),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: openEstimatorForm,
        tooltip: 'Add New Estimation',
        child: const Icon(Icons.add),
      ),
    );
  }
}
