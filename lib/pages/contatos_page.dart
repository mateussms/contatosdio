// ignore_for_file: use_build_context_synchronously, duplicate_ignore, no_leading_underscores_for_local_identifiers
import 'dart:io';
import 'package:contatosdio/model/contato_model.dart';
import 'package:contatosdio/repository/contato_repository.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path/path.dart' as p;

class ContatoPage extends StatefulWidget {
  const ContatoPage({super.key});

  @override
  State<ContatoPage> createState() => _ContatoPageState();
}

class _ContatoPageState extends State<ContatoPage> {
  
  late ContatoRepository contatoRepository;
  List<ContatoModel> contatoModel = [];
  
  TextEditingController objectIdController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dataNascimentoController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController imagemPathController = TextEditingController();
  
  final FocusNode _focusNode = FocusNode();

  static const String imagemPadraoUrl = "https://assets.stickpng.com/images/585e4bcdcb11b227491c3396.png";
  File? _imagem;

  @override
  void initState() {
    super.initState();
    carregaDados();

    _focusNode.addListener(() async{
        
    });
  }

  carregaDados() async{
    contatoRepository  = await ContatoRepository.carregar();
   
    contatoModel     = await contatoRepository.obterDados();
   
    setState(() {});
  }

   XFile? photo;

