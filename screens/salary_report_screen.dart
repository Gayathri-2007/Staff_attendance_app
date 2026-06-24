import 'package:flutter/material.dart';

import '../models/employee.dart';

class SalaryReportScreen
    extends StatelessWidget {

  final Employee employee;

  const SalaryReportScreen({

    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {

    int presentDays =
        employee.attendanceHistory.length;

    int leaveDays =
        employee.leaveHistory.length;

    double totalSalary =
        presentDays *
            employee.salaryPerDay;

    return Scaffold(

      appBar: AppBar(

        title: Text(
          "${employee.name} Salary Report",
        ),

        backgroundColor:
        Colors.deepPurple,

        foregroundColor:
        Colors.white,
      ),

      body: SingleChildScrollView(

        padding:
        const EdgeInsets.all(16),

        child: Column(

          children: [

            /// PROFILE CARD
            Card(

              elevation: 5,

              shape:
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(
                    20),
              ),

              child: Padding(

                padding:
                const EdgeInsets.all(20),

                child: Column(

                  children: [

                    const CircleAvatar(

                      radius: 40,

                      backgroundColor:
                      Colors.deepPurple,

                      child: Icon(
                        Icons.person,
                        size: 40,
                        color:
                        Colors.white,
                      ),
                    ),

                    const SizedBox(
                        height: 15),

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

                    Text(
                      "Email: ${employee.email}",
                    ),

                    Text(
                      "Mobile: ${employee.mobile}",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// SUMMARY CARDS
            Row(

              children: [

                buildCard(
                  "Present",
                  presentDays.toString(),
                  Colors.green,
                ),

                buildCard(
                  "Leave",
                  leaveDays.toString(),
                  Colors.orange,
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(

              children: [

                buildCard(
                  "Per Day",
                  "₹${employee.salaryPerDay}",
                  Colors.blue,
                ),

                buildCard(
                  "Salary",
                  "₹$totalSalary",
                  Colors.deepPurple,
                ),
              ],
            ),

            const SizedBox(height: 25),

            /// ATTENDANCE HISTORY
            Align(

              alignment:
              Alignment.centerLeft,

              child: Text(

                "Attendance History",

                style:
                const TextStyle(
                  fontSize: 22,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            ListView.builder(

              shrinkWrap: true,

              physics:
              const NeverScrollableScrollPhysics(),

              itemCount:
              employee.attendanceHistory
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
                      Colors.green,

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

            const SizedBox(height: 25),

            /// LEAVE HISTORY
            Align(

              alignment:
              Alignment.centerLeft,

              child: Text(

                "Leave History",

                style:
                const TextStyle(
                  fontSize: 22,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 15),

            employee.leaveHistory.isEmpty

                ? const Text(
              "No Leave Records",
            )

                : ListView.builder(

              shrinkWrap: true,

              physics:
              const NeverScrollableScrollPhysics(),

              itemCount:
              employee.leaveHistory
                  .length,

              itemBuilder:
                  (context, index) {

                var leave =
                employee.leaveHistory[
                index];

                return Card(

                  child: ListTile(

                    leading:
                    const CircleAvatar(

                      backgroundColor:
                      Colors.orange,

                      child: Icon(
                        Icons.event_busy,
                        color:
                        Colors.white,
                      ),
                    ),

                    title: Text(
                      leave.date,
                    ),

                    subtitle: Column(

                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                      children: [

                        Text(
                          "Type: ${leave.type}",
                        ),

                        Text(
                          "Reason: ${leave.reason}",
                        ),

                        Text(
                          "Status: ${leave.status}",
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(
      String title,
      String value,
      Color color,
      ) {

    return Expanded(

      child: Container(

        margin:
        const EdgeInsets.symmetric(
            horizontal: 5),

        padding:
        const EdgeInsets.all(15),

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
      ),
    );
  }
}