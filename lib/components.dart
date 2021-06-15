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
        style: TextStyle(fontSize: 18, color: Colors.red),
        decoration: InputDecoration(
          labelText: titulo,
          labelStyle: TextStyle(fontSize: 18, color: Colors.red),
          hintText: dica,
          hintStyle: TextStyle(color: Colors.red[100]),
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
          backgroundColor: MaterialStateProperty.all(Colors.red),
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
