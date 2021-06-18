class Historico {
  String idHistorico;
  String nome;
  dynamic data;
  String apelido;
  String servico;

  Historico({this.nome, this.data, this.apelido, this.servico});

  Historico.fromJson(Map<String, dynamic> json, String id) {
    idHistorico = id ?? '';
    nome = json['nome'];
    data = json['data'];
    apelido = json['apelido'];
    servico = json['servico'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['idContato'] = this.idHistorico;
    data['nome'] = this.nome;
    data['data'] = this.data;
    data['apelido'] = this.apelido;
    data['servico'] = this.servico;
    return data;
  }
}
