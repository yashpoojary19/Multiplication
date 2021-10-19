//
//  SwiftUIViewNew.swift
//  Multiplication
//
//  Created by Yash Poojary on 18/10/21.
//

import SwiftUI


struct AnswerImage: View {
    var image: String
    
    var body: some View {
        Image(image)
            .renderingMode(.original)
            .scaleEffect(0.5)
            .frame(width: 80, height: 80)
    }
}


struct AnswerButton: ViewModifier {

    
    func body(content: Content) -> some View {
        content
            .frame(width: 300, height: 100, alignment: .center)
            .background(Color.gray)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
    }
}

extension View {
    func answerButton() -> some View {
        self.modifier(AnswerButton())
    }
}

struct GameLabel: ViewModifier {
    func body(content: Content) -> some View {
         content
            .padding()
            .background(Color.yellow)
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(Color.green, lineWidth: 2)
            )
            .padding(.bottom, 10)
            .padding(.top, 50)
    }
}

extension View {
    func drawGameLabel() -> some View {
        self.modifier(GameLabel())
    }
}


struct StartToEndButton: ViewModifier {
    var whatColor: Bool
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(whatColor ? Color.purple : Color.green)
            .clipShape(Capsule())
            .overlay(
                Capsule().stroke(Color.black, lineWidth: 2))
            .font(.title)
            .padding(.top, 10)
            .foregroundColor(.black)
        
    }
}

extension View {
    
    func drawStartAndEndButton(whatColor: Bool) -> some View {
        self.modifier(StartToEndButton(whatColor: whatColor))
    }
}

struct GamePicker: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .pickerStyle(SegmentedPickerStyle())
            .colorMultiply(.red)
            .padding(.bottom, 50)
    }
}

extension View {
    func drawGamePicker() -> some View {
        self.modifier(GamePicker())
    }
}


struct FontText: ViewModifier {
    let font = Font.system(size: 22, weight: .heavy, design: .default)
    
    func body(content: Content) -> some View {
        content
            .font(font)
        
    }
}

extension View {
    func setFontText() -> some View {
        self.modifier(FontText())
    }
}

struct DrawHorizontalText: View {
    var text: String
    var textResult: String
    
    
    var body: some View {
        HStack {
            Text(text)
                .modifier(FontText())
                .foregroundColor(Color.green)
            
            Text(textResult)
                .modifier(FontText())
                .foregroundColor(Color.red)
        }
        .padding(.top, 10)
    }
}



struct Question {
    var text: String
    var answer: Int
}


struct ContentView: View {
    
    @State private var imagesName = ["parrot", "duck", "dog", "horse", "rabbit", "whale", "rhino", "elephant", "zebra", "chicken", "cow", "panda", "hippo", "gorilla", "owl", "penguin", "sloth", "frog", "narwhal", "buffalo", "monkey", "giraffe", "moose", "pig", "snake", "bear", "chick", "walrus", "goat", "crocodile"]
    
    @State private var gameIsRunning = false
    @State private var multiplicationTable = 1
    let allMutiplicationTable = Range(1...12)
    
    @State private var numberOfQuestions = "5"
    let allPossibleQuestions = ["5", "10", "20", "All"]
    
//    @State private var arrayOfQuestions = [Question(text: "1 * 1", answer: 1), Question(text: "2 * 2 ", answer: 4), Question(text: "3 * 3", answer: 9), Question(text: "5 * 5", answer: 25)]
//
    
    @State private var arrayOfQuestions = [Question]()
    
    @State private var currentQuestion = 0
    
    
    @State private var totalScore = 0
    @State private var remainingQuestions = 0
    @State private var selectedNumber = 0
    
    
    @State private var isCorrect = false
    @State private var isWrong = false
    
    @State private var isShowAlert = false
    @State private var alertTitle = ""
    @State private var buttonAlertTitle = ""
    
    @State private var isWinGame = false
    
    @State private var answerArray = [Question]()
    
    var body: some View {
        Group {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                if gameIsRunning {
                    VStack {
                        Text("\(arrayOfQuestions[currentQuestion].text) ")
                                .drawGameLabel()
                                .font(.largeTitle)
                        ForEach(0..<4) { number in
                            Button(action: {})
                                {
                                    AnswerImage(image: imagesName[number])
                                        .padding()
                                    Text("\(answerArray[number].answer)")
                                        .foregroundColor(Color.black)
                                        .font(.largeTitle)
                                }
                                
                        }
                        
                        Button(action: {
                            gameIsRunning = false
                        }) {
                            Text("End Game")
                                .drawStartAndEndButton(whatColor: gameIsRunning)
                        }
                        
                        VStack {
                            DrawHorizontalText(text: "Total Score:", textResult: "\(totalScore)")
                            DrawHorizontalText(text: "Questions Remaining:", textResult: "\(remainingQuestions)")
                        }
                        
                        
                    }
                    
                }
                    else {
                        //settings block
                        VStack {
                            Text("Pick a multiplication table to practice")
                                .drawGameLabel()
                            
                            
                            Picker("Pick a multiplication table to practice", selection: $multiplicationTable) {
                                ForEach(allMutiplicationTable, id: \.self) {
                                    Text("\($0)")
                                }
                            }.drawGamePicker()
                            
                            
                            
                            Text("How many questions do you want to be asked?")
                            Picker("numberOfQuestions", selection: $numberOfQuestions) {
                                ForEach(allPossibleQuestions, id: \.self) {
                                    Text($0)
                                }
                            }
                            .drawGamePicker()
                            
                            Button(action: {
                                newGame()
                            }) {
                                Text("Start Game")
                                    .drawStartAndEndButton(whatColor: gameIsRunning)
                            }
                            Spacer()
                            
                        }
                        
                    }
                   
                }
            
            }
            .alert(isPresented: $isShowAlert) {
                Alert(title: Text("\(alertTitle)"), message: Text("Your score is \(totalScore)"), dismissButton: .default(Text("\(buttonAlertTitle)")){
                    if isWinGame {
                        newGame()
                        isWinGame = false
                        isCorrect  = false
                    } else if isCorrect {
                        isCorrect = false
                        newQuestion()
                    } else {
                        isWinGame = false
                    }
                })
            }
        }
    
    
    func createArrayOfQuestions() {
         for i in 1 ... multiplicationTable {
             for j in 1...12 {
                 let newQuestion = Question(text: "How much is: \(i) * \(j) ?", answer: i * j)
                 arrayOfQuestions.append(newQuestion)
             }
         }
         self.arrayOfQuestions.shuffle()
         self.currentQuestion = 0
         self.answerArray = []
     }
    
    func setCountOfQuestions() {
        guard let count = Int(self.numberOfQuestions) else {
            remainingQuestions  = arrayOfQuestions.count
            return
        }
        
        remainingQuestions = count
    }

    func createAnswersArray() {
         if currentQuestion + 4 < arrayOfQuestions.count {
             for i in currentQuestion ... currentQuestion + 3 {
                 answerArray.append(arrayOfQuestions[i])
             }
         } else {
             for i in arrayOfQuestions.count - 4 ..< arrayOfQuestions.count {
                 answerArray.append(arrayOfQuestions[i])
             }
         }
         self.answerArray.shuffle()
     }
      
    
    func newGame() {
        gameIsRunning = true
        arrayOfQuestions = []
        createArrayOfQuestions()
        currentQuestion = 0
        setCountOfQuestions()
        createAnswersArray()
        answerArray = []
        createAnswersArray()
        totalScore = 0
    }
    
    
    func newQuestion() {
        imagesName.shuffle()
        currentQuestion += 1
        answerArray = []
        createAnswersArray()
    }
    
    
    
    
    }


struct ContentView: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
