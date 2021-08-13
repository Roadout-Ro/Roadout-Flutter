//
//  InterfaceController.swift
//  Roadout Watch Extension
//
//  Created by David Retegan on 13.08.2021.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet weak var unlockBtn: WKInterfaceButton!
    @IBOutlet weak var buttonWrapper: WKInterfaceGroup!
    
    @IBAction func unlocked() {
        print("Unlocked")
    }
    
    override func awake(withContext context: Any?) {
        buttonWrapper.setCornerRadius(20)
    }
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

}
