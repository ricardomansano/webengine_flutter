import 'package:flutter/material.dart';
import 'dart:js' as js; // Integracao com JS

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Flutter via WebEngine';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const MyCustomForm(),
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({Key? key}) : super(key: key);

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  
  // Controla "estado" de preenchimento do Form
  final _formKey = GlobalKey<FormState>();

  // Variaveis que serao preenchidas do Form
  String name = "";
  String niver = "";
  List<String> nivers = [];

  @override
  Widget build(BuildContext context) {
    // Formulario
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Aniversariante
          //--------------------
          TextFormField(
            decoration: const InputDecoration(labelText: 'Aniversariante'), // placeHolder

            // Valida preenchimento
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },

            // Atualiza variavel prenchida
            onChanged: (text) {
              setState(() {
                name = text;
              });
            },
          ),

          // Data aniversario
          //--------------------
          TextFormField(
            maxLength: 10,
            decoration: const InputDecoration(labelText: 'Niver'),

            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },

            onChanged: (text) {
              setState(() {
                niver = text;
              });
            },
          ),

          // Boatao Inserir
          // ------------------
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              child: const Text('INSERIR'),

              onPressed: () {
                // Se o Form estiver preenchido
                if (_formKey.currentState!.validate()) {
  
                  // print("Salvo: $name / $niver"); // Debug
                  // Atualiza lista de aniversariantes
                  setState(() {
                    nivers.add("$name | $niver");

                    // Envia dados ao Protheus
                    js.context.callMethod('jsToAdvpl', ["<INSERT>", "$name | $niver"]);
                  });
  
                  // Exibe barra inferior
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: (Text('Saving data...'))));
                }
              },
            ),
          ),

          // Exibe lista de aniversariantes
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: nivers.length,
            itemBuilder: (context, i) {
              return ListTile(
                leading: 
                    SizedBox(
                      height: 30.0,
                      width: 30.0,
                      child: FittedBox(
                        child: FloatingActionButton(

                          // Botao "Apagar"
                          tooltip: 'Apagar',
                          child: const Icon(Icons.delete),
                          onPressed: (){                            
                            setState(() {
                              nivers.removeAt(i);

                              // Envia dados ao Protheus
                              String s = i.toString();
                              js.context.callMethod('jsToAdvpl', ["<DELETE>", s]);
                            });

                          },
                        )
                      )
                    ),
                  title:Text(nivers[i]),
                );
            },
          )

        ],
      ),
    );
  }
}
