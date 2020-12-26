import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:goaltracker/screens/auth/register.dart';
import 'package:goaltracker/screens/home/home.dart';
import 'package:goaltracker/services/fire/auth.dart';
import 'package:goaltracker/style/style.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  AuthService _auth = AuthService();
  final TextEditingController _email = TextEditingController();

  final TextEditingController _pass = TextEditingController();

  bool _isLoading = false;
  bool loadingGoogle = false;

  bool hidden = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Container(
            margin: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.1,
                // ),
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: Text(
                //     'Bssahtek',
                //     style: BigBoldHeading,
                //   ),
                // ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Let\'s Sign You In',
                    style: BigBoldHeading,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Welcome back we\'ve 100+ new donors added everyday!',
                    style: GreySubtitle.copyWith(fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: [
                          AutofillHints.email,
                        ],
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          hintText: 'Email',
                        ),
                        validator: (String value) {
                          if (value == '') {
                            return 'This field is required';
                          }
                          if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                          ).hasMatch(value)) {
                            return 'Please enter correct email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        controller: _pass,
                        obscureText: hidden,
                        obscuringCharacter: "*",
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock),
                          hintText: 'Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                hidden = !hidden;
                              });
                            },
                            icon: Icon(
                              hidden ? Icons.visibility_off : Icons.visibility,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == '') {
                            return 'This field is required';
                          }
                          if (value.length < 8) {
                            return 'Password length must be atleast 8 characters long';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
                (_isLoading)
                    ? CircularProgressIndicator()
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        child: RaisedButton(
                          elevation: 0,
                          textColor: Colors.white,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                _isLoading = true;
                              });

                              var data = {
                                "email": _email.text,
                                "password": _pass.text,
                              };

                              print(data);

                              var result =
                                  await _auth.signInWithEmailandPassword(
                                      _email.text, _pass.text);

                              if (result == null) {
                                print('ERROR LOGIN WITH EMAIL AND PASSWORD');
                                setState(() {
                                  _isLoading = false;
                                });
                              } else {
                                setState(() {
                                  _isLoading = false;
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              }

                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(),
                              Text('SIGN IN'),
                              Icon(Icons.exit_to_app)
                            ],
                          ),
                        ),
                      ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => RegScreen()));
                  },
                  child: RichText(
                    text: TextSpan(
                      style: GreySubtitle,
                      text: "DON'T HAVE AN ACCOUNT? ",
                      children: [
                        TextSpan(
                          style: GreySubtitle.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                          text: "SIGN UP",
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 40,
                ),
                loadingGoogle == true
                    ? CircularProgressIndicator()
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        child: RaisedButton(
                          elevation: 0,
                          textColor: Colors.white,
                          color: Colors.blue,
                          onPressed: () async {
                            setState(() {
                              loadingGoogle = true;
                            });

                            var result = await _auth.signInWithGoogle();
                            if (result == null) {
                              setState(() {
                                loadingGoogle = false;
                              });
                              print('GOOGLE SIGN IN IN ERROR');
                            } else {
                              setState(() {
                                loadingGoogle = false;
                              });

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()));
                            }

                            setState(() {
                              loadingGoogle = false;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('LOGIN WITH GOOGLE'),
                              SizedBox(
                                width: 10,
                              ),
                              Icon(
                                FontAwesomeIcons.google,
                                size: 18,
                              )
                            ],
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
