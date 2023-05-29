//
//  ViewController.swift
//  Challenge3
//
//  Created by Ning, Xinran on 29/5/23.
//

import UIKit

class ViewController: UIViewController {

  var ALL_WORDS = [String]()
  var CURRENT_LEVEL = 0 {
    didSet { levelLabel.text = "level: \(CURRENT_LEVEL + 1)" }
  }
  var CHANCES_LEFT = 7 {
    didSet { chancesLabel.text = "chances left: \(CHANCES_LEFT)" }
  }
  var currentWord = ""
  var currentAnswer = "" {
    didSet { currentAnswerLabel.text = currentAnswer }
  }
  var levelLabel: UILabel!
  var chancesLabel: UILabel!
  var currentAnswerLabel: UILabel!
  var makeGuessButton: UIButton!

  override func loadView() {
    view = UIView()
    view.backgroundColor = .white

    // levelLabel
    levelLabel = UILabel()
    levelLabel.translatesAutoresizingMaskIntoConstraints = false
    levelLabel.text = "level: \(CURRENT_LEVEL + 1)"
    levelLabel.textAlignment = .left
    levelLabel.font = .systemFont(ofSize: 12)
    view.addSubview(levelLabel)

    // chancesLabel
    chancesLabel = UILabel()
    chancesLabel.translatesAutoresizingMaskIntoConstraints = false
    chancesLabel.text = "chances left: \(CHANCES_LEFT)"
    chancesLabel.textAlignment = .right
    chancesLabel.font = .systemFont(ofSize: 12)
    view.addSubview(chancesLabel)

    // currentAnswerLabel
    currentAnswerLabel = UILabel()
    currentAnswerLabel.translatesAutoresizingMaskIntoConstraints = false
    currentAnswerLabel.textAlignment = .center
    currentAnswerLabel.font = .systemFont(ofSize: 32)
    currentAnswerLabel.textColor = .systemBlue
    view.addSubview(currentAnswerLabel)

    // makeGuessButton
    makeGuessButton = UIButton(type: .system)
    makeGuessButton.translatesAutoresizingMaskIntoConstraints = false
    makeGuessButton.setTitle("make a guess", for: .normal)
    makeGuessButton.tintColor = .systemBlue
    makeGuessButton.addTarget(self, action: #selector(makeGuess), for: .touchUpInside)
    view.addSubview(makeGuessButton)


    // Activate constraints
    NSLayoutConstraint.activate([
      levelLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
      levelLabel.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
      chancesLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
      chancesLabel.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor),
      currentAnswerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      currentAnswerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
      makeGuessButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      makeGuessButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 30)
    ])
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    title = "the hangman game"
    loadWords()
    loadLevel(action: nil)
  }

  @objc func makeGuess() {
    let ac = UIAlertController(title: "Make a guess:", message: nil, preferredStyle: .alert)
    ac.addTextField()
    let submitGuess = UIAlertAction(title: "Enter", style: .default) { [weak self, weak ac] _ in
      guard let input = ac?.textFields?[0].text else { return }
      self?.submitGuessHandler(input: input)
    }
    ac.addAction(submitGuess)
    present(ac, animated: true)
  }

  func submitGuessHandler(input: String) {
    print("SubmitGuessHandler called.")
    let ans = ALL_WORDS[CURRENT_LEVEL].split(separator: "")
    if input.count != ans.count {
      let ac = UIAlertController(title: "Oops...",
                                 message: "Please give an answer that matches the number of letters shown.",
                                 preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .cancel))
      present(ac, animated: true)
    } else {
      CHANCES_LEFT -= 1
      var cur = Array(currentAnswer)
      for (i, char) in input.enumerated() {
        if ans[i].lowercased() == String(char).lowercased() {
          cur[i] = char
        }
      }
      currentAnswer = String(cur).uppercased()
    }

    // Validate answer and chances left
    if currentAnswer == ALL_WORDS[CURRENT_LEVEL] {
      CURRENT_LEVEL += 1
      let ac = UIAlertController(title: "correct!", message: "you guessed it! the answer was \(currentAnswer).", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "next level", style: .default, handler: loadLevel))
      present(ac, animated: true)
    } else if CHANCES_LEFT <= 0 {
      let ac = UIAlertController(title: "oh no...", message: "you have no more chances left. try again!", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "try again", style: .default, handler: loadLevel))
      present(ac, animated: true)
    }
  }

  func loadWords() {
    if let wordsURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
      if let wordsContents = try? String(contentsOf: wordsURL) {
        ALL_WORDS = wordsContents.components(separatedBy: "\n")
      }
    }
  }

  func loadLevel(action: UIAlertAction?) {
    if CURRENT_LEVEL+1 == ALL_WORDS.count {
      CURRENT_LEVEL = 0
      let ac = UIAlertController(title: "game has ended. good job:)", message: nil, preferredStyle: .actionSheet)
      ac.addAction(UIAlertAction(title: "restart", style: .default, handler: loadLevel))
      present(ac, animated: true)
    }

    CHANCES_LEFT = 7  // reset chances_left
    currentAnswer = ""
    currentWord = ALL_WORDS[CURRENT_LEVEL]
    for _ in 0..<currentWord.count {
      currentAnswer.append("?")
    }
    currentAnswerLabel.text = currentAnswer
  }
  
}

