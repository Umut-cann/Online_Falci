// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:oyunn/service/DatabaseService.dart';
import 'package:oyunn/views/Fallarim_page.dart';
import 'package:oyunn/widgets/constants.dart';

class MyWidget extends StatefulWidget {
  final List photo;
  final String sender;
  final String tur;
  final String comment;
  final String falname;
  const MyWidget({
    Key? key,
    required this.photo,
    required this.sender,
    required this.tur,
    required this.comment,
    required this.falname,
  }) : super(key: key);

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late Future<List<DocumentSnapshot>> _fortunesFuture;
  @override
  @override
  void initState() {
    super.initState();
    _fortunesFuture = _getFortunes();
  }

  Future<List<DocumentSnapshot>> _getFortunes() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection("fortuneTellings").get();
    return snapshot.docs;
  }

  TextEditingController _controller = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("comment",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          centerTitle: true,
        ),
        body: Column(children: [
          //Text(widget.sender),
          Text(widget.tur),
          //Text(widget.falname),
          Text("fal yorumu ${widget.comment}"),

          SizedBox(
            height: 100,
            width: 600,
            child: widget.photo.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.photo.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Image.network(
                          widget.photo[index].toString(),
                          height: 100,
                          width: 80,
                          fit: BoxFit.fill,
                        ),
                      );
                    },
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 8),
                      Text('Fotoğraf yüklenirken bir hata oluştu.'),
                    ],
                  ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(),
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                        .addComment(widget.falname, _controller.text);

                    nextScreenReplace(context, const FallarimPage());
                  },
                  child: const Center(child: Text("submit ")))
            ],
          ),
        ]));
  }
}

Widget buildPhotoWidget(Map<String, dynamic> data) {
  List<dynamic>? photoUrls = data['photographs'];

  print(photoUrls?.length);
  return SizedBox(
    height: 100,
    width: 600,
    child: photoUrls != null && photoUrls.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: photoUrls.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Image.network(
                  photoUrls[index].toString(),
                  height: 100, 
                  width: 80, 
                  fit: BoxFit.fill,
                ),
              );
            },
          )
        : const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 8),
              Text('Fotoğraf yüklenirken bir hata oluştu.'),
            ],
          ),
  );
}
