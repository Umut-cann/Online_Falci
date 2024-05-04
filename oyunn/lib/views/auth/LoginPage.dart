

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:oyunn/views/FalLoadingPage.dart';

import 'package:oyunn/views/auth/registerPage.dart';

import 'package:sign_in_button/sign_in_button.dart';

import '../../controller/helper.dart';
import '../../service/DatabaseService.dart';
import '../../service/authService.dart';
import '../../widgets/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String _email = "";
  String _password = "";
  bool _isloading = false;
  bool _isloadingFull = false;
  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final Width = MediaQuery.of(context).size.width;
    return Scaffold(

        appBar:  AppBar(
      backgroundColor: Colors.blueGrey,
          centerTitle: true,
          title: const Text("welcome",style: TextStyle(color: Colors.black87),),),
        backgroundColor: Colors.blueGrey[50],
        body: _isloadingFull
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).canvasColor,
                ),
              )
            : Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Form(
                        key: _formKey,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SvgIcon(
                                  size:
                                      MediaQuery.sizeOf(context).height * 0.25,
                                  icon: const SvgIconData('lib/images/deneme.svg',
                                      colorSource:
                                          SvgColorSource.specialColors)),

                              SizedBox(
                                height: MediaQuery.sizeOf(context).width *0.1,
                              ),

                    
                              TextFormField(
                                decoration: TextInputdecoration.copyWith(
                                    labelText: "email",
                                    labelStyle: TextStyle(color: Colors.black),
                                    prefixIcon: const Icon(
                                      Icons.email,
                                      color: Colors.black,
                                    )),
                                onChanged: (value) {
                                  setState(() {
                                    _email = value;
                                  });
                                },
                                autocorrect: true,
                                validator: (value) {
                                  RegExp emailRegex = RegExp(
                                    r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$',
                                  );

                                  if (value == null || value.isEmpty) {
                                    return 'Please enter an email address.';
                                  }

                                  if (!emailRegex.hasMatch(value)) {
                                    return 'Please enter a valid email address.';
                                  }

                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextFormField(
                                obscureText: true,
                                decoration: TextInputdecoration.copyWith(
                                  labelText: "password",
                                labelStyle: TextStyle(color: Colors.black),

                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    color: Colors.black,
                                  ),
                                ),
                                validator: (value) {
                                  if (value!.length < 6) {
                                    return "password en az 6 karakter içermeli ";
                                  } else {
                                    return null;
                                  }
                                },
                                onChanged: (value) {
                                  _password = value;
                                },
                                keyboardType: TextInputType.visiblePassword,
                                autocorrect: true,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).canvasColor,
                                    ),
                                 
                                    onPressed: () => login(),
                                    child: const Text(
                                      "sign in",
                                      style: TextStyle(fontSize: 16,color: Colors.black),
                                    )),
                              ),
                             
                              _googlesignButton(context),
                              SizedBox(
                                child: Text.rich(TextSpan(
                                    text: "Don't have an account ",
                                    style: const TextStyle(color: Colors.black),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: "Register here",
                                        style: const TextStyle(
                                            color: Colors.black,
                                            decoration:
                                                TextDecoration.underline),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            nextScreenReplace(
                                                context, registerPage());
                                          },
                                      ),
                                    ])),
                              ),
                            ],
                          ),
                        )),
                  ),
                ),
              ));
  }

  login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });

      try {
        bool loginResult =
            await _authService.LoginUserWithEmailandPassword(_email, _password);

        if (loginResult) {
          User? currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser != null && currentUser.emailVerified) {
            print("e posta doğrulanmış");
            nextScreenReplace(context, const FalYuklemeEkrani());
          } else {
          
            showSnackbar(
                context, Colors.red, 'Lütfen e-posta adresinizi doğrulayın.');
          }
        } else {
          // Giriş başarısız, hata mesajı göster
          showSnackbar(context, Colors.red, 'E-posta veya şifre hatalı.');
        }
      } catch (error) {
        
        showSnackbar(context, Colors.red, error.toString()+"hataaaa");
      }

      setState(() {
        _isloading = false;
      });
    }
  }

  Widget _googlesignButton(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SignInButton(
          Buttons.google,
          text: "Sign up with google",
          onPressed: () {
            _authService.handleGoogleSignIn().then(
              (value) async {
                if (value) {
                  QuerySnapshot snapshot = await DatabaseService(
                          uid: FirebaseAuth.instance.currentUser!.uid)
                      .gettingUserData(_email);

        
                  await HelperFunctions.saveuserLoggIdstate(true);

                  await HelperFunctions.saveuserEmailSF(_email);
                  await HelperFunctions.saveuserNameSF(_email);

                  // Homepage yap
                  nextScreenReplace(context, const FalYuklemeEkrani());
                } else {
                  showSnackbar(context, Colors.red, "böyle bir kullanici yok");

                  nextScreenReplace(context, const LoginPage());
                  setState(() {
                    _isloading = false;
                  });
                }
              },
            );
         
          },
        ),
      ),
    );
  }
}

