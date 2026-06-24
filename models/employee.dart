import 'attendance_record.dart';
import 'leave_record.dart';

class Employee {

  String name;
  String staffId;
  String email;
  String department;
  String mobile;
  String role;

  int presentDays;
  int absentDays;
  int lateDays;
  int halfDays;

  String checkInTime;
  String checkOutTime;

  /// SALARY
  double salaryPerDay;
  double totalSalary;

  /// ATTENDANCE HISTORY
  List<AttendanceRecord>
  attendanceHistory;

  /// LEAVE HISTORY
  List<LeaveRecord> leaveHistory;

  Employee({

    required this.name,
    required this.staffId,
    required this.email,
    required this.department,
    required this.mobile,
    this.role = "staff",

    this.presentDays = 0,
    this.absentDays = 0,
    this.lateDays = 0,
    this.halfDays = 0,

    this.checkInTime = "--",
    this.checkOutTime = "--",

    this.salaryPerDay = 500,
    this.totalSalary = 0,

    List<AttendanceRecord>?
    attendanceHistory,

    List<LeaveRecord>?
    leaveHistory,

  }) :

        attendanceHistory =
            attendanceHistory ?? [],

        leaveHistory =
            leaveHistory ?? [];

  /// TO JSON
  Map<String, dynamic> toJson() {

    return {

      'name': name,
      'staffId': staffId,
      'email': email,
      'department': department,
      'mobile': mobile,
      'role': role,

      'presentDays': presentDays,
      'absentDays': absentDays,
      'lateDays': lateDays,
      'halfDays': halfDays,

      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,

      'salaryPerDay': salaryPerDay,
      'totalSalary': totalSalary,

      'attendanceHistory':

      attendanceHistory
          .map((e) => e.toJson())
          .toList(),

      'leaveHistory':

      leaveHistory
          .map((e) => e.toJson())
          .toList(),
    };
  }

  /// FROM JSON
  factory Employee.fromJson(
      Map<String, dynamic> json) {

    return Employee(

      name: json['name'],
      staffId: json['staffId'],
      email: json['email'],
      department: json['department'],
      mobile: json['mobile'],
      role: json['role'] ?? "staff",

      presentDays:
      json['presentDays'] ?? 0,

      absentDays:
      json['absentDays'] ?? 0,

      lateDays:
      json['lateDays'] ?? 0,

      halfDays:
      json['halfDays'] ?? 0,

      checkInTime:
      json['checkInTime'] ?? "--",

      checkOutTime:
      json['checkOutTime'] ?? "--",

      salaryPerDay:
      (json['salaryPerDay'] ?? 500)
          .toDouble(),

      totalSalary:
      (json['totalSalary'] ?? 0)
          .toDouble(),

      attendanceHistory:

      (json['attendanceHistory']
      as List? ?? [])

          .map((e) =>

          AttendanceRecord
              .fromJson(e))

          .toList(),

      leaveHistory:

      (json['leaveHistory']
      as List? ?? [])

          .map((e) =>

          LeaveRecord
              .fromJson(e))

          .toList(),
    );
  }
}