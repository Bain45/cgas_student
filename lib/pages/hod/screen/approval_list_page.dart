import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApprovalListPage extends StatefulWidget {
  const ApprovalListPage({Key? key}) : super(key: key);

  @override
  _ApprovalListPageState createState() => _ApprovalListPageState();
}

class _ApprovalListPageState extends State<ApprovalListPage> {
  List<Map<String, dynamic>> approvedRequests = [];
  final User? user = FirebaseAuth.instance.currentUser;
  
  String? get id => null;

  @override
  void initState() {
    super.initState();
    _fetchApprovedRequests();
  }

  Future<void> _fetchApprovedRequests() async {
    if (user == null) {
      print("User not logged in!");
      return;
    }

    try {
      // Get the HOD's department ID
      final hodDoc = await FirebaseFirestore.instance
          .collection('hod')
          .doc(id) // Assuming the HOD document is saved using UID
          .get();

      if (!hodDoc.exists) {
        print("HOD document does not exist.");
        return;
      }

      String departmentId = hodDoc.data()?['departmentId'];

      // Fetching Inpass Requests with status 0 from the same department
      final inpassSnapshot = await FirebaseFirestore.instance
          .collection('inpass')
          .where('departmentId', isEqualTo: departmentId)
          .where('status', isEqualTo: 0)
          .get();

      for (var doc in inpassSnapshot.docs) {
        final data = doc.data();
        approvedRequests.add({
          'type': 'inpass',
          'data': data,
          'id': doc.id,
        });
      }

      // Fetching Outpass Requests with status 0 from the same department
      final outpassSnapshot = await FirebaseFirestore.instance
          .collection('outpass')
          .where('departmentId', isEqualTo: departmentId)
          .where('status', isEqualTo: 0)
          .get();

      for (var doc in outpassSnapshot.docs) {
        final data = doc.data();
        approvedRequests.add({
          'type': 'outpass',
          'data': data,
          'id': doc.id,
        });
      }

      // Refresh UI
      setState(() {});
    } catch (e) {
      print("Error fetching approved requests: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pending GatePass Requests'),
        backgroundColor: const Color.fromARGB(255, 3, 21, 41),
      ),
      body: approvedRequests.isEmpty
          ? const Center(child: Text('No pending requests found.'))
          : ListView.builder(
              itemCount: approvedRequests.length,
              itemBuilder: (context, index) {
                final request = approvedRequests[index];
                final requestData = request['data'];

                return Card(
                  color: const Color.fromARGB(255, 149, 218, 239),
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      '${request['type'] == 'inpass' ? 'Inpass' : 'Outpass'} Request',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Reason: ${requestData['reason']}\nDate: ${requestData['date']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.check),
                      onPressed: () {
                        _approveRequest(request['id'], request['type']);
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _approveRequest(String requestId, String requestType) async {
    try {
      // Update the status of the request to approved (1)
      await FirebaseFirestore.instance
          .collection(requestType) // Use 'inpass' or 'outpass'
          .doc(requestId)
          .update({'status': 1});

      // Refresh the list of requests
      setState(() {
        approvedRequests.removeWhere((req) => req['id'] == requestId);
      });

      // Optionally show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request approved successfully!')),
      );
    } catch (e) {
      print("Error approving request: $e");
    }
  }
}
