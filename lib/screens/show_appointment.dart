import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medical_health_firebase/main.dart';

class AppointmentsPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'APPOINTMENTS',
          style: TextStyle(
            color: kPrimaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('appointments').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No appointments found.'));
          }

          final appointments = snapshot.data!.docs;
          final dateFormatter = DateFormat('d MMMM yyyy');

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final appointment = appointments[index].data() as Map<String, dynamic>;
              final documentId = appointments[index].id; // Get the document ID

              final caregiverName = appointment['caregiverName'] ?? 'Unknown';
              final selectedTime = appointment['selectedTime'] ?? 'NoSelectedTime';
              final dutyDatesList = appointment['dutyDates'] as List<dynamic>? ?? [];
              final selectedDates = dutyDatesList.map((e) {
                if (e is Timestamp) {
                  return e.toDate();
                } else if (e is String) {
                  try {
                    return DateTime.parse(e);
                  } catch (e) {
                    return null;
                  }
                }
                return null;
              }).where((date) => date != null).cast<DateTime>().toList();
              final dutyDates = selectedDates.map((e) => dateFormatter.format(e)).join('\n');
              final days = appointment['days'] ?? 0;
              final pricePerDay = appointment['pricePerDay'] ?? '0';
              final totalPrice = (int.tryParse(pricePerDay) ?? 0) * days;

              return Dismissible(
                key: Key(documentId),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Center(
                          child: Text('CONFIRM DELETE',
                            style: TextStyle(
                              color: kPrimaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),),
                        ),
                        content: Text('Are you sure you want to delete this appointment?'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('No'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: Text('Yes'),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (direction) async {
                  await deleteAppointment(documentId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Appointment deleted')),
                  );
                },
                child: Card(
                  elevation: 1,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text('$caregiverName'),
                    subtitle: Text('$selectedTime\n$dutyDates', style: TextStyle(color: kPrimaryColor)),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('$days days'),
                        Text('฿$totalPrice', style: TextStyle(color: kPrimaryColor)),
                      ],
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Center(
                              child: Text(
                                '$caregiverName APPOINTMENT',
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Name: $caregiverName'),
                                Text('Duty Type: ${appointment['label'] ?? 'Not Provided'}'),
                                Text('Duty Time: ${appointment['selectedTime'] ?? 'Not Provided'}'),
                                SizedBox(height: 10),
                                Text('Duty Dates:'),
                                Text(
                                  dutyDates,
                                  textAlign: TextAlign.right,
                                  style: TextStyle(color: kPrimaryColor),
                                ),
                                SizedBox(height: 10),
                                Text('Customer Name: ${appointment['customerName'] ?? 'Not Provided'}'),
                                Text('Customer Ph: ${appointment['phone'] ?? 'Not Provided'}'),
                                Text('Customer Address: ${appointment['address'] ?? 'Not Provided'}'),
                                SizedBox(height: 10),
                                Text('Fee: ฿ $pricePerDay x $days day(s)'),
                                Divider(),
                                Text('Total Fees: ฿ $totalPrice'),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Close'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> deleteAppointment(String documentId) async {
    try {
      await _firestore.collection('appointments').doc(documentId).delete();
    } catch (e) {
      print('Error deleting appointment: $e');
    }
  }
}
