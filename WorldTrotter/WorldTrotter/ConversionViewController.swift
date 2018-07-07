//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Alpaca on 2018. 7. 4..
//  Copyright © 2018년 Alpaca. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController {
    
    @IBOutlet weak var celsiusLabel: UILabel!
    @IBOutlet weak var textField: UITextField!

    var fahrenheitValue: Measurement<UnitTemperature>? {
        didSet {
            updateCelsiusLabel()
        }
    }
    var celsiusValue: Measurement<UnitTemperature>? {
        guard let fahrenheitValue = fahrenheitValue else { return nil }
        
        return fahrenheitValue.converted(to: .celsius)
    }
    
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        
        return formatter
    }()
    
    let backgroundColors: [UIColor] = [.red, .orange, .yellow, .green, .blue, .clear]
    var currentColorIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ConversionViewController loaded its view.")
        
        updateCelsiusLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        currentColorIndex = currentColorIndex % backgroundColors.count
        view.backgroundColor = backgroundColors[currentColorIndex]
        
        currentColorIndex += 1
    }
    
    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField) {
        guard let text = textField.text, let value = Double(text) else {
            fahrenheitValue = nil
            
            return
        }
        
        fahrenheitValue = Measurement(value: value, unit: .fahrenheit)
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
    func updateCelsiusLabel() {
        guard let celsiusValue = celsiusValue else {
            celsiusLabel.text = "???"
            
            return
        }
        
        celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
    }
}

extension ConversionViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard CharacterSet.letters.intersection(CharacterSet(charactersIn: string)).isEmpty else {
            return false
        }
        
        let existingTextHasDecimalSeparator = textField.text?.range(of: ".")
        let replacementTextHasDecimalSeparator = string.range(of: ".")
        
        guard existingTextHasDecimalSeparator != nil && replacementTextHasDecimalSeparator != nil else {
            return true
        }
        
        return false
    }
}
