//
//  GigDetailViewController.swift
//  Gigs_iOS17
//
//  Created by Stephanie Ballard on 5/6/20.
//  Copyright © 2020 Stephanie Ballard. All rights reserved.
//

import UIKit

class GigDetailViewController: UIViewController {
    
    @IBOutlet weak var gigTitleTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    
    var gigController: GigController!
    var gig: Gig?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard
            let title = gigTitleTextField.text,
            let description = textView.text,
            !title.isEmpty,
            !description.isEmpty
            else { return }
        
        
        if var gig = gig {
            gig.title = title
            gig.dueDate = datePicker.date
            gig.description = description
        }
        if gig == nil {
            let gig = Gig(title: title, dueDate: datePicker.date, description: description)
            self.gigController.createGig(with: gig) { result in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
    }
    
    func updateViews() {
        if let gig = gig {
            title = gig.title
            gigTitleTextField.text = gig.title
            datePicker.date = gig.dueDate
            textView.text = gig.description
        } else {
            title = "New Gig"
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
