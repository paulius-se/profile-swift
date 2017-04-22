//
//  DisplayViewController.swift
//  profile-swift
//
//  Created by Paulius Serafinavicius on 2016-06-29.
//

import UIKit

class DisplayViewController: UIViewController {
    
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var ageButton: UIButton!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    
    var person = Person()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData(person)
    }
    
    func loadData(_ person: Person) {
        nameButton.setTextForLabel(person.name)
        ageButton.setTextForLabel(person.age)
        genderButton.setTextForLabel(person.gender)
        emailButton.setTextForLabel(person.email)
        dateButton.setTextForLabel(person.birthDate)
    }

    @IBAction func buttonDidPress(_ button: UIButton) {
        openEditController(button)
    }
    
    func openEditController(_ button: UIButton) {
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "EditViewController") as? EditViewController else {
            print("the controller could be not found in the storyboard")
            return
        }
        switch button {
        case nameButton:
            controller.fieldType = .name
        case ageButton:
            controller.fieldType = .age
        case genderButton:
            controller.fieldType = .gender
        case emailButton:
            controller.fieldType = .email
        case dateButton:
            controller.fieldType = .date
        default:
            print("unknown button pressed")
            return
        }
        controller.editableText = button.getTextForLabel()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension DisplayViewController: EditViewControllerDelegate {
    
    func editViewControllerDidChangedText(_ text: String?, fieldType: FieldType) {
        switch fieldType {
        case .name:
            person.name = text
        case .age:
            person.age = text
        case .gender:
            person.gender = text
        case .email:
            person.email = text
        case .date:
            person.birthDate = text
        }
    }
}


extension UIButton {
    
    // we assume that button label is already predefined in storyboard and ends with ": ". The method updates only text to existing label
    func setTextForLabel(_ text: String?) {
        guard let text = text else {
            return
        }
        let currentFullText = titleLabel?.text
        guard let label = currentFullText?.components(separatedBy: ": ").first else {
            return
        }
        setTitle(label + ": " + text, for: UIControlState())
    }
    
    func getTextForLabel() -> String? {
        let currentFullText = titleLabel?.text
        guard let label = currentFullText?.components(separatedBy: ": ").first else {
            return nil
        }
        return currentFullText?.replacingOccurrences(of: label + ": ", with: "")
    }
}

public enum FieldType {
    case name
    case age
    case gender
    case email
    case date
}
