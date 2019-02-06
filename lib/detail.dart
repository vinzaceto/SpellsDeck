import 'package:flutter/material.dart';
import 'package:vote_app/home_page.dart';
import 'package:vote_app/main.dart';

class SecondRoute extends StatelessWidget {
  final Spell spell;

  SecondRoute({Key key, @required this.spell}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(spell.name),
      ),
      body: _buildBody(context, spell),
    );
  }

  Widget _buildBody(BuildContext context, Spell spell) {
    return Padding(
        padding: EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.perm_contact_calendar, size: 20.0),
                    SizedBox(width: 5.0),
                    Text("Classe: "),
                    SizedBox(width: 5.0),
                    Text(
                      spell.classe,
                    )
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.arrow_upward, size: 20.0),
                    SizedBox(width: 5.0),
                    Text("Livello: "),
                    SizedBox(width: 5.0),
                    Text(
                      spell.level,
                    )
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.timelapse, size: 20.0),
                    SizedBox(width: 5.0),
                    Text("Tempo di lancio: "),
                    SizedBox(width: 5.0),
                    Text(
                      spell.lunchTime,
                    )
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.directions, size: 20.0),
                    SizedBox(width: 5.0),
                    Text("Gittata: "),
                    SizedBox(width: 5.0),
                    Text(
                      spell.range,
                    )
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.av_timer, size: 20.0),
                    SizedBox(width: 5.0),
                    Text("Durata: "),
                    SizedBox(width: 5.0),
                    Text(
                      spell.duration,
                    )
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Row(
                  children: <Widget>[
                    Icon(Icons.pan_tool, size: 20.0),
                    SizedBox(width: 5.0),
                    Text("Componenti: "),
                    SizedBox(width: 5.0),
                    Text(
                      spell.composition,
                    )
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 20.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  spell.description,
                  maxLines: null,
                ),
              ),
            ],
          ),
        ));
  }
}
