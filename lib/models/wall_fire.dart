import 'package:cloud_firestore/cloud_firestore.dart';

class WallFire {
  String id;
  String goalID;
  DateTime startDate;
  DateTime endDate;
  List<DocumentReference> members;
  WallFire({this.id, this.goalID, this.members, this.startDate, this.endDate});

  WallFire.fromMap(Map data) {
    id = data['id'] ?? '';
    goalID = data['goalID'] ?? '';
    members = (data['members'] as List ?? [])
        .map((v) => v as DocumentReference)
        .toList();
    startDate = (data['startDate'] as Timestamp).toDate() ?? '';
    endDate = (data['endDate'] as Timestamp).toDate() ?? '';
  }
  Map<String, dynamic> toMap() => {
        "goalID": goalID,
        "members": members,
        'startDate': Timestamp.fromDate(startDate),
        "endDate": Timestamp.fromDate(endDate),
      };
}
