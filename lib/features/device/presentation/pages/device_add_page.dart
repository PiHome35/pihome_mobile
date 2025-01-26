import 'package:flutter/material.dart';

class DeviceAddPage extends StatelessWidget {
  const DeviceAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Device'),
      ),
      body: const Center(
        child: Text('Add Device'),
      ),
    );
  }
}
