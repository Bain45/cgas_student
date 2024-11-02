import 'package:cgas_official/pages/student/screen/qr_code.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  String name = 'Loading...';
  String image = '';

  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    if (user == null) {
      print("User is not logged in.");
      return;
    }
    final userId = user!.uid;
    final firestore = FirebaseFirestore.instance;

    try {
      DocumentSnapshot studentDoc = await firestore.collection('students').doc(userId).get();

      if (studentDoc.exists) {
        final data = studentDoc.data() as Map<String, dynamic>?;

        if (data != null) {
          setState(() {
            name = data['name'] ?? "No Name Available";
            image = data['imageUrl'] ?? "";
          });
        }
      } else {
        print("No document found for this user.");
      }
    } catch (e) {
      print("Error Fetching Data: $e");
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String getStatusText(int status) {
    switch (status) {
      case 0:
        return 'Pending';
      case 1:
        return 'Approved by Teacher';
      case 2:
        return 'Rejected by Teacher';
      case 3:
        return 'Approved by HOD';
      case 4:
        return 'Rejected by HOD';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 3, 21, 41),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          _buildProfileHeader(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              childAspectRatio: 1.1,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildCard(context, Icons.arrow_circle_down, 'INPASS', '/inpass'),
                _buildCard(context, Icons.arrow_circle_up, 'OUTPASS', '/outpass'),
              ],
            ),
          ),
          const Divider(color: Color.fromARGB(137, 83, 190, 240)),
          StreamBuilder(
            stream: CombineLatestStream.list([
              _firestore.collection('inpass')
                  .where('studentUid', isEqualTo: _auth.currentUser!.uid)
                  .snapshots(),
              _firestore.collection('outpass')
                  .where('studentUid', isEqualTo: _auth.currentUser!.uid)
                  .snapshots(),
            ]),
            builder: (context, AsyncSnapshot<List<QuerySnapshot>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('An error occurred.'));
              }

              var allRequests = snapshot.data!
                  .expand((collection) => collection.docs)
                  .toList();

              if (allRequests.isEmpty) {
                return Center(child: Text('No requests found.', style: TextStyle(color: Colors.white70)));
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: allRequests.length,
                itemBuilder: (context, index) {
                  var request = allRequests[index];
                  var action = request.reference.parent.id == 'inpass' ? 'INPASS' : 'OUTPASS';

                  return Card(
                    color: const Color.fromARGB(255, 124, 213, 249),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(request['reason'], style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0),fontWeight: FontWeight.bold)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date: ${request['date']}', style: TextStyle(color: const Color.fromARGB(179, 0, 0, 0),fontWeight: FontWeight.bold)),
                          Text('Time: ${request['time']}', style: TextStyle(color: const Color.fromARGB(179, 0, 0, 0),fontWeight: FontWeight.bold)),
                          Text('Status: ${getStatusText(request['status'])}', style: TextStyle(color: const Color.fromARGB(151, 172, 10, 7),fontWeight: FontWeight.bold)),
                        ],
                      ),
                      trailing: Text(
                        action,
                        style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0), fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      onTap: () {
                        // Check if the status is 3
                        if (request['status'] == 3) {
                          // Navigate to QrCodePage with the documentId and action
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QrCodePage(
                                documentId: request.id,
                                action: action,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  );
                },
              );
            },
          ),

        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.account_circle_rounded, color: Color.fromARGB(255, 124, 213, 249), size: 30.0),
            onPressed: () {
              Navigator.pushNamed(context, '/myprofile');
            },
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CGAS',
                style: TextStyle(
                  color: Color.fromARGB(255, 124, 213, 249),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  const Text(
                    'Welcome, ',
                    style: TextStyle(color: Color.fromARGB(255, 124, 213, 249), fontSize: 14),
                  ),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 124, 213, 249),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app_sharp, color: Color.fromARGB(255, 124, 213, 249), size: 30.0),
            onPressed: () {
              _showLogoutConfirmationDialog(context);
            },
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout Confirmation'),
          content: const Text('Do you really want to logout?'),
          actions: [
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String label, String routeName) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Card(

        color: const Color.fromARGB(255, 124, 213, 249),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80.0, color: const Color.fromARGB(255, 3, 21, 41)),
            const SizedBox(height: 8.0),
            Text(
              label,
              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
