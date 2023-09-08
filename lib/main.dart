import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(AcademicCalculatorApp());
}

class AcademicCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Média Acadêmica - Ponderada',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        brightness: Brightness.dark,
      ),
      home: CalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  List<TextEditingController> gradeControllers =
      List.generate(5, (index) => TextEditingController());

  List<TextEditingController> weightControllers =
      List.generate(5, (index) => TextEditingController());

  double average = 0.0;

  String nomeAluno = "ENRICO FERREIRA DOS SANTOS";
  String raAluno = "1431432312012";

  void _calculateAverage() {
    double total = 0.0;
    double totalWeight = 0.0;

    for (int i = 0; i < 5; i++) {
      String gradeText = gradeControllers[i].text.trim();
      String weightText = weightControllers[i].text.trim();

      if (gradeText.isNotEmpty && weightText.isNotEmpty) {
        double grade = double.tryParse(gradeText) ?? 0.0;
        double weight = double.tryParse(weightText) ?? 1.0;

        if (grade >= 0 && grade <= 10 && weight > 0) {
          total += (grade * weight);
          totalWeight += weight;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'As notas devem estar entre 0 e 10 e o peso deve ser positivo.'),
          ));
          return;
        }
      }
    }

    setState(() {
      average = totalWeight > 0 ? total / totalWeight : 0.0;
    });
  }

  void _reset() {
    for (TextEditingController controller in gradeControllers) {
      controller.clear();
    }

    for (TextEditingController controller in weightControllers) {
      controller.clear();
    }

    setState(() {
      average = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de Média Acadêmica - Ponderada'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(height: 16.0),
          Text(
            nomeAluno,
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 8.0),
          Text(
            raAluno,
            style: TextStyle(fontSize: 16.0),
          ),
          for (int i = 0; i < 5; i++)
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Nota ${i + 1}:',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  Row(
                    children: <Widget>[
                      Flexible(
                        flex: 2,
                        child: TextField(
                          controller: gradeControllers[i],
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                            signed: false,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}$')),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Nota',
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Flexible(
                        flex: 1,
                        child: TextField(
                          controller: weightControllers[i],
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                            signed: false,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}$')),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Peso',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: _calculateAverage,
                child: Text('Calcular Média Ponderada'),
              ),
              SizedBox(width: 16.0),
              ElevatedButton(
                onPressed: _reset,
                child: Text('Limpar'),
              ),
            ],
          ),
          SizedBox(height: 20.0),
          Text(
            'Média Ponderada: ${average.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (TextEditingController controller in gradeControllers) {
      controller.dispose();
    }

    for (TextEditingController controller in weightControllers) {
      controller.dispose();
    }

    super.dispose();
  }
}
