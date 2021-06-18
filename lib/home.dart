import 'dart:async';
import 'dart:ui';
import 'package:booktron/cadastro_contato.dart';
import 'package:booktron/contato.dart';
import 'package:booktron/favoritos.dart';
import 'package:booktron/historico_ligacao.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      _filtroPesquisa("");
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
                autofocus: true,
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white, fontSize: 18),
                onChanged: (value) => _filtroPesquisa(value),
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    hintText: "Pesquisar...",
                    hintStyle: TextStyle(color: Colors.blueGrey[100])),
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
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: ListTile(
                title: Text('Favoritos', style: TextStyle(fontSize: 24.0)),
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Favoritos())),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: ListTile(
                title: Text('Histórico', style: TextStyle(fontSize: 24.0)),
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HistoricoLigacao())),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/fundo.jpg'), fit: BoxFit.cover)),
        child: StreamBuilder<QuerySnapshot>(
          stream: getListaContatos(),
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
                                                    _favoritos(contatos[index]);
                                                  })
                                              : IconButton(
                                                  icon: Icon(
                                                    Icons.star_border,
                                                    size: 30.0,
                                                  ),
                                                  onPressed: () {
                                                    _favoritos(contatos[index]);
                                                  }),
                                          IconButton(
                                              icon: Icon(
                                                Icons.phone_enabled,
                                                color: Colors.green,
                                                size: 30.0,
                                              ),
                                              onPressed: () {
                                                _gravarHistorico(
                                                    contatos[index],
                                                    'telefone');
                                              }),
                                          IconButton(
                                              icon: Icon(
                                                Icons.sms,
                                                color: Colors.blue[800],
                                                size: 30,
                                              ),
                                              onPressed: () {
                                                _gravarHistorico(
                                                    contatos[index], 'sms');
                                              }),
                                          InkWell(
                                              child: SizedBox(
                                                width: 50,
                                                child: Image.asset(
                                                    'assets/whatsapp.png',
                                                    width: 30,
                                                    height: 30),
                                              ),
                                              onTap: () {
                                                _gravarHistorico(
                                                    contatos[index],
                                                    'whatsapp');
                                              })
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

  void _favoritos(Contato contato) {
    contato.favorito = !contato.favorito;
    db
        .collection('contatos')
        .doc(contato.idContato)
        .update({'favorito': contato.favorito});
  }

  void _gravarHistorico(Contato contato, String servico) {
    final now = DateTime.now();
    String data = DateFormat('kk:mm - dd/MM/yyyy').format(now);

    db.collection('historicos').add({
      'nome': contato.nome,
      'apelido': contato.apelido,
      'data': data,
      'servico': servico
    });
  }
}
