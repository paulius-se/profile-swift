//
//  EditViewController.swift
//  profile-swift
//
//  Created by Paulius Serafinavicius on 2016-06-29.
//

import UIKit

protocol EditViewControllerDelegate {
    func editViewControllerDidChangedText(_ text: String?, fieldType: FieldType)
}

class EditViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var genderPicker: UIPickerView!
    
    var editableText: String?
    var fieldType: FieldType!
    var delegate: EditViewControllerDelegate?
    let genders: [Gender] = [.male, .female]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let fieldType = fieldType else {
            print("fieldType is missing")
            return
        }
        
        switch fieldType {
        case .name:
            title = "Name:"
            textField.keyboardType = .default
            textField.autocapitalizationType = .words
        case .age:
            title = "Age:"
            textField.keyboardType = .numberPad
        case .gender:
            title = "Gender:"
            textField.inputView = genderPicker
            if let editableText = editableText {
                switch editableText {
                case Gender.male.toString():
                    genderPicker.selectRow(0, inComponent: 0, animated: false)
                case Gender.female.toString():
                    genderPicker.selectRow(1, inComponent: 0, animated: false)
                default:
                    break
                }
            }
        case .email:
            title = "Email:"
            textField.keyboardType = .emailAddress
            textField.autocapitalizationType = .none
        case .date:
            title = "Date of Birth:"
            textField.inputView = datePicker
            datePicker.maximumDate = Date()
            if let date = stringToDate(editableText) {
                datePicker.date = date
            }
            break
        }
        textField.text = editableText
        textField.becomeFirstResponder()
    }

    @IBAction func textFieldEditingChanged(_ textField: UITextField) {
        delegate?.editViewControllerDidChangedText(textField.text, fieldType: fieldType)
    }
    
    @IBAction func datePickerValueChanged(_ datePicker: UIDatePicker) {
        let dateString = dateToString(datePicker.date)
        textField.text = dateString
        delegate?.editViewControllerDidChangedText(dateString, fieldType: fieldType)
    }
    
    func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }
    
    func stringToDate(_ dateString: String?) -> Date? {
        guard let dateString = dateString else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.date(from: dateString)
    }
}

extension EditViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        _ = navigationController?.popViewController(animated: true)
        return true
    }
}

extension EditViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let genderString = genders[row].toString()
        textField.text = genderString
        delegate?.editViewControllerDidChangedText(genderString, fieldType: fieldType)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row].toString()
    }
}

extension EditViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
}

enum Gender {
    case male
    case female
}

extension Gender {
    func toString() -> String {
        switch self {
        case .male:
            return "Male"
        case .female:
            return "Female"
        }
    }
}
