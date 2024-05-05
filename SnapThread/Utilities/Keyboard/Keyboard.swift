//
//  keyboard.swift
//  SnapThread
//
//  Created by Rahul K on 04/05/24.
//

import UIKit

@objc protocol KeyboardToolbarDelegate: AnyObject {
    @objc func doneButtonTapped()
}

class KeyboardToolbarHelper {
    
    static func addDoneButton(to textField: UITextField, delegate: KeyboardToolbarDelegate) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: delegate, action: #selector(delegate.doneButtonTapped))
        
        toolbar.items = [flexibleSpace, doneButton]
        
        textField.inputAccessoryView = toolbar
    }
}

