import 'dart:async';
import 'package:booktron/components.dart';
import 'package:booktron/historico.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistoricoLigacao extends StatefulWidget {
  @override
  _HistoricoLigacaoState createState() => _HistoricoLigacaoState();
}

class _HistoricoLigacaoState extends State<HistoricoLigacao> {
  List<Historico> historicos;

  var db = FirebaseFirestore.instance;

  StreamSubscription<QuerySnapshot> favoritoInscricao;

  @override
  void initState() {
    super.initState();
    historicos = [];
    favoritoInscricao?.cancel();

    favoritoInscricao = db
        .collection('historicos')
        .orderBy('timer', descending: true)
        .snapshots()
        .listen((snapshot) {
      final List<Historico> historico = snapshot.docs
          .map((documentSnapshot) =>
              Historico.fromJson(documentSnapshot.data(), documentSnapshot.id))
          .toList();
      setState(() {
        this.historicos = historico;
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
      appBar: AppBar(
        title: Text('Histórico'),
        actions: [
          IconButton(
              icon: Icon(
                Icons.delete_forever,
                color: Colors.red,
              ),
              onPressed: () => ShowDialog.showMyDialogSimNao(
                  context, "Excluir", "Excluir Histórico?",
                  onClick: () => _limpaHistorico(historicos)))
        ],
      ),
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
                if (historicos.isNotEmpty) {
                  return ListView.builder(
                    itemCount: historicos.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: Colors.cyan[200],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(historicos[index].apelido,
                                  style: TextStyle(fontSize: 22.0)),
                              subtitle: Text(historicos[index].data,
                                  style: TextStyle(fontSize: 18.0)),
                              trailing: historicos[index].servico == 'telefone'
                                  ? Icon(
                                      Icons.phone_enabled,
                                      color: Colors.green,
                                      size: 30.0,
                                    )
                                  : historicos[index].servico == 'sms'
                                      ? Icon(
                                          Icons.sms,
                                          color: Colors.blue[800],
                                          size: 30,
                                        )
                                      : Image.asset('assets/whatsapp.png',
                                          width: 30, height: 30),
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
        .collection('historicos')
        .orderBy('timer', descending: true)
        .snapshots();
  }
//esta função serve para limpar o histórico de ligações
  void _limpaHistorico(List<Historico> historicos) {
    for (var historico in historicos) {
      db.collection('historicos').doc(historico.idHistorico).delete();
    }
    Navigator.pop(context);
  }
}
