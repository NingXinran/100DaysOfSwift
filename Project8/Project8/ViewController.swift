//
//  ViewController.swift
//  Project8
//
//  Created by Ning, Xinran on 25/5/23.
//

import UIKit

class ViewController: UIViewController {

  // The components in the interface, child views
  var cluesLabel: UILabel!
  var answersLabel: UILabel!
  var currentAnswer: UITextField!
  var scoreLabel: UILabel!
  var letterButtons = [UIButton]()

  var activatedButtons = [UIButton]()
  var solutions = [String]()
  var score = 0 {
    didSet { // added property observer to score
      scoreLabel.text = "Score: \(score)"
    }
  }
  var correct = 0
  var level = 1

  override func loadView() {
    // Main view is a white empty space
    view = UIView()
    view.backgroundColor = .white

    // position scoreLabel
    scoreLabel = UILabel()
    scoreLabel.translatesAutoresizingMaskIntoConstraints = false
    scoreLabel.textAlignment = .right
    scoreLabel.text = "Score: \(score)"
    view.addSubview(scoreLabel)

    // position cluesLabel
    cluesLabel = UILabel()
    cluesLabel.translatesAutoresizingMaskIntoConstraints = false
    cluesLabel.font = UIFont.systemFont(ofSize: 24)  // Uses whatever font the system is using
    cluesLabel.text = "CLUES"  //placeholder
    cluesLabel.numberOfLines = 0  // unnlimited
    cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
    view.addSubview(cluesLabel)

    // position answersLabel
    answersLabel = UILabel()
    answersLabel.translatesAutoresizingMaskIntoConstraints = false
    answersLabel.font = UIFont.systemFont(ofSize: 24)
    answersLabel.text = "ANSWERS"
    answersLabel.numberOfLines = 0  // unnlimited
    answersLabel.textAlignment = .right
    answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)  // Stretch this instead
    view.addSubview(answersLabel)

    // position currentAnswer
    currentAnswer = UITextField()
    currentAnswer.translatesAutoresizingMaskIntoConstraints = false
    currentAnswer.placeholder = "Tap letters below to guess"
    currentAnswer.textAlignment = .center
    currentAnswer.font = UIFont.systemFont(ofSize: 44)
    currentAnswer.isUserInteractionEnabled = false  // disables tapping to type
    view.addSubview(currentAnswer)

    // position submit buttons
    let submit = UIButton(type: .system)
    submit.translatesAutoresizingMaskIntoConstraints = false
    submit.setTitle("SUBMIT", for: .normal)
    submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)  // press down and lets go while finger is within button boundaries
    view.addSubview(submit)

    let clear = UIButton(type: .system)
    clear.translatesAutoresizingMaskIntoConstraints = false
    clear.setTitle("CLEAR", for: .normal)
    clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
    view.addSubview(clear)

    // Wrap all buttons in a conntainer view
    let buttonsView = UIView()
    buttonsView.translatesAutoresizingMaskIntoConstraints = false
    buttonsView.layer.borderWidth = 1
    view.addSubview(buttonsView)


    // Activate all constraints at once
    NSLayoutConstraint.activate([
      scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
      scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
      cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
      cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
      cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
      answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
      answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
      answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
      answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
      currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
      currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),

      submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
      submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
      submit.heightAnchor.constraint(equalToConstant: 44),
      clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
      clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
      clear.heightAnchor.constraint(equalTo: submit.heightAnchor),

      buttonsView.widthAnchor.constraint(equalToConstant: 750),
      buttonsView.heightAnchor.constraint(equalToConstant: 320),
      buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
      buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
    ])

    let width = 150
    let height = 80

    for row in 0..<4 {
      for column in 0..<5 {
        let letterButton = UIButton(type: .system)
        letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
        letterButton.setTitle("WWW", for: .normal)
        let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
        letterButton.frame = frame
        letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
        buttonsView.addSubview(letterButton)
        letterButtons.append(letterButton)
      }
    }

//    buttonsView.backgroundColor = .green
//    cluesLabel.backgroundColor = .red
//    answersLabel.backgroundColor = .blue
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    performSelector(inBackground: #selector(loadLevel), with: nil)
  }

  @objc func letterTapped(_ sender: UIButton) {
//    print("letterTapped")
    guard let buttonTitle = sender.titleLabel?.text else { return }  // get content of button safely
    currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
    activatedButtons.append(sender)
    sender.isHidden = true
  }

  @objc func submitTapped(_ sender: UIButton) {
//    print("submitTapped")
    guard let answerText = currentAnswer.text else { return }
    if let solutionPosition = solutions.firstIndex(of: answerText) {
      activatedButtons.removeAll()
      var splitAnswers = answersLabel.text?.components(separatedBy: "\n")  // split clues
      splitAnswers?[solutionPosition] = answerText  // replace clue with answer
      answersLabel.text = splitAnswers?.joined(separator: "\n")  // join back tgt

      currentAnswer.text = ""
      score += 1
      correct += 1
      // Property observer for the score property

      // finish level
      if correct % 7 == 0 {
        let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Go!", style: .default, handler: levelUp))
        present(ac, animated: true)
      }
    } else {
      if score > 0 { score -= 1}
      let ac = UIAlertController(title: "Oops!", message: "That's not quite right. Please try again.", preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      present(ac, animated: true)
    }

  }

  @objc func clearTapped(_ sender: UIButton) {
//    print("clearTapped")
    currentAnswer.text = ""
    for button in activatedButtons {
      button.isHidden = false
    }
    activatedButtons.removeAll()
  }

  @objc func loadLevel() {
    // Properties that are dynamic wrt level
    correct = 0  // reset
    var cluesString = ""
    var solutionsString = ""
    var letterBits = [String]()

    if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {  // there is a file
      if let levelContents = try? String(contentsOf: levelFileURL) {  // file has contents
        var lines = levelContents.components(separatedBy: "\n")
        lines.shuffle()

        for (i, line) in lines.enumerated() {
          let parts = line.components(separatedBy: ": ")
          let answer = parts[0]
          let clue = parts[1]

          cluesString += "\(i + 1). \(clue)\n"
          let solutionWord = answer.replacingOccurrences(of: "|", with: "")
          solutionsString += "\(solutionWord.count) letters\n"
          solutions.append(solutionWord)

          let bits = answer.components(separatedBy: "|")
          letterBits += bits
        }
      }
    }

    DispatchQueue.main.async{ [weak self] in
      self?.cluesLabel.text = cluesString.trimmingCharacters(in: .whitespacesAndNewlines)  // remove the last line break
      self?.answersLabel.text = solutionsString.trimmingCharacters(in: .whitespacesAndNewlines)

      self?.letterButtons.shuffle()
      if self?.letterButtons.count == letterBits.count {
        guard let numLetterButtons = self?.letterButtons.count else { return }
        for i in 0..<numLetterButtons {
          self?.letterButtons[i].setTitle(letterBits[i], for: .normal)
        }
      }
    }

  }

  func levelUp(action: UIAlertAction) {  // called from UI Alert action
    level += 1

    solutions.removeAll(keepingCapacity: true)
    loadLevel()

    for button in letterButtons {
      button.isHidden = false
    }
  }




}

