import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TaskAdd extends StatefulWidget {
  const TaskAdd({Key? key}) : super(key: key);

  @override
  State<TaskAdd> createState() => _TaskAddState();
}

class _TaskAddState extends State<TaskAdd> {

  TextEditingController adAlici = TextEditingController();
  TextEditingController tarihAlici = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Görev Ekle Ekrani"),
      ),
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(8.0),
            child: TextFormField(
              controller: adAlici,
              decoration: InputDecoration(
                labelText: "Görev Adı : ",
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
              padding: EdgeInsets.all(8.0),
              child: TextFormField(
                controller: tarihAlici,
                decoration: InputDecoration(
                  labelText: "Son Tarih : ",
                  border: OutlineInputBorder()
                ),
              ),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            height: 70,
            width: double.infinity,
            child: ElevatedButton(
              child: Text("Görev Ekle", style: TextStyle(fontSize: 24),),
              onPressed: (){
                veriEkle();
               },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
            ),
          )
        ],
      ),
    );
  }

  void veriEkle() async{
    FirebaseAuth yetki = FirebaseAuth.instance;
    var mevcutKullanici = await yetki.currentUser;

    String uidTutucu = mevcutKullanici!.uid;
    var zamanTututcu = DateTime.now();

    await FirebaseFirestore.instance
    .collection("Gorevler")
    .doc(uidTutucu)
    .collection("Gorevlerim")
    .doc(zamanTututcu.toString())
    .set({
      'ad' :adAlici.text,
      'sonTarih' : tarihAlici.text,
      'zaman' : zamanTututcu.toString(),
       'tamZaman' : zamanTututcu
    });
    Fluttertoast.showToast(msg: "Görev başarıyla ekleenmiştir");
  }
}
