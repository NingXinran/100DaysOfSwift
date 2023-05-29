//
//  ViewController.swift
//  Project10
//
//  Created by Ning, Xinran on 29/5/23.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  var people = [Person]()

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return people.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath)
    // this returns a normal cell. need to type case
    guard let cell = cell as? PersonCell else { fatalError("fatalError: Unable to dequeue a personCell.") }
    let person = people[indexPath.item]
    let path = getDocumentsDirectory().appendingPathComponent(person.image)

    cell.name.text = person.name
    cell.imageView.image = UIImage(contentsOfFile: path.path())

    cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor  // grey
    cell.imageView.layer.borderWidth = 2
    cell.imageView.layer.cornerRadius = 3
    cell.layer.cornerRadius = 7
    return cell
  }

  @objc func addNewPerson() {
    let picker = UIImagePickerController()
    if UIImagePickerController.isSourceTypeAvailable(.camera) {
      picker.sourceType = .camera
    }
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
  }

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.editedImage] as? UIImage else { return }
    // create unique name using UUID
    let imageName = UUID().uuidString
    let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
    // convert image to jpeg data
    if let jpegData = image.jpegData(compressionQuality: 0.8) {
      try? jpegData.write(to: imagePath)
    }
    // add person to people
    let person = Person(name: "", image: imageName)
    people.append(person)
    collectionView.reloadData()

    dismiss(animated: true)  // dismiss top most vc
  }

  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }

  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let person = people[indexPath.item]

    let ac1 = UIAlertController(title: "Choose an action:", message: nil, preferredStyle: .actionSheet)
    ac1.addAction(UIAlertAction(title: "Rename", style: .default) { _ in
      let ac2 = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
      ac2.addTextField()
      ac2.addAction(UIAlertAction(title: "OK", style: .default) { [ weak self, weak ac2 ] _ in
        guard let newName = ac2?.textFields?[0].text else { return }
        person.name = newName
        self?.collectionView.reloadData()
      })
      ac2.addAction(UIAlertAction(title: "Cancel", style: .cancel))
      self.present(ac2, animated: true)
    })
    ac1.addAction(UIAlertAction(title: "Delete", style: .destructive) { [ weak self ] _ in
      self?.people.remove(at: indexPath.item)
      self?.collectionView.reloadData()
    })
    present(ac1, animated: true)
  }


}

