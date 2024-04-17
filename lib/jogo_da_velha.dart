import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class JogoDaVelha extends StatefulWidget {
  @override
  _JogoDaVelhaState createState() => _JogoDaVelhaState();
}

class _JogoDaVelhaState extends State<JogoDaVelha> {
  List<String> _tabuleiro = List.filled(9, '');
  String _turno = 'X';
  String _mensagem = 'Jogador X começa!';
  bool _contraComputador = false;
  String _simboloSelecionado = 'X';
  String _nomeJogadorX = '';
  String _nomeJogadorO = '';

  @override
  void initState() {
    super.initState();
    _iniciarJogo();
  }

  // Função para iniciar um novo jogo
  void _iniciarJogo() {
    setState(() {
      _tabuleiro = List.filled(9, ''); // Limpa o tabuleiro
      if (_contraComputador) {
        _turno = _simboloSelecionado;
        String nomeJogador = _simboloSelecionado == 'X' ? _nomeJogadorX : _nomeJogadorO;
        _mensagem = 'Jogador $_turno ($nomeJogador) começa!';
        if (_turno == 'O') {
          Timer(Duration(seconds: 1), () {
            _realizarJogadaAutomatica();
          });
        }
      } else {
        _turno = _simboloSelecionado;
        String nomeJogador = _simboloSelecionado == 'X' ? _nomeJogadorX : _nomeJogadorO;
        _mensagem = 'Jogador $_turno ($nomeJogador) começa!';
      }
    });
  }

  // Função para realizar uma jogada
  void _realizarJogada(int indice) {
    if (_tabuleiro[indice] == '' && (!_contraComputador || _turno == 'X')) {
      setState(() {
        _tabuleiro[indice] = _turno;
        if (_verificarVitoria(_turno)) {
          String nomeJogador = _turno == 'X' ? _nomeJogadorX : _nomeJogadorO;
          _mensagem = 'Jogador $_turno ($nomeJogador) ganhou!';
        } else if (_tabuleiro.every((element) => element != '')) {
          _mensagem = 'Deu velha!';
        } else {
          _turno = (_turno == 'X') ? 'O' : 'X';
          String nomeJogador = _turno == 'X' ? _nomeJogadorX : _nomeJogadorO;
          _mensagem = 'Jogador $_turno ($nomeJogador) é a sua vez!';
          if (_contraComputador && _turno == 'O') {
            Timer(Duration(seconds: 1), () {
              _realizarJogadaAutomatica();
            });
          }
        }
      });
    }
  }

  // Função para realizar uma jogada automática do computador
  void _realizarJogadaAutomatica() {
    int posicao;
    do {
      posicao = Random().nextInt(9); // Gerar posição aleatória
    } while (_tabuleiro[posicao] != ''); // Verificar se a posição está vazia
    setState(() {
      _tabuleiro[posicao] = 'O'; // Realizar jogada do computador
      if (_verificarVitoria('O')) {
        _mensagem = 'Jogador O ($_nomeJogadorO) ganhou!';
      } else if (_tabuleiro.every((element) => element != '')) {
        _mensagem = 'Deu velha!';
      } else {
        _turno = 'X';
        _mensagem = 'Jogador $_turno ($_nomeJogadorX) é a sua vez!';
      }
    });
  }

  // Função para verificar se houve vitória
  bool _verificarVitoria(String jogador) {
    for (int i = 0; i < 3; i++) {
      if (_tabuleiro[i * 3] == jogador &&
          _tabuleiro[i * 3 + 1] == jogador &&
          _tabuleiro[i * 3 + 2] == jogador) {
        return true;
      }
      if (_tabuleiro[i] == jogador &&
          _tabuleiro[i + 3] == jogador &&
          _tabuleiro[i + 6] == jogador) {
        return true;
      }
    }
    if (_tabuleiro[0] == jogador &&
        _tabuleiro[4] == jogador &&
        _tabuleiro[8] == jogador) {
      return true;
    }
    if (_tabuleiro[2] == jogador &&
        _tabuleiro[4] == jogador &&
        _tabuleiro[6] == jogador) {
      return true;
    }
    return false;
  }

  // Função para reiniciar o jogo
  void _reiniciarJogo() {
    setState(() {
      _iniciarJogo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('JOGO DA VELHA'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              _mensagem,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _contraComputador,
                  onChanged: (bool? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _contraComputador = newValue;
                        _iniciarJogo();
                      });
                    }
                  },
                ),
                Text(
                  'Jogar contra o computador',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 20),
            Wrap(
              spacing: 10,
              alignment: WrapAlignment.center,
              children: <Widget>[
                ChoiceChip(
                  label: Text('Jogar com X'),
                  selected: _simboloSelecionado == 'X',
                  onSelected: (bool selected) {
                    if (selected) {
                      setState(() {
                        _simboloSelecionado = 'X';
                        _iniciarJogo();
                      });
                    }
                  },
                ),
                ChoiceChip(
                  label: Text('Jogar com O'),
                  selected: _simboloSelecionado == 'O',
                  onSelected: (bool selected) {
                    if (selected) {
                      setState(() {
                        _simboloSelecionado = 'O';
                        _iniciarJogo();
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                setState(() {
                  _nomeJogadorX = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Nome do Jogador X',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              onChanged: (value) {
                setState(() {
                  _nomeJogadorO = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Nome do Jogador O',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _realizarJogada(index),
                  child: Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Text(
                        _tabuleiro[index],
                        style: TextStyle(fontSize: 40),
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _reiniciarJogo,
              child: Text('Reiniciar Jogo'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: JogoDaVelha(),
    debugShowCheckedModeBanner: false,
  ));
}
