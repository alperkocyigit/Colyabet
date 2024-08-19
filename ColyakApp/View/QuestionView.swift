//
//  QuestionView.swift
//  ColyakApp
//
//  Created by Alper Koçyiğit on 28.06.2024.
//

import SwiftUI
import SDWebImageSwiftUI

struct QuestionView: View {
    let quiz: Quiz
    @State private var userAnswers: [String] = []
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var showResult = false
    @StateObject var vm = QuizViewModel()
    
    var body: some View {
        VStack(spacing: 25) {
            headerView
               
            ScrollView {
                questionsView
            }
            .background(Color(red: 0.97, green: 0.97, blue: 0.97))
            finishButton
        }
        .scrollContentBackground(.hidden)
        .navigationBarBackButtonHidden(true)
        .background(
            NavigationLink(destination: ResultView(quiz: quiz, userAnswers: userAnswers, vm: vm), isActive: $showResult) {
                EmptyView()
            }
        )
        .onAppear {
            userAnswers = Array(repeating: "", count: quiz.questionList?.count ?? 0)
        }
    }
    
    private var headerView: some View {
        VStack {
            ZStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 12, height: 20)
                            .foregroundColor(.black)
                            .padding(.horizontal)
                    })
                    Spacer()
                }
                
                Text(quiz.topicName ?? "")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.black)
                
            }
        }
        .padding(.top)
        .frame(width: UIScreen.main.bounds.width)
    }
    
    private var questionsView: some View {
        VStack(spacing: 20) {
            ForEach(0..<(quiz.questionList?.count ?? 0), id: \.self) { index in
                questionCardView(for: index)
            }
        }
        .padding(.top)
        .padding(.horizontal)
        .frame(width: UIScreen.main.bounds.width)
        .cornerRadius(15)
        
    }
    
    private func questionCardView(for index: Int) -> some View {
        VStack(spacing: 15) {
            HStack {
                Circle()
                    .frame(width: 25, height: 25)
                    .foregroundColor(Color(red: 1, green: 0.48, blue: 0.22))
                  
                Text("Soru \(index + 1)")
                    .font(.title3)
                    .fontWeight(.semibold)
                   
                Spacer()
            }
            .padding(.leading,6)
            .padding(.bottom,10)
            HStack {
                Text(quiz.questionList?[index].question ?? "")
                    .font(Font.custom("Urbanist", size: 18).weight(.medium))
                    .multilineTextAlignment(.leading)
                    .lineSpacing(8)
                    .foregroundColor(Color(red: 0.61, green: 0.61, blue: 0.61))
            }
            .padding(.bottom,10)
            ForEach(0..<(quiz.questionList?[index].choicesList?.count ?? 0), id: \.self) { optionIndex in
                optionButton(for: index, optionIndex: optionIndex)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }
    
    private func optionButton(for questionIndex: Int, optionIndex: Int) -> some View {
        let choice = quiz.questionList?[questionIndex].choicesList?[optionIndex]
        return Button(action: {
            if userAnswers.count <= questionIndex {
                userAnswers.append(choice?.choice ?? "")
            } else {
                userAnswers[questionIndex] = choice?.choice ?? ""
            }
        }) {
            HStack {
                WebImage(url: URL(string: "https://api.colyakdiyabet.com.tr/api/image/get/\(choice?.imageId ?? 0)")) { image in
                       image.resizable() // Control layout like SwiftUI.AsyncImage, you must use this modifier or the view will use the image bitmap size
                   } placeholder: {
                       Image(systemName: "questionmark.square")
                           .resizable()
                           .foregroundColor(.black)
                           .scaledToFit()
                           .frame(width:45,height: 45)
                           .cornerRadius(8)
                   }
                 
                   .indicator(.activity)
                   .scaledToFit()
                   .frame(width:45,height: 45)
                   .cornerRadius(8)
                   .padding(.leading)
                
                Text(choice?.choice ?? "")
                    .padding()
                    .foregroundColor(.black)
                Spacer()
                if userAnswers.count > questionIndex && userAnswers[questionIndex] == choice?.choice {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
    }
    
    private var finishButton: some View {
        Button(action: {
            submitAnswers()
        }) {
            Text("Testi Bitir")
                .bold()
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(25)
        }
    }
    private func submitAnswers() {
        for (index, _) in userAnswers.enumerated() {
            let questionId = quiz.questionList?[index].id ?? 0
            let chosenAnswer = userAnswers[index]
            
            vm.submitAnswer(questionId: questionId, chosenAnswer: chosenAnswer)
        }
        showResult = true
    }
}

#Preview {
    NavigationView {
        QuestionView(quiz: Quiz(id: 1, topicName: "Test Quiz", questionList: [
            Question(id: 1, question: "Hangisi bir meyve değildirkmklk fwlkmfnkwmfkl fkwmfkwflkwm wmfklwmkfmwl fwlnfkwkfnw kwmnkflw wjrklwjfwkflkw fmlkwfmkwmklk ?", choicesList: [
                Choice(id: 1, choice: "Elma", imageId: 1),
                Choice(id: 2, choice: "Armut", imageId: 1),
                Choice(id: 3, choice: "Patates", imageId: 1),
                Choice(id: 4, choice: "Çilek", imageId: 1)
            ], correctAnswer: "Patates"),
            Question(id: 2, question: "Hangisi bir renk değildir?", choicesList: [
                Choice(id: 1, choice: "Kırmızı", imageId: 1),
                Choice(id: 2, choice: "Mavi", imageId: 1),
                Choice(id: 3, choice: "Yeşil", imageId: 1),
                Choice(id: 4, choice: "Sandalye", imageId: 1)
            ], correctAnswer: "Sandalye")
        ], deleted: false))
    }
}


struct ResultView: View {
    let quiz: Quiz
    let userAnswers: [String]
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var vm : QuizViewModel
    
    var body: some View {
        VStack(spacing: 25) {
            headerView
            scoreView
            ScrollView {
                resultsView
            }
            homeButton
        }
        .navigationBarBackButtonHidden(true)
        .onAppear(perform: {
            Task {
                do {
                    try await vm.fetchQuizScore(byId: quiz.id ?? 0)
                } catch {
                    print("Error fetching quiz score: \(error)")
                }
            }
        })
    }
    
    private var headerView: some View {
        VStack {
            Text("Sonuçlar")
                .font(.title3)
                .bold()
                .foregroundColor(.black)
        }
        .padding(.top)
        .frame(width: UIScreen.main.bounds.width)
    }
    private var scoreView: some View {
        VStack {
            HStack {
                Text("Score:\(vm.score)")
                    .bold()
                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                    .foregroundColor(.black)
            }
        }
    }
    private var resultsView: some View {
        VStack(spacing: 20) {
            ForEach(0..<(quiz.questionList?.count ?? 0), id: \.self) { index in
                resultCardView(for: index)
            }
        }
        .padding(.top)
        .padding(.horizontal)
        .frame(width: UIScreen.main.bounds.width)
        .background(Color(red: 0.97, green: 0.97, blue: 0.97))
    }
    
    private func resultCardView(for index: Int) -> some View {
        let question = quiz.questionList?[index]
        let userAnswer = userAnswers.count > index ? userAnswers[index] : ""
        let correctAnswer = question?.correctAnswer ?? ""
        let isCorrect = userAnswer == correctAnswer
        
        return VStack(spacing: 10) {  // Spacing adjusted
            HStack {
                Circle()
                    .frame(width: 20, height: 20)  // Size adjusted
                    .foregroundColor(isCorrect ? .green : .red)
                Text("Soru \(index + 1)")
                    .font(.headline)  // Font size adjusted
                Spacer()
            }
            Text(question?.question ?? "")
                .font(Font.custom("Urbanist", size: 18).weight(.medium))  // Font size adjusted
                .lineSpacing(6)  // Line spacing adjusted
                .foregroundColor(Color(red: 0.61, green: 0.61, blue: 0.61))
            
            ForEach(0..<(question?.choicesList?.count ?? 0), id: \.self) { optionIndex in
                let choice = question?.choicesList?[optionIndex]
                let userSelected = userAnswer == choice?.choice
                let correct = correctAnswer == choice?.choice
                resultOptionButton(choice: choice, userSelected: userSelected, correct: correct)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }
    
    private func resultOptionButton(choice: Choice?, userSelected: Bool, correct: Bool) -> some View {
        HStack {
            Text(choice?.choice ?? "")
                .padding()
            Spacer()
            if userSelected {
                Image(systemName: correct ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(correct ? .green : .red)
            } else if correct {
                Text("Doğru Cevap")
                    .foregroundColor(.green)
                    .font(.caption)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
    
    private var homeButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Text("Geri Dön")
                .bold()
                .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(25)
        }
        .padding(.bottom, 20)
    }
}

#Preview {
    NavigationView {
        ResultView(quiz: Quiz(id: 1, topicName: "Test Quiz", questionList: [
            Question(id: 1, question: "Hangisi bir meyve değildir?", choicesList: [
                Choice(id: 1, choice: "Elma", imageId: 1),
                Choice(id: 2, choice: "Armut", imageId: 1),
                Choice(id: 3, choice: "Patates", imageId: 1),
                Choice(id: 4, choice: "Çilek", imageId: 1)
            ], correctAnswer: "Patates"),
            Question(id: 2, question: "Hangisi bir renk değildir?", choicesList: [
                Choice(id: 1, choice: "Kırmızı", imageId:1),
                Choice(id: 2, choice: "Mavi", imageId: 1),
                Choice(id: 3, choice: "Yeşil", imageId: 1),
                Choice(id: 4, choice: "Sandalye", imageId: 1)
            ], correctAnswer: "Sandalye")
        ], deleted: false), userAnswers: ["Patates", "Kırmızı"], vm: QuizViewModel())
    }
}
