//
//  EntryDetailViewController.swift
//  JournalCloudKit
//
//  Created by Madison Kaori Shino on 7/8/19.
//  Copyright © 2019 Madi S. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {

    //LANDING PAD
    var entry: Entry? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }
    
    //OUTLETS
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextView!
    
    //LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        bodyTextField.layer.borderWidth = 2
    }
    
    //ACTIONS
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text, title != "",
            let body = bodyTextField.text, body != "" else { return }
        if entry != nil {
            guard let entry = entry else { return }
            EntryController.sharedInstance.updateEntry(entry: entry, title: title, body: body)
            self.navigationController?.popViewController(animated: true)
        } else {
            EntryController.sharedInstance.addEntryWith(title: title, bodyText: body) { (true) in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        titleTextField.text = ""
        bodyTextField.text = ""
    }
    
    func updateViews() {
        guard let entry = entry else { return }
            titleTextField.text = entry.title
            bodyTextField.text = entry.bodyText
    }
}

extension EntryDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
