import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:goaltracker/helpers/toast.dart';
import 'package:goaltracker/models/goal.dart';
import 'package:goaltracker/models/wall_fire.dart';
import 'package:goaltracker/screens/goals/wall_fire.dart';
import 'package:goaltracker/services/fire/database.dart';
import 'package:goaltracker/services/fire/global.dart';
import 'package:goaltracker/style/style.dart';
import 'package:provider/provider.dart';

class ExploreGoals extends StatefulWidget {
  @override
  _ExploreGoalsState createState() => _ExploreGoalsState();
}

class _ExploreGoalsState extends State<ExploreGoals> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);
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
            'Explore Goals',
            style: BigBoldHeading.copyWith(color: Colors.black),
          ),
        ),
        body: FutureBuilder(
          future: Global.wallfireRef.getDatabyDateInf('endDate'),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<WallFire> exploreGoals = snapshot.data;
              exploreGoals = exploreGoals
                  .where((element) => !element.members.contains(user.uid))
                  .toList();
              return ListView.builder(
                  itemCount: exploreGoals.length,
                  itemBuilder: (BuildContext context, index) {
                    Document<Goal> goalDoc = Document<Goal>(
                        path: 'goals/${exploreGoals[index].goalID}');
                    Document<Goal> wallDoc = Document<Goal>(
                        path: 'wallfire/${exploreGoals[index].id}');
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: 160,
                        decoration: BoxDecoration(
                          color: Color(0xFFE4E4E8),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: FutureBuilder(
                            future: goalDoc.getData(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                Goal goal = snapshot.data;
                                bool loading = false;
                                return Column(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => WallOfFire(
                                              goal: goal,
                                              wallfire: exploreGoals[index],
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 32, vertical: 16),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              child: SvgPicture.asset(
                                                'assets/images/goal.svg',
                                                height: 60,
                                              ),
                                            ),
                                            Flexible(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      goal.name,
                                                      style: SansHeading,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    //
                                                    Text(
                                                      '+${exploreGoals[index].members.length} users',
                                                      style: WhiteSubtitle
                                                          .copyWith(
                                                              color:
                                                                  Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 64, vertical: 8),
                                      child: RaisedButton(
                                        elevation: 0,
                                        textColor: Colors.white,
                                        onPressed: () async {
                                          setState(() {
                                            loading = true;
                                          });

                                          var newGoal = Goal(
                                            name: goal.name,
                                            description: goal.description,
                                            owner: goal.owner,
                                            player: user.uid,
                                            originalId: goal.id,
                                            status: 'Pending',
                                            target: goal.target,
                                            dateGoals: goal.dateGoals.map((e) {
                                              e.status = false;
                                              return e;
                                            }).toList(),
                                            startDate: goal.startDate,
                                            endDate: goal.endDate,
                                            public: goal.public,
                                          );

                                          await Global.goalsRef
                                              .upsert(newGoal.toMap());

                                          DocumentReference newDocRef =
                                              DatabaseService(
                                                      path:
                                                          '/profiles/${user.uid}')
                                                  .createRef();

                                          await wallDoc.upsert(
                                            ({
                                              'members': FieldValue.arrayUnion(
                                                  [newDocRef])
                                            }),
                                          );
                                          // List<String> members = [];
                                          // members.add(user.uid);
                                          // var wallfire = WallFire(
                                          //     goalID: res.id, members: members);

                                          // await Global.wallfireRef
                                          //     .upsert(wallfire.toMap());

                                          toast(
                                              'New Goal Successfully from explore');

                                          setState(() {
                                            loading = false;
                                          });

                                          Navigator.pop(context);
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(),
                                            Text(
                                              'Add Goal',
                                              style: WhiteSubtitle.copyWith(
                                                  fontSize: 20),
                                            ),
                                            !loading
                                                ? Icon(Icons.add)
                                                : CircularProgressIndicator()
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else
                                return Center(
                                  child: Text('Loading goal...'),
                                );
                            }),
                      ),
                    );
                  });
            } else
              return Center(
                child: Text('Loading..'),
              );
          },
        ));
  }
}
