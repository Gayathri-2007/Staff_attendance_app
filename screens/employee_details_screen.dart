import 'package:flutter/material.dart';

import '../models/employee.dart';



class EmployeeDetailsScreen extends StatelessWidget {


  final Employee employee;



  const EmployeeDetailsScreen({

    super.key,

    required this.employee,

  });





  @override
  Widget build(BuildContext context) {


    return Scaffold(



      appBar: AppBar(


        title:

        const Text(
            "Employee Details"
        ),


        backgroundColor:
        Colors.deepPurple,


        foregroundColor:
        Colors.white,


      ),





      body:


      SingleChildScrollView(


        padding:

        const EdgeInsets.all(20),




        child:


        Column(



          children: [






            const CircleAvatar(


              radius:50,


              child:

              Icon(

                Icons.person,

                size:60,

              ),


            ),





            const SizedBox(
                height:20),






            Text(


              employee.name,


              style:

              const TextStyle(

                fontSize:25,

                fontWeight:
                FontWeight.bold,

              ),


            ),




            const SizedBox(
                height:10),






            Text(

              "Staff ID : ${employee.staffId}",

            ),



            Text(

              "Department : ${employee.department}",

            ),



            Text(

              "Email : ${employee.email}",

            ),



            Text(

              "Mobile : ${employee.mobile}",

            ),






            const SizedBox(
                height:30),







            Card(


              elevation:5,



              child:


              Padding(

                padding:

                const EdgeInsets.all(15),



                child:


                Column(



                  children: [



                    const Text(

                      "Attendance Summary",

                      style:

                      TextStyle(

                        fontSize:20,

                        fontWeight:
                        FontWeight.bold,

                      ),

                    ),





                    Text(

                        "Present Days : ${employee.presentDays}"

                    ),



                    Text(

                        "Absent Days : ${employee.absentDays}"

                    ),



                    Text(

                        "Late Days : ${employee.lateDays}"

                    ),



                    Text(

                        "Half Days : ${employee.halfDays}"

                    ),




                  ],


                ),


              ),



            ),







            const SizedBox(
                height:20),







            const Text(

              "Attendance History",

              style:

              TextStyle(

                fontSize:20,

                fontWeight:
                FontWeight.bold,

              ),

            ),





            const SizedBox(
                height:10),







            ListView.builder(


              shrinkWrap:true,


              physics:

              const NeverScrollableScrollPhysics(),



              itemCount:

              employee.attendanceHistory.length,



              itemBuilder:(context,index){



                var data =

                employee.attendanceHistory[index];





                return Card(



                  child:


                  ListTile(



                    title:

                    Text(

                      data.date,

                    ),



                    subtitle:

                    Text(

                      "In : ${data.checkIn}\n"
                          "Out : ${data.checkOut}",

                    ),



                  ),



                );



              },



            )



          ],



        ),



      ),



    );

  }


}