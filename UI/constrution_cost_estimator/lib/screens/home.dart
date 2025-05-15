import 'package:constrution_cost_estimator/screens/estimation.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // List to store saved estimation data
  final List<Map<String, dynamic>> savedItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estimations'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 108, 23, 17),
              Color.fromARGB(255, 176, 66, 20),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: savedItems.isEmpty
            ? const Center(
                child: Text(
                  'No estimations yet.',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: savedItems.length,
                itemBuilder: (context, index) {
                  final item = savedItems[index];
                  return Card(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.9),
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text('Estimated Cost: ₹${item['predictedCost'].toStringAsFixed(2)}'),
                      subtitle: Text(
                        'Area: ${item['area']} sqft, Cement: ${item['cement']}kg, Steel: ${item['steel']}kg, Labor: ${item['labor']} hrs, Location: ${['Rural', 'Urban', 'Metro'][item['locationIndex']]}',
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EstimatorFormScreen(
                onSave: (data) {
                  setState(() {
                    savedItems.add(data); // Save the entry
                  });
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
