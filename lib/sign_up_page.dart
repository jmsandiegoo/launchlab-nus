import 'package:flutter/material.dart';
import 'package:prototype/home_page.dart';
import 'package:prototype/login_page.dart';
import 'package:prototype/main.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPage createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  String degreeTypeVal = "Bachelor's";

  var degreeType = [
    "Bachelor's",
    "Master's",
    'Doctor of Philosophy',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              _navigateToLoginPage(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            )),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  //Sign up title is here
                  Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          Text(
                            "Sign up",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                        ],
                      ),


                      //Text Field are here
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: [
                            makeInput(
                              label: "First Name",
                            ),
                            makeInput(label: "Last Name"),
                            makeInput(label: "Current Institution"),
                            makeInput(label: "Major"),
                            makeInput(label: "Enrollment Year"),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              const Text("Degree Type:",
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87
                                  )
                              ),
                              DropdownButton(
                                isExpanded: true,
                                value: degreeTypeVal,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: degreeType.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    degreeTypeVal = newValue!;
                                  });
                                },
                              ),
                            ])
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),


                      //Sign up Button goes here
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            onPressed: () {
                              _navigateToHomePage(context);
                            },
                            //To be edited
                            color: const Color(0xFFFFD84E),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40)),
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      /*
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("Already have an account? "),
                          Text(
                            "Login here",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ],
                      ) */
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToHomePage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const RootPage()));
  }

  void _navigateToLoginPage(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  Widget makeInput({label, obsureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(
          height: 5,
        ),
        TextField(
          obscureText: obsureText,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            border:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          ),
        ),
        const SizedBox(
          height: 30,
        )
      ],
    );
  }
}
