import 'package:flutter/material.dart';
import 'package:track_expenses/Animation/FadeAnimation.dart';
import 'package:track_expenses/screens/Loginpage.dart';
import 'package:track_expenses/services/AuthServices.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    String name = '';
    String email = '';
    String password = '';
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                height: 400,
                // decoration: BoxDecoration(
                //   // image: DecorationImage(
                //   //   image: AssetImage('assets/images/background.png'),
                //   //   fit: BoxFit.fill,
                //   // ),
                // ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 200,
                      child: FadeAnimation(
                          1,
                          Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage('assets/images/light-1.png'),
                            )),
                          )),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 150,
                      child: FadeAnimation(
                          1.3,
                          Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage('assets/images/light-2.png'),
                            )),
                          )),
                    ),
                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: 150,
                      child: FadeAnimation(
                          1.5,
                          Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                              image: AssetImage('assets/images/clock.png'),
                            )),
                          )),
                    ),
                    Positioned(
                      child: FadeAnimation(
                          1.6,
                          Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.35),
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          )),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
                child: Column(children: [
                  FadeAnimation(
                      1.8,
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 20,
                                  offset: Offset(0, 5))
                            ]),
                        child: Column(children: [
                          textItem("Full Name", nameController, false),
                          SizedBox(
                            height: 10,
                          ),
                          textItem("Email", emailController, false),
                          SizedBox(
                            height: 10,
                          ),
                          textItem("Password", passwordController, true),
                          SizedBox(
                            height: 30,
                          ),
                          FadeAnimation(
                              2,
                              TextButton(
                                onPressed: () async {
                                  setState(() {
                                    name = nameController.text;
                                    email = emailController.text;
                                    password = passwordController.text;
                                  });
                                  await AuthServices().signUpUser(
                                      email, password, name, context);
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(colors: [
                                      Color(0xFFFD746C),
                                      Color(0xFFFF9068),
                                      Color(0xFFFD746C),
                                    ]),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Create Account",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )),
                          // SizedBox(
                          //   height: 10,
                          // ),
                          FadeAnimation(
                              1.5,
                              Text(
                                "Already have an account ?",
                                style: TextStyle(color: Colors.white),
                              )),
                          FadeAnimation(
                              2.2,
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/Login');
                                },
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: const LinearGradient(colors: [
                                        Color(0xFFFD746C),
                                        Color(0xFFFF9068),
                                        Color(0xFFFD746C),
                                      ])),
                                  child: Center(
                                    child: Text(
                                      "Login",
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )),
                        ]),
                      )),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget textItem(
      String name, TextEditingController controller, bool obsecureText) {
    return Container(
      width: MediaQuery.of(context).size.width - 70,
      height: 55,
      child: TextFormField(
        controller: controller,
        obscureText: obsecureText,
        style: const TextStyle(
          fontSize: 17,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          labelText: name,
          labelStyle: const TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              width: 1.5,
              color: Colors.amber,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
