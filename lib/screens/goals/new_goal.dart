import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:goaltracker/helpers/toast.dart';
import 'package:goaltracker/models/goal.dart';
import 'package:goaltracker/models/wall_fire.dart';
import 'package:goaltracker/services/fire/auth.dart';
import 'package:goaltracker/services/fire/database.dart';
import 'package:goaltracker/services/fire/global.dart';
import 'package:goaltracker/style/style.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class NewGoalScreen extends StatefulWidget {
  static const routename = "/goals";

  @override
  _NewGoalScreenState createState() => _NewGoalScreenState();
}

class _NewGoalScreenState extends State<NewGoalScreen> {
  AuthService _auth = AuthService();

  bool dropDownButtonValue = false;

  bool loading = false;

  List<int> dates = [];

  final _formKey = GlobalKey<FormState>();

  TextEditingController _name = TextEditingController();
  TextEditingController _description = TextEditingController();
  // TextEditingController _date = TextEditingController();
  // TextEditingController _pass = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: PrimaryRed,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
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

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Create a new Goal',
                  style: BigBoldHeading,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextFormField(
                controller: _name,
                autofillHints: [
                  AutofillHints.name,
                ],
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.check),
                  hintText: 'Goal Name',
                ),
                validator: (value) {
                  if (value == '') {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.filter_alt,
                  ),
                ),
                hint: Text('Type'),
                // validator: (value) {
                //   if (dropDownButtonValue != "Male" || dropDownButtonValue != "Female") {
                //     return "Please select gender";
                //   }
                // },
                onChanged: (value) {
                  setState(() {
                    dropDownButtonValue = value;
                    print(value);
                  });
                },
                items: [
                  DropdownMenuItem(
                    child: Text('Public'),
                    value: true,
                  ),
                  DropdownMenuItem(
                    child: Text('Private'),
                    value: false,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _description,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.description),
                  hintText: 'Description',
                ),
                validator: (value) {
                  if (value == '') {
                    return 'This field is required';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 30,
              ),
              // Container(
              //   padding: EdgeInsets.symmetric(horizontal: 10),
              //   decoration: BoxDecoration(
              //       color: kDarkBlue,
              //       borderRadius: BorderRadius.only(
              //           topLeft: Radius.circular(30),
              //           bottomLeft: Radius.circular(30))),
              //   height: 80,
              //   child: ListView.builder(
              //       scrollDirection: Axis.horizontal,
              //       itemCount: 8,
              //       itemBuilder: (BuildContext context, index) {
              //         return Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Container(
              //             height: 60,
              //             width: 60,
              //             decoration: BoxDecoration(
              //                 color: kPrimaryColor,
              //                 borderRadius: BorderRadius.all(Radius.circular(
              //                   5,
              //                 ))),
              //             child: Center(
              //                 child: Column(
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: [Text('1'), Text('Jan')],
              //             )),
              //           ),
              //         );
              //       }),
              // ),

              Container(
                height: 90,
                decoration: BoxDecoration(
                  color: kDarkBlue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                ),
                padding: EdgeInsets.all(15),
                child: ListView.builder(
                  itemCount: 7,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, f) {
                    int day = DateTime.now().day + f;

                    return FittedBox(
                      child: GestureDetector(
                        onTap: () {
                          if (dates.indexOf(f) < 0) {
                            setState(() {
                              dates.add(f);
                            });
                          } else {
                            setState(() {
                              dates.remove(f);
                            });
                          }
                          print(dates);
                        },
                        child: Container(
                          width: 90,
                          height: 90,
                          margin: EdgeInsets.only(right: 15.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: dates.indexOf(f) > -1
                                ? kPrimaryColor
                                : Color(0xff131b26),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          padding: EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "${DateTime.now().day + f}",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: day == DateTime.now().day
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: day == DateTime.now().day
                                      ? Colors.white
                                      : Colors.grey[500],
                                ),
                              ),
                              Text(
                                DateFormat('EE').format(
                                  DateTime.now().add(
                                    Duration(days: f),
                                  ),
                                ),
                                style: TextStyle(
                                    color: day == DateTime.now().day
                                        ? Colors.white
                                        : Colors.grey[700],
                                    fontWeight: day == DateTime.now().day
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(
                height: 40,
              ),
              loading == true
                  ? CircularProgressIndicator()
                  : Container(
                      width: MediaQuery.of(context).size.width,
                      height: 45,
                      child: RaisedButton(
                        elevation: 0,
                        textColor: Colors.white,
                        onPressed: () async {
                          setState(() {
                            loading = true;
                          });

                          if (!_formKey.currentState.validate()) {
                            setState(() {
                              loading = false;
                            });
                            return;
                          }

                          var user = Provider.of<User>(context, listen: false);

                          List<DateGoal> goals = dates
                              .map((e) => DateGoal(
                                    date: DateTime.now().add(
                                      Duration(days: e),
                                    ),
                                    status: false,
                                  ))
                              .toList();

                          int biggest = dates.reduce(max);

                          var time = DateTime.now();
                          var goal = Goal(
                            name: _name.text,
                            description: _description.text,
                            owner: user.uid,
                            player: user.uid,
                            originalId: 'original${user.uid}',
                            status: 'Pending',
                            target: dates.length,
                            dateGoals: goals,
                            startDate: DateTime(
                                time.year, time.month, time.day, 0, 0, 0, 0, 0),
                            endDate: DateTime(time.year, time.month, time.day,
                                    23, 59, 59, 0, 0)
                                .add(
                              Duration(days: biggest),
                            ),
                            public: dropDownButtonValue,
                          );

                          DocumentReference res =
                              await Global.goalsRef.upsert(goal.toMap());

                          List<DocumentReference> members = [];
                          DocumentReference newDocRef =
                              DatabaseService(path: '/profiles/${user.uid}')
                                  .createRef();

                          members.add(newDocRef);
                          var wallfire = WallFire(
                              goalID: res.id,
                              members: members,
                              startDate: goal.startDate,
                              endDate: goal.endDate);

                          await Global.wallfireRef.upsert(wallfire.toMap());

                          var goalDoc =
                              Document<Goal>(path: '/goals/${res.id}');
                          await goalDoc.upsert({'originalId': res.id});

                          toast('New Goal Successfully added');

                          setState(() {
                            loading = false;
                          });

                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(),
                            Text('Create New Goal'),
                            Icon(Icons.exit_to_app)
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
            ],
          ),
        ),
      ),
    );
  }
}
