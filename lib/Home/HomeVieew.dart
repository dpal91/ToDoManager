
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:todomanager/Login/LoginView.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Manage To Do"),
        actions: [
          IconButton(
              onPressed: () {
                showLogoutDialog();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20,right: 20,bottom: 20),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("todo").snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator(),);
            }
            return ListView.builder(
                itemCount: snapshot.data!.size,
                itemBuilder: (context,int index){
                  return ListItem(DockId: snapshot.data!.docs[index].id, Titleval: snapshot.data!.docs[index]["Title"], Descriptionval: snapshot.data!.docs[index]['Description'], Dateval: snapshot.data!.docs[index]['Date']);
                });
            // return ListView(
            //   children: snapshot.data!.docs.map((document) {
            //     return ListItem(Titleval: snapshot.data.si  ,Descriptionval: document['Description'], Dateval: document['Date'],);
            //   }).toList(),
            // );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          addToDo();
        },
        child: Text(
          "+",
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }

  Future<void> showLogoutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure to logout?'),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => Login()));
                // Navigator.ma
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> addToDo() async {
    TextEditingController titleCont = TextEditingController();
    TextEditingController descCont = TextEditingController();
    TextEditingController dateCont = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {

        return AlertDialog(
          title: const Center(
            child: Text('Add'),
          ),
          content: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              // border: Border.all(width: 0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[

                  TextField(
                    controller: titleCont,
                    decoration: InputDecoration(
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 2)),
                      labelText: "Enter Title",

                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: descCont,
                    decoration: InputDecoration(
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 2)),
                      labelText: "Enter Description",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: dateCont,
                    decoration: InputDecoration(
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 2)),
                      labelText: "Enter Date",
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950, 8),
                          lastDate: DateTime(2030));
                      setState(() {
                        if (pickedDate != null)
                          dateCont.text = pickedDate.day.toString() +
                              "/" +
                              pickedDate.month.toString() +
                              "/" +
                              pickedDate.year.toString();
                        else
                          dateCont.text = "";
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                var title = titleCont.text.trim();
                var desc = descCont.text.trim();
                var date = dateCont.text.trim();
                if(title.length==0){
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please Enter Title")));
                  return;
                }
                if(desc.length==0){
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please Enter Description")));
                  return;
                }
                if(date.length==0){
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please choose Date")));
                  return;
                }
                try {
                  // DatabaseReference ref = FirebaseDatabase.instance.ref("Todo");
                  // String? key=ref.push().key;
                  // ref = FirebaseDatabase.instance.ref("Todo/${key}");
                  // ref.set({
                  //
                  //   "Title": title,
                  //   "Description": desc,
                  //   "Date": date,
                  // });
                  FirebaseFirestore.instance.collection('todo').add({
                    "Title": title,
                    "Description": desc,
                    "Date": date,
                  });
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("done")));
                } on Exception catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Some Error occured")));
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class ListItem extends StatefulWidget {
  String DockId,Titleval,Descriptionval,Dateval;
  ListItem({Key? key,required this.DockId, required  this.Titleval, required this.Descriptionval, required this.Dateval }): super(key: key);

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.task_outlined),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text( widget.Titleval,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  widget.Descriptionval,
                  style: TextStyle(fontSize: 13),
                ),
                Text(
                  "Date: "+widget.Dateval,
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
          IconButton(
              onPressed: () {
                updateToDo(widget.DockId);
              },
              icon: Icon(Icons.edit)),
          IconButton(onPressed: () {
            deleteToDo(widget.DockId);
          }, icon: Icon(Icons.delete))
        ],
      ),
    );
  }

  Future<void> updateToDo(String DocID) async {
    TextEditingController title=TextEditingController();
    TextEditingController desc=TextEditingController();
    TextEditingController date=TextEditingController();
    FirebaseFirestore.instance.collection('todo').doc('${DocID}')
        .get().then((document) {
      title.text = document["Title"];
      desc.text = document["Description"];
      date.text = document["Date"];
    });


    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text('Update'),
          ),
          content: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              // border: Border.all(width: 0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                    controller: title,
                    decoration: InputDecoration(
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 2)),
                      labelText: "Enter Title",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: desc,
                    decoration: InputDecoration(
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 2)),
                      labelText: "Enter Description",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    controller: date,
                    decoration: InputDecoration(
                      border:
                          OutlineInputBorder(borderSide: BorderSide(width: 2)),
                      labelText: "Enter Date",
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1950, 8),
                          lastDate: DateTime(2030));
                      setState(() {
                        if (pickedDate != null)
                          date.text = pickedDate.day.toString() +
                              "/" +
                              pickedDate.month.toString() +
                              "/" +
                              pickedDate.year.toString();
                        else
                          date.text = "";
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                var vtitle = title.text.trim();
                var vdesc = desc.text.trim();
                var vdate = date.text.trim();
                if(vtitle.length==0){
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please Enter Title")));
                  return;
                }
                if(vdesc.length==0){
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please Enter Description")));
                  return;
                }
                if(vdate.length==0){
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please choose Date")));
                  return;
                }

                try {
                  FirebaseFirestore.instance.collection('todo').doc('${DocID}').update({
                    "Title": vtitle,
                    "Description": vdesc,
                    "Date": vdate,
                  });
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Data Updated Successfully")));
                } on Exception catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Some Error occured")));
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  Future<void> deleteToDo(String DocId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure to Delete Enrty?'),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                try {
                  FirebaseFirestore.instance.collection('todo').doc('${DocId}').delete();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("Data Deleted Successfully")));
                } on Exception catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Some Error occured")));
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

}
