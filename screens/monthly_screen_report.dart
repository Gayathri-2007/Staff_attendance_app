import 'package:flutter/material.dart';

import '../models/employee.dart';

class MonthlyReportScreen
    extends StatelessWidget {

  final Employee employee;

  const MonthlyReportScreen({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {

    int presentDays =
        employee.attendanceHistory.length;

    return Scaffold(

      appBar: AppBar(
        title: Text(
          "${employee.name} Report",
        ),

        backgroundColor:
        Colors.deepPurple,

        foregroundColor:
        Colors.white,
      ),

      body: Padding(

        padding: const EdgeInsets.all(16),

        child: Column(

          children: [

            /// TOP SUMMARY
            Card(

              elevation: 5,

              child: Padding(

                padding:
                const EdgeInsets.all(20),

                child: Column(

                  children: [

                    Text(

                      employee.name,

                      style:
                      const TextStyle(
                        fontSize: 24,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                        height: 10),

                    Text(
                      "Staff ID: ${employee.staffId}",
                    ),

                    Text(
                      "Department: ${employee.department}",
                    ),

                    const SizedBox(
                        height: 20),

                    Row(

                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceAround,

                      children: [

                        buildReportCard(
                          "Present",
                          presentDays
                              .toString(),
                          Colors.green,
                        ),

                        buildReportCard(
                          "Records",
                          employee
                              .attendanceHistory
                              .length
                              .toString(),
                          Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// HISTORY LIST
            Expanded(

              child: ListView.builder(

                itemCount: employee
                    .attendanceHistory
                    .length,

                itemBuilder:
                    (context, index) {

                  var history =
                  employee
                      .attendanceHistory[
                  index];

                  return Card(

                    child: ListTile(

                      leading:
                      const CircleAvatar(
                        backgroundColor:
                        Colors.deepPurple,
                        child: Icon(
                          Icons.calendar_month,
                          color:
                          Colors.white,
                        ),
                      ),

                      title: Text(
                        history.date,
                      ),

                      subtitle: Column(

                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                        children: [

                          Text(
                            "Check In: ${history.checkIn}",
                          ),

                          Text(
                            "Check Out: ${history.checkOut}",
                          ),

                          Text(
                            "Status: ${history.status}",
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReportCard(
      String title,
      String value,
      Color color,
      ) {

    return Container(

      padding:
      const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color:
        color.withOpacity(0.2),

        borderRadius:
        BorderRadius.circular(15),
      ),

      child: Column(

        children: [

          Text(

            title,

            style: TextStyle(
              color: color,
              fontWeight:
              FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(

            value,

            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight:
              FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}