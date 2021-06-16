import 'package:flutter/material.dart';
import 'package:validadores/validadores.dart';

class InputText extends StatelessWidget {
  final TextEditingController controlador;
  final String titulo;
  final String dica;
  final bool numerico;
  final Function validador;

  InputText(
      {this.controlador,
      this.titulo,
      this.dica,
      this.numerico,
      this.validador});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: TextFormField(
        autofocus: true,
        validator: validador,
        controller: controlador,
        keyboardType:
            numerico != null ? TextInputType.number : TextInputType.text,
        style: TextStyle(fontSize: 18, color: Colors.blue),
        decoration: InputDecoration(
          labelText: titulo,
          labelStyle: TextStyle(fontSize: 18, color: Colors.blue),
          hintText: dica,
          hintStyle: TextStyle(color: Colors.blue[100]),
        ),
      ),
    );
  }
}

class Validadores {
  static String validaObrigatorio(String campo) {
    return Validador()
        .add(Validar.OBRIGATORIO, msg: 'Campo não Preenchido')
        .valido(campo);
  }
}

class Botao extends StatelessWidget {
  final String titulo;
  final Function onClick;

  Botao({this.titulo, @required this.onClick});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 150, height: 60),
      child: ElevatedButton(
        child: Text(
          titulo,
          textAlign: TextAlign.center,
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blue),
          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 24)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        ),
        onPressed: () {
          onClick();
        },
      ),
    );
  }
}

class ShowDialog {
  static Future<void> showMyDialogSimNao(
      BuildContext context, String titulo, String texto1,
      {Function onClick}) async {
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
            TextButton(
              child: Text(
                "Não",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
                child: Text(
                  "Sim",
                  style: TextStyle(color: Colors.green),
                ),
                onPressed: () {
                  onClick();
                }),
          ],
        );
      },
    );
  }

  static Future<void> showMyDialogOk(
      BuildContext context, String titulo, String texto1,
      {Function onClick}) async {
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
            Container(
              alignment: Alignment.center,
              width: double.maxFinite,
              child: Botao(
                titulo: 'OK',
                onClick: () {
                  onClick();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
