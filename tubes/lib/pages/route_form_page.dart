import 'package:flutter/material.dart';

class RouteFormPage extends StatefulWidget {
  const RouteFormPage({super.key});

  @override
  State<RouteFormPage> createState() => _RouteFormPageState();
}

class _RouteFormPageState extends State<RouteFormPage> {
  final fromController = TextEditingController();
  final toController = TextEditingController();

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    super.dispose();
  }

  void submit() {
    final from = fromController.text;
    final to = toController.text;

    if (from.isEmpty || to.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Isi From dan Destination")));
      return;
    }

    // sementara: tampilkan hasil
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Route Info"),
        content: Text("From: $from\nTo: $to"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Route Planner")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: fromController,
              decoration: const InputDecoration(
                labelText: "From",
                prefixIcon: Icon(Icons.location_pin),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: toController,
              decoration: const InputDecoration(
                labelText: "Destination",
                prefixIcon: Icon(Icons.flag),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: submit,
              icon: const Icon(Icons.alt_route),
              label: const Text("Search Route"),
            ),
          ],
        ),
      ),
    );
  }
}
