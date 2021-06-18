import 'dart:async';

import 'package:booktron/cadastro_contato.dart';
import 'package:booktron/contato.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Favoritos extends StatefulWidget {
  @override
  _FavoritosState createState() => _FavoritosState();
}

class _FavoritosState extends State<Favoritos> {
  List<Contato> contatos;

  var db = FirebaseFirestore.instance;

  StreamSubscription<QuerySnapshot> favoritoInscricao;

  @override
  void initState() {
    super.initState();
    contatos = [];
    favoritoInscricao?.cancel();

    favoritoInscricao = db
        .collection('contatos')
        .where('favorito', isEqualTo: true)
        .orderBy('apelido', descending: false)
        .snapshots()
        .listen((snapshot) {
      final List<Contato> contatos = snapshot.docs
          .map((documentSnapshot) =>
              Contato.fromJson(documentSnapshot.data(), documentSnapshot.id))
          .toList();
      setState(() {
        this.contatos = contatos;
      });
    });
  }

  @override
  void dispose() {
    favoritoInscricao?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favoritos')),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/fundo.jpg'), fit: BoxFit.cover)),
        child: StreamBuilder<QuerySnapshot>(
          stream: getListaFavoritos(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                if (contatos.isNotEmpty) {
                  return ListView.builder(
                    itemCount: contatos.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CadastroContato(
                                        contato: contatos[index],
                                      ))),
                          child: Card(
                            color: Colors.cyan[200],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(contatos[index].apelido,
                                        style: TextStyle(fontSize: 22.0)),
                                    Container(
                                      child: Row(
                                        children: [
                                          contatos[index].favorito
                                              ? IconButton(
                                                  icon: Icon(
                                                    Icons.star,
                                                    color: Colors.yellow,
                                                    size: 30.0,
                                                  ),
                                                  onPressed: () {
                                                    _favoritos(
                                                        contatos[index], index);
                                                  })
                                              : IconButton(
                                                  icon: Icon(
                                                    Icons.star_border,
                                                    size: 30.0,
                                                  ),
                                                  onPressed: () {
                                                    _favoritos(
                                                        contatos[index], index);
                                                  }),
                                          IconButton(
                                              icon: Icon(
                                                Icons.phone_enabled,
                                                color: Colors.green,
                                                size: 30.0,
                                              ),
                                              onPressed: () {}),
                                          IconButton(
                                              icon: Icon(
                                                Icons.sms,
                                                color: Colors.blue[800],
                                                size: 30,
                                              ),
                                              onPressed: () {}),
                                          InkWell(
                                              child: SizedBox(
                                                width: 50,
                                                child: Image.asset(
                                                    'assets/whatsapp.png',
                                                    width: 30,
                                                    height: 30),
                                              ),
                                              onTap: () {})
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Container(
                      child: Center(
                          child: Text(
                    'Lista Vazia',
                    style: TextStyle(fontSize: 24),
                  )));
                }
            }
          },
        ),
      ),
    );
  }

  Stream<QuerySnapshot> getListaFavoritos() {
    return db
        .collection('favoritos')
        .where('favorito', isEqualTo: true)
        .orderBy('apelido', descending: false)
        .snapshots();
  }

  void _favoritos(Contato contato, int index) {
    contato.favorito = !contato.favorito;
    db
        .collection('contatos')
        .doc(contato.idContato)
        .update({'favorito': contato.favorito});
    setState(() {
      this.contatos.removeAt(index);
    });
  }
}
