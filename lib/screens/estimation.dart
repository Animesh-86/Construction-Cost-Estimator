import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EstimatorFormScreen extends StatefulWidget {
  const EstimatorFormScreen({super.key});

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
  bool isLoading = false;

  @override
  void dispose() {
    areaController.dispose();
    cementController.dispose();
    steelController.dispose();
    laborController.dispose();
    super.dispose();
  }

  Future<void> estimateCost() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      predictedCost = null;
    });

    final url = Uri.parse("https://render-construction.onrender.com"); // Use correct URL

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
          predictedCost = responseData['predicted_cost']?.toDouble() ?? 0;
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
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void saveData() {
    if (predictedCost == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please estimate cost before saving')),
      );
      return;
    }

    final data = {
      'area': areaController.text,
      'cement': cementController.text,
      'steel': steelController.text,
      'labor': laborController.text,
      'locationIndex': locationIndex,
      'predictedCost': predictedCost,
    };

    Navigator.pop(context, data); // Return data to previous screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Construction Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: areaController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Area (sq.ft)',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'Please enter area'
                            : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: cementController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Cement (kg)',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'Please enter cement quantity'
                            : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: steelController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Steel (kg)',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'Please enter steel quantity'
                            : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: laborController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Labor Hours',
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'Please enter labor hours'
                            : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: locationIndex,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
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
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      locationIndex = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: isLoading ? null : estimateCost,
                icon:
                    isLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Icons.calculate),
                label: const Text("Estimate Cost"),
              ),
              const SizedBox(height: 30),
              if (predictedCost != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estimated Cost: ₹${predictedCost!.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: saveData,
                      icon: const Icon(Icons.save),
                      label: const Text("Save"),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
