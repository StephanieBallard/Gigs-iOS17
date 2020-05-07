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
    
    var gigController: GigController?
    var gig: Gig? {
        didSet {
            updateViews()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let gig = gig else { return }
        
        gigController?.createGig(with: gig, completion: { _ in
            DispatchQueue.main.async {
                self.gigTitleTextField.text = self.gig?.title
                self.textView.text = self.gig?.description
                self.datePicker?.date = self.gig?.dueDate
            }
            
        })
            
            
    }
    
    func updateViews() {
        gigTitleTextField.text = gig?.title
        textView.text = gig?.description
        
        if let dueDate = gig?.dueDate {
            datePicker?.date = dueDate
        }
        
        if gigTitleTextField.text == "" {
            gigTitleTextField.text = "New Gig"
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
