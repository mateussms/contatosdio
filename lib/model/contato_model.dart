// ignore_for_file: unnecessary_this, unnecessary_getters_setters

import 'package:intl/intl.dart';

class ContatoModel {
  late String? _objectId;
  late String _name;
  late String _email;
  late String? _imagemPath;
  late String _dataNascimento;
  late String _telefone;

  List<ContatoModel> contatos = [];

  ContatoModel(
      { String? objectId,
        required String name,
      required String email,
      String? imagemPath,
      required String dataNascimento,
      required String telefone}) {
        _objectId = objectId;
      _name = name;
      _email = email;
      _imagemPath = imagemPath;
      _dataNascimento = dataNascimento;
      _telefone = telefone;
   
  }
  
  String? get objectId => _objectId;
  set objectId(String? objectId) => _objectId = objectId;

  String get name => _name;
  set name(String name) => _name = name;
  String get email => _email;
  set email(String email) => _email = email;
  String? get imagemPath => _imagemPath;
  set imagemPath(String? imagemPath) => _imagemPath = imagemPath;
  String get dataNascimento => _dataNascimento;
  set dataNascimento(String dataNascimento) =>
      _dataNascimento = dataNascimento;
  String get telefone => _telefone;
  set telefone(String telefone) => _telefone = telefone;

  ContatoModel.fromJson(Map<String, dynamic> json) {
     if (json['results'] != null) {
      contatos = <ContatoModel>[];
      json['results'].forEach((v) {
        contatos.add(ContatoModel.fromJson(v));
      });
    }
    else {
      _objectId = json['objectId'];
      _name = json['name'];
      _email = json['email'];
      _imagemPath = json['imagemPath'];
      _dataNascimento = DateFormat("dd/MM/yyyy").format(DateTime.parse(json['dataNascimento']['iso'].toString()));
      _telefone = json['telefone'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['objectId'] = this._objectId;
    data['name'] = this._name;
    data['email'] = this._email;
    data['imagemPath'] = this._imagemPath;
    data['dataNascimento'] = _dataNascimento;
    data['telefone'] = this._telefone;
    return data;
  }

   Map<String, dynamic> toJsonEndpoint() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = this._name;
    data['email'] = this._email;
    data['imagemPath'] = this._imagemPath;
    data['dataNascimento'] = {"__type":"Date","iso": DateFormat("dd/MM/yyyy").parse(this._dataNascimento).toString()};
    data['telefone'] = this._telefone;
    return data;
  }
}
