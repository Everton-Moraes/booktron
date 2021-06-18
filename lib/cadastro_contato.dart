import 'package:booktron/components.dart';
import 'package:booktron/contato.dart';
import 'package:booktron/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class CadastroContato extends StatefulWidget {
  final Contato contato;

  CadastroContato({this.contato});

  @override
  _CadastroContatoState createState() => _CadastroContatoState();
}

class _CadastroContatoState extends State<CadastroContato> {
  final db = FirebaseFirestore.instance;

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController _controladorNome;
  TextEditingController _controladorTelefone;
  TextEditingController _controladorApelido;
  TextEditingController _controladorFoto;

  @override
  void initState() {
    super.initState();
    if (widget.contato != null) {
      _controladorNome = TextEditingController(text: widget.contato.nome);
      _controladorTelefone = MaskedTextController(
          mask: '(00) 00000-0000', text: widget.contato.telefone);
      _controladorApelido = TextEditingController(text: widget.contato.apelido);
      _controladorFoto = TextEditingController(text: widget.contato.foto);
    } else {
      _controladorNome = TextEditingController();
      _controladorTelefone = MaskedTextController(mask: '(00) 00000-0000');
      _controladorApelido = TextEditingController();
      _controladorFoto = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos'),
        actions: [
          widget.contato != null
              ? IconButton(
                  icon: Icon(
                    Icons.delete_forever,
                    color: Colors.red,
                  ),
                  onPressed: () => ShowDialog.showMyDialogSimNao(
                      context, "Excluir", "Excluir Contato?",
                      onClick: () => _deletaContato(context)))
              : Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.delete_forever,
                    color: Colors.grey,
                  ),
                ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/fundo.jpg'), fit: BoxFit.cover)),
        child: Form(
          key: _formkey,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0),
            child: ListView(
              children: <Widget>[
                InputText(
                  controlador: _controladorNome,
                  titulo: 'Nome',
                  dica: 'Digite seu Nome',
                  validador: Validadores.validaObrigatorio,
                ),
                InputText(
                  controlador: _controladorTelefone,
                  titulo: 'Telefone',
                  dica: '(99)99999-9999',
                  numerico: true,
                  validador: Validadores.validaObrigatorio,
                ),
                InputText(
                  controlador: _controladorApelido,
                  titulo: 'Apelido',
                  dica: 'Digite o apelido',
                  validador: Validadores.validaObrigatorio,
                ),
                Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Botao(
                      titulo:
                          (widget.contato != null) ? 'Atualizar' : 'Cadastrar',
                      onClick: () {
                        _cadastrar();
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _cadastrar() {
    final String nome = _controladorNome.text;
    final String telefone = _controladorTelefone.text;
    final String apelido = _controladorApelido.text;
    final String foto = _controladorFoto.text;

    if (_formkey.currentState.validate()) {
      Contato contato = Contato(
        apelido: apelido,
        foto: null,
        nome: nome,
        telefone: telefone,
      );
      if (widget.contato == null) {
        db.collection('contatos').add({
          'foto': contato.foto,
          'nome': contato.nome,
          'telefone': contato.telefone,
          'apelido': contato.apelido
        });
        ShowDialog.showMyDialogOk(
            context, 'Cadastrado', 'Cadastrado com Sucesso',
            onClick: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Home()),
                (route) => false));
      } else {
        db.collection('contatos').doc(widget.contato.idContato).update({
          'foto': contato.foto,
          'nome': contato.nome,
          'telefone': contato.telefone,
          'apelido': contato.apelido
        });
        ShowDialog.showMyDialogOk(
            context, 'Atualizado', 'Atualizado com Sucesso',
            onClick: () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Home()),
                (route) => false));
      }
    } else {
      ShowDialog.showMyDialogOk(
          context, 'Dados faltando', 'Complete todo o cadastro',
          onClick: () => Navigator.pop(context));
    }
  }

  void _deletaContato(BuildContext context) {
    db.collection('contatos').doc(widget.contato.idContato).delete();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => Home()), (route) => false);
  }
}
