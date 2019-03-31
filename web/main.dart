import 'dart:html';
import 'dart:math';

int wrongGuesses;
const int GUESS_LIMIT=5;
const String WORD_LIST_FILE = "word_lists/wordlist.txt";
const String CAPITAL_APHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
const List<String> HANGMANG_IMAGES = const ["images/hang0.jpg", "images/hang1.jpg",
    "images/hang2.jpg","images/hang3.jpg","images/hang4.jpg","images/hang5.jpg", "images/hang6.jpg"];
String lettersLft, secretWord;
bool gameOver;

void playLetter(String letter) {
  if (lettersLft.contains(letter) && !gameOver) {
    lettersLft = lettersLft.replaceFirst(new RegExp(letter), '');
    querySelector("#letter_list").text = lettersLft;

    if (secretWord.contains(letter)) {
      String oldDisplay = querySelector("#secret").text;
      String newDisplay = "";
      for (int i = 0; i < secretWord.length; i++) {
        if (secretWord[i] == letter) {
          newDisplay = newDisplay + letter;
        }
        else { // put the old back in
          newDisplay = newDisplay + oldDisplay[i];
        }
      }
      querySelector("#secret").text = newDisplay;
      if (newDisplay == secretWord) { // if we won
         gameOver = true;
         querySelector("#letter_list").text = "YOU WIN";
      }
    }
    else {
      wrongGuesses++;
      (querySelector("#hang_image") as ImageElement).src = HANGMANG_IMAGES[wrongGuesses]; if (wrongGuesses > GUESS_LIMIT) {
        gameOver = true; querySelector("#letter_list").text = "GAME OVER"; querySelector("#secret").text = secretWord;
      } }
  } }



void restart(){
  gameOver=false;
  chooseSecretWord();
  clearBoard();
}

void clearBoard(){
  wrongGuesses = 0;
  (querySelector("#hang_image") as ImageElement).src = HANGMANG_IMAGES[wrongGuesses];
  lettersLft = CAPITAL_APHABET;
  querySelector("#letter_list").text = lettersLft;
}

void chooseSecretWord(){
  HttpRequest.getString(WORD_LIST_FILE)
      .then((String fileContents) {
    List<String> words = fileContents.split("\n");
    Random rnd = new Random();
    secretWord = words[rnd.nextInt(words.length)];
    secretWord = secretWord.toUpperCase();
    window.console.log(secretWord);
    querySelector("#secret").text = secretWord.replaceAll(new RegExp(r'[a-zA-Z]'), "_");
  })
      .catchError((Error error) {
    print(error.toString());
  });
}

void main() {
  window.onKeyPress.listen((KeyboardEvent ke){
    String lastPressed = new String.fromCharCodes([ke.charCode]);
    lastPressed = lastPressed.toUpperCase();
    playLetter(lastPressed);
  });
  (querySelector("#hang_image") as ImageElement).src = HANGMANG_IMAGES[0];
  querySelector("#new_game_button").onClick.listen((MouseEvent me){
    restart();
  });
  restart();
}
