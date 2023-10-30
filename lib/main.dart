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

  int opt = 3;

  final List<int> _numbers = [0, 0, 1, 1,
                        2, 2, 3, 3, 
                        4, 4, 5, 5, 
                        6, 6, 7, 7,
                        8, 8, 9, 9];
  List<String> images = ["bee", "cat", "chameleon", "chicken", "dolphin", "fox", "parrot", "sheep", "squirrel", "turtle"];

   final List<int> _both = [0, 0, 1, 1,
                        2, 2, 3, 3, 
                        4, 4, 5, 5, 
                        6, 6, 7, 7,
                        8, 8, 9, 9];

  void embaralhaCards () {
    _numbers.shuffle();
  }

  late Timer liltempo;
  bool showingCards = true;
  
  List<bool> _selected = List.generate(20, (index) => true);

  List<int> numbersSelected = [];
  List<int> numbersFound = [];
  List<int> indexSelected = [];

  int erros = 0;

  @override
  void initState(){
    embaralhaCards();
    super.initState();
  }
  
  Widget numberOrImg (int index){
    String img = "bee";
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
      
    }
    Widget image = Image(image: AssetImage("assets/images/$img.png"));
    Widget numero = Text(
      _numbers[index].toString(),
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 48),
    );

    if(_numbers[index] >= 5) return image;
    return numero;
  }

  @override
  Widget build(BuildContext context) {


    double cardSizeHeigh = 50;
    double cardSizeWidth = 30;

    if (showingCards){
      Timer(Duration(seconds: 2), (){
        _selected = List.generate(20, (index) => false);
        showingCards = false;
        setState(() {
          
        });
      });
    }

    _onSelected (index) async {
      if (numbersFound.contains(_numbers[index]) == false) {
        if (indexSelected.length < 2) {
          indexSelected.add(index);
        }
        else {
          indexSelected.clear();
          indexSelected.add(index);
        }
        
        _selected[index] = true;

        numbersSelected.add(_numbers[index]);

        if (numbersSelected.length>1) {
          if(numbersSelected[0] == numbersSelected[1]){
            numbersFound.add(numbersSelected[0]);
            numbersFound.add(numbersSelected[1]);
            print("engual eu");
          }
          else{

            setState(() {});
            await Future.delayed(const Duration(seconds: 1));
            _selected[indexSelected[0]] = false;
            _selected[indexSelected[1]] = false;
            erros+=1;
          }
          numbersSelected.clear();
        }
        setState(() {});
      }}

    return Scaffold(
      appBar: AppBar(title: Text("Jogo da Memória", style: TextStyle(color: Colors.black),), backgroundColor: Colors.transparent, shadowColor: Colors.transparent,),
      body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 12.0,
                ),
                Center(child: Text("tentativas: ${erros.toString()}", style: TextStyle(fontSize: 24),)),
                SizedBox(
                  height: 24.0,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: GridView.builder(
                      shrinkWrap: true,
                        itemCount: 20,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          childAspectRatio: 1,
                          crossAxisCount: 4,
                          crossAxisSpacing: 32.0,
                          mainAxisSpacing: 16.0,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            child: card(context, index),
                            onTap: () {
                              _onSelected(index);
                              print(index);
                            },
                            );
                        }),
                  ),
                )
              ],
            ),
        ));
  }

Widget card(BuildContext context, int index){
  if (opt == 1) return NumberCard(context, index);
  if (opt == 2) return ImageCard(context, index);
  return bothCard(context, index);

}
  Widget NumberCard (BuildContext context, int index) {
    Color corCard;
    Widget lilnumber = Text(
        _numbers[index].toString(),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 48),
        );

    (_selected[index]) ? corCard = Colors.white : corCard = Color.fromARGB(255, 205, 205, 205);

    (_selected[index]) ? lilnumber = Text(
        _numbers[index].toString(),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 48),
        ) : lilnumber = Text("");
    
    return Ink(
      decoration: BoxDecoration(
        color: corCard,
        boxShadow: const [ BoxShadow(color: Color.fromARGB(255, 163, 162, 162), blurRadius: 5.0, offset: Offset(5, 5)) ],
        borderRadius: BorderRadius.all(Radius.circular(5))),
      height: 80,
      width: 20,
      // child: lilnumber,
      child: lilnumber,
    );
  }

  Widget ImageCard (BuildContext context, int index) {
    Color corCard;
    Widget lilnumber = Text(
        _numbers[index].toString(),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 48),
        );

    Widget lilimg = Image(image: AssetImage("assets/images/${images[_numbers[index]]}.png"));

    (_selected[index]) ? corCard = Colors.white : corCard = Color.fromARGB(255, 205, 205, 205);

    (_selected[index]) ? lilnumber = Text(
        _numbers[index].toString(),
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 48),
        ) : lilnumber = Text("");
    
    (_selected[index]) ? lilimg = Image(image: AssetImage("assets/images/${images[_numbers[index]]}.png")) : lilimg = Text("");

    return Ink(
      decoration: BoxDecoration(
        color: corCard,
        boxShadow: const [ BoxShadow(color: Color.fromARGB(255, 163, 162, 162), blurRadius: 5.0, offset: Offset(5, 5)) ],
        borderRadius: BorderRadius.all(Radius.circular(5))),
      height: 80,
      width: 60,
      // child: lilnumber,
      child: lilimg,
    );
  
  
  }


  Widget bothCard (BuildContext context, int index) {
    Color corCard;



    (_selected[index]) ? corCard = Colors.white : corCard = Color.fromARGB(255, 205, 205, 205);

    
    

    return Ink(
      decoration: BoxDecoration(
        color: corCard,
        boxShadow: const [ BoxShadow(color: Color.fromARGB(255, 163, 162, 162), blurRadius: 5.0, offset: Offset(5, 5)) ],
        borderRadius: BorderRadius.all(Radius.circular(5))),
      height: 80,
      width: 60,
      // child: lilnumber,
      child: (_selected[index]) ? numberOrImg(index) : Text("")
    );
  }
}
