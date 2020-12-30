import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_util/date_util.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goaltracker/models/goal.dart';
import 'package:goaltracker/models/profile.dart';
import 'package:goaltracker/models/wall_fire.dart';
import 'package:goaltracker/screens/goals/goal_detail.dart';
import 'package:goaltracker/screens/goals/new_goal.dart';
import 'package:goaltracker/services/fire/database.dart';
import 'package:goaltracker/services/fire/global.dart';
import 'package:goaltracker/style/style.dart';
// import 'package:habit_tracker/details.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

List<Map<String, dynamic>> habits = [
  {
    'color': kCyanBlue,
    'title': 'YP',
    'fulltext': 'Yoga Practice',
  },
  {
    'color': kPurple,
    'title': 'GE',
    'fulltext': 'Get Up Early',
  },
  {
    'color': kCyanBlue,
    'title': 'NS',
    'fulltext': 'No Sugar',
  },
];

List<Map<String, dynamic>> habits2 = [
  {
    'color': Color(0xff7524ff),
    'objectif': 'Learn 5 new words',
    'progress': '5 from 7 this week'
  },
  {
    'color': Color(0xfff03244),
    'objectif': 'Get Up Early',
    'progress': '5 from 7 this week'
  },
  {
    'color': Color(0xff00d5e2),
    'objectif': 'Create an App a day',
    'progress': '6 from 7 this week'
  },
];

class MainGoals extends StatefulWidget {
  @override
  _MainGoalsState createState() => _MainGoalsState();
}

class _MainGoalsState extends State<MainGoals> {
  int selected = 0;
  // Collection<Goal> _col = Collection(path: 'goals');

  DateTime selectedDate = DateTime.now();
  // DateTime selectedDate = DateTime(DateTime.now().year, DateTime.now().month,
  //     DateTime.now().day, 0, 0, 0, 0, 0);
  @override
  Widget build(BuildContext context) {
    var profile = Provider.of<Profile>(context);
    var user = Provider.of<User>(context);
    var dateUtility = DateUtil();

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 25.0, left: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RichText(
                        softWrap: true,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Most Popular",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 25,
                              ),
                            ),
                            TextSpan(
                              text: " Habits",
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewGoalScreen()));
                        },
                        child: Container(
                          padding: EdgeInsets.all(9.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kPrimaryColor,
                            boxShadow: [
                              BoxShadow(
                                  color: kPrimaryColor,
                                  offset: Offset(0, 3),
                                  blurRadius: 5.0),
                            ],
                          ),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 25.0,
                    )
                  ],
                ),
                SizedBox(
                  height: 35.0,
                ),
                Container(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: habits.length,
                    itemBuilder: (ctx, id) {
                      return Container(
                        width: 150,
                        margin:
                            EdgeInsets.only(right: 15.0, top: 9.0, bottom: 9.0),
                        padding: EdgeInsets.all(13.0),
                        decoration: BoxDecoration(
                          color: habits[id]['color'],
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: habits[id]['color'],
                              blurRadius: 5.0,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              habits[id]['title'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 27,
                                  color: Colors.white),
                            ),
                            Text(
                              habits[id]['fulltext'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 35.0,
                ),
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
                            setState(() {
                              selected = f;
                              selectedDate =
                                  DateTime.now().add(Duration(days: f));
                            });
                          },
                          child: Container(
                            width: 90,
                            height: 90,
                            margin: EdgeInsets.only(right: 15.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: selected == f
                                  ? kPrimaryColor
                                  : Color(0xff131b26),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            padding: EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "${dateUtility.daysInMonth(DateTime.now().month, DateTime.now().year) >= (DateTime.now().day + f) ? (DateTime.now().day + f) : (DateTime.now().day + f) % dateUtility.daysInMonth(DateTime.now().month, DateTime.now().year)}",
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
                  height: 35.0,
                ),
                FutureBuilder(
                  future:
                      Global.goalsRef.getDataByPlayer(user.uid, selectedDate),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List<Goal> goals = snapshot.data;
                      print(goals);
                      return Container(
                        height: 500,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Your Habits ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 21,
                                            color: Colors.black),
                                      ),
                                      TextSpan(
                                        text: '${goals.length}',
                                        style: TextStyle(
                                          color: Colors.grey[500],
                                          fontSize: 21,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                profile != null
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(right: 16.0),
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(
                                            profile.avatar,
                                          ),
                                        ),
                                      )
                                    : null
                              ],
                            ),
                            Expanded(
                              child: Container(
                                height: 300,
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: goals.length,
                                  itemBuilder: (ctx, id) {
                                    var startToday = DateTime(
                                        selectedDate.year,
                                        selectedDate.month,
                                        selectedDate.day,
                                        0,
                                        0,
                                        0,
                                        0,
                                        0);

                                    var endToday = DateTime(
                                        selectedDate.year,
                                        selectedDate.month,
                                        selectedDate.day,
                                        23,
                                        59,
                                        59,
                                        0,
                                        0);

                                    var exists = goals[id].dateGoals.indexWhere(
                                        (element) =>
                                            element.date.isAfter(startToday) &&
                                            element.date.isBefore(endToday));

                                    print(exists);

                                    if (exists >= 0) {
                                      return ListItem(
                                        dateG: goals[id].dateGoals[exists],
                                        goal: goals[id],
                                      );
                                    } else
                                      return null;
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    } else
                      return Center(
                        child: Text('Loading Goals...'),
                      );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListItem extends StatefulWidget {
  final DateGoal dateG;
  final Goal goal;

  const ListItem({Key key, this.dateG, this.goal}) : super(key: key);

  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    Document<Goal> docRef = Document<Goal>(path: 'goals/${widget.goal.id}');
    return Container(
      // height: 150,
      margin: EdgeInsets.symmetric(vertical: 21.0),
      padding: EdgeInsets.only(right: 25.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              InkWell(
                onTap: () async {
                  setState(() {
                    widget.dateG.status = !widget.dateG.status;
                  });

                  print(widget.dateG.date);
                  print(widget.dateG.status);

                  await docRef.upsert(({
                    'dateGoals':
                        widget.goal.dateGoals.map((e) => e.toJson()).toList()
                  }));
                },
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.dateG.status == true
                        ? kPrimaryColor
                        : Colors.transparent,
                    border: widget.dateG.status == true
                        ? Border()
                        : Border.all(
                            color: Colors.grey[500],
                          ),
                  ),
                  child: Icon(
                    Icons.check,
                    color: widget.dateG.status == true
                        ? Colors.white
                        : Colors.grey[500],
                  ),
                ),
              ),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Details()));
                    },
                    child: Text(
                      widget.goal.name,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 19),
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    '${widget.goal.dateGoals.where((element) => element.status == true).length} from ${widget.goal.target}',
                    style: TextStyle(color: Colors.grey[500], fontSize: 17),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              )
            ],
          ),
          LinearProgressIndicator(
            value: widget.goal.dateGoals
                    .where((element) => element.status == true)
                    .length /
                widget.goal.dateGoals.length,
            backgroundColor: Color(0xff1c232d),
            valueColor: AlwaysStoppedAnimation(
              kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