  cropImage(XFile imageFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      await GallerySaver.saveImage(croppedFile.path);
      photo = XFile(croppedFile.path);
      imagemPathController.text = croppedFile.path;
    }
   
  }

  _showModalBottomSheet(ContatoModel? cm) async{
    if(cm != null){
      nameController.text           = cm.name;
      emailController.text          = cm.email;
      dataNascimentoController.text = cm.dataNascimento;
      telefoneController.text       = cm.telefone;
      imagemPathController.text     = cm.imagemPath ?? "";
      objectIdController.text       = cm.objectId ?? "";
      _imagem = imagemPathController.text.trim().isNotEmpty ? File(cm.imagemPath!) : null;
      setState(() {
        
      });
    }
    else{
      _imagem = null;
      setState(() {});
    }
    // ignore: use_build_context_synchronously
    showModalBottomSheet<void>(context: context, builder: (_){
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [ Expanded(
                  child: Column(children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: _imagem != null ? FileImage(_imagem!) : const NetworkImage(imagemPadraoUrl) as ImageProvider<Object>?,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                        InkWell(
                          child: const Icon(Icons.camera, color: Colors.white,),
                          onTap: () {
                             showModalBottomSheet(
                              context: context,
                              builder: (_) {
                                return Wrap(
                                  children: [
                                    ListTile(
                                      leading: const FaIcon(FontAwesomeIcons.camera),
                                      title: const Text("Camera"),
                                      onTap: () async {
                                        final ImagePicker _picker = ImagePicker();
                                        photo = await _picker.pickImage(
                                            source: ImageSource.camera);
                                        if (photo != null) {
                                          String path = (await path_provider
                                                  .getApplicationDocumentsDirectory())
                                              .path;
                                          String name = p.basename(photo!.path);
                                          await photo!.saveTo("$path/$name");
                                          imagemPathController.text = "$path/$name";
                                          _imagem = File(imagemPathController.text);
                                          await GallerySaver.saveImage(photo!.path);
                                          Navigator.pop(context);

                                          cropImage(photo!);
                                        }
                                      },
                                    ),
                                    ListTile(
                                        leading: const FaIcon(FontAwesomeIcons.images),
                                        title: const Text("Galeria"),
                                        onTap: () async {
                                          final ImagePicker _picker = ImagePicker();
                                          photo = await _picker.pickImage(
                                              source: ImageSource.gallery);
                                          Navigator.pop(context);

                                          cropImage(photo!);
                                        })
                                  ],
                                );
                              },
                            );
                          }),
                        ]
                      ),
                    ),
                    TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "Nome",
                          icon: Icon(Icons.people)
                        ),
                        keyboardType: TextInputType.text,
                        focusNode: _focusNode,
                    ),
                    TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: "E-mail",
                          icon: Icon(Icons.email)
                        ),
                        keyboardType: TextInputType.emailAddress,
                        readOnly: false,
                    ),
                    TextField(
                        controller: dataNascimentoController,
                        decoration: const InputDecoration(
                          labelText: "Data Nascimento",
                          icon: Icon(Icons.calendar_today)
                        ),
                        keyboardType: TextInputType.text,
                    ),
                    TextField(
                        controller: telefoneController,
                        decoration: const InputDecoration(
                          labelText: "Telefone",
                          icon: Icon(Icons.phone)
                        ),
                        keyboardType: TextInputType.phone,
                        readOnly: false,
                    ),
                    Visibility(
                      visible: false,
                      child: TextField(
                          controller: imagemPathController,
                          decoration: const InputDecoration(
                            labelText: "imagemPath",
                            icon: Icon(Icons.people)
                          ),
                          keyboardType: TextInputType.text,
                          readOnly: true,
                      ),
                    ),
                    Visibility(
                      visible: false,
                      child: TextField(
                          controller: objectIdController,
                          decoration: const InputDecoration(
                            labelText: "objectId",
                            icon: Icon(Icons.people)
                          ),
                          keyboardType: TextInputType.text,
                          readOnly: true,
                      ),
                    ),
                    TextButton(
                      onPressed: () async{
                        if(nameController.text.trim().isEmpty){
                          showDialog(
                            context: context, 
                            builder: (_){
                            return AlertDialog(
                                    title: const Text('Alerta'),
                                    content: const Text('Informe o Nome do contato.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Fecha o alerta
                                        },
                                        child: const Text('Fechar'),
                                      ),
                                    ],
                                  );
                          });
                          return;
                        }
                        ContatoModel contato = ContatoModel(name: nameController.text, 
                                                            email: emailController.text, 
                                                            dataNascimento: dataNascimentoController.text, 
                                                            telefone: telefoneController.text,
                                                            imagemPath: imagemPathController.text,
                                                            objectId: objectIdController.text);
                        await contatoRepository.salvar(contato);
                        objectIdController.text     = "";
                        nameController.text           = "";
                        emailController.text          = "";
                        dataNascimentoController.text = "";
                        telefoneController.text       = "";
                        imagemPathController.text     = "";
                        contatoModel                 = await contatoRepository.obterDados();
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                        setState(() {
                          _imagem = null;
                        });
                      }, 
                      child: const Text("Salvar")
                    
                    ),
              
                ],),
                )
              ]),
            );
          });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //drawer: const CustomDrawer(),
        floatingActionButton: FloatingActionButton(onPressed: (){
          _showModalBottomSheet(null);
        },
        tooltip: "Contatos DIO", 
        child: const Icon(Icons.add),
        ),
        body: Column(
            children: [
            (contatoModel.isEmpty) ?
              const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      "Sem registros para serem listados",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                )
            :
              Expanded(
                child: ListView.builder(
                        itemCount: contatoModel.length,
                        itemBuilder: (_, int index){
                          return 
                              Dismissible(
                                  key: Key(UniqueKey().toString()),
                                  background: Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onDismissed: (direction) async {
                                    await contatoRepository.delete(index);
                                    contatoModel = await contatoRepository.obterDados();
                                    setState(() {});
                                  },
                                  child: Card(
                                    child:  Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        // ignore: sized_box_for_whitespace
                                        children:[Container(
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            
                                                  children: [
                                                  //, ${viaCepModel[index].complemento}, ${viaCepModel[index]} , ${viaCepModel[index].bairro}, 
                                                    Row(
                                                      children: [

                                                        Flexible(
                                                          flex:2,
                                                          fit: FlexFit.tight,
                                                          child: CircleAvatar(
                                                            radius: 45,
                                                            backgroundImage: (contatoModel[index].imagemPath != null && contatoModel[index].imagemPath!.isNotEmpty) ? FileImage(File(contatoModel[index].imagemPath!)) : const NetworkImage(imagemPadraoUrl) as ImageProvider<Object>?,
                                                          ),
                                                        ),
                                                        Flexible(
                                                          flex: 4,
                                                          fit: FlexFit.loose,
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                contatoModel[index].name,
                                                                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                                                              ),
                                                              Text(
                                                                contatoModel[index].email,
                                                                style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
                                                              ),
                                                              Text(
                                                                contatoModel[index].dataNascimento,
                                                                style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
                                                              ),
                                                              Text(
                                                                contatoModel[index].telefone,
                                                                style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 10),
                                                              ),
                                                              
                                                            ],
                                                          ),
                                                        ),
                                                        
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,                                                          
                                                          children: [
                                                            InkWell(
                                                              child: const Icon(Icons.edit),
                                                              onTap: () {
                                                                setState(() {
                                                                  _imagem = null;
                                                                });
                                                                _showModalBottomSheet(contatoModel[index]);
                                                              },
                                                                
                                                            )
                                                          ],
                                                        ),
                                                        
                                                      ],
                                                    ),
                                                   
                                        
                                        
                                                  ],
                                                ),
                                        ),
                                  
                                          ],
                                        )
                                  
                                      ),
                                    ),
                                
                                
                              );
                        
                        },
                      ),
              ),
          ],
        ),
              
      ),
    );
  }
}