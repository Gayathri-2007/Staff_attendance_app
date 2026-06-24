import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class LeaveApprovalScreen extends StatefulWidget {


  const LeaveApprovalScreen({super.key});



  @override
  State<LeaveApprovalScreen> createState() =>
      _LeaveApprovalScreenState();


}






class _LeaveApprovalScreenState
    extends State<LeaveApprovalScreen> {





  Future<void> approveLeave(

      String leaveId,

      String staffId,

      String date,

      ) async {



    // update leave status

    await FirebaseFirestore.instance

        .collection("leave_requests")

        .doc(leaveId)

        .update({

      "status":
      "Approved",

    });







    // find correct employee using staffId

    QuerySnapshot employeeQuery =

    await FirebaseFirestore.instance

        .collection("employees")

        .where(

      "staffId",

      isEqualTo: staffId,

    )

        .get();







    if(employeeQuery.docs.isNotEmpty){



      var employeeDoc =

          employeeQuery.docs.first;






      List attendance =

      List.from(

          employeeDoc["attendanceHistory"] ?? []

      );






      attendance.add({



        "date":

        date,



        "checkIn":

        "--",



        "checkOut":

        "--",



        "status":

        "Absent",



      });







      int absentDays =

          employeeDoc["absentDays"] ?? 0;








      await employeeDoc.reference.update({



        "attendanceHistory":

        attendance,



        "absentDays":

        absentDays + 1,



      });




    }







    ScaffoldMessenger.of(context)

        .showSnackBar(



      const SnackBar(

        content:

        Text(

            "Leave Approved and Attendance Updated"

        ),

      ),



    );




  }









  Future<void> rejectLeave(

      String leaveId

      ) async {



    await FirebaseFirestore.instance

        .collection("leave_requests")

        .doc(leaveId)

        .update({


      "status":

      "Rejected",



    });





    ScaffoldMessenger.of(context)

        .showSnackBar(



      const SnackBar(

        content:

        Text(

            "Leave Rejected"

        ),

      ),



    );


  }









  @override
  Widget build(BuildContext context) {


    return Scaffold(



      appBar: AppBar(



        title:

        const Text(

            "Leave Requests"

        ),



        backgroundColor:

        Colors.deepPurple,



        foregroundColor:

        Colors.white,



      ),







      body:


      StreamBuilder<QuerySnapshot>(



        stream:


        FirebaseFirestore.instance

            .collection("leave_requests")

            .snapshots(),






        builder:(context,snapshot){





          if(snapshot.connectionState ==

              ConnectionState.waiting){



            return const Center(

              child:

              CircularProgressIndicator(),

            );


          }







          if(!snapshot.hasData ||

              snapshot.data!.docs.isEmpty){



            return const Center(

              child:

              Text(

                  "No Leave Requests"

              ),

            );


          }







          var requests =

              snapshot.data!.docs;







          return ListView.builder(



            padding:

            const EdgeInsets.all(15),




            itemCount:

            requests.length,






            itemBuilder:(context,index){





              var leave =

              requests[index];





              Map<String,dynamic> data =

              leave.data()

              as Map<String,dynamic>;







              return Card(



                elevation:

                5,



                margin:

                const EdgeInsets.only(

                    bottom:15

                ),






                child:


                Padding(



                  padding:

                  const EdgeInsets.all(15),






                  child:


                  Column(



                    crossAxisAlignment:

                    CrossAxisAlignment.start,





                    children: [






                      Text(



                        data["staffName"] ??

                            "Unknown",




                        style:

                        const TextStyle(



                          fontSize:

                          20,



                          fontWeight:

                          FontWeight.bold,



                        ),



                      ),







                      const SizedBox(

                          height:10

                      ),







                      Text(

                        "Staff ID : ${data["staffId"] ?? ""}",

                      ),





                      Text(

                        "Reason : ${data["reason"] ?? ""}",

                      ),






                      Text(

                        "Date : ${data["date"] ?? ""}",

                      ),





                      Text(

                        "Leave Type : ${data["leaveType"] ?? "Not specified"}",

                      ),






                      const SizedBox(

                          height:10

                      ),







                      Text(



                        "Status : ${data["status"] ?? "Pending"}",




                        style:

                        TextStyle(



                          fontWeight:

                          FontWeight.bold,



                          color:

                          data["status"]=="Approved"

                              ?

                          Colors.green



                              :



                          data["status"]=="Rejected"

                              ?

                          Colors.red



                              :



                          Colors.orange,



                        ),



                      ),







                      const SizedBox(

                          height:15

                      ),







                      if(data["status"]=="Pending")

                        Row(



                          mainAxisAlignment:

                          MainAxisAlignment.end,




                          children: [





                            ElevatedButton(



                              onPressed:(){



                                approveLeave(



                                  leave.id,



                                  data["staffId"],



                                  data["date"],



                                );



                              },




                              style:

                              ElevatedButton.styleFrom(



                                backgroundColor:

                                Colors.green,



                              ),





                              child:

                              const Text(



                                "Approve",


                                style:

                                TextStyle(

                                  color:

                                  Colors.white,

                                ),

                              ),



                            ),






                            const SizedBox(

                                width:10

                            ),






                            ElevatedButton(



                              onPressed:(){



                                rejectLeave(



                                    leave.id

                                );



                              },




                              style:

                              ElevatedButton.styleFrom(



                                backgroundColor:

                                Colors.red,



                              ),




                              child:

                              const Text(



                                "Reject",


                                style:

                                TextStyle(

                                  color:

                                  Colors.white,

                                ),

                              ),



                            )




                          ],



                        )





                    ],



                  ),



                ),



              );




            },



          );




        },



      ),




    );

  }



}