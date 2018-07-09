//
//  DatePickerController.swift
//  Homepwner
//
//  Created by Alpaca on 2018. 7. 10..
//  Copyright © 2018년 Alpaca. All rights reserved.
//

import UIKit

protocol DatePickerControllerDelegate: class {
    func dateChanged(to date: Date)
}

class DatePickerController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    weak var delegate: DatePickerControllerDelegate?
    
    var date: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let date = date else { return }
        datePicker.date = date
    }
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        delegate?.dateChanged(to: sender.date)
    }
}
