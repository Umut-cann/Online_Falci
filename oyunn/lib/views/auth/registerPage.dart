/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:oyunn/service/authService.dart';

//import 'package:oyunn/view/homePage.dart';
import 'package:flutter/material.dart';
import 'package:oyunn/controller/helper.dart';
import 'package:oyunn/views/HomePage.dart';
import 'package:oyunn/views/auth/LoginPage.dart';

import '../../widgets/constants.dart';

class registerPage extends StatefulWidget {
  const registerPage({super.key});

  @override
  State<registerPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<registerPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isloading = false;
  String _email = "";
  String _password = "";
  String _fullname = "";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isloading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              )
            : Center(
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Groupie",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          const Text("Login now to see what"),
              
              
                /*       const custom_textField(
              
                        
                   
                        ),
              */
              
                                    TextFormField(
                            decoration: TextInputdecoration.copyWith(
                                labelText: "fullname",
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.black,
                                )),
                            onChanged: (value) {
                              setState(() {
                                _fullname = value;
                              });
                            },
                            autocorrect: true,
                            validator: (value) {
                              if (value!.isNotEmpty) {
                                return null;
                              } else {
                                return "ad bos olmaz ki ";
                              }
                            },
              
                          ),
              
                          
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            decoration: TextInputdecoration.copyWith(
                                labelText: "email",
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
                            validator: email_regex,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: TextInputdecoration.copyWith(
                              labelText: "password",
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
                                        Theme.of(context).cardColor),
                                onPressed: () => register(),
                                child: const Text(
                                  "sign in",
                                  style: TextStyle(fontSize: 16),
                                )),
                          ),
                        ],
                      )),
                ),
            ));
  }

  String? email_regex(value) {
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
                        }

/*
  register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isloading = true;
        nextScreen(context, const LoginPage());
      });

      await authService
          .registerUserWithEmailandPassword(_fullname, _email, _password)
          .then((value) async {
        if (value == true) {
          // shared preferences

           await HelperFunctions.saveuserLoggIdstate(true);

          await HelperFunctions.saveuserEmailSF(_email);
 await HelperFunctions.saveuserNameSF(_fullname);
 

 // homepage yap

        nextScreenReplace(  context, const HomePage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isloading = false;
          });
        }

      });
    }
  }

  */




// kayıt olmadan mail atma

/*register() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isloading = true;
    });


    await FirebaseAuth.instance.currentUser!.sendEmailVerification();

    // Kullanıcıyı kaydetmek yerine, e-posta adresinin doğrulanmasını bekleyin
    await FirebaseAuth.instance.authStateChanges().firstWhere((user) => user != null);

    // shared preferences
    await HelperFunctions.saveuserLoggIdstate(true);
    await HelperFunctions.saveuserEmailSF(_email);
    await HelperFunctions.saveuserNameSF(_fullname);

    // Kayıt tamamlandıktan sonra bir mesaj gösterilebilir veya
    // kullanıcı başka bir ekrana yönlendirilebilir.
    showSnackbar(context, Colors.green, 'Kayıt başarıyla tamamlandı.');

    // Eğer kullanıcının e-posta adresi doğrulandıysa, ana sayfaya yönlendir
    nextScreenReplace(context, const HomePage());

    setState(() {
      _isloading = false;
    });
  }
}

*/


register() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isloading = true;
    });

    try {
      // Kullanıcıyı kaydet ve e-posta doğrulama bağlantısı gönder
      bool registrationResult = await authService.registerUserWithEmailandPassword(_fullname, _email, _password);

      if (registrationResult) {
        // E-posta doğrulama bağlantısını gönder
        await FirebaseAuth.instance.currentUser!.sendEmailVerification();

        // Kayıt başarıyla tamamlandı
        showSnackbar(context, Colors.green, 'Kayıt başarıyla tamamlandı. Lütfen e-postanızı kontrol edin.');

        // Kullanıcının doğrulama bağlantısına tıkladığını kontrol et
        FirebaseAuth.instance.authStateChanges().listen((user) async {
          if (user != null && user.emailVerified) {
            // Kullanıcı doğrulandı, login sayfasına yönlendir


           await HelperFunctions.saveuserLoggIdstate(true);

          await HelperFunctions.saveuserEmailSF(_email);
 await HelperFunctions.saveuserNameSF(_fullname);


            nextScreenReplace(context, const LoginPage());
          }
        });
      } else {
        showSnackbar(context, Colors.red, 'Kayıt sırasında bir hata oluştu.');
      }
    } catch (error) {
      // Hata durumunda hata mesajını göster
      showSnackbar(context, Colors.red, error.toString());
    }

    setState(() {
      _isloading = false;
    });
  }
}


}


