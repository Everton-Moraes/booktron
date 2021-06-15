import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  TextEditingController _controladorImagem;

  @override
  void initState() {
    super.initState();
    if (widget.contato != null) {
      _controladorNome = TextEditingController(text: widget.contato.nome);
      _controladorTelefone =
          TextEditingController(text: widget.contato.telefone);
      _controladorApelido = TextEditingController(text: widget.contato.apelido);
      _controladorImagem = TextEditingController(text: widget.contato.Imagem);
    } else {
      _controladorNome = TextEditingController();
      _controladorTelefone = TextEditingController();
      _controladorApelido = TextEditingController();
      _controladorImagem = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Produto'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 24.0),
            child: Column(
              children: <Widget>[
                InputText(
                  controlador: _controladorNome,
                  titulo: 'Nome do Produto*',
                  dica: 'Digite o produto',
                  validador: Validadores.validaObrigatorio,
                ),
                InputText(
                  controlador: _controladorTelefone,
                  titulo: 'Preço*',
                  dica: '2.50 (use ponto ao invés de virgula',
                  numerico: true,
                  validador: Validadores.validaObrigatorio,
                ),
                InputText(
                  controlador: _controladorApelido,
                  titulo: 'Categoria*',
                  dica: 'Comida / Bebida / Sobremesa',
                  validador: Validadores.validaObrigatorio,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 16.0),
                  child: TextFormField(
                    autofocus: true,
                    maxLines: 2,
                    validator: Validadores.validaObrigatorio,
                    controller: _controladorDescricao,
                    style: TextStyle(fontSize: 18, color: Colors.red),
                    decoration: InputDecoration(
                      labelText: 'Descrição*',
                      labelStyle: TextStyle(fontSize: 18, color: Colors.red),
                      hintText: 'Descreva o prato',
                      hintStyle: TextStyle(color: Colors.red[100]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 16.0),
                  child: TextFormField(
                    autofocus: true,
                    maxLines: 2,
                    controller: _controladorImagem,
                    style: TextStyle(fontSize: 18, color: Colors.red),
                    decoration: InputDecoration(
                      labelText: 'Imagem do prato',
                      labelStyle: TextStyle(fontSize: 18, color: Colors.red),
                      hintText: 'Insira o link da sua imagem na internet',
                      hintStyle: TextStyle(color: Colors.red[100]),
                    ),
                  ),
                ),
                Botao(
                    titulo:
                        (widget.contato != null) ? 'Atualizar' : 'Cadastrar',
                    onClick: () {
                      _cadastrar();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _cadastrar() {
    final String nomeProduto = _controladorNome.text;
    final String preco = _controladorTelefone.text;
    final String categoriaProduto = _controladorApelido.text;
    final String descricao = _controladorDescricao.text;
    final String linkImagemProduto = _controladorImagem.text;
    final bool ativo = true;

    Produto produto;

    if (_formkey.currentState.validate()) {
      produto = Produto(
        ativo: ativo,
        categoriaProduto: categoriaProduto,
        descricao: descricao,
        linkImagemProduto: linkImagemProduto,
        nomeProduto: nomeProduto,
        preco: preco,
      );

      if (widget.contato != null) {
        ProdutoDao.getAtualizaProduto(
            widget.contato.idProduto, produto, widget.comercio);
        Navigator.pop(context);
      } else {
        print('NULO');
        ProdutoDao.getAddProduto(produto, widget.comercio);
        Navigator.pop(context);
      }
    } else {
      ShowDialog.showMyDialog(
          context, 'Dados faltando', 'Complete todo o cadastro', '',
          onClick: () => Navigator.pop(context));
    }
  }
}
