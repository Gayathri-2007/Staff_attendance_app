class LeaveRecord {

  String date;
  String reason;
  String type;
  String status;

  LeaveRecord({

    required this.date,
    required this.reason,
    required this.type,
    required this.status,
  });

  Map<String, dynamic> toJson() {

    return {

      'date': date,
      'reason': reason,
      'type': type,
      'status': status,
    };
  }

  factory LeaveRecord.fromJson(
      Map<String, dynamic> json) {

    return LeaveRecord(

      date: json['date'],
      reason: json['reason'],
      type: json['type'],
      status: json['status'],
    );
  }
}