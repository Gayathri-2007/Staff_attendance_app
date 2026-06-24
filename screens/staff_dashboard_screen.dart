import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/employee.dart';
import '../models/attendance_record.dart';

import 'leave_request_screen.dart';



class StaffDashboardScreen extends StatefulWidget {


  final String staffId;


  const StaffDashboardScreen({

    super.key,

    required this.staffId,

  });



  @override
  State<StaffDashboardScreen> createState() =>
      _StaffDashboardScreenState();

}






class _StaffDashboardScreenState
    extends State<StaffDashboardScreen> {



  Employee? employee;


  bool loading = true;


  String selectedShift = "1st Shift";






  @override
  void initState(){


    super.initState();


    loadEmployee();


  }








  Future<void> loadEmployee() async {



    QuerySnapshot snapshot =


    await FirebaseFirestore.instance

        .collection("employees")

        .where(

      "staffId",

      isEqualTo: widget.staffId,

    )

        .get();





    if(snapshot.docs.isNotEmpty){


      employee = Employee.fromJson(


        snapshot.docs.first.data()

        as Map<String,dynamic>,


      );


    }







    await checkAbsentAttendance();





    setState((){

      loading=false;

    });



  }









  Future<void> checkAbsentAttendance() async {



    DateTime yesterday =

    DateTime.now()

        .subtract(

        const Duration(days:1)

    );





    String date =


        "${yesterday.day}/"
        "${yesterday.month}/"
        "${yesterday.year}";







    bool exists =


    employee!

        .attendanceHistory

        .any((e)=>


    e.date == date



    );








    if(exists){

      return;

    }







    AttendanceRecord absent =



    AttendanceRecord(



      date: date,



      checkIn:"--",



      checkOut:"--",



      status:"Absent",



    );








    employee!

        .attendanceHistory

        .add(absent);





    employee!.absentDays++;







    await updateEmployee();




  }










  bool isLeaveToday(){



    String today =



        "${DateTime.now().day}/"
        "${DateTime.now().month}/"
        "${DateTime.now().year}";






    for(var leave in employee!.leaveHistory){



      if(leave.date == today &&

          leave.status == "Leave"){



        return true;


      }


    }



    return false;


  }









  String calculateStatus(){



    DateTime now = DateTime.now();



    int hour = now.hour;

    int minute = now.minute;







    if(selectedShift=="1st Shift"){



      if(hour > 9 ||

          (hour==9 && minute>0)){



        return "Late";


      }


    }







    if(selectedShift=="2nd Shift"){



      if(hour > 10 ||

          (hour==10 && minute>0)){



        return "Late";


      }


    }






    return "Present";



  }









  Future<void> punchIn() async {



    if(isLeaveToday()){



      ScaffoldMessenger.of(context)

          .showSnackBar(



        const SnackBar(

          content:

          Text(

              "You are on approved leave today"

          ),

        ),



      );



      return;


    }








    String today =



        "${DateTime.now().day}/"
        "${DateTime.now().month}/"
        "${DateTime.now().year}";







    bool already =


    employee!

        .attendanceHistory

        .any((e)=>



    e.date == today &&

        e.checkIn!="--"



    );






    if(already){


      return;


    }







    String time =


    TimeOfDay.now()

        .format(context);







    AttendanceRecord record =



    AttendanceRecord(


      date: today,


      checkIn: time,


      checkOut:"--",


      status:calculateStatus(),


    );








    employee!

        .attendanceHistory

        .add(record);







    employee!.presentDays++;






    if(record.status=="Late"){


      employee!.lateDays++;


    }






    employee!.checkInTime=time;





    await updateEmployee();



    setState((){});



  }









  Future<void> punchOut() async {



    if(isLeaveToday()){



      ScaffoldMessenger.of(context)

          .showSnackBar(



        const SnackBar(

          content:

          Text(

              "You are on approved leave today"

          ),

        ),



      );



      return;


    }








    var record =


        employee!

            .attendanceHistory

            .last;







    String time =


    TimeOfDay.now()

        .format(context);








    record.checkOut=time;







    DateTime start = DateTime.now();



    DateTime end = DateTime.now();






    if(record.checkIn!="--"){



      int inHour =


      int.parse(

          record.checkIn.split(":")[0]

      );



      start = DateTime(

        DateTime.now().year,

        DateTime.now().month,

        DateTime.now().day,

        inHour,

      );


    }






    Duration work =

    end.difference(start);







    if(work.inHours < 6 &&

        record.status!="Half Day"){



      record.status="Half Day";


      employee!.halfDays++;



    }







    employee!.checkOutTime=time;







    await updateEmployee();




    setState((){});



  }









  Future<void> updateEmployee() async {



    QuerySnapshot snapshot =


    await FirebaseFirestore.instance

        .collection("employees")

        .where(

      "staffId",

      isEqualTo: widget.staffId,

    )

        .get();






    if(snapshot.docs.isNotEmpty){



      await snapshot.docs.first.reference.update({




        "presentDays":

        employee!.presentDays,



        "absentDays":

        employee!.absentDays,



        "lateDays":

        employee!.lateDays,



        "halfDays":

        employee!.halfDays,



        "checkInTime":

        employee!.checkInTime,



        "checkOutTime":

        employee!.checkOutTime,



        "attendanceHistory":


        employee!

            .attendanceHistory

            .map((e)=>e.toJson())

            .toList(),



      });



    }


  }









  void showHistory(){



    showDialog(



      context: context,



      builder:(context){



        return AlertDialog(



          title:

          const Text(

              "Attendance History"

          ),




          content:


          SizedBox(


            height:350,


            width:300,



            child:


            ListView.builder(



              itemCount:

              employee!

                  .attendanceHistory

                  .length,



              itemBuilder:(context,index){



                var item =


                employee!

                    .attendanceHistory[index];






                return Card(



                  child:

                  ListTile(



                    title:

                    Text(item.date),




                    subtitle:

                    Text(

                        "In : ${item.checkIn}\n"
                            "Out : ${item.checkOut}\n"
                            "Status : ${item.status}"

                    ),



                  ),



                );



              },



            ),



          ),



        );



      },



    );



  }









  @override
  Widget build(BuildContext context) {



    if(loading){



      return const Scaffold(

        body:

        Center(

          child:

          CircularProgressIndicator(),

        ),


      );


    }







    return Scaffold(



      appBar: AppBar(



        title:

        const Text(

            "Staff Dashboard"

        ),



        backgroundColor:

        Colors.green,



        foregroundColor:

        Colors.white,


      ),






      body:


      Center(



        child:


        SingleChildScrollView(



          padding:

          const EdgeInsets.all(20),




          child:


          Column(



            children: [






              const CircleAvatar(

                radius:45,

                child:

                Icon(

                  Icons.person,

                  size:50,

                ),

              ),






              const SizedBox(height:20),





              Text(

                employee!.name,


                style:

                const TextStyle(

                  fontSize:25,

                  fontWeight:

                  FontWeight.bold,

                ),

              ),





              Text(

                  "ID : ${employee!.staffId}"

              ),





              DropdownButton(


                value:selectedShift,



                items:

                const [



                  DropdownMenuItem(

                    value:"1st Shift",

                    child:

                    Text(

                        "1st Shift (9 AM - 5 PM)"

                    ),

                  ),




                  DropdownMenuItem(

                    value:"2nd Shift",

                    child:

                    Text(

                        "2nd Shift (10 AM - 6 PM)"

                    ),

                  ),



                ],



                onChanged:(value){


                  setState((){


                    selectedShift=value!;


                  });



                },


              ),






              Card(



                child:

                Padding(

                  padding:

                  const EdgeInsets.all(15),



                  child:


                  Column(



                    children: [



                      const Text(

                          "Attendance Summary"

                      ),



                      Text(

                          "Present : ${employee!.presentDays}"

                      ),



                      Text(

                          "Absent : ${employee!.absentDays}"

                      ),



                      Text(

                          "Late : ${employee!.lateDays}"

                      ),



                      Text(

                          "Half Day : ${employee!.halfDays}"

                      ),



                    ],



                  ),



                ),



              ),







              ElevatedButton(

                  onPressed:punchIn,

                  child:

                  const Text(

                      "Punch In"

                  )

              ),





              ElevatedButton(

                  onPressed:punchOut,

                  child:

                  const Text(

                      "Punch Out"

                  )

              ),






              ElevatedButton(



                onPressed:(){



                  Navigator.push(

                    context,

                    MaterialPageRoute(


                      builder:(context)=>

                          LeaveRequestScreen(


                            staffId:

                            employee!.staffId,


                            staffName:

                            employee!.name,


                          ),


                    ),


                  );


                },


                child:

                const Text(

                    "Apply Leave"

                ),



              ),






              ElevatedButton(


                  onPressed:

                  showHistory,


                  child:

                  const Text(

                      "View Attendance History"

                  )


              )



            ],



          ),



        ),



      ),



    );


  }


}