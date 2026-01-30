import 'package:flutter/material.dart';
import '../services/traffic_service.dart';

class SimulationPage extends StatefulWidget {
  const SimulationPage({super.key});

  @override
  State<SimulationPage> createState() => _SimulationPageState();
}

class _SimulationPageState extends State<SimulationPage> {
  bool busy = false;

  Future<void> _step() async {
    setState(() => busy = true);
    try {
      final ok = await TrafficService.triggerLoopStep();
      if (ok) {
        if (mounted)
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Loop step executed')));
      } else {
        if (mounted)
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Loop step returned no success flag')),
          );
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Loop step error: $e')));
    } finally {
      setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simulation')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: busy ? null : _step,
              icon: const Icon(Icons.loop),
              label: const Text('Run Single Loop Step'),
            ),
            const SizedBox(height: 12),
            const Text(
              'For continuous automatic loop run `php loop_engine.php --daemon` on server (recommended).',
            ),
          ],
        ),
      ),
    );
  }
}
