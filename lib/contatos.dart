class Contato {
  String foto;
  String nome;
  String telefone;
  String apelido;

  Contato({this.foto, this.nome, this.telefone, this.apelido});

  Contato.fromJson(Map<String, dynamic> json) {
    foto = json['foto'];
    nome = json['nome'];
    telefone = json['telefone'];
    apelido = json['apelido'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['foto'] = this.foto;
    data['nome'] = this.nome;
    data['telefone'] = this.telefone;
    data['apelido'] = this.apelido;
    return data;
  }
}