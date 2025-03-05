import 'package:flutter/material.dart';

void main() {
  runApp(CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Calculadora(),
    );
  }
}

class Calculadora extends StatefulWidget {
  @override
  _CalculadoraState createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String _output = "0";
  String _currentInput = "";
  dynamic _num1;
  dynamic _num2;
  String _operacion = "";
  bool _debeLimpiar = false;
  bool _error = false;

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        _reset();
      } else if (buttonText == "⌫") {
        _borrarUltimo();
      } else if (buttonText == "+" || buttonText == "-" || buttonText == "x" || buttonText == "/") {
        if (_operacion.isNotEmpty && _currentInput.isNotEmpty) {
          _num2 = _parseNumber(_currentInput);
          _calcularResultado();
        } else if (_currentInput.isNotEmpty) {
          _num1 = _parseNumber(_currentInput);
        }
        if (!_error) {
          _operacion = buttonText;
          _output = "$_num1 $_operacion";
          _currentInput = "";
          _debeLimpiar = false;
        }
      } else if (buttonText == "=") {
        if (_operacion.isNotEmpty && _currentInput.isNotEmpty) {
          _num2 = _parseNumber(_currentInput);
          _calcularResultado();
          _operacion = "";
        }
      } else if (buttonText == ".") {
        if (!_currentInput.contains(".")) {
          if (_currentInput.isEmpty || _currentInput == "0") {
            _currentInput = "0.";
          } else {
            _currentInput += buttonText;
          }
          _output = _operacion.isEmpty ? _currentInput : "$_num1 $_operacion $_currentInput";
        }
      } else {
        if (_debeLimpiar || _error) {
          _reset();
        }

        if (buttonText == "0" && _currentInput == "0") {
          return;
        }

        if (_currentInput == "0" && buttonText != ".") {
          _currentInput = buttonText;
        } else {
          _currentInput += buttonText;
        }

        _output = _operacion.isEmpty ? _currentInput : "$_num1 $_operacion $_currentInput";
      }
    });
  }

  void _borrarUltimo() {
    if (_currentInput.isNotEmpty) {
      _currentInput = _currentInput.substring(0, _currentInput.length - 1);
      if (_currentInput.isEmpty) {
        _currentInput = "0";
      }
      _output = _operacion.isEmpty ? _currentInput : "$_num1 $_operacion $_currentInput";
    }
  }

  dynamic _parseNumber(String input) {
    return input.contains(".") ? double.parse(input) : int.parse(input);
  }

  void _calcularResultado() {
    if (_operacion == "/" && _num2 == 0) {
      _output = "Error";
      _error = true;
      return;
    }
    switch (_operacion) {
      case "+":
        _num1 += _num2;
        break;
      case "-":
        _num1 -= _num2;
        break;
      case "x":
        _num1 *= _num2;
        break;
      case "/":
        _num1 = _num1 / _num2;
        break;
    }
    _output = (_num1 is int || _num1 % 1 == 0) ? _num1.toInt().toString() : _num1.toString();
    _currentInput = "";
    _debeLimpiar = true;
  }

  void _reset() {
    _output = "0";
    _currentInput = "";
    _num1 = null;
    _num2 = null;
    _operacion = "";
    _debeLimpiar = false;
    _error = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Text(
                _output,
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: _error ? Colors.red : Colors.black),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
                _buildRow(["7", "8", "9", "/"]),
                _buildRow(["4", "5", "6", "x"]),
                _buildRow(["1", "2", "3", "-"]),
                _buildRow(["C", "0", ".", "+"]),
                _buildRow(["⌫", "", "=", ""]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> buttons) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttons.map((button) {
          return button.isEmpty
              ? Expanded(child: Container())
              : Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () => _buttonPressed(button),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: button == "=" ? Colors.orange : Colors.grey[200],
                        foregroundColor: button == "=" ? Colors.white : Colors.black,
                        textStyle: TextStyle(fontSize: 24),
                      ),
                      child: Text(button),
                    ),
                  ),
                );
        }).toList(),
      ),
    );
  }
}
