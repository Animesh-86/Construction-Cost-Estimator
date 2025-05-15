import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EstimatorFormScreen extends StatefulWidget {
  final void Function(Map<String, dynamic>) onSave; // Add save callback

  const EstimatorFormScreen({super.key, required this.onSave});

  @override
  State<EstimatorFormScreen> createState() => _EstimatorFormScreenState();
}

class _EstimatorFormScreenState extends State<EstimatorFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final areaController = TextEditingController();
  final cementController = TextEditingController();
  final steelController = TextEditingController();
  final laborController = TextEditingController();

  int locationIndex = 0;
  double? predictedCost;

  @override
  void dispose() {
    areaController.dispose();
    cementController.dispose();
    steelController.dispose();
    laborController.dispose();
    super.dispose();
  }

  void estimateCost() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('http://10.0.2.2:5000/predict');

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'area': double.parse(areaController.text),
            'cement_kg': double.parse(cementController.text),
            'steel_kg': double.parse(steelController.text),
            'labor_hours': double.parse(laborController.text),
            'location_index': locationIndex,
          }),
        );

        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          setState(() {
            predictedCost = responseData['predicted_cost'];
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.reasonPhrase}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void saveData() {
    final data = {
      'area': areaController.text,
      'cement': cementController.text,
      'steel': steelController.text,
      'labor': laborController.text,
      'locationIndex': locationIndex,
      'predictedCost': predictedCost,
    };
    widget.onSave(data);
    Navigator.pop(context); // Return to home screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Construction Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: areaController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Area (sq.ft)',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) => value!.isEmpty ? 'Please enter area' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: cementController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Cement (kg)',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Please enter cement quantity' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: steelController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Steel (kg)',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Please enter steel quantity' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: laborController,
                keyboardType: TextInputType.number,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Labor Hours',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value!.isEmpty ? 'Please enter labor hours' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: locationIndex,
                items: const [
                  DropdownMenuItem(
                    value: 0,
                    child: Text('Rural', style: TextStyle(color: Colors.white)),
                  ),
                  DropdownMenuItem(
                    value: 1,
                    child: Text('Urban', style: TextStyle(color: Colors.white)),
                  ),
                  DropdownMenuItem(
                    value: 2,
                    child: Text('Metro', style: TextStyle(color: Colors.white)),
                  ),
                ],
                onChanged: (value) => setState(() => locationIndex = value!),
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: estimateCost,
                icon: const Icon(Icons.calculate),
                label: const Text(
                  "Estimate Cost",
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 80),
              if (predictedCost != null) ...[
                Text(
                  'Estimated Cost: ₹${predictedCost!.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: saveData,
                  icon: const Icon(Icons.save),
                  label: const Text(
                    "Save",
                    style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
