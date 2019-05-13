//
//  ViewController.swift
//  DataSportsGuru
//
//  Created by Arturo González on 4/24/19.
//  Copyright © 2019 Arturo González. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase

class ViewController: UIViewController {
    var games = [Game]()
    var numberGames : Int = 0
    let date = Date()
    let format = DateFormatter()
    var todaysDate : String!
    
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoImageView.layer.borderWidth = 1
        logoImageView.layer.masksToBounds = false
        logoImageView.layer.borderColor = UIColor.black.cgColor
        logoImageView.layer.cornerRadius = logoImageView.frame.height/2
        logoImageView.clipsToBounds = true

        format.dateFormat = "yyyyMMdd"
        todaysDate = format.string(from: date)
        // Do any additional setup after loading the view.
        getTodayGameData(url: "http://data.nba.net/10s/prod/v1/" + todaysDate + "/scoreboard.json")
//        getTodayGameData(url: "http://data.nba.net/10s/prod/v1/" + "20190510" + "/scoreboard.json")

    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let user = Auth.auth().currentUser {
            self.performSegue(withIdentifier: "muestra", sender: self)
       }
    }
    
    func getTodayGameData(url: String) {
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess {
                let gameData : JSON = JSON(response.result.value!)
                
                self.updateGameData(json: gameData)
            } else {
                print("Error \(response.result.error!)")
            }
        }
    }
    
    // MARK: - JSONParsing
    func updateGameData(json : JSON) {
  
        
        let numberOfGames = json["numGames"].int!
        numberGames = numberOfGames
        
        if numberGames >= 1 {
            for i in 0...numberOfGames-1 {
                var currentGame = json["games"][i]
                games.append(Game.init(gameID: currentGame["gameId"].stringValue, arenaGame: currentGame["arena"]["name"].stringValue, startTime: currentGame["startTimeEastern"].stringValue, vTeamID: currentGame["vTeam"]["teamId"].stringValue, vTeamTriCode: currentGame["vTeam"]["triCode"].stringValue, hTeamID: currentGame["hTeam"]["teamId"].stringValue, hTeamTriCode: currentGame["hTeam"]["triCode"].stringValue, vScore: currentGame["vTeam"]["score"].stringValue, hScore: currentGame["hTeam"]["score"].stringValue, status: currentGame["statusNum"].stringValue, hTeamWin: currentGame["playoffs"]["hTeam"]["seriesWin"].stringValue, vTeamWin: currentGame["playoffs"]["vTeam"]["seriesWin"].stringValue, period: currentGame["period"]["current"].stringValue))
            }
        }
        
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "muestra"){
           
            let vistaJuegos = segue.destination as! IndexGamesTableViewController
            vistaJuegos.games = games
            vistaJuegos.numberGames = numberGames
            vistaJuegos.todaysDate = todaysDate
            
            
        }
 
    }


}

