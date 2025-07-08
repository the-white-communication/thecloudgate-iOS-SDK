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
    
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var startBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startBtn.layer.cornerRadius = startBtn.frame.height / 2
        textLabel.text = "SDK Version: \(TwcManager.shared.version)"
    }

    @IBAction func startAction(_ sender: Any) {
        
        let brandKey = "is_your_brandKey"
        let customParam = ["pram1": "val1", "pram2": "val2"]
        let config = TwcConfig(brandKey: brandKey, customParam: customParam, presentationStyle: .fullScreen)

        TwcManager.shared.showChat(vc: self, config: config, isStaging: true)
    }
}

