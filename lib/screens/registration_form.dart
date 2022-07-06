import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

String? userName, email, password;
bool kayitDurumu = false;

class _RegistrationFormState extends State<RegistrationForm> {
  var _accessKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _accessKey,

      ///doğrula anahtarı
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Container(
              height: 150,
              child: Image.asset('images/todo.png'),
            ),
            if (!kayitDurumu)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onChanged: (alinanAd) {
                    userName = alinanAd;
                  },
                  validator: (alinanAd) {
                    return alinanAd!.isEmpty
                        ? "Kullanıcı adı boş bırakılamaz"
                        : null;
                  },
                  decoration: InputDecoration(
                    labelText: "Kullanıcı Adı : ",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (alinanEmail) {
                  email = alinanEmail;
                },
                validator: (alinanEmail) {
                  return alinanEmail!.contains("@") ? null : "Geçersiz Email !";
                },
                decoration: InputDecoration(
                  labelText: "Email : ",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                onChanged: (alinanParola) {
                  password = alinanParola;
                },
                validator: (alinanParola) {
                  return alinanParola!.length >= 6
                      ? null
                      : "Parola en az 6 karakter olmalıdır !";
                },
                decoration: InputDecoration(
                  labelText: "Parola : ",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                child: ElevatedButton(
                  child: kayitDurumu
                      ? Text("Giriş Yap", style: TextStyle(fontSize: 24))
                      : Text("Kayıt Ol", style: TextStyle(fontSize: 24)),
                  onPressed: () {
                    kayitEkle();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    shadowColor: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    kayitDurumu = !kayitDurumu;
                  });
                },
                child: kayitDurumu
                    ? Text("Hesabım Yok")
                    : Text("Zaten Hesabım Var"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void kayitEkle() {
    if (_accessKey.currentState!.validate()) {
      formuTestEt(userName!, email!, password!);
    }
  }

  void formuTestEt(String userName, String email, String password) async {
    final yetki = FirebaseAuth.instance;
    AuthCredential? yetkiSonucu;

    if (kayitDurumu) {
      yetkiSonucu = (await yetki.signInWithEmailAndPassword(
          email: email, password: password)) as AuthCredential;
    } else {
      yetkiSonucu = (await yetki.createUserWithEmailAndPassword(
          email: email, password: password)) as AuthCredential;
    }
    String uidTutucu = yetkiSonucu.toString();
    await FirebaseFirestore.instance
        .collection("Kullanicilar")
        .doc(uidTutucu)
        .set({"kullaniciAdi": userName, "email": email});
  }
}
