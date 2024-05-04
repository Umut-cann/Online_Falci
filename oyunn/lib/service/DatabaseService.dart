import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';


late String fullname = "";

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference fortuneCollection =
      FirebaseFirestore.instance.collection("fortuneTellings");



  Future savingUserData(String fullname, String email) async {
    fullname = fullname;
    return await userCollection.doc(uid).set({
      "fullname": fullname,
      "email": email,
      "fortuneTellings": [],
      "profilepic": "",
      "uid": uid,
    });
  }

  Future gettingUserData(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();

    return snapshot;
  }

  getUserfals() async {
    return userCollection.doc(uid).snapshots();
  }


  Future<List<dynamic>> getFortuneTellings(String uid) async {
    var userData =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userData.exists) {
    
      List<dynamic> fortuneTellings = userData.data()?['fortuneTellings'];

      if (fortuneTellings.contains("")) {
        print("icnde var");
      }

      return fortuneTellings;
    } else {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> myFortune() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    List myFortunelist = await getFortuneTellings(id);

    QuerySnapshot querySnapshot =
        await fortuneCollection.where("falName", whereIn: myFortunelist).get();

    List<Map<String, dynamic>> result = [];
    if (querySnapshot.docs.isNotEmpty) {
      for (DocumentSnapshot document in querySnapshot.docs) {
        
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        result.add(data);
      }
    } else {
    
      print("Belge bulunamadı");
    }

    return result;
  }

  Future<void> createFortuneTelling(String userName, String id, String kind,
      List<File?> selectedPhotos) async {
    QuerySnapshot snapshot =
        await userCollection.where("fullname", isEqualTo: uid).get();

  
    print("fotolar yükleniyor");
    List<String> photoUrls =
       await uploadPhotosToFirebaseStorage(id, selectedPhotos, userName);
    print("basarili");


    var faltime = DateTime.now().microsecondsSinceEpoch;
    DocumentReference fortunedocumentReference = await fortuneCollection.add({
      "falName": faltime.toString(),
      "kind": kind,
      "sender": "${id}_$userName",
     "photographs": photoUrls,
      "comment": "",
    });

    await userCollection.doc(id).update({
      "fortuneTellings": FieldValue.arrayUnion([faltime.toString()])
    });

    print("Fal oluşturuldu");
  }

  Future<List<String>> uploadPhotosToFirebaseStorage(
      String userId, List<File?> photos, String username) async {
    List<String> photoUrls = [];

    for (int i = 0; i < photos.length; i++) {
      if (photos[i] != null) {
        File imageFile = photos[i]!;
        String filename = DateTime.now().microsecondsSinceEpoch.toString();

     
        Reference storageReference = FirebaseStorage.instance.ref();
        Reference images = storageReference.child('yeni');
        Reference upload = images.child(filename);

        try {
        
          TaskSnapshot uploadTask = await upload.putFile(File(imageFile.path));

  
          String downloadURL = await uploadTask.ref.getDownloadURL();
          photoUrls.add(downloadURL);

          print("Uploaded photo: $downloadURL");
        } catch (e) {
          print("Error uploading image: $e");
         
        }
      }
    }

    print("Uploaded photo URLs: $photoUrls");
    return photoUrls;
  }


  Future<void> addComment(String falName, String comment) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("fortuneTellings")
          .where("falName", isEqualTo: falName)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
       
        DocumentReference falDocumentRef = querySnapshot.docs.first.reference;
        await falDocumentRef.update({"comment": comment});
        print(" yorum  basarili!");
      } else {
    
        print("Belge bulunamadı: $falName");
      }
    } catch (e) {
      
      print("Hata oluştu: $e");
      print("İşlem tamamlanamadı. Lütfen daha sonra tekrar deneyin.");
    }
  }

  Future<dynamic> Readcomment() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').get();
    snapshot.docs;

    var a =
        await userCollection.doc(FirebaseAuth.instance.currentUser!.uid).get();

    print(a.data);

    List<QueryDocumentSnapshot<Object?>> Data = snapshot.docs;

    if (Data.isNotEmpty) {}
  }
}


