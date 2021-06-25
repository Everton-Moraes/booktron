//import 'dart:html';
import 'dart:io';

import 'package:booktron/components.dart';
import 'package:booktron/contato.dart';
import 'package:booktron/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:flutter_initicon/flutter_initicon.dart';

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

  File _image;
  bool _semFoto;
  bool _novoContato;
  var _url = "";
  String _nomeFoto;
  var gambiarra;
  var imageUrl;
  var _nome;

  Future retornaFoto() async {
    final Reference ref =
        FirebaseStorage.instance.ref().child(widget.contato.foto);
    if (widget.contato.foto != null) {
      print(widget.contato.foto);
      setState(() {
        _url = widget.contato.foto;
      });
    } else {
      setState(() {
        _url =
            "https://caruarucity.com.br/wp-content/uploads/2016/12/avatar-vazio.jpg";
      });
    }
  }

  Future getImage(String fonte) async {
    var image;
    if (fonte == "g") {
      image = await ImagePicker.pickImage(source: ImageSource.gallery);
    } else {
      image = await ImagePicker.pickImage(source: ImageSource.camera);
    }
    setState(() {
      _image = image;
    });
  }

  Future uploadPic(BuildContext context) async {
    if (_image != null) {
      String fileName = basename(_image.path);
      Reference ref = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(_image);
      imageUrl = await (await uploadTask).ref.getDownloadURL();
      setState(() {
        _nomeFoto = imageUrl;
        _cadastrar(context);
      });
    } else {
      _cadastrar(context);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.contato != null) {
      retornaFoto();
      _controladorNome = TextEditingController(text: widget.contato.nome);
      _controladorTelefone = MaskedTextController(
          mask: '(00) 00000-0000', text: widget.contato.telefone);
      _controladorApelido = TextEditingController(text: widget.contato.apelido);
      if (widget.contato.foto ==
          "https://caruarucity.com.br/wp-content/uploads/2016/12/avatar-vazio.jpg") {
        _nome = widget.contato.apelido;
        _novoContato = false;
        _semFoto = true;
      }
    } else {
      _novoContato = true;
      _nome = "";
      _controladorNome = TextEditingController();
      _controladorTelefone = MaskedTextController(mask: '(00) 00000-0000');
      _controladorApelido = TextEditingController();
      setState(() {
        _url =
            "https://caruarucity.com.br/wp-content/uploads/2016/12/avatar-vazio.jpg";
      });
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Color(0xff476cfb),
                        child: ClipOval(
                          child: SizedBox(
                            width: 180.0,
                            height: 180.0,
                            child: (_image != null)
                                ? Image.file(
                                    _image,
                                    fit: BoxFit.fill,
                                  )
                                : (_novoContato == true)
                                    ? Image.network(
                                        "https://caruarucity.com.br/wp-content/uploads/2016/12/avatar-vazio.jpg",
                                        fit: BoxFit.fill,
                                      )
                                    : (_semFoto == true)
                                        ? Initicon(
                                            text: "${_nome}",
                                            backgroundColor: Colors.blue,
                                            size: 200)
                                        : Image.network(
                                            _url,
                                            fit: BoxFit.fill,
                                          ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(top: 60.0),
                        child: IconButton(
                            icon: Icon(
                              FontAwesomeIcons.camera,
                              size: 30.0,
                            ),
                            onPressed: () => showDialogFoto(
                                context,
                                "Escolher Fonte",
                                "Escolher câmera ou Galeria?"))),
                  ],
                ),
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
                        uploadPic(context);
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _cadastrar(BuildContext context) async {
    final String nome = _controladorNome.text;
    final String telefone = _controladorTelefone.text;
    final String apelido = _controladorApelido.text;
    String foto = "";
    if (imageUrl != null) {
      foto = imageUrl;
    } else {
      foto =
          "https://caruarucity.com.br/wp-content/uploads/2016/12/avatar-vazio.jpg";
    }
    if (_formkey.currentState.validate()) {
      Contato contato = Contato(
        apelido: apelido,
        foto: foto,
        nome: nome,
        telefone: telefone,
      );
      if (widget.contato == null) {
        QuerySnapshot consultaCadastro = await db
            .collection('contatos')
            .where('telefone', isEqualTo: telefone)
            .get();

        if (consultaCadastro.docs.isEmpty) {
          db.collection('contatos').add({
            'foto': contato.foto,
            'nome': contato.nome,
            'telefone': contato.telefone,
            'apelido': contato.apelido,
            'favorito': false
          });
          ShowDialog.showMyDialogOk(
              context, 'Cadastrado', 'Cadastrado com Sucesso',
              onClick: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                  (route) => false));
        } else {
          ShowDialog.showMyDialogOk(context, 'Existente', 'Conta já cadastrado',
              onClick: () => Navigator.pop(context));
        }
      } else {
        db.collection('contatos').doc(widget.contato.idContato).update({
          'foto': contato.foto,
          'nome': contato.nome,
          'telefone': contato.telefone,
          'apelido': contato.apelido,
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

  Future<void> showDialogFoto(
      BuildContext context, String titulo, String texto1) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Align(
            alignment: Alignment.center,
            child: Text(titulo),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    texto1,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                  child: Text(
                    "Câmera",
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                  onPressed: () {
                    var ft = "c";
                    getImage(ft);
                    Navigator.pop(context);
                  }),
            ),
            Center(
              child: TextButton(
                  child: Text(
                    "Galeria",
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                  onPressed: () {
                    //var ft = "g";
                    getImage("g");
                    Navigator.pop(context);
                  }),
            )
          ],
        );
      },
    );
  }
}