*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg_icons/flutter_svg_icons.dart';
import 'package:oyunn/service/authService.dart';

//import 'package:oyunn/view/homePage.dart';
import 'package:flutter/material.dart';
import 'package:oyunn/controller/helper.dart';
//import 'package:oyunn/views/HomePage.dart';
import 'package:oyunn/views/auth/LoginPage.dart';

import '../../widgets/constants.dart';

class registerPage extends StatefulWidget {
  const registerPage({super.key});

  @override
  State<registerPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<registerPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isloading = false;
  String _email = "";
  String _password = "";
  String _fullname = "";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {




    return Scaffold(
 
        body: _isloading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              )
            : Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SvgIcon(
                                size: MediaQuery.sizeOf(context).height * 0.25,
                                icon: const SvgIconData(
                                    'lib/images/register.svg',
                                    colorSource: SvgColorSource.specialColors)),
                            const Text(
                              "Girdiğin email hesabına doğrulama bağlantısı gönderilecek lütfen doğru yazdığına emin ol",
                              style: TextStyle(
                                  fontSize: 16, color: Colors.red),
                            ),

                            SizedBox(height: 10,),
                            TextFormField(
                              decoration: TextInputdecoration.copyWith(
                                  labelText: "fullname",
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    color: Colors.black,
                                  )),
                              onChanged: (value) {
                                setState(() {
                                  _fullname = value;
                                });
                              },
                              autocorrect: true,
                              validator: (value) {
                                if (value!.isNotEmpty) {
                                  return null;
                                } else {
                                  return "ad bos olmaz ki ";
                                }
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              decoration: TextInputdecoration.copyWith(
                                  labelText: "email",
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
                              validator: email_regex,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              obscureText: true,
                              decoration: TextInputdecoration.copyWith(
                                labelText: "password",
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
                              height: MediaQuery.of(context).size.width * 0.1,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).cardColor),
                                  onPressed: () => register(),
                                  child: const Text(
                                    "sign in",
                                    style: TextStyle(fontSize: 16),
                                  )),
                            ),
                          ],
                        )),
                  ),
                ),
              ));
  }

  String? email_regex(value) {
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
  }

/*
  register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isloading = true;
        nextScreen(context, const LoginPage());
      });

      await authService
          .registerUserWithEmailandPassword(_fullname, _email, _password)
          .then((value) async {
        if (value == true) {
          // shared preferences

           await HelperFunctions.saveuserLoggIdstate(true);

          await HelperFunctions.saveuserEmailSF(_email);
 await HelperFunctions.saveuserNameSF(_fullname);
 

 // homepage yap

        nextScreenReplace(  context, const HomePage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isloading = false;
          });
        }

      });
    }
  }

  */

// kayıt olmadan mail atma

/*register() async {
  if (_formKey.currentState!.validate()) {
    setState(() {
      _isloading = true;
    });


    await FirebaseAuth.instance.currentUser!.sendEmailVerification();



    
    await HelperFunctions.saveuserLoggIdstate(true);
    await HelperFunctions.saveuserEmailSF(_email);
    await HelperFunctions.saveuserNameSF(_fullname);

 
    showSnackbar(context, Colors.green, 'Kayıt başarıyla tamamlandı.');

    nextScreenReplace(context, const LoginPage());

    setState(() {
      _isloading = false;
    });
  }
}
*/


  register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });

      try {
     
        bool registrationResult = await authService
            .registerUserWithEmailandPassword(_fullname, _email, _password);

        if (registrationResult) {
        
          await FirebaseAuth.instance.currentUser!.sendEmailVerification();


          showSnackbar(context, Colors.green,
              'Kayıt başarıyla tamamlandı. Lütfen e-postanızı kontrol edin.');

          FirebaseAuth.instance.authStateChanges().listen((user) async {


      
        

              await HelperFunctions.saveuserLoggIdstate(true);

              await HelperFunctions.saveuserEmailSF(_email);
              await HelperFunctions.saveuserNameSF(_fullname);

              nextScreenReplace(context, const LoginPage());
            

          });
        } 
        
        
        else {
          showSnackbar(context, Colors.red, 'Kayıt sırasında bir hata oluştu.');
        }
      } catch (error) {
  
        showSnackbar(context, Colors.red, error.toString());
      }

      setState(() {
        _isloading = false;
      });
    }
  }





}
