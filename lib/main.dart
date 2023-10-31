// ignore_for_file: prefer_const_constructors

// assets credits <a href="https://www.flaticon.com/free-icons/spooky" title="spooky icons">Spooky icons created by Freepik - Flaticon</a>
// <a href="https://www.flaticon.com/free-icons/chameleon" title="chameleon icons">Chameleon icons created by Graficon - Flaticon</a>

import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MemoryGame());
}

class MemoryGame extends StatelessWidget {
  const MemoryGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage(), debugShowCheckedModeBanner: false,);
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<int> _numbers = [0, 0, 1, 1,
                        2, 2, 3, 3, 
                        4, 4, 5, 5, 
                        6, 6, 7, 7,
                        8, 8, 9, 9];
  final List<String> _images = ["bee", "cat", "chameleon", "chicken", "dolphin", "fox", "parrot", "sheep", "squirrel", "turtle"];

  late Timer liltempo;
  bool showingCards = true;
  bool gameHasStarted = false;
  bool showStats = false;
  
  List<bool> _selected = List.generate(20, (index) => true);

  List<int> numbersSelected = [];
  List<int> numbersFound = [];
  List<int> indexSelected = [];

  List<bool> isChecked = [false, false];
  bool alertIsOn = false;

  int tentativas = 0;

  void embaralhaCards () {
    _numbers.shuffle();
  }

  void restart() {
    embaralhaCards();
    numbersFound.clear();
    numbersSelected.clear();
    indexSelected.clear();
    _selected = List.generate(20, (index) => true);
    tentativas = 0;
  }

  @override
  void initState () {
    embaralhaCards();
    super.initState();
  }
  
  Widget checkbox (BuildContext context, int index) {
    return Checkbox(
      checkColor: Colors.white,
      value: isChecked[index],
      onChanged: (bool? value) {
        setState(() {
          isChecked[index] = value!;
        });
      });
  }
  
  Widget numberOrImg (int index){
    String img;
    switch (_numbers[index]){
      case 5:
        img = "bee";
        break;
      case 6:
        img = "cat";
        break;
      case 7:
        img = "chameleon";
        break;
      case 8:
        img = "chicken";
        break;
      case 9:
        img = "fox";
        break;
      default:
        img = "bee";
        break;
    }
    
    Widget image = Image(image: AssetImage("assets/images/$img.png"));
    Widget numero = Text(
      _numbers[index].toString(),
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 48),
    );

    if (_numbers[index] >= 5) return image;
    return numero;
  }
  
  @override
  Widget build(BuildContext context) {
    if (alertIsOn) {
      Timer (Duration(seconds: 2), () { 
        alertIsOn = false;
        setState(() {});
      });
    }

    if (gameHasStarted) {
      if (showingCards) {
        Timer (Duration(seconds: 2), () {
          // timer de 2 segundos para mostrar as cartas para serem memorizadas
          _selected = List.generate(20, (index) => false);
          showingCards = false;
          setState(() {});
        });
      }
      
      if (numbersFound.length == 20) {
        setState(() {
          gameHasStarted = false;
          showStats = true;
          
        });
      }
    }

    _onSelected (index) async {
      if (numbersFound.contains(_numbers[index]) == false && numbersSelected.length < 2) {
        // bloqueia seleção de cards se o par do número já não tiver sido encontrado
        // e se já tiver selecionado 2 cartas
        if (indexSelected.length < 2) {
          indexSelected.add(index);
        } else {
          indexSelected.clear();
          indexSelected.add(index);
        }
        
        _selected[index] = true;

        numbersSelected.add(_numbers[index]);

        if (numbersSelected.length > 1) {
          if (numbersSelected[0] == numbersSelected[1]) {
            numbersFound.add(numbersSelected[0]);
            numbersFound.add(numbersSelected[1]);
          }
          else {
            setState(() {});
            await Future.delayed(const Duration(seconds: 1));
            _selected[indexSelected[0]] = false;
            _selected[indexSelected[1]] = false;
          }

          tentativas++;
          numbersSelected.clear();
        }
        setState(() {});
      }}

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text("Jogo da Memória", style: TextStyle(color: Colors.white, fontSize: 28), textAlign: TextAlign.center)),
      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox( height: 12.0 ),
                if (showStats) ... [
                  Column(children: [
                    SizedBox( height: 24.0 ),
                    Text("vitória!", 
                      style: TextStyle(fontSize: 28, color: Colors.green)),
                    SizedBox( height: 12.0 ),
                    Text("você finalizou com $tentativas tentativas!", 
                      style: TextStyle(fontSize: 20, color: Colors.green)),
                    SizedBox( height: 18.0 ),
                  ],)
                ],

                if (gameHasStarted) ... [
                  Center(child: Text("tentativas: ${tentativas.toString()}", style: TextStyle(fontSize: 24),)),
                  SizedBox( height: 24.0 ),

                SizedBox(
                  height: 750,
                  width: 500,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: GridView.builder(
                      shrinkWrap: true,
                        itemCount: 20,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1,
                          crossAxisCount: 4,
                          crossAxisSpacing: 24.0,
                          mainAxisSpacing: 24.0,
                          mainAxisExtent: 125,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            child: card(context, index),
                            onTap: () {
                              if (gameHasStarted) _onSelected(index);
                            },
                          );
                        }),
                  ),
                ),
                ],
                if (!gameHasStarted) ... [
                    if (alertIsOn)... [
                      Column(children: const [
                        Text("você precisa selecionar algum modo para iniciar!", 
                          style: TextStyle(color: Colors.red, fontSize: 18),),
                        SizedBox( height: 12.0 ), ])
                    ],
                    SizedBox( height: 24.0 ),
                    Text("selecione o modo de jogo:", style: TextStyle(fontSize: 24),),
                    SizedBox( height: 12.0 ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        checkbox(context, 0), Text("imagens", style: TextStyle(fontSize: 20),),
                        SizedBox( width: 12.0 ),
                        checkbox(context, 1), Text("números", style: TextStyle(fontSize: 20),)
                      ]
                    ),
                    SizedBox( height: 24.0 ),
                    Center(
                      child:  ElevatedButton(
                        child: Text("iniciar jogo!", style: TextStyle(fontSize: 18),), 
                        onPressed: () {
                          (!isChecked[0] && !isChecked[1]) ?
                            setState(() { alertIsOn = true; })
                            : setState(() { 
                              restart();
                              showStats = false;
                              showingCards = true;
                              gameHasStarted = true; 
                          });
                        },
                      )
                    ),
                  ],],
            ),
        ));
  }

Widget card (BuildContext context, int index) {
  return isChecked[0] ? 
    isChecked[1] ? 
      bothCard(context, index)
      : imageCard(context, index)
    : numberCard(context, index);
}

Widget numberCard (BuildContext context, int index) {
  Color corCard;
  Widget lilnumber = Text(
      _numbers[index].toString(),
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 48),
      );

  (_selected[index]) ? corCard = Color.fromARGB(255, 234, 234, 234) : corCard = Color.fromARGB(255, 205, 205, 205);

  (gameHasStarted && _selected[index]) ?
    lilnumber = Text(
      _numbers[index].toString(),
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 48),
    ) 
    : lilnumber = Text("");
  
  return 
    Container( 
      alignment: Alignment.center,
      child: Ink(
          height: 140,
          width: 100,
          decoration: BoxDecoration(
            color: corCard,
            borderRadius: BorderRadius.all(Radius.circular(5))),
          child: lilnumber,
        )
    );
}

Widget imageCard (BuildContext context, int index) {
  Color corCard;

  Widget lilimg = Image(image: AssetImage("assets/images/${_images[_numbers[index]]}.png"));

  (_selected[index]) ? corCard = Color.fromARGB(255, 234, 234, 234) : corCard = Color.fromARGB(255, 205, 205, 205);

  (gameHasStarted && _selected[index]) ? lilimg = Image(image: AssetImage("assets/images/${_images[_numbers[index]]}.png")) : lilimg = Text("");

  return Container(
    alignment: Alignment.center,
    child: Ink(
      height: 140,
      width: 100,
      decoration: BoxDecoration(
        color: corCard,
        borderRadius: BorderRadius.all(Radius.circular(5))),
      child: lilimg,
    ),
  );
}

Widget bothCard (BuildContext context, int index) {
  Color corCard;

  (_selected[index]) ? corCard = Color.fromARGB(255, 234, 234, 234) : corCard = Color.fromARGB(255, 205, 205, 205);

  return Container(
    alignment: Alignment.center,
    child: Ink(
      height: 140,
      width: 100,
      decoration: BoxDecoration(
        color: corCard,
        borderRadius: BorderRadius.all(Radius.circular(5))),
      child: (gameHasStarted && _selected[index]) ? numberOrImg(index) : Text("")
    ),
  );
}
}
