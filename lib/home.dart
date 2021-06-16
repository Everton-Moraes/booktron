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
  List<Contato> contatosBuscados;
  bool _exibePesquisa = true;

  var db = FirebaseFirestore.instance;

  StreamSubscription<QuerySnapshot> contatoInscricao;

  @override
  void initState() {
    super.initState();
    contatos = [];
    contatoInscricao?.cancel();

    contatoInscricao = db
        .collection('contatos')
        .orderBy('apelido', descending: false)
        .snapshots()
        .listen((snapshot) {
      contatosBuscados = snapshot.docs
          .map((documentSnapshot) =>
              Contato.fromJson(documentSnapshot.data(), documentSnapshot.id))
          .toList();
      setState(() {
        this.contatos = contatosBuscados;
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
        title: _exibePesquisa
            ? Text('BookTron')
            : TextField(
                style: TextStyle(color: Colors.white, fontSize: 18),
                onChanged: (value) => _filtroPesquisa(value),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    hintText: "|",
                    hintStyle: TextStyle(color: Colors.white)),
              ),
        actions: <Widget>[
          IconButton(
            icon: Icon(_exibePesquisa ? Icons.search : Icons.close),
            onPressed: () {
              setState(() {
                _exibePesquisa = !_exibePesquisa;
                _filtroPesquisa("");
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getListaContatos(),
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(contatos[index].apelido,
                                    style: TextStyle(fontSize: 18.0)),
                                Container(
                                  child: Row(
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.phone_android),
                                          onPressed: () {}),
                                      IconButton(
                                          icon: Icon(Icons.phone_android),
                                          onPressed: () {}),
                                      IconButton(
                                          icon: Icon(Icons.phone_android),
                                          onPressed: () {}),
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
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => CadastroContato())),
      ),
    );
  }

  Stream<QuerySnapshot> getListaContatos() {
    return db
        .collection('contatos')
        .orderBy('apelido', descending: false)
        .snapshots();
  }

  void _filtroPesquisa(String value) {
    List<Contato> resultado = [];

    if (value.isEmpty) {
      resultado = contatosBuscados;
    } else {
      resultado = contatosBuscados
          .where((elemento) =>
              elemento.apelido.toLowerCase().contains(value.toLowerCase()))
          .toList();
    }
    setState(() {
      this.contatos = resultado;
    });
  }
}
