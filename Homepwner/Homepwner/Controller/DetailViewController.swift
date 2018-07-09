//
//  DetailViewController.swift
//  Homepwner
//
//  Created by Alpaca on 2018. 7. 9..
//  Copyright © 2018년 Alpaca. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var serialNumberTextFied: UITextField!
    @IBOutlet weak var valueTextField: UITextField!
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
