import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../services/attendance_service.dart';

class AddStaffScreen extends StatelessWidget {
  AddStaffScreen({super.key});

  final nameController = TextEditingController();
  final idController = TextEditingController();
  final emailController = TextEditingController();
  final deptController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Staff")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Name")),
            TextField(controller: idController, decoration: const InputDecoration(labelText: "Staff ID")),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            TextField(controller: deptController, decoration: const InputDecoration(labelText: "Department")),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Phone")),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final employee = Employee(
                  name: nameController.text,
                  staffId: idController.text,
                  email: emailController.text,
                  department: deptController.text,
                  mobile: phoneController.text,
                );

                await AttendanceService.addEmployee(employee);

                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}