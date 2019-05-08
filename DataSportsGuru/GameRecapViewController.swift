//
//  GameRecapViewController.swift
//  DataSportsGuru
//
//  Created by Patricio Gutierrez on 5/5/19.
//  Copyright © 2019 Arturo González. All rights reserved.
//

import UIKit
import SwiftyJSON

class GameRecapViewController: UIViewController {
    var gameRecapJSON : JSON!
    var numParagraphs : Int!
    var gameRecap : String = ""
    
    
    @IBOutlet weak var gameRecapTF: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        numParagraphs = gameRecapJSON["paragraphs"].count - 2
        for i in 0...numParagraphs {
            gameRecap = gameRecap + gameRecapJSON["paragraphs"][i]["paragraph"].stringValue + "\n\n"
            
        }
        
        gameRecapTF.text = gameRecap
        // Do any additional setup after loading the view.
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
