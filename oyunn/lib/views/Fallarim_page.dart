
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:oyunn/service/databaseService.dart';

class FallarimPage extends StatefulWidget {
  const FallarimPage({Key? key}) : super(key: key);

  @override
  State<FallarimPage> createState() => _FallarimPageState();
}

class _FallarimPageState extends State<FallarimPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.brown,
        title: const Text(
          "Fallarim",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: const Column(
        children: [
          Center(
            child: Text("Fallarim page"),
          ),
        ],
      ),
    );
  }

  falList() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserfals();
  }
}

class DisplayImagesPage extends StatefulWidget {
  const DisplayImagesPage({Key? key}) : super(key: key);

  @override
  _DisplayImagesPageState createState() => _DisplayImagesPageState();
}

class _DisplayImagesPageState extends State<DisplayImagesPage> {
  List<String> photoUrls = [];

  @override
  void initState() {
    super.initState();

    getPhotoUrls();
  }

  Future<void> getPhotoUrls() async {
    try {
   
      Reference storageReference = FirebaseStorage.instance.ref();
      Reference imagesReference = storageReference.child('fortunes');

   
      ListResult result = await imagesReference.listAll();

      
      for (Reference ref in result.items) {
        String downloadURL = await ref.getDownloadURL();
        photoUrls.add(downloadURL);
      }
      print("resimler alınıyor");
      
      setState(() {});
    } catch (e) {
      print("Hata: Resim URL'leri alınırken bir hata oluştu: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Storage'dan Resimler"),
      ),
      body: ListView.builder(
        itemCount: photoUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(photoUrls[index]),
          );
        },
      ),
    );
  }
}

class Deneme extends StatefulWidget {
  const Deneme({Key? key}) : super(key: key);

  @override
  State<Deneme> createState() => _DenemeState();
}

class _DenemeState extends State<Deneme> {
  late Future<List<dynamic>> _futureList;

  @override
  void initState() {
    super.initState();
    _futureList = fallarim();
  }

  Future<List<dynamic>> fallarim() async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    return DatabaseService(uid: id).myFortune();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[300],
        title: const Text(
          "Fallarim ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body:   Center(
        child: FutureBuilder<List<dynamic>>(
          future: _futureList,
          builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return 
              
             const Text('Haydi ilk falini gönder');
            } else {
              List<dynamic> list = snapshot.data!;
              return ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  DateTime falDateTime = DateTime.fromMicrosecondsSinceEpoch(int.parse(list[index]["falName"]));
                  return Card(
                    color: list[index]['comment'].toString().isNotEmpty ? Colors.brown[100] : Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      onTap: () {
                        if (list[index]['comment'].toString().isNotEmpty) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return SingleChildScrollView(
                                padding: const EdgeInsets.all(28),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    color: Colors.blueGrey,
                                  ),
                                  padding: const EdgeInsets.all(20),
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      ListTile(
                                        leading: IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(Icons.clear),
                                        ),
                                      ),
                                      Text(list[index]['comment'])
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                      leading: const Icon(Icons.message),
                      title: Text("${falDateTime.day}/${falDateTime.month }/${falDateTime.year} ${falDateTime.hour+3}:${falDateTime.minute}"),
                      subtitle: Text(list[index]["comment"]),
                      trailing: Text(
                        list[index]['comment'].toString().isNotEmpty ? "Yorumlandı" : "Falin hazırlanıyor ...",
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
