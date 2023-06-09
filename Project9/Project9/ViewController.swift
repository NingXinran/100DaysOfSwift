//
//  ViewController.swift
//  Project7
//
//  Created by Ning, Xinran on 24/5/23.
//

import UIKit

class ViewController: UITableViewController {

  var petitions = [Petition]()
  var filteredPetitions = [Petition]()

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "We the People"
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterPetitions))

    let urlString: String
    if navigationController?.tabBarItem.tag == 0 {
      urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
    } else {
      urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"  // cached copy
    }

    performSelector(inBackground: #selector(fetchJSON), with: urlString)
  }

  @objc func fetchJSON(urlString: String) {
    // Download and parse data
    if let url = URL(string: urlString) {  // url string -> URL object (safely)
      // NOTE: synchronous fetch right now
      if let data = try? Data(contentsOf: url) {  //  URL object -> Data object (fetch contents, safely)
        parse(json: data)  // implicit capture of self
        return
      }
    }
    performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    showError()

  }

  @objc func showError(){
    let ac = UIAlertController(title: "Loading error",
                               message: "There was a problem loading the feed; please check your connection and try again.",
                               preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    present(ac, animated: true)
  }

  func parse(json: Data) {
    let decoder = JSONDecoder()
    if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {  // convert to a petitions object
      petitions = jsonPetitions.results  // assign results array into petitions variable
      filteredPetitions = jsonPetitions.results
      // push work back to main queue
      DispatchQueue.main.async { [weak self] in
        self?.tableView.reloadData()
      }

    }
  }

  @objc func showCredits() {
    let ac = UIAlertController(title: "Source:", message: "This data comes from the We The People API provided by the White House.", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .cancel))
    present(ac, animated: true)
  }

  @objc func filterPetitions() {
    let ac = UIAlertController(title: "Search petitions", message: nil, preferredStyle: .alert)
    ac.addTextField()
    let handleFilter = UIAlertAction(title: "Enter", style: .default) { [weak self, weak ac] _ in
      guard let input = ac?.textFields?[0].text else { return }
      DispatchQueue.global().async {
        print("in background thread")
        self?.search(input: input)
      }
    }

    ac.addAction(handleFilter)
    present(ac, animated: true)
  }

  @objc func search(input: String) {
    let input = input.lowercased()
    var temp = [Petition]()
    for petition in petitions {
      if petition.title.lowercased().contains(input) || petition.body.lowercased().contains(input) {
        temp.append(petition)
      }
    }
    filteredPetitions = temp
    DispatchQueue.main.async { [ weak self ] in
      print("in main thread")
      self?.tableView.reloadData()
    }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filteredPetitions.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    // set both text and detail
    let petition = filteredPetitions[indexPath.row]
    cell.textLabel?.text = petition.title
    cell.detailTextLabel?.text = petition.body
    return cell
  }

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = DetailViewController()
    vc.detailItem = filteredPetitions[indexPath.row]
    navigationController?.pushViewController(vc, animated: true)  // use the navigationController to present.
  }

}

