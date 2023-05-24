//
//  ViewController.swift
//  Project6b
//
//  Created by Ning, Xinran on 24/5/23.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    let label1 = UILabel()  // a piece of static text
    // Constraints are manually created. For newer phones
    label1.translatesAutoresizingMaskIntoConstraints = false
    label1.backgroundColor = .systemMint
    label1.text = "LABEL1"
    label1.sizeToFit()  // enought o fit the text

    let label2 = UILabel()  // a piece of text
    label2.translatesAutoresizingMaskIntoConstraints = false
    label2.backgroundColor = .systemCyan
    label2.text = "LABEL2"
    label2.sizeToFit()  // enought o fit the text

    let label3 = UILabel()  // a piece of text
    label3.translatesAutoresizingMaskIntoConstraints = false
    label3.backgroundColor = .systemPink
    label3.text = "LABEL3"
    label3.sizeToFit()  // enought o fit the text

    let label4 = UILabel()  // a piece of text
    label4.translatesAutoresizingMaskIntoConstraints = false
    label4.backgroundColor = .systemIndigo
    label4.text = "LABEL4"
    label4.sizeToFit()  // enought o fit the text

    let label5 = UILabel()  // a piece of text
    label5.translatesAutoresizingMaskIntoConstraints = false
    label5.backgroundColor = .systemOrange
    label5.text = "LABEL5"
    label5.sizeToFit()  // enought o fit the text

    // Add to screen. Default position is top left
    view.addSubview(label1)
    view.addSubview(label2)
    view.addSubview(label3)
    view.addSubview(label4)
    view.addSubview(label5)

//    // Start at the left, end at the right.
//    // Use visual format language
//    let viewsDictionary = ["label1": label1,
//                           "label2": label2,
//                           "label3": label3,
//                           "label4": label4,
//                           "label5": label5]
//    for label in viewsDictionary.keys {
//      // '|' is the edge of the screen
//      // '[' is the edge of the view
//      // 'H:' means its a horizontal constraint
//      view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))
//    }
//    // '-' is a space, which is 10points by default
//    // Set height to 88points
//    // Set a space of at least 10 points from the edge of the screen (must be speecified in between '-')
//    // use metrics to provide an array of sizes
//    let metrics = ["labelHeight": 88]
//
//    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=10)-|", options: [], metrics: metrics, views: viewsDictionary))
//
//    // Priority: 1000 is highest, and is default.
//    // We want the labels to be optional ('@999'), but standardised height

    var previous: UILabel?  // use an optional variable to utilise previous label

    for label in [label1, label2, label3, label4, label5] {
      label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
      label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
      label.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2, constant: -10).isActive = true
      if let previous = previous {
        label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
      } else {
        // first label
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
      }
      previous = label
    }

    
  }


}

