import 'package:calculo_imc2022/services/calculo_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _alturaController = TextEditingController();
  final _pesoController = TextEditingController();
  String _texto = '';

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          "Calculo IMC",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: atualizar,
            icon: Icon(Icons.refresh),
            tooltip: "Atualizar",
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    CircleAvatar(
                      backgroundImage: AssetImage("assets/images/perfil.jpg"),
                      radius: 80,
                      backgroundColor: Colors.transparent,
                    ),
                    TextFormField(
                      controller: _alturaController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Altura (cm)",
                        hintText: "Ex: 1.74",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.green,
                            width: 2,
                          ),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.green[700],
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Informe a altura!");
                        } else if (double.parse(value) == 0.0) {
                          return ("Altura deve ser maior que 0");
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _pesoController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Peso (KG)",
                        hintText: "Ex: 55",
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.green,
                            width: 2,
                          ),
                        ),
                        labelStyle: TextStyle(
                          color: Colors.green[700],
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Informe o peso!");
                        } else if (double.parse(value) == 0.0) {
                          return ("Peso deve ser maior que 0");
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _formKey.currentState!.validate() ? calcular() : null;
                        },
                        child: Text(
                          "Calcular",
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      _texto,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 25),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void atualizar() {
    _alturaController.clear();
    _pesoController.clear();
    setState(() {
      _texto = '';
      _formKey = GlobalKey<FormState>();
    });
  }

  void calcular() {
    double altura;
    double peso;

    try {
      altura = double.parse(_alturaController.text) / 100;
      peso = double.parse(_pesoController.text);
    } on FormatException catch (e) {
      if (e.message == 'Invalid double') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Valor Invalido!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
      throw CalculoException(e.message);
    }

    double imc = peso / (altura * altura);

    setState(() {
      if (imc < 18.6) {
        _texto = 'Abaixo do peso IMC: (${imc.toStringAsPrecision(4)})';
      } else if (imc >= 18.6 && imc < 24.9) {
        _texto = 'Peso ideal IMC: (${imc.toStringAsPrecision(4)})';
      } else if (imc >= 24.9 && imc < 29.9) {
        _texto = 'Levemente acima do peso IMC: (${imc.toStringAsPrecision(4)})';
      } else if (imc >= 29.9 && imc < 34.9) {
        _texto = 'Obesidade Grau 1 IMC: (${imc.toStringAsPrecision(4)})';
      } else if (imc >= 34.9 && imc < 39.9) {
        _texto = 'Obesidade Grau 2 IMC: (${imc.toStringAsPrecision(4)})';
      } else if (imc >= 40) {
        _texto = 'Obesidade Grau 3 IMC: (${imc.toStringAsPrecision(4)})';
      }
    });
  }
}
