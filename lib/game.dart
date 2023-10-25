class Game {
  final String hiddenCardpath = 'assets/images/hidden.png';
  List<String>? gameImg;

  final int cardCount = 8;

  void initGame() {
    gameImg = List.generate(cardCount, (index) => hiddenCardpath);
  }
}
