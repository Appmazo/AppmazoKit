//
//  DatePickerTableViewCell.swift
//  AppmazoKit
//
//  Created by James Hickman on 5/22/18.
//  Copyright © 2018 Appmazo, LLC. All rights reserved.
//

import UIKit

public protocol DatePickerTableViewCellDelegate: NSObjectProtocol {
    func datePickerTableViewCell(_ datePickerTableViewCell: DatePickerTableViewCell, didUpdateDate date: Date)
    func datePickerTableViewCellDidFinish(_ datePickerTableViewCell: DatePickerTableViewCell)
}

public class DatePickerTableViewCell: UITableViewCell {
    public weak var delegate : DatePickerTableViewCellDelegate?
    
    private let datePicker = UIDatePicker()
    private var promptLabel = UILabel()
    private var textField = UITextField()
    
    public var promptText: String? {
        didSet {
            promptLabel.text = promptText
        }
    }
    
    public var placeholderText: String? {
        didSet {
            textField.placeholder = placeholderText
        }
    }
    
    public var textFieldText: String? {
        didSet {
            textField.text = textFieldText
        }
    }
    
    // MARK: - Init
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        promptLabel.font = UIFont.systemFont(ofSize: 10.0, weight: .regular)
        contentView.addSubview(promptLabel)
        
        datePicker.backgroundColor = UIColor.groupTableViewBackground
        datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.sizeToFit()
        
        let spaceBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBarButtonItemPressed(_:)))
        toolBar.setItems([spaceBarButtonItem, doneBarButtonItem], animated: false)
        
        textField.inputAccessoryView = toolBar
        textField = UITextField()
        textField.borderStyle = .none
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.autocorrectionType = .no
        textField.adjustsFontSizeToFitWidth = true
        textField.inputView = datePicker
        textField.inputAccessoryView = toolBar
        contentView.addSubview(textField)
        
        let views: [String : UIView] = [ "textField" : textField,
                                         "promptLabel": promptLabel]
        
        for (_, view) in views {
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "|-[promptLabel(90)]-|", options: [.alignAllLastBaseline], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "|-16-[textField]-16-|", options: [.alignAllLastBaseline], metrics: nil, views: views))
        NSLayoutConstraint.activate(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[promptLabel][textField]-|", options: [], metrics: nil, views: views))
    }
    
    @objc private func doneBarButtonItemPressed(_ sender: UIBarButtonItem) {
        endEditing(true)
        delegate?.datePickerTableViewCellDidFinish(self)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        textField.text = sender.date.convertToString()
        delegate?.datePickerTableViewCell(self, didUpdateDate: sender.date)
    }
}
