import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
            top: 40,
            left: 16,
            right: 16,
            bottom: 16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'VerbiSense',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),

        // Upload Section
        ListTile(
          leading: const Icon(Icons.upload),
          title: const Text('Upload'),
          onTap: () {
            // Handle upload action
          },
        ),

        // Documents Section
        ListTile(
          leading: const Icon(Icons.document_scanner),
          title: const Text('Documents'),
          onTap: () {
            // Handle documents action
          },
        ),

        // Uploaded Documents Section
        Container(
          padding: const EdgeInsets.all(16.0),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Uploaded Documents(Max.3MB)',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              Text('No Files Uploaded'),
            ],
          ),
        ),

        const Spacer(),

        // History Section
        Container(
          padding: const EdgeInsets.all(16.0),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'History',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
              Text(
                'Today',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                leading: Icon(Icons.calendar_today),
                title: Text('14th Nov - Generating Random Numbers'),
                dense: true,
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                leading: Icon(Icons.calendar_today),
                title: Text('13th Nov - Greeting'),
                dense: true,
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                leading: Icon(Icons.calendar_today),
                title: Text('13th Nov - Greeting'),
                dense: true,
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                leading: Icon(Icons.calendar_today),
                title: Text('13th Nov - Greeting'),
                dense: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
