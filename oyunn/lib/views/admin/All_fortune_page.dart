
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oyunn/views/admin/comment.dart';
import 'package:oyunn/widgets/constants.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late Future<List<DocumentSnapshot>> _fortunesFuture;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Panel"),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder<List<DocumentSnapshot>>(
        future: _fortunesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
             return const Center(
              child: CircularProgressIndicator(color: Colors.black87),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          List<DocumentSnapshot> documents = snapshot.data!;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> data =
                  documents[index].data() as Map<String, dynamic>;
           

              return ListTile(
              title: Text(data["sender"]), 
                subtitle: Text("Kind: ${data['kind']}"),
                onTap: () {
              

                  nextScreen(context,  MyWidget(

                    comment: data ['comment'],
                    falname: data['falName'],
                   tur: data['kind'],  sender: data['sender'], photo: data['photographs'],
                          

                  ));
                  
                },
              );
            },
          );
        },
      ),
    );
  }

  void _showFortuneDetailsDialog(Map<String, dynamic> data) {
      List<dynamic>? photoUrls = data['photographs'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Fortune Details"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("User: ${data['sender']}"),
              Text("Kind: ${data['kind']}"),

Text(data['photographs'].toString()),
              buildPhotoWidget(data),

            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _showCommentDialog(data['sender']);
              },
              child: const Text("Add Comment"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _showCommentDialog(String userId) {
    String comment = "";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Comment"),
          content: TextField(
            onChanged: (value) {
              comment = value;
            },
            decoration: const InputDecoration(labelText: "yorum ekle"),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (comment.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection("fortuneTellings")
                      .doc(userId)
                      .update({"comment": comment});

                  Navigator.of(context).pop();
                } else {
                 
                  print("yorum boş olmaz");
                }
              },
              child: const Text("yorum ekle"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }
}

class FortuneTellingDetails extends StatelessWidget {
  final List<String> photoUrls;

  FortuneTellingDetails({required this.photoUrls});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fal detaylari'),
      ),
      body: ListView.builder(
        itemCount: photoUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(
              photoUrls[index],
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}


Widget buildPhotoWidget(Map<String, dynamic> data) {
  List<dynamic>? photoUrls = data['photographs'];

  print(photoUrls?.length);
  return Container(
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
