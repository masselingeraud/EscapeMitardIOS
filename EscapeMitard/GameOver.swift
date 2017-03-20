//
//  GameOver.swift
//  EscapeMitard
//
//  Created by Maroin Kassas on 13/03/2017.
//  Copyright © 2017 Geraud Masselin. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameOver: UIViewController {
    
   
    @IBOutlet weak var rejouerBtn: UIButton!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func buttonClick(sender: UIButton) {
           
          
            
            
        }
        
    
        
        }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
