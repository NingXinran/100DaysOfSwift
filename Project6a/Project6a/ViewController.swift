//
//  ViewController.swift
//  Project6a
//
//  Created by Ning, Xinran on 18/5/23.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var button1: UIButton!
  @IBOutlet weak var button2: UIButton!
  @IBOutlet weak var button3: UIButton!

  var countries = [String]()
  var questionsAsked = 0
  var correctAnswer = 0
  var score = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "View Score", style: .plain, target: self, action: #selector(showScore))

    // Set up countries array
    countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]

    askQuestion()

    button2.imageView?.contentMode = .scaleToFill
    button2.layer.borderWidth = 1
    button1.layer.borderWidth = 1
    button3.layer.borderWidth = 1

    view.setNeedsLayout()
    view.layoutIfNeeded()
  }

  func askQuestion(action: UIAlertAction! = nil) {
    questionsAsked += 1
    countries.shuffle()  // Can also randomly pick but need to prevent overlap
    button1.setImage(UIImage(named: countries[0]), for: .normal)
    button2.setImage(UIImage(named: countries[1]), for: .normal)
    button3.setImage(UIImage(named: countries[2]), for: .normal)

    // Randomly select correct answer
    correctAnswer = Int.random(in: 0...2)
    title = countries[correctAnswer].uppercased() + " (Score: \(score))".uppercased()
  }

  func resetGame(action: UIAlertAction! = nil) {
    questionsAsked = 0
    score = 0
    askQuestion()
  }

  @IBAction func buttonTapped(_ sender: UIButton) {
    let chosen = sender.tag
    if chosen == correctAnswer {
      title = "Correct :)"
      score += 1
    } else {
      title = "Wrong :( That's the flag of \(countries[chosen])!"
    }

    if questionsAsked < 10 {
      // Show next question
      let ac = UIAlertController(title: title,
                                 message: "Your score is \(score)",
                                 preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: askQuestion))
      present(ac, animated: true)
    } else {
      // Final alert and close
      let ac = UIAlertController(title: "Done!",
                                 message: "You have scored \(score) out of \(questionsAsked). Well done!",
                                 preferredStyle: .alert)
      ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: resetGame))
      present(ac, animated: true)
    }

  }

  @objc func showScore() {
    let ac = UIAlertController(title:"Paused",
                               message: "You've scored \(score) out of \(questionsAsked - 1) questions so far.",
                               preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "Continue", style: .cancel, handler: .none))
    present(ac, animated: true)
  }

}

