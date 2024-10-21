import 'package:flutter/material.dart';

class HodHomePage extends StatefulWidget {
  const HodHomePage({super.key});

  @override
  _HodHomePageState createState() => _HodHomePageState();
}

class _HodHomePageState extends State<HodHomePage> {
  int _currentIndex = 0;

  // Sample data for approved students by faculty (replace with actual data source)
  List<Map<String, String>> approvedStudents = [
    {"name": "John Doe", "id": "123", "status": "Pending"},
    {"name": "Jane Smith", "id": "456", "status": "Pending"},
    {"name": "David Williams", "id": "789", "status": "Pending"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HOD Homepage"),
      ),
      body: _currentIndex == 0 ? _approvedStudentList() : _pastRecords(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.approval),
            label: 'Approval List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Past Records',
          ),
        ],
      ),
    );
  }

  Widget _approvedStudentList() {
    return ListView.builder(
      itemCount: approvedStudents.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            title: Text(approvedStudents[index]["name"]!),
            subtitle: Text("ID: ${approvedStudents[index]["id"]}"),
            trailing: ElevatedButton(
              onPressed: () {
                _approvePass(index);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: approvedStudents[index]["status"] == "Approved"
                    ? Colors.green
                    : Colors.blue,
              ),
              child: Text(approvedStudents[index]["status"] == "Approved"
                  ? "Approved"
                  : "Approve"),
            ),
          ),
        );
      },
    );
  }

  // Approve the pass
  void _approvePass(int index) {
    setState(() {
      approvedStudents[index]["status"] = "Approved";
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          "Pass for ${approvedStudents[index]["name"]} (ID: ${approvedStudents[index]["id"]}) approved by HOD"),
    ));
  }

  Widget _pastRecords() {
    // Sample past records (replace with actual data)
    List<String> pastRecords = ["Record 1", "Record 2", "Record 3"];
    
    return ListView.builder(
      itemCount: pastRecords.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.all(10),
          child: ListTile(
            title: Text(pastRecords[index]),
          ),
        );
      },
    );
  }
}
