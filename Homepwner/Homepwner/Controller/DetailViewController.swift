//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Alpaca on 2018. 7. 9..
//  Copyright © 2018년 Alpaca. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: MyTextField!
    @IBOutlet weak var serialNumberTextFied: MyTextField!
    @IBOutlet weak var valueTextField: MyTextField!
    @IBOutlet weak var dateLabel: UILabel!
    
    var item: Item? {
        didSet {
            navigationItem.title = item?.name
        }
    }
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
    
    let segueIdentifier: String = "ShowDatePickerViewController"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let item = item else { return }
        
        nameTextField.text = item.name
        serialNumberTextFied.text = item.serialNumber
        valueTextField.text = numberFormatter.string(from: NSNumber(value: item.valueInDollars))
        dateLabel.text = dateFormatter.string(from: item.dateCreated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        item?.name = nameTextField.text ?? ""
        item?.serialNumber = serialNumberTextFied.text
        
        guard let valueText = valueTextField.text,
            let value = numberFormatter.number(from: valueText) else {
                item?.valueInDollars = 0
                
                return
        }
        item?.valueInDollars = value.intValue
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == segueIdentifier else { return }
        
        guard let datePickerController = segue.destination as? DatePickerController else { return }
        
        guard let item = item else { return }
        datePickerController.date = item.dateCreated
        datePickerController.delegate = self
    }
    
    @IBAction func backgroundTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension DetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
}

extension DetailViewController: DatePickerControllerDelegate {
    func dateChanged(to date: Date) {
        item?.dateCreated = date
    }
}
