import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todozapp/screens/task_add.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? mevcutKullaniciUidTutucu;

  @override
  void initState() {
    mevcutKullaniciUidAll();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yapilacaklar Listesi"),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,

        ///streamBuilder verileri çekip Firestorede görmemizi sağlar
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Görevler")
              .doc(mevcutKullaniciUidTutucu)
              .collection("Görevlerim")
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot> veriTabanindangelenVeriler) {
            if (veriTabanindangelenVeriler.connectionState ==
                ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              ///nullsafety kontol et dökümanları çek
              final alinanVeri = veriTabanindangelenVeriler.data!.docs;
              return ListView.builder(
                  itemCount: veriTabanindangelenVeriler.data!.docs.length,
                  itemBuilder: (context, index) {
                    var eklemeZamani =
                        (alinanVeri[index]['Tam Zaman'] as Timestamp).toDate();
                    return Container(
                      margin: EdgeInsets.fromLTRB(10, 5, 10, 3),
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      alinanVeri[index]['ad'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 7,
                                  ),
                                  Text(
                                    DateFormat.yMd()
                                        .add_jm()
                                        .format(eklemeZamani)
                                        .toString(),
                                    style: TextStyle(fontSize: 24),
                                  )
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  alinanVeri[index]['sonTarih'],
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('Gorevler')
                                    .doc(mevcutKullaniciUidTutucu)
                                    .collection('Gorevlerim')
                                    .doc(alinanVeri[index]['zaman'])
                                    .delete();
                              },
                              icon: Icon(Icons.delete),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => TaskAdd()));
        },
      ),
    );
  }

  void mevcutKullaniciUidAll() async {
    FirebaseAuth yetki = FirebaseAuth.instance;
    var mevcutKullanici = await yetki.currentUser;
    setState(() {
      mevcutKullaniciUidTutucu = mevcutKullanici!.uid;
    });
  }
}
