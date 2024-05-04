import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:oyunn/controller/helper.dart';
import 'package:oyunn/service/authService.dart';
import 'package:oyunn/views/Fallarim_page.dart';
import 'package:oyunn/views/admin/All_fortune_page.dart';
import 'package:oyunn/views/auth/LoginPage.dart';
import 'package:oyunn/widgets/constants.dart';

import '../models/fal_turu_model.dart';
import '../service/DatabaseService.dart';
import '../widgets/photograph.dart';

class FalYuklemeEkrani extends StatefulWidget {
  const FalYuklemeEkrani({Key? key});

  @override
  _FalYuklemeEkraniState createState() => _FalYuklemeEkraniState();
}

class _FalYuklemeEkraniState extends State<FalYuklemeEkrani> {
  int selectedColumn = -1;
  String userId = "";
  String userName = "";
  AuthService _authService = AuthService();
  @override
  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() {
    userId = DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).uid!;

    gettingUserData() async {
      await HelperFunctions.getuserNameSF().then((value) {
        setState(() {
          userName = value!;
        });
      });
    }
  }

  List<File?> selectedPhotos = List.generate(3, (_) => null);

  void _updateSelectedPhoto(int index, File? photo) {
    setState(() {
      selectedPhotos[index] = photo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[800],
      appBar: AppBar(
        backgroundColor: Colors.brown,
        centerTitle: true,
        title: const Text(
          "Fal gönderme",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      drawer: Drawer(
          child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 50),
        children: <Widget>[
          const Icon(
            Icons.account_circle,
            size: 150,
            color: Colors.white,
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            userName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 30,
          ),
          const Divider(
            height: 2,
          ),
          ListTile(
            onTap: () {
              nextScreenReplace(context, AdminPage());
            },
            selectedColor: Theme.of(context).primaryColor,
            selected: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.person),
            title: const Text(
              "Admin",
              style: TextStyle(color: Colors.black),
            ),
          ),
          ListTile(  title: const Text(
              "Fallarim",
              style: TextStyle(color: Colors.black),
            ),
            leading: const Icon(Icons.message),
            selectedColor: Theme.of(context).primaryColor,
            selected: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            onTap: () {
              nextScreenReplace(context, const Deneme());
            },
          ),
          ListTile(
            onTap: () async {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await _authService.SignOut();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                                (route) => false);
                          },
                          icon: const Icon(
                            Icons.done,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    );
                  });
            },
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.exit_to_app),
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.black),
            ),
          )
        ],
      )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Photograph(
                    onPhotoSelected: (photo) => _updateSelectedPhoto(0, photo)),
                Photograph(
                    onPhotoSelected: (photo) => _updateSelectedPhoto(1, photo)),
                Photograph(
                    onPhotoSelected: (photo) => _updateSelectedPhoto(2, photo)),
              ],
            ),
            const SizedBox(height: 100),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: FalTuruModel.falmodelList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedColumn == -1) {
                          selectedColumn = index;

                          FalTuruModel.falmodelList[index].isSelected =
                              !FalTuruModel.falmodelList[index].isSelected;
                        } else {
                          FalTuruModel.falmodelList[selectedColumn].isSelected =
                              false;
                          selectedColumn = index;

                          FalTuruModel.falmodelList[index].isSelected =
                              !FalTuruModel.falmodelList[index].isSelected;
                        }

                        print(FalTuruModel.falmodelList[index].name);
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 10,
                                  color: FalTuruModel
                                          .falmodelList[index].isSelected
                                      ? Colors.red
                                      : Colors.blueGrey),
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(10)),
                          width: 120,
                          height: 120,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Text(
                                    FalTuruModel.falmodelList[index].name)),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedColumn == -1) {
                  print("Fal türü sec.");
                  return;
                }

                String selectedFalName =
                    FalTuruModel.falmodelList[selectedColumn].name;

                await DatabaseService(uid: userId).createFortuneTelling(
                  userName,
                  userId,
                  selectedFalName,
                  selectedPhotos,
                );

                print(" basarili!");
              },
              child: const Text("Fali gönder"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            ),
            
          ],
        ),
      ),
    );
  }
}
