import 'dart:ffi';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io';

class ResultPage extends StatefulWidget {
  final File? image;
  final String output;
  final double confidence;

  const ResultPage(
      {Key? key, this.image, this.output = "", this.confidence = 0})
      : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> with TickerProviderStateMixin {
  late DatabaseReference _dbref;
  String databasejson = "";
  List precautions = [];
  List docotrlist = [];
  @override
  void initState() {
    super.initState();
    _dbref = FirebaseDatabase.instance.reference();
    _information();
    _precautions();
    _doctor();
  }

  _information() {
    _dbref
        .child("Information")
        .child(widget.output)
        .once()
        .then((DatabaseEvent dataSnapshot) {
      print("read once - " + dataSnapshot.snapshot.value.toString());
      setState(() {
        databasejson = dataSnapshot.snapshot.value.toString();
      });
    });
  }

  _precautions() {
    List itemlist1 = [];
    _dbref
        .child("Precautions")
        .child(widget.output)
        .once()
        .then((DatabaseEvent dataSnapshot) {
      dataSnapshot.snapshot.children.forEach((element) {
        itemlist1.add(element.value);
        setState(() {
          precautions = itemlist1;
        });
      });
    });
  }

  _doctor() {
    List itemlist2 = [];
    _dbref.child("Doctors").once().then((DatabaseEvent dataSnapshot) {
      dataSnapshot.snapshot.children.forEach((element) {
        itemlist2.add(element.value);
        setState(() {
          docotrlist = itemlist2;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController = TabController(length: 3, vsync: this);
    final _markDownData =
        precautions.map((x) => "- $x\n").reduce((x, y) => "$x$y");
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Prediction"),
          ),
          body: Column(children: [
            SizedBox(
              height: 30,
            ),
            Container(
              child: Image.file(
                widget.image!,
                width: 250,
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              child: Text(
                widget.output,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              child: Text(
                "Confidence : " + widget.confidence.toStringAsFixed(2) + "%",
                style: TextStyle(fontSize: 15),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              child: const TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: "Information"),
                    Tab(text: "Precaution"),
                    Tab(text: "Suggestion")
                  ]),
            ),
            Expanded(
                child: TabBarView(
              children: [
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.topCenter,
                  child: Column(children: [
                    Expanded(
                        child: SingleChildScrollView(
                      child: Text(
                        databasejson,
                        textAlign: TextAlign.justify,
                      ),
                    ))
                  ]),
                ),
                Container(
                  child: Markdown(data: _markDownData),
                ),
                Container(
                  child: ListView.builder(
                      itemCount: docotrlist.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      content: Container(
                                        padding: EdgeInsets.all(5),
                                        height: 300,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                                radius: 50,
                                                child: Image(
                                                    image: AssetImage(
                                                        "assets/doctor_profile.png"))),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Center(
                                              child: Text(
                                                "Dr." +
                                                    docotrlist[index]["Name"],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text("Hospital : " +
                                                docotrlist[index]["Hospital"]),
                                            Text("Phone : " +
                                                docotrlist[index]["Phone"]
                                                    .toString()),
                                            Text("Email : " +
                                                docotrlist[index]["Email"]),
                                            Text("Address : " +
                                                docotrlist[index]["Address"])
                                          ],
                                        ),
                                      ),
                                    ));
                          },
                          child: Card(
                            child: ListTile(
                              title: Text("Dr." + docotrlist[index]["Name"]),
                              subtitle: Text(docotrlist[index]["Hospital"]),
                              leading: CircleAvatar(
                                child: Image(
                                  image:
                                      AssetImage("assets/doctor_profile.png"),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                )
              ],
            ))
          ]),
        ));
  }
}
