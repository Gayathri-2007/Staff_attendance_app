import 'package:flutter/material.dart';

import '../services/attendance_service.dart';

import 'profile_screen.dart';
import 'employee_details_screen.dart';
import 'leave_approval_screen.dart';



class DashboardScreen extends StatefulWidget {


  const DashboardScreen({super.key});


  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();

}



class _DashboardScreenState
    extends State<DashboardScreen> {



  TextEditingController searchController =
  TextEditingController();




  @override
  void initState(){

    super.initState();

    loadData();

  }






  Future<void> loadData() async {

    await AttendanceService.loadEmployees();

    setState(() {});

  }







  @override
  Widget build(BuildContext context) {



    var employees =

    AttendanceService.employees
        .where((employee){


      return employee.name
          .toLowerCase()
          .contains(
          searchController.text.toLowerCase()
      )

          ||

          employee.staffId
              .toLowerCase()
              .contains(
              searchController.text.toLowerCase()
          );


    }).toList();





    int present = employees
        .where((e)=>
    e.checkInTime != "--"
    )
        .length;




    int absent =
        employees.length-present;







    return Scaffold(



      appBar: AppBar(


        title:

        const Text(
            "Admin Dashboard"
        ),



        centerTitle:true,



        backgroundColor:

        Colors.deepPurple,



        foregroundColor:

        Colors.white,




        actions: [



          IconButton(


            icon:

            const Icon(
                Icons.assignment
            ),



            tooltip:

            "Leave Requests",




            onPressed:(){


              Navigator.push(

                context,

                MaterialPageRoute(

                  builder:(context)=>

                  const LeaveApprovalScreen(),

                ),

              );


            },


          )


        ],



      ),







      floatingActionButton:


      FloatingActionButton(



        backgroundColor:

        Colors.deepPurple,



        child:

        const Icon(

          Icons.add,

          color:

          Colors.white,

        ),



        onPressed:(){



          Navigator.push(

              context,


              MaterialPageRoute(

                builder:(context)=>

                    ProfileScreen(),

              )


          ).then((value){

            setState((){});

          });



        },


      ),









      body:


      Padding(


        padding:

        const EdgeInsets.all(16),





        child:


        Column(



          children: [





            TextField(



              controller:

              searchController,



              onChanged:(value){

                setState((){});

              },



              decoration:

              InputDecoration(


                hintText:

                "Search Employee",



                prefixIcon:

                const Icon(
                    Icons.search
                ),




                border:

                OutlineInputBorder(

                  borderRadius:

                  BorderRadius.circular(15),

                ),


              ),



            ),






            const SizedBox(
                height:20),








            Row(


              children: [



                card(

                    "Employees",

                    employees.length.toString(),

                    Colors.blue

                ),



                card(

                    "Present",

                    present.toString(),

                    Colors.green

                ),



                card(

                    "Absent",

                    absent.toString(),

                    Colors.red

                ),



              ],


            ),






            const SizedBox(
                height:20),







            Expanded(



              child:

              ListView.builder(



                itemCount:

                employees.length,





                itemBuilder:(context,index){



                  var employee =
                  employees[index];







                  return GestureDetector(



                    onTap:(){



                      Navigator.push(


                        context,


                        MaterialPageRoute(


                          builder:(context)=>

                              EmployeeDetailsScreen(

                                employee:
                                employee,


                              ),


                        ),


                      );


                    },




                    child:


                    Card(



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



                          children: [





                            Row(



                              children: [



                                const CircleAvatar(



                                  child:

                                  Icon(
                                      Icons.person
                                  ),



                                ),





                                const SizedBox(
                                    width:15),





                                Expanded(



                                  child:


                                  Column(



                                    crossAxisAlignment:

                                    CrossAxisAlignment.start,



                                    children: [





                                      Text(



                                        employee.name,



                                        style:

                                        const TextStyle(

                                          fontSize:20,

                                          fontWeight:

                                          FontWeight.bold,

                                        ),



                                      ),





                                      Text(

                                          "ID : ${employee.staffId}"

                                      ),





                                      Text(

                                          employee.department

                                      ),





                                      Text(

                                          employee.email

                                      ),





                                      Text(

                                          employee.mobile

                                      ),



                                    ],



                                  ),



                                ),





                                IconButton(



                                  icon:

                                  const Icon(

                                      Icons.delete,

                                      color:

                                      Colors.red

                                  ),




                                  onPressed:() async {



                                    await AttendanceService

                                        .deleteEmployee(

                                        employee.staffId

                                    );



                                    setState((){});



                                  },



                                )





                              ],



                            ),






                            const SizedBox(
                                height:20),






                            Row(



                              mainAxisAlignment:

                              MainAxisAlignment.spaceEvenly,



                              children: [





                                ElevatedButton(



                                  onPressed:() async {



                                    if(employee.checkInTime!="--"){


                                      ScaffoldMessenger.of(context)

                                          .showSnackBar(

                                        const SnackBar(

                                          content:

                                          Text(

                                              "Already Punched In"

                                          ),

                                        ),

                                      );


                                      return;

                                    }





                                    employee.checkInTime =

                                        TimeOfDay.now()

                                            .format(context);





                                    await AttendanceService

                                        .updateEmployee(employee);





                                    setState((){});



                                  },



                                  child:

                                  const Text(

                                      "Punch In"

                                  ),



                                ),





                                ElevatedButton(



                                  onPressed:() async {



                                    if(employee.checkOutTime!="--"){


                                      ScaffoldMessenger.of(context)

                                          .showSnackBar(

                                        const SnackBar(

                                          content:

                                          Text(

                                              "Already Punched Out"

                                          ),

                                        ),

                                      );


                                      return;

                                    }





                                    employee.checkOutTime =

                                        TimeOfDay.now()

                                            .format(context);





                                    await AttendanceService

                                        .updateEmployee(employee);





                                    setState((){});



                                  },




                                  child:

                                  const Text(

                                      "Punch Out"

                                  ),



                                )




                              ],



                            ),






                            const SizedBox(
                                height:10),





                            Text(

                                "Check In : ${employee.checkInTime}"

                            ),





                            Text(

                                "Check Out : ${employee.checkOutTime}"

                            ),





                          ],



                        ),



                      ),



                    ),



                  );




                },



              ),



            )





          ],



        ),



      ),



    );



  }







  Widget card(

      String title,

      String value,

      Color color,

      ){



    return Expanded(



      child:

      Container(



        margin:

        const EdgeInsets.all(5),




        padding:

        const EdgeInsets.all(15),




        decoration:

        BoxDecoration(


          color:

          color.withOpacity(0.2),



          borderRadius:

          BorderRadius.circular(15),


        ),





        child:


        Column(



          children: [



            Text(title),



            Text(



              value,



              style:

              TextStyle(

                fontSize:25,

                fontWeight:

                FontWeight.bold,

                color:

                color,

              ),


            )


          ],



        ),



      ),



    );


  }



}