import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  DateTime startDate;
  DateTime endDate;
  String description;
  String id;
  String name;
  String owner;
  String player;
  String status;
  String originalId; // refers to the original goal ID
  int target;
  List<DateGoal> dateGoals;
  bool public;

  Goal(
      {this.id,
      this.name,
      this.status,
      this.description,
      this.target,
      this.owner,
      this.player,
      this.dateGoals,
      this.originalId,
      this.startDate,
      this.endDate,
      this.public});

  Goal.fromMap(Map data) {
    id = data['id'] ?? '';
    description = data['description'] ?? '';
    status = data['status'] ?? '';
    name = data['name'] ?? '';
    dateGoals = (data['dateGoals'] as List ?? [])
        .map((v) => DateGoal.fromMap(v))
        .toList();
    target = data['target'] ?? 0;
    startDate = (data['startDate'] as Timestamp).toDate() ?? '';
    endDate = (data['endDate'] as Timestamp).toDate() ?? '';
    owner = data['owner'] ?? '';
    player = data['player'] ?? '';
    originalId = data['originalId'] ?? '';
    public = data['public'] ?? false;
  }

  Map<String, dynamic> toMap() => {
        // "created": created.toIso8601String(),
        // "appointments": List<dynamic>.from(appointments.map((x) => x)),
        // "reviews": List<dynamic>.from(reviews.map((x) => x)),
        // "favourites": List<dynamic>.from(favourites.map((x) => x)),
        "name": name,
        // "salt": salt,
        // "hashed_password": hashedPassword,
        "status": status,
        "target": target,
        "dateGoals": dateGoals.map((dg) => dg.toJson()).toList(),
        'startDate': Timestamp.fromDate(startDate),
        "endDate": Timestamp.fromDate(endDate),
        "owner": owner,
        "description": description,
        "originalId": originalId,
        "player": player,
        "public": public,

        // "__v": v,
      };

  Map toJson() => {
        "name": name,
        "status": status,
        "target": target,
        "dateGoals": dateGoals,
        'startDate': Timestamp.fromDate(startDate),
        "endDate": Timestamp.fromDate(endDate),
        "owner": owner,
        "description": description,
      };
}

class DateGoal {
  bool status;
  DateTime date;

  DateGoal({this.status, this.date});

  DateGoal.fromMap(Map data) {
    status = data['status'] ?? '';
    date = (data['date'] as Timestamp).toDate() ?? '';
  }

  Map toJson() => {"date": Timestamp.fromDate(date), "status": status};
}
