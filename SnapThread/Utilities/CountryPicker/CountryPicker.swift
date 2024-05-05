//
//  CountryPicker.swift
//  SnapThread
//
//  Created by Rahul K on 04/05/24.
//

import UIKit

class CountryPicker: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    // Array to hold country data
    private let countries: [(name: String, code: String)] = [
        ("United States", "+1"),
        ("United Kingdom", "+44"),
        ("Australia", "+61"),
        ("India", "+91")
        // Add more countries as needed
    ]
    
    // Reference to the text field
    weak var countryTextField: UITextField?
    
    // Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // Setup method
    private func setup() {
        self.delegate = self
        self.dataSource = self
    }
    
    // MARK: - UIPickerViewDataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCountry = countries[row].code
        countryTextField?.text = selectedCountry 
    }
}
