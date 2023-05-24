//
//  ViewController.swift
//  Project5
//
//  Created by Ning, Xinran on 23/5/23.
//

import UIKit

class ViewController: UITableViewController {

  var allWords = [String]()
  var usedWords = [String]()



  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New", style: .done, target: self, action: #selector(startGame))

    if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
      if let startWords = try? String(contentsOf: startWordsURL) {
        allWords = startWords.components(separatedBy: "\n")
      }
    }
    if allWords.isEmpty {
      allWords = ["NIL"]
    }

    startGame()
  }

  @objc func startGame() {
    title = allWords.randomElement()
    usedWords.removeAll(keepingCapacity: true)
    tableView.reloadData()
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return usedWords.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
    cell.textLabel?.text = usedWords[indexPath.row]
    return cell
  }

  @objc func promptForAnswer() {
    let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
    ac.addTextField()

    let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
      guard let answer = ac?.textFields?[0].text else { return }  // what was submitted in the above addTextField
      self?.submit(answer: answer)
    }

    ac.addAction(submitAction)
    present(ac, animated: true)
  }

  func submit(answer: String) {
    let lowerAnswer = answer.lowercased()

    let errorTitle: String
    let errorMessage: String

    if !isPossible(word: lowerAnswer) {
      guard let title = title?.lowercased() else { return }
      errorTitle = "Word not possible"
      errorMessage = "You can't spell that word from \(title)"
      showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
      return
    }

    if !isOriginal(word: lowerAnswer) {
      errorTitle = "Word used already"
      errorMessage = "Be more original!"
      showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
      return
    }

    if !isReal(word: lowerAnswer) {
      errorTitle = "Word not recognised"
      errorMessage = "You can't just make them up, you know!"
      showErrorMessage(errorTitle: errorTitle, errorMessage: errorMessage)
      return
    }
    // Word is valid
    usedWords.insert(answer.lowercased(), at: 0)
    let indexPath = IndexPath(row: 0, section: 0)
    tableView.insertRows(at: [indexPath], with: .automatic)
  }

  // Checks for submission
  func isPossible(word: String) -> Bool {
    guard var tempWord = title?.lowercased() else {return false}
    for letter in word {
      if let position = tempWord.firstIndex(of: letter) {
        tempWord.remove(at: position)
      } else {
        return false
      }
    }
    return true
  }

  func isOriginal(word: String) -> Bool {
    return !usedWords.contains(word) && !word.lowercased().elementsEqual(title?.lowercased() ?? "")
  }

  func isReal(word: String) -> Bool {
    if word.utf16.count < 3 {
      return false
    }
    let checker = UITextChecker()
    let range = NSRange(location: 0, length: word.utf16.count)
    let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
    return misspelledRange.location == NSNotFound
  }

  func showErrorMessage(errorTitle: String, errorMessage: String) {
    let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    present(ac, animated: true)
  }


}

