import 'package:flutter/material.dart';

class ImcScreen extends StatefulWidget {
  const ImcScreen({super.key});

  @override
  State<ImcScreen> createState() => _ImcScreenState();
}

class _ImcScreenState extends State<ImcScreen> {
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  String _imcResult = '';
  String _imcClassification = '';

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  String _classifyIMC(double imc) {
    if (imc < 18.5) return 'Abaixo do peso';
    if (imc < 24.9) return 'Peso normal';
    if (imc < 29.9) return 'Sobrepeso';
    if (imc < 34.9) return 'Obesidade Grau I';
    if (imc < 39.9) return 'Obesidade Grau II';
    return 'Obesidade Grau III';
  }

  void _calculateIMC() {
    final double weight = double.tryParse(_weightController.text) ?? 0;
    final double height = double.tryParse(_heightController.text) ?? 0;

    if (weight <= 0 || height <= 0) {
      _showDialog('Erro', 'Por favor, insira valores válidos para peso e altura.');
      return;
    }

    final double imc = weight / (height * height);
    final String classification = _classifyIMC(imc);

    setState(() {
      _imcResult = imc.toStringAsFixed(2);
      _imcClassification = classification;
    });

    _showDialog('Resultado do IMC', 'Seu IMC é $_imcResult\n$_imcClassification');
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Peso:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ex: 70.5',
                  suffixText: 'kg',
                ),
                onChanged: (_) {
                  setState(() {
                    _imcResult = '';
                    _imcClassification = '';
                  });
                },
              ),
              const SizedBox(height: 20),
              const Text('Altura:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Ex: 1.75',
                  suffixText: 'm',
                ),
                onChanged: (_) {
                  setState(() {
                    _imcResult = '';
                    _imcClassification = '';
                  });
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _calculateIMC,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 5,
                ),
                child: const Text('Calcular', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
              Text(
                _imcResult.isNotEmpty
                    ? 'Seu IMC é $_imcResult\n$_imcClassification'
                    : 'Aguardando cálculo do IMC...',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
