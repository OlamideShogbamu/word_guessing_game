import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'game_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Word Guessing Game',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatelessWidget {
  final GameController controller = Get.put(GameController());
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Word Guessing Game'),
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Score Card
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.purpleAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.3),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Score: ${controller.score.value}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.yellow,
                      size: 30,
                    ),
                  ],
                )),
              ),

              SizedBox(height: 20),

              // Secret Word Display
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Secret Word',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 10),
                    Obx(() => Text(
                      ' ${'⭐' * controller.secretWord.value.length}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                        letterSpacing: 8,
                      ),
                    )),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Input Field
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Make Your Guess',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: textController,
                      onChanged: (value) {
                        if (value.length == 4) {
                          controller.makeGuess(value);
                          textController.clear();
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter 4-letter word...',
                        prefixIcon: Icon(Icons.edit, color: Colors.purple),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.purple, width: 2),
                        ),
                      ),
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Word List
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🧾 Available Words',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 15),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: controller.words.map((word) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.purple.withOpacity(0.3)),
                          ),
                          child: Text(
                            word,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.purple[700],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Guesses History
              Obx(() => controller.guesses.isNotEmpty
                  ? Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🎲 Your Guesses',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 15),
                    Column(
                      children: controller.guesses.map((guess) {
                        bool isCorrect = guess.toLowerCase() == controller.secretWord.value.toLowerCase();
                        return Container(
                          margin: EdgeInsets.only(bottom: 10),
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: isCorrect ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isCorrect ? Colors.green : Colors.red,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                guess.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: isCorrect ? Colors.green[700] : Colors.red[700],
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    isCorrect ? Icons.check_circle : Icons.cancel,
                                    color: isCorrect ? Colors.green : Colors.red,
                                    size: 20,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    isCorrect ? 'Correct!' : 'Try again',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: isCorrect ? Colors.green[700] : Colors.red[700],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              )
                  : Container()),

              SizedBox(height: 20),

              // New Game Button
              ElevatedButton(
                onPressed: () {
                  controller.newGame();
                  textController.clear();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  '🔄 New Game',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}