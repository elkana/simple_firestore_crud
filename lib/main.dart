import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screen_add.dart';
import 'screen_edit.dart';
import 'util/database.dart';

// https://github.com/sbis04/flutterfire-samples/tree/crud-firestore

void main() {
  // asumsi userUid di hardcode, biasanya disesuaikan dengan loginname
  Database.userUid = 'eric elkana';

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error initializing Firebase');
            } else if (snapshot.connectionState == ConnectionState.done) {
              return MyHomePage(
                title: 'Firestore Demo',
              );
            }
            return CircularProgressIndicator();
          }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>?>>(
        stream: Database.readItems(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          } else if (snapshot.hasData || snapshot.data != null) {
            return ListView.separated(
              separatorBuilder: (context, index) => SizedBox(height: 16.0),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var noteInfo = snapshot.data!.docs[index].data()!;

                String docID = snapshot.data!.docs[index].id;

                String title = noteInfo['title'] ?? '';
                String description = noteInfo['description'] ?? '';

                return ListTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ScreenEdit(
                        currentTitle: title,
                        currentDescription: description,
                        documentId: docID,
                      ),
                    ),
                  ),
                  title: Text(title),
                  subtitle: Text(description),
                  trailing: _isDeleting
                      ? CircularProgressIndicator()
                      : IconButton(
                          onPressed: () async {
                            setState(() {
                              _isDeleting = true;
                            });

                            try {
                              await Database.deleteItem(docId: docID);
                            } finally {
                              setState(() {
                                _isDeleting = false;
                              });
                            }
                          },
                          icon: Icon(Icons.delete_forever)),
                );
              },
            );
          }

          return CircularProgressIndicator();
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ScreenAdd(),
            ),
          );
        },
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
