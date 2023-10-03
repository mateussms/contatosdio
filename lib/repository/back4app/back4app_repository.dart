import 'package:contatosdio/model/contato_model.dart';

import 'back4app_custon_dio.dart';

class Back4AppRepositoy {
  final _custonDio = Back4AppCustonDio();
  final String classe = "/Contatos";

  Back4AppRepositoy();

  Future<ContatoModel> obter(String? objectId) async {
    var url = classe;
    if(objectId != null && objectId.isNotEmpty){
      url += "/$objectId";
    }
    var result = await _custonDio.dio.get(url);
    return ContatoModel.fromJson(result.data);
  }

  Future<void> criar(ContatoModel contatoModel) async {
    try {
      await _custonDio.dio
          .post(classe, data: contatoModel.toJsonEndpoint());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> atualizar(ContatoModel contatoModel) async {
    try {
      // ignore: unused_local_variable
      var response = await _custonDio.dio.put(
          "$classe/${contatoModel.objectId}",
          data: contatoModel.toJsonEndpoint());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> remover(String objectId) async {
    try {
      // ignore: unused_local_variable
      var response = await _custonDio.dio.delete("$classe/$objectId");
    } catch (e) {
      rethrow;
    }
  }
}