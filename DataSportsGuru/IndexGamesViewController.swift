//
//  IndexGamesViewController.swift
//  
//
//  Created by Arturo González on 4/24/19.
//

import UIKit
import Alamofire
import SwiftyJSON

class IndexGamesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var games = [Game]()
    var numberGames : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getTodayGameData(url: "http://data.nba.net/10s/prod/v1/20190424/scoreboard.json")

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Networking
    
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
        
        for i in 0...numberOfGames-1 {
            var currentGame = json["games"][i]
            games.append(Game.init(arenaGame: currentGame["arena"]["name"].stringValue, startTime: currentGame["startTimeEastern"].stringValue, vTeamID: currentGame["vTeam"]["teamId"].stringValue, vTeamTriCode: currentGame["vTeam"]["triCode"].stringValue, hTeamID: currentGame["hTeam"]["teamId"].stringValue, hTeamTriCode: currentGame["hTeam"]["triCode"].stringValue, vScore: currentGame["vTeam"]["score"].stringValue, hScore: currentGame["hTeam"]["score"].stringValue))
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberGames
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableViewCell else {
            fatalError("ERROR")
        }
        
        cell.vScoreLabel.text = games[indexPath.row].vScore
        cell.vTeamLabel.text = games[indexPath.row].vTeamTriCode
        cell.hScoreLabel.text = games[indexPath.row].hScore
        cell.hTeamLabel.text = games[indexPath.row].hTeamTriCode
        
        return cell
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
