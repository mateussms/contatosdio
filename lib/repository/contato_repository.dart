import 'package:contatosdio/model/contato_model.dart';
import 'package:contatosdio/repository/back4app/back4app_repository.dart';
import 'package:dio/dio.dart';

class ContatoRepository{

  
  late List<ContatoModel> contatoModels = [];
  static late ContatoModel contatoModel;
  static List<String> data = [];
  final dio = Dio();

  ContatoRepository._criar();

  static Future<ContatoRepository> carregar() async{
    return ContatoRepository._criar();
  }

  Future<ContatoModel> getId(String objectId) async {
    ContatoModel vcm = await Back4AppRepositoy().obter(objectId);
    // ignore: unnecessary_null_comparison
    return vcm.contatos.first;
  }

  Future<void> salvar(ContatoModel contatoModel) async {
      if(contatoModel.objectId!.isEmpty) {
        await Back4AppRepositoy().criar(contatoModel);
      }
      else{
        await Back4AppRepositoy().atualizar(contatoModel);
      }
    }
    
    
    Future<void> delete(int index) async {
    try{
      await  Back4AppRepositoy().remover(contatoModels[index].objectId.toString());
      contatoModels.removeAt(index);
    // ignore: empty_catches
    } catch(e){
    }
    
  }

  Future<List<ContatoModel>> obterDados() async {
    contatoModels = (await  Back4AppRepositoy().obter(null)).contatos;
    return contatoModels;
  }

}