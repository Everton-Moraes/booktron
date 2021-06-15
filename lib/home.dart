import 'dart:async';
import 'package:booktron/cadastro_contato.dart';
import 'package:booktron/contato.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Contato> contatos;
  var db = FirebaseFirestore.instance;

  StreamSubscription<QuerySnapshot> contatoInscricao;

  @override
  void initState() {
    super.initState();
    contatos = [];
    contatoInscricao?.cancel();

    contatoInscricao = db
        .collection('contatos')
        .orderBy('nome', descending: false)
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
    contatoInscricao?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar um pesquisar'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getListaProdutos(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              List<DocumentSnapshot> documentos = snapshot.data.docs;
              return ListView.builder(
                itemCount: documentos.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: Image.asset(contatos[index].foto,
                          width: 80, height: 80),
                      trailing: Row(
                        children: [
                          IconButton(
                              icon: Icon(Icons.phone),
                              onPressed: () {/* Criar o método */})
                        ],
                      ),
                      title: Text(contatos[index].nome),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CadastroContato())),
                    ),
                  );
                },
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => CadastroContato())),
      ),
    );
  }

  Stream<QuerySnapshot> getListaProdutos() {
    return FirebaseFirestore.instance
        .collection('Contatos')
        .orderBy('Nome', descending: false)
        .snapshots();
  }
}
