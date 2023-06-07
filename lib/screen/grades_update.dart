import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GradesManager {
  final db = FirebaseFirestore.instance;

  Future<void> grade(String termid, String subject, String grades) async {
    late String docid;
    final userUid = FirebaseAuth.instance.currentUser?.uid;

    final query = await db.collection("학생").where("uuid", isEqualTo: userUid).get();
    docid = query.docs.first.id;
    print("docid: $docid");

    final data = await db.collection("학생").doc(docid).get();
    final dbFavorite = data['favorite'];
    final subjectMap=dbFavorite[termid][subject];
    print(subjectMap['점수']);
    subjectMap['점수']=grades;

    await db.collection("학생").doc(docid).update({
      "favorite": dbFavorite,
    });
  }

  Future<String> getUserUid() async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        return FirebaseAuth.instance.currentUser!.uid;
      } else {
        return "No user found";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        print("user not found");
        return e.code;
      } else {
        throw e;
      }
    }
  }
}