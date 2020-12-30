import 'package:flutter/material.dart';
import 'package:goaltracker/models/goal.dart';
import 'package:goaltracker/models/profile.dart';
import 'package:goaltracker/models/wall_fire.dart';
import 'package:goaltracker/services/fire/database.dart';
import 'package:goaltracker/style/style.dart';
import 'package:intl/intl.dart';

class WallOfFire extends StatefulWidget {
  final Goal goal;
  final WallFire wallfire;

  const WallOfFire({Key key, this.goal, this.wallfire}) : super(key: key);
  @override
  _WallOfFireState createState() => _WallOfFireState();
}

class _WallOfFireState extends State<WallOfFire> {
  Collection<Profile> profiles = Collection<Profile>(path: 'profiles');
  Collection<Goal> goals = Collection<Goal>(path: 'goals');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: kPrimaryColor,
          ),
        ),
        title: Text(
          'Wall Of Fire',
          style: BigBoldHeading.copyWith(color: Colors.black),
        ),
      ),
      body: FutureBuilder(
        future: profiles.getProfiles(widget.wallfire.members),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            List<Profile> profiles = snapshot.data;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Goal N : ${widget.goal.id}',
                        style: SansHeading,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Container(
                    height: 25,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 25,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  profiles.length > 3 ? 3 : profiles.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  child: CircleAvatar(
                                    radius: 12,
                                    backgroundImage:
                                        NetworkImage(profiles[index].avatar),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        profiles.length > 3
                            ? Text('+ ${profiles.length}')
                            : Container(
                                height: 1,
                              ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 70,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.goal.name,
                        style: SansHeading.copyWith(fontSize: 25),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FutureBuilder(
                    future: goals.getDataByPlayerAndGoal(widget.goal.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Goal> goals = snapshot.data;
                        print(goals.length);
                        return Expanded(
                          child: Container(
                            height: 400,
                            child: ListView.builder(
                                itemCount: goals.length,
                                itemBuilder: (context, index) {
                                  var profile = profiles.firstWhere((element) =>
                                      element.id == goals[index].player);
                                  return Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0.5, color: Colors.grey),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5))),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(profile.avatar),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(profile.fullName,
                                                      style: SansHeading),
                                                  Text(DateFormat.yMd().format(
                                                      goals[index].startDate))
                                                ],
                                              ),
                                              SizedBox(
                                                width: 100,
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    goals[index].status,
                                                    style: SansHeading.copyWith(
                                                        color: goals[index]
                                                                    .status ==
                                                                'Pending'
                                                            ? kSecondaryColor
                                                            : kPrimaryColor),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Container(
                                                    width: 100,
                                                    child:
                                                        LinearProgressIndicator(
                                                      value: goals[index]
                                                              .dateGoals
                                                              .where((element) =>
                                                                  element
                                                                      .status ==
                                                                  true)
                                                              .length /
                                                          goals[index]
                                                              .dateGoals
                                                              .length,
                                                      backgroundColor:
                                                          Color(0xff1c232d),
                                                      valueColor:
                                                          AlwaysStoppedAnimation(
                                                        kPrimaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        );
                      } else
                        return Text('Loading wall of fire...');
                    },
                  )
                ],
              ),
            );
          } else
            return Center(
              child: Text('Loading..'),
            );
        },
      ),
    );
  }
}
