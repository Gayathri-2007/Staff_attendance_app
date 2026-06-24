import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/employee.dart';

class AttendanceService {

  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static List<Employee> employees = [];

  /// LOAD EMPLOYEES
  static Future<void> loadEmployees() async {

    final snapshot =
    await _firestore
        .collection('employees')
        .get();

    employees = snapshot.docs.map((doc) {

      return Employee.fromJson(doc.data());

    }).toList();
  }

  /// ADD EMPLOYEE
  static Future<void> addEmployee(
      Employee employee) async {

    /// SAVE EMPLOYEE DATA
    await _firestore
        .collection('employees')
        .doc(employee.staffId)
        .set(employee.toJson());

    /// SAVE USER ROLE
    await _firestore
        .collection('users')
        .doc(employee.email)
        .set({

      'email': employee.email,
      'role': employee.role,
    });

    await loadEmployees();
  }

  /// DELETE EMPLOYEE
  static Future<void> deleteEmployee(
      String staffId) async {

    /// FIND EMPLOYEE
    Employee employee = employees.firstWhere(
          (e) => e.staffId == staffId,
    );

    /// DELETE EMPLOYEE DATA
    await _firestore
        .collection('employees')
        .doc(staffId)
        .delete();

    /// DELETE USER ROLE
    await _firestore
        .collection('users')
        .doc(employee.email)
        .delete();

    await loadEmployees();
  }

  /// UPDATE EMPLOYEE
  static Future<void> updateEmployee(
      Employee employee) async {

    await _firestore
        .collection('employees')
        .doc(employee.staffId)
        .update(employee.toJson());

    await loadEmployees();
  }

  /// GET USER ROLE
  static Future<String> getUserRole(
      String email) async {

    final doc =
    await _firestore
        .collection('users')
        .doc(email)
        .get();

    if (doc.exists) {

      return doc.data()?['role']
          ?? "staff";
    }

    return "staff";
  }
}