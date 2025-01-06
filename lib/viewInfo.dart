// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';  // Make sure this file is generated during Firebase setup


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Example',
      debugShowCheckedModeBanner: false,
      home: EmployeeListPage(),
    );
  }
}

class EmployeeListPage extends StatelessWidget {
  // Reference to Firestore collection
  final CollectionReference employees = FirebaseFirestore.instance.collection('datanew');

  // Retrieve employee data as a Stream
  Stream<QuerySnapshot> getEmployeeData() {
    return employees.snapshots();  // This listens to real-time updates in Firestore
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Employee List')),
      body: StreamBuilder<QuerySnapshot>(
        stream: getEmployeeData(),  // Get stream of data from Firestore
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available.'));
          }

          // Display employee data in a ListView
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var employee = snapshot.data!.docs[index];
              String name = employee['name'] ?? 'No name';
              String salary = employee['phone'] ;

              return ListTile(
                title: Text(name),
                subtitle: Text(salary),
              );
            },
          );
        },
      ),
    );
  }
}
