import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class LeaveRequestScreen extends StatefulWidget {


  final String staffId;
  final String staffName;


  const LeaveRequestScreen({

    super.key,

    required this.staffId,

    required this.staffName,

  });



  @override
  State<LeaveRequestScreen> createState() =>
      _LeaveRequestScreenState();

}



class _LeaveRequestScreenState
    extends State<LeaveRequestScreen> {


  TextEditingController reasonController =
  TextEditingController();



  String leaveType = "Casual Leave";




  Future<void> submitLeave() async {



    if(reasonController.text.trim().isEmpty){

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content:
          Text(
              "Enter leave reason"
          ),

        ),

      );

      return;

    }





    await FirebaseFirestore.instance

        .collection("leave_requests")

        .add({


      "staffId":
      widget.staffId,


      "staffName":
      widget.staffName,


      "reason":
      reasonController.text.trim(),



      "leaveType":
      leaveType,



      "date":

      "${DateTime.now().day}/"
          "${DateTime.now().month}/"
          "${DateTime.now().year}",



      "status":
      "Pending",


    });





    ScaffoldMessenger.of(context)
        .showSnackBar(

      const SnackBar(

        content:
        Text(
            "Leave Request Sent"
        ),

      ),

    );



    Navigator.pop(context);



  }






  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(

        title:

        const Text(
            "Apply Leave"
        ),

      ),



      body:

      Padding(

        padding:

        const EdgeInsets.all(20),



        child:

        Column(



          children: [



            TextField(


              controller:
              reasonController,


              decoration:

              const InputDecoration(


                labelText:
                "Reason",

              ),



            ),





            DropdownButtonFormField(


              value:
              leaveType,


              items:


              const [


                DropdownMenuItem(

                  value:
                  "Casual Leave",

                  child:
                  Text(
                      "Casual Leave"
                  ),

                ),



                DropdownMenuItem(

                  value:
                  "Sick Leave",

                  child:
                  Text(
                      "Sick Leave"
                  ),

                ),



                DropdownMenuItem(

                  value:
                  "Emergency Leave",

                  child:
                  Text(
                      "Emergency Leave"
                  ),

                ),



              ],



              onChanged:(value){


                leaveType =
                    value.toString();


              },


            ),





            const SizedBox(
                height:30),






            ElevatedButton(


              onPressed:
              submitLeave,


              child:

              const Text(
                  "Submit"
              ),


            )



          ],



        ),



      ),


    );


  }


}