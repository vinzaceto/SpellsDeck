import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vote_app/detail.dart';
import 'package:vote_app/home_page.dart';
import 'package:vote_app/services/authentication.dart';

class AllSpells extends StatefulWidget {
  AllSpells({
    Key key,
    this.userId,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  final String userId;

  @override
  State<StatefulWidget> createState() => new _AllSpellState();
}

class _AllSpellState extends State<AllSpells> {

  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: new AppBar(
        title: new Text('All the Spells'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('spell').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return LinearProgressIndicator();

          return _buildList(context, snapshot.data.documents);
        });
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> documents) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: documents.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final spell = Spell.fromSnapshot(data);

    var isPresent;

    if (spell.users.contains(widget.userId)) {
      isPresent = true;
    } else {
      isPresent = false;
    }

    return Padding(
        key: ValueKey(spell.name),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: createSpellItem(isPresent, spell));
  }

  Container createSpellItem(bool isPresent, Spell spell) {
    return Container(
      decoration: _createBoxDecorator(isPresent),
      child: ListTile(
        title: Text(spell.name),
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => SecondRoute(spell: spell))),
        onLongPress: () => _createFuncOnLongPress(isPresent, spell),
      ),
    );
  }

  void _createFuncOnLongPress(bool isPresent, Spell spell) {
    if (!isPresent) {
      _addSpell(spell);
    }
  }

  BoxDecoration _createBoxDecorator(bool isPresent) {
    return isPresent
        ? new BoxDecoration(
            border: Border.all(color: Colors.redAccent),
            borderRadius: BorderRadius.circular(5.0),
          )
        : new BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          );
  }

  void _addSpell(Spell spell) {
    _addSpelltoUser(spell.reference);
    final snackBarContent = SnackBar(
      content: Text(spell.name + " aggiunta"),
      action: SnackBarAction(
          label: 'Annulla', onPressed: () => _UNDOaddSpelltoUser(spell.reference)),
    );
  _scaffoldkey.currentState.showSnackBar(snackBarContent);
  }

  void _addSpelltoUser(DocumentReference reference) {
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

  void _UNDOaddSpelltoUser(DocumentReference reference) {
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
}
