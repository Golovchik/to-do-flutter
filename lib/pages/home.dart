import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? _userToDo;
  List todoList = [];

  void initFirebase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initFirebase();

    todoList.addAll(['Buy meat', 'Open window', 'Change money']);
  }

  void _menuOpen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Menu'),
        ),
        body: Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (route) => false);
                },
                child: Text('On general')),
            Padding(padding: EdgeInsets.only(left: 15)),
            Text('Our simple menu'),
          ],
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: Text('To-do list'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _menuOpen,
            icon: Icon(Icons.menu),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Text('No records');
          return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                  key: Key(snapshot.data!.docs[index].id),
                  child: Card(
                    child: ListTile(
                        title: Text(snapshot.data?.docs[index].get('item')),
                        trailing: IconButton(
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('items')
                                .doc(snapshot.data!.docs[index].id)
                                .delete();
                          },
                          icon: Icon(
                            Icons.delete_sweep,
                            color: Colors.deepOrangeAccent,
                          ),
                        )),
                  ),
                  onDismissed: (direction) {
                    //if (direction == DismissDirection.endToStart)
                    //setState(() {
                    //  todoList.removeAt(index);
                    //});
                    FirebaseFirestore.instance
                                .collection('items')
                                .doc(snapshot.data!.docs[index].id)
                                .delete();
                  },
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Add element'),
                  content: TextField(
                    onChanged: (String value) {
                      _userToDo = value;
                    },
                  ),
                  actions: [
                    ElevatedButton(
                        onPressed: () {
                          //setState(() {
                          // todoList.add(_userToDo);
                          //});

                          FirebaseFirestore.instance
                              .collection('items')
                              .add({'item': _userToDo});

                          Navigator.of(context).pop();
                        },
                        child: Text('Add'))
                  ],
                );
              });
        },
        child: Icon(
          Icons.add_box,
          color: Colors.white,
        ),
      ),
    );
  }
}
