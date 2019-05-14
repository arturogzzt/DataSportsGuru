//
//  IndexGamesTableViewController.swift
//  DataSportsGuru
//
//  Created by Patricio Gutierrez on 4/25/19.
//  Copyright © 2019 Arturo González. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Firebase
class IndexGamesTableViewController: UITableViewController {
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    var games = [Game]()
    var numberGames : Int!
    var timer = Timer()
    var todaysDate : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        if (Auth.auth().currentUser == nil) {
         logoutButton.isEnabled = false
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Networking
    
//    func scheduledTimerWithTimeInterval(){
//                // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
//        timer = Timer.scheduledTimer(timeInterval: 15,
//                                target: self,
//                                selector: #selector(self.refresh),
//                                userInfo: nil,
//                                repeats: true)
//    }

//    func getTodayGameData(url: String) {
//        Alamofire.request(url, method: .get).responseJSON { response in
//            if response.result.isSuccess {
//                let gameData : JSON = JSON(response.result.value!)
//
//                self.updateGameData(json: gameData)
//            } else {
//                print("Error \(response.result.error!)")
//            }
//        }
//    }
//
//    // MARK: - JSONParsing
//    func updateGameData(json : JSON) {
//
//        let numberOfGames = json["numGames"].int!
//        numberGames = numberOfGames
//
//        for i in 0...numberOfGames-1 {
//            var currentGame = json["games"][i]
//            games.append(Game.init(gameID: currentGame["gameId"].stringValue, arenaGame: currentGame["arena"]["name"].stringValue, startTime: currentGame["startTimeEastern"].stringValue, vTeamID: currentGame["vTeam"]["teamId"].stringValue, vTeamTriCode: currentGame["vTeam"]["triCode"].stringValue, hTeamID: currentGame["hTeam"]["teamId"].stringValue, hTeamTriCode: currentGame["hTeam"]["triCode"].stringValue, vScore: currentGame["vTeam"]["score"].stringValue, hScore: currentGame["hTeam"]["score"].stringValue, status: currentGame["statusNum"].stringValue, hTeamWin: currentGame["playoffs"]["hTeam"]["seriesWin"].stringValue, vTeamWin: currentGame["playoffs"]["vTeam"]["seriesWin"].stringValue, period: currentGame["period"]["current"].stringValue))
//
//
//        }
//
//    }
    
    @IBAction func handleLogout(_ target: UIBarButtonItem){
        try! Auth.auth().signOut()
        self.navigationController?.popViewController(animated: true)
    }
    
//    @objc func refresh(){
//        getTodayGameData(url: "http://data.nba.net/10s/prod/v1/" + todaysDate + "/scoreboard.json")
//        DispatchQueue.main.async {
//
//             self.tableView.reloadData()
//        }
//
//         print("refreshed")
//
//    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return numberGames
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CustomTableViewCell else {
            fatalError("The dequeued cell is not an instance of CustomTableViewCell.")
        }

        if(games[indexPath.row].status == "2"){
            cell.vScoreLabel.text = games[indexPath.row].vScore
            cell.vTeamLabel.text = games[indexPath.row].vTeamTriCode
            cell.hScoreLabel.text = games[indexPath.row].hScore
            cell.hTeamLabel.text = games[indexPath.row].hTeamTriCode
            cell.gameStatus.text = "Quarter: " + games[indexPath.row].period
            cell.hTeamImageView.image = UIImage(named: games[indexPath.row].hTeamTriCode)
            cell.vTeamImageView.image = UIImage(named: games[indexPath.row].vTeamTriCode)
        }
        else if(games[indexPath.row].status == "1") {
            cell.vScoreLabel.text = "0"
            cell.vTeamLabel.text = games[indexPath.row].vTeamTriCode
            cell.hScoreLabel.text = "0"
            cell.hTeamLabel.text = games[indexPath.row].hTeamTriCode
            cell.gameStatus.text = games[indexPath.row].startTime
            cell.hTeamImageView.image = UIImage(named: games[indexPath.row].hTeamTriCode)
            cell.vTeamImageView.image = UIImage(named: games[indexPath.row].vTeamTriCode)
            
        }
        else {
            cell.vScoreLabel.text = games[indexPath.row].vScore
            cell.vTeamLabel.text = games[indexPath.row].vTeamTriCode
            cell.hScoreLabel.text = games[indexPath.row].hScore
            cell.hTeamLabel.text = games[indexPath.row].hTeamTriCode
            cell.hTeamImageView.image = UIImage(named: games[indexPath.row].hTeamTriCode)
            cell.vTeamImageView.image = UIImage(named: games[indexPath.row].vTeamTriCode)
            cell.gameStatus.text = "FINAL"
        }
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "gameView"){
            let indice = tableView.indexPathForSelectedRow!
            let vistaJuego = segue.destination as! GameViewController
            vistaJuego.game = games[indice.row]
            vistaJuego.todaysDate = todaysDate
            

            
            
       }
        
    }
 

}
