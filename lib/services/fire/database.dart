import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:goaltracker/services/fire/global.dart';
import 'package:rxdart/rxdart.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String path;

  DocumentReference ref;

  DatabaseService({this.path}) {
    ref = _db.doc(path);
  }

  DocumentReference createRef() {
    return ref;
  }
}

class SubCategory<T> {
  Future<List<T>> getSubSubData(List<DocumentReference> listRef) {
    print('INTERIEUR FUTURE');
    print(listRef);
    return Future.wait(listRef
        .map((ref) => ref.get().then((doc) {
              print('THE DATA');
              print(doc.data());
              return Global.models[T]({'id': doc.id, ...doc.data()}) as T;
            }))
        .toList());
  }
}

class Document<T> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String path;

  DocumentReference ref;

  Document({this.path}) {
    ref = _db.doc(path);
  }

  Future<T> getData() {
    return ref
        .get()
        .then((doc) => Global.models[T]({'id': doc.id, ...doc.data()}) as T);
  }

  // Future<List<T>> getSubSubData(List<DocumentReference> listRef) {
  //   return Future.wait(listRef.map(
  //       (ref) => ref.get().then((doc) => Global.models[T](doc.data()) as T)));
  // }

  // List<Future<T>> getSubData(List<DocumentReference> listRef) {
  //   return listRef
  //       .map(
  //           (ref) => ref.get().then((doc) => Global.models[T](doc.data()) as T))
  //       .toList();
  // }

  Stream<T> streamData() {
    return ref
        .snapshots()
        .map((doc) => Global.models[T]({'id': doc.id, ...doc.data()}) as T);
  }

  Future<void> upsert(Map data) {
    return ref.set(Map<String, dynamic>.from(data), SetOptions(merge: true));
  }
}

class Collection<T> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String path;
  CollectionReference ref;

  Collection({this.path}) {
    ref = _db.collection(path);
  }

  Future<List<T>> getData() async {
    // print('HERE IS THE SNAPSHOT');
    var snapshots = await ref.get();
    // print(snapshots.docs.map((doc) => doc.data()).toList());
    return snapshots.docs
        .map((doc) => Global.models[T]({'id': doc.id, ...doc.data()}) as T)
        .toList();
  }

  Future<List<T>> getDataById(String field, String uid) async {
    // print('HERE IS THE SNAPSHOT');
    var snapshots = await ref.where(field, isEqualTo: uid).get();
    print(snapshots.docs.map((doc) => doc.data()).toList());
    return snapshots.docs
        .map((doc) => Global.models[T]({'id': doc.id, ...doc.data()}) as T)
        .toList();
  }

  Future<List<T>> getDatabyDateInf(String field) async {
    // print('HERE IS THE SNAPSHOT');
    var snapshots = await ref
        .where(field, isLessThan: Timestamp.fromDate(DateTime.now()))
        .get();
    print(snapshots.docs.map((doc) => doc.data()).toList());
    return snapshots.docs
        .map((doc) => Global.models[T]({'id': doc.id, ...doc.data()}) as T)
        .toList();
  }

  Stream<List<T>> streamData() {
    return ref.snapshots().map((event) => event.docs
        .map((doc) => Global.models[T]({'id': doc.id, ...doc.data()}) as T));
  }
}

class UserData<T> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String collection;

  UserData({this.collection});

  Stream<T> get documentStream {
    return _auth.authStateChanges().switchMap((user) {
      if (user != null) {
        Document<T> doc = Document<T>(path: '$collection/${user.uid}');
        return doc.streamData();
      } else {
        return Stream<T>.value(null);
      }
    });
  }

  Future<T> getDocument() async {
    User user = _auth.currentUser;
    if (user != null) {
      Document doc = Document<T>(path: '$collection/${user.uid}');
      return doc.getData();
    } else {
      return null;
    }
  }

  Future<void> upsert(Map data) async {
    User user = _auth.currentUser;
    Document<T> ref = Document(path: '$collection/${user.uid}');
    return ref.upsert(data);
  }
}
