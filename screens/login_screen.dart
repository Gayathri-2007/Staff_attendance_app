import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {

  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final TextEditingController
  emailController =
  TextEditingController();

  final TextEditingController
  passwordController =
  TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text("Admin Login"),

        backgroundColor:
        Colors.deepPurple,

        foregroundColor:
        Colors.white,

        centerTitle: true,
      ),

      body: Center(

        child: Padding(

          padding:
          const EdgeInsets.all(20),

          child: Column(

            mainAxisAlignment:
            MainAxisAlignment.center,

            children: [

              const Icon(

                Icons.admin_panel_settings,

                size: 100,

                color: Colors.deepPurple,
              ),

              const SizedBox(height: 30),

              /// EMAIL
              TextField(

                controller:
                emailController,

                decoration:
                InputDecoration(

                  labelText:
                  "Admin Email",

                  border:
                  OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(
                        15),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// PASSWORD
              TextField(

                controller:
                passwordController,

                obscureText: true,

                decoration:
                InputDecoration(

                  labelText:
                  "Password",

                  border:
                  OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(
                        15),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(

                width: double.infinity,
                height: 50,

                child: ElevatedButton(

                  style:
                  ElevatedButton.styleFrom(

                    backgroundColor:
                    Colors.deepPurple,
                  ),

                  onPressed: () async {

                    String email =
                    emailController.text
                        .trim();

                    String password =
                    passwordController.text
                        .trim();

                    if (email.isEmpty ||
                        password.isEmpty) {

                      ScaffoldMessenger.of(
                          context)

                          .showSnackBar(

                        const SnackBar(

                          content: Text(
                            "Enter email & password",
                          ),
                        ),
                      );

                      return;
                    }

                    try {

                      setState(() {
                        isLoading = true;
                      });

                      await FirebaseAuth.instance
                          .signInWithEmailAndPassword(

                        email: email,
                        password: password,
                      );

                      setState(() {
                        isLoading = false;
                      });

                      Navigator.pushReplacement(

                        context,

                        MaterialPageRoute(

                          builder: (context) =>
                          const DashboardScreen(),
                        ),
                      );

                    } on FirebaseAuthException catch (e) {

                      setState(() {
                        isLoading = false;
                      });

                      ScaffoldMessenger.of(
                          context)

                          .showSnackBar(

                        SnackBar(

                          content: Text(
                            e.message ??
                                "Login Failed",
                          ),
                        ),
                      );
                    }
                  },

                  child: isLoading

                      ? const CircularProgressIndicator(
                    color: Colors.white,
                  )

                      : const Text(

                    "Login",

                    style: TextStyle(

                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}