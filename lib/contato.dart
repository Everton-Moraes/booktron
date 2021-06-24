class Contato {
  String idContato;
  String foto;
  String nome;
  String telefone;
  String apelido;
  bool favorito;

  Contato({this.foto, this.nome, this.telefone, this.apelido});

  Contato.fromJson(Map<String, dynamic> json, String id) {
    idContato = id ?? '';
    foto = json['foto'];
    nome = json['nome'];
    telefone = json['telefone'];
    apelido = json['apelido'];
    favorito = json['favorito'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idContato'] = this.idContato;
    data['foto'] = this.foto;
    data['nome'] = this.nome;
    data['telefone'] = this.telefone;
    data['apelido'] = this.apelido;
    data['favorito'] = this.favorito;

    return data;
  }
}
