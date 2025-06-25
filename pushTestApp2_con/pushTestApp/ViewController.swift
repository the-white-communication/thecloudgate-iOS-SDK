//
//  ViewController.swift
//  pushTestApp
//
//  Created by 220804 on 4/21/25.
//

import UIKit
import Firebase
import FirebaseMessaging
import twcLibrary

class ViewController: UIViewController {
    
    @IBOutlet weak var startBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startBtn.layer.cornerRadius = startBtn.frame.height / 2
        
    }

    @IBAction func startAction(_ sender: Any) {
        
        let config = TwcConfig(brandKey: "20250526062543skorHzoCqwAc8H7UF6LPvg")

        TwcManager.shared.showChat(vc: self, config: config, isStaging: true)
    }


    
    
    
}

