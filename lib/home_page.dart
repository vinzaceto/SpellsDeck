import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vote_app/all_spells.dart';
import 'package:vote_app/detail.dart';
import 'package:vote_app/services/authentication.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.auth, this.userId, this.onSignedOut})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback onSignedOut;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Spell Deck'),
        actions: <Widget>[
          new FlatButton(
              child: new Text('Logout',
                  style: new TextStyle(fontSize: 17.0, color: Colors.white)),
              onPressed: _signOut)
        ],
      ),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AllSpells(userId: widget.userId)),
              ),
        icon: Icon(Icons.add),
        label: Text("Add"),
      ),

    );
  }

  _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('spell').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final spell = Spell.fromSnapshot(data);

    if (!spell.users.contains(widget.userId)) {
      return Container(
        height: 0.0,
      );
    }

    return Padding(
      key: ValueKey(spell.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(spell.name),
          onTap: () =>
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SecondRoute(spell: spell)),
              )
            ,
          onLongPress: () => _deleteSpell(context, spell)),
        ),
      );
  }

  void _deleteSpell(BuildContext context, Spell spell) {
    _deleteSpellFromFirebase(spell.reference);

    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
      content: Text(spell.name + " eliminata"),
        action: SnackBarAction(
            label: 'Annulla',
            onPressed: () => _UNDOdeleteSpellFromFirebase(spell.reference)),
      ),
    );
  }

  void _deleteSpellFromFirebase(DocumentReference reference) {
    Firestore.instance.runTransaction((transaction) async {
      final freshSnapshot = await transaction.get(reference);
      final fresh = Spell.fromSnapshot(freshSnapshot);

      if (fresh.users.contains(widget.userId)) {
        await transaction.update(freshSnapshot.reference, <String, dynamic>{
          'users': FieldValue.arrayRemove([widget.userId])
        });
      }
    });
  }

  void _UNDOdeleteSpellFromFirebase(DocumentReference reference) {
    Firestore.instance.runTransaction((transaction) async {
      final freshSnapshot = await transaction.get(reference);
      final fresh = Spell.fromSnapshot(freshSnapshot);

      if (!fresh.users.contains(widget.userId)) {
        await transaction.update(freshSnapshot.reference, <String, dynamic>{
          'users': FieldValue.arrayUnion([widget.userId])
        });
      }
    });
  }
}

class Spell {
  final String name;
  final String description;
  final String duration;
  final String lunchTime;
  final String range;
  final String composition;
  final String level;
  final String classe;
  final DocumentReference reference;
  var users;

  Spell.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['nome'] != null),
        assert(map['descrizione'] != null),
        assert(map['durata'] != null),
        assert(map['gittata'] != null),
        assert(map['tempoLancio'] != null),
        assert(map['componenti'] != null),
        assert(map['users'] != null),
        assert(map['classe'] != null),
        name = map['nome'],
        classe = map['classe'],
        description = map['descrizione'],
        duration = map['durata'],
        range = map['gittata'],
        lunchTime = map['tempoLancio'],
        composition = map['componenti'],
        level = map['livello'],
        users = map['users'];

  Spell.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Spell<$name:$description>";
}
