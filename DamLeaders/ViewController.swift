//
//  ViewController.swift
//  DamLeaders
//
//  Created by Mac Mini 9 on 5/11/2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var Dreamlabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // ******** UnderLine the label ***************//
        // Set the text you want to display
        let text = "Dream Job"
        // Create an attributed string with underline style
        let attributedString = NSAttributedString(
            string: text,
            attributes: [
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        // Set the attributed string to the label
        Dreamlabel.attributedText = attributedString
        // *******************************************//

    }

 
    

    
    
    
    
}

