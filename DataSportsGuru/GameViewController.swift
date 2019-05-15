//
//  GameViewController.swift
//  DataSportsGuru
//
//  Created by Patricio Gutierrez on 5/2/19.
//  Copyright © 2019 Arturo González. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Charts
import SwiftyButton
import Firebase
import FirebaseDatabase

class GameViewController: UIViewController {
    var game : Game!
    var gameRecap : JSON!
    var playoffData : JSON!
    
    var hTeamStats : TeamStats!
    var vTeamStats : TeamStats!
    
    var hTeamElo : Int!
    var vTeamElo : Int!
    
    var ref: DatabaseReference!
    
    var currentHomeVotes : Int!
    var currentVisitVotes : Int!
    
    var usersVoted = [String]()
    
    var userVote : Bool = false
    
    
    @IBOutlet weak var vScore: UILabel!
    @IBOutlet weak var hScore: UILabel!
    @IBOutlet weak var vTeamTri: UILabel!
    @IBOutlet weak var arena: UILabel!
    @IBOutlet weak var hTeamTri: UILabel!
    @IBOutlet weak var vTeamSeriesWin: UILabel!
    @IBOutlet weak var hTeamSeriesWin: UILabel!
    @IBOutlet weak var vTeamSeriesLoss: UILabel!
    @IBOutlet weak var hTeamSeriesLoss: UILabel!
    @IBOutlet weak var vTeamImageView: UIImageView!
    @IBOutlet weak var hTeamImageView: UIImageView!
    @IBOutlet weak var voteAwayButton: FlatButton!
    @IBOutlet weak var voteHomeButton: FlatButton!
    @IBOutlet weak var votePieChart: PieChartView!
    
    
    @IBOutlet weak var gameInfo: UILabel!
    
    @IBOutlet weak var gameRecapBtn: UIButton!
    var todaysDate : String!
    @IBOutlet weak var pieChartView: PieChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        getPlayoffStats()
        getCurrentVotes()
        getUserCount()
        
        
        if(game.status == "2"){
            vScore.text = game.vScore
            hScore.text = game.hScore
            arena.text = game.arenaGame
            vTeamTri.text = game.vTeamTriCode
            hTeamTri.text = game.hTeamTriCode
            vTeamSeriesWin.text = game.vTeamWin
            vTeamSeriesLoss.text = game.hTeamWin
            hTeamSeriesWin.text = game.hTeamWin
            hTeamSeriesLoss.text = game.vTeamWin
            vTeamImageView.image = UIImage(named: game.vTeamTriCode)
            hTeamImageView.image = UIImage(named: game.hTeamTriCode)
            gameInfo.text = "Quarter: " + game.period
            gameRecapBtn.isHidden = true
        }
        else if(game.status == "1"){
            vScore.text = "0"
            hScore.text = "0"
            arena.text = game.arenaGame
            vTeamTri.text = game.vTeamTriCode
            hTeamTri.text = game.hTeamTriCode
            vTeamSeriesWin.text = game.vTeamWin
            vTeamSeriesLoss.text = game.hTeamWin
            hTeamSeriesWin.text = game.hTeamWin
            hTeamSeriesLoss.text = game.vTeamWin
            vTeamImageView.image = UIImage(named: game.vTeamTriCode)
            hTeamImageView.image = UIImage(named: game.hTeamTriCode)
            gameInfo.text = game.startTime
            gameRecapBtn.isHidden = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.userVote = self.userVoted()
            })
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                if Auth.auth().currentUser != nil {
                    if self.userVote {
                        self.voteHomeButton.isHidden = true
                        self.voteAwayButton.isHidden = true
                        self.votePieChart.isHidden = false
                        self.updateVoteChartData()
                    } else {
                        self.votePieChart.isHidden = true
                        self.voteHomeButton.isHidden = false
                        self.voteAwayButton.isHidden = false
                    }
                } else {
                    self.updateVoteChartData()
                    self.pieChartView.isHidden = false
                }
                
            })
        }
        else {
            vScore.text = game.vScore
            hScore.text = game.hScore
            arena.text = game.arenaGame
            vTeamTri.text = game.vTeamTriCode
            hTeamTri.text = game.hTeamTriCode
            vTeamSeriesWin.text = game.vTeamWin
            vTeamSeriesLoss.text = game.hTeamWin
            hTeamSeriesWin.text = game.hTeamWin
            hTeamSeriesLoss.text = game.vTeamWin
            vTeamImageView.image = UIImage(named: game.vTeamTriCode)
            hTeamImageView.image = UIImage(named: game.hTeamTriCode)
            gameInfo.text = "FINAL"
         //   getGameRecap(url: "http://data.nba.net/10s/prod/v1/" + todaysDate + "/" + game.gameID + "_recap_article.json")
           getGameRecap(url: "http://data.nba.net/10s/prod/v1/" + "20190514" + "/" + game.gameID + "_recap_article.json")
            
        }
    }
    
    func getGameRecap(url : String){
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess {
                self.gameRecap = JSON(response.result.value!)
                print(self.gameRecap ?? "Error")
            } else {
                print("Error \(response.result.error!)")
            }
        }
        
    }
    //Update Chart

    func updateChartData()  {
        let
        totalElo = hTeamElo + vTeamElo
        let hTeamPercentage = (Float(hTeamElo) / Float(totalElo)) * 100
        let vTeamPercentage = (Float(vTeamElo) / Float(totalElo)) * 100
        // 2. generate chart data entries
        let equipos = [game.hTeamTriCode, game.vTeamTriCode]
        let percentages = [hTeamPercentage, vTeamPercentage]
        
        var entries = [PieChartDataEntry]()
        for (index, value) in percentages.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = Double(value)
            entry.label = equipos[index]
            entries.append( entry)
        }
        
        // 3. chart setup
        let set = PieChartDataSet( entries: entries, label: "Game Odds via DataSportsGuru Algorithm")
        // this is custom extension method. Download the code for more details.
        var colors: [UIColor] = []
        
        for _ in 0..<percentages.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        set.colors = colors
        let data = PieChartData(dataSet: set)
        pieChartView.data = data
        pieChartView.noDataText = "No data available"
        // user interaction
        pieChartView.isUserInteractionEnabled = true
        
        let d = Description()
        pieChartView.chartDescription = d
        pieChartView.holeRadiusPercent = 0
        pieChartView.transparentCircleColor = UIColor.clear
        self.view.addSubview(pieChartView)
        
    }

    
    func updateVoteChartData()  {
        let hTeamVotePercentage = Float(currentHomeVotes) / (Float(currentHomeVotes) + Float(currentVisitVotes)) * 100
        let vTeamVotePercentage = Float(currentVisitVotes) / (Float(currentHomeVotes) + Float(currentVisitVotes)) * 100
        let equipos = [game.hTeamTriCode, game.vTeamTriCode]
        let percentages = [hTeamVotePercentage, vTeamVotePercentage]
        
        var entries = [PieChartDataEntry]()
        for (index, value) in percentages.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = Double(value)
            entry.label = equipos[index]
            entries.append( entry)
        }
        
        // 3. chart setup
        let set = PieChartDataSet( entries: entries, label: "Game Odds via DataSportsGuru Algorithm")
        // this is custom extension method. Download the code for more details.
        var colors: [UIColor] = []
        
        for _ in 0..<percentages.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        set.colors = colors
        let data = PieChartData(dataSet: set)
        votePieChart.data = data
        votePieChart.noDataText = "No data available"
        // user interaction
        votePieChart.isUserInteractionEnabled = true
        
        let d = Description()
        votePieChart.chartDescription = d
        votePieChart.holeRadiusPercent = 0
        votePieChart.transparentCircleColor = UIColor.clear
        self.view.addSubview(votePieChart)
        
    }
    //PLAYOFFSTAT FUNCTION
    
    func getPlayoffStats(){
        let url = "http://data.nba.net/prod/v1/2018/team_stats_rankings.json"
        Alamofire.request(url, method: .get).responseJSON { response in
            if response.result.isSuccess {
               self.playoffData = JSON(response.result.value!)
               self.playoffData = self.playoffData["league"]["standard"]["playoffs"]["series"]
               self.assignPlayoffData()

            } else {
                print("Error \(response.result.error!)")
            }
        }
    }
    
    func assignPlayoffData(){
        var ppgLocal : Float = 0
        var oppgLocal : Float = 0
        var fgpLocal : Float = 0
        var trpgLocal : Float = 0
        var ftpLocal : Float = 0
        var stealsLocal : Float = 0
        var blocksLocal : Float = 0
        
        var ppgVisit : Float = 0
        var oppgVisit : Float = 0
        var fgpVisit : Float = 0
        var trpgVisit : Float = 0
        var ftpVisit : Float = 0
        var stealsVisit : Float = 0
        var blocksVisit : Float = 0
        
        var localGames : Int = 0
        var visitGames : Int = 0
        
        for i in 0...playoffData.count - 4{
            if(playoffData[i]["teams"][0]["teamId"].stringValue == game.vTeamID){
                let data = playoffData[i]["teams"][0]
                
                fgpVisit += Float(data["fgp"]["avg"].stringValue)!
                trpgVisit += Float(data["trpg"]["avg"].stringValue)!
                ftpVisit += Float(data["ftp"]["avg"].stringValue)!
                stealsVisit += Float(data["spg"]["avg"].stringValue)!
                blocksVisit += Float(data["bpg"]["avg"].stringValue)!
                ppgVisit += Float(data["ppg"]["avg"].stringValue)!
                oppgVisit += Float(data["oppg"]["avg"].stringValue)!
                
                visitGames += 1
                
            }
            else if(playoffData[i]["teams"][1]["teamId"].stringValue == game.vTeamID){
                let data = playoffData[i]["teams"][1]
                fgpVisit += Float(data["fgp"]["avg"].stringValue)!
                trpgVisit += Float(data["trpg"]["avg"].stringValue)!
                ftpVisit += Float(data["ftp"]["avg"].stringValue)!
                stealsVisit += Float(data["spg"]["avg"].stringValue)!
                blocksVisit += Float(data["bpg"]["avg"].stringValue)!
                ppgVisit += Float(data["ppg"]["avg"].stringValue)!
                oppgVisit += Float(data["oppg"]["avg"].stringValue)!
                
                visitGames += 1
            }
            if(playoffData[i]["teams"][0]["teamId"].stringValue == game.hTeamID){
                let data = playoffData[i]["teams"][0]
                
                fgpLocal += Float(data["fgp"]["avg"].stringValue)!
                trpgLocal += Float(data["trpg"]["avg"].stringValue)!
                ftpLocal += Float(data["ftp"]["avg"].stringValue)!
                stealsLocal += Float(data["spg"]["avg"].stringValue)!
                blocksLocal += Float(data["bpg"]["avg"].stringValue)!
                ppgLocal += Float(data["ppg"]["avg"].stringValue)!
                oppgLocal += Float(data["oppg"]["avg"].stringValue)!
                
                localGames += 1
            }
            else if(playoffData[i]["teams"][1]["teamId"].stringValue == game.hTeamID){
                let data = playoffData[i]["teams"][1]
                
                fgpLocal += Float(data["fgp"]["avg"].stringValue)!
                trpgLocal += Float(data["trpg"]["avg"].stringValue)!
                ftpLocal += Float(data["ftp"]["avg"].stringValue)!
                stealsLocal += Float(data["spg"]["avg"].stringValue)!
                blocksLocal += Float(data["bpg"]["avg"].stringValue)!
                ppgLocal += Float(data["ppg"]["avg"].stringValue)!
                oppgLocal += Float(data["oppg"]["avg"].stringValue)!
                localGames += 1
            }
        }
        
        self.hTeamStats = TeamStats.init(ppg: ppgLocal, oppg: oppgLocal, fgp: fgpLocal, rebounds: trpgLocal, freethrows: ftpLocal, steals: stealsLocal, blocks: blocksLocal)
        self.vTeamStats = TeamStats.init(ppg: ppgVisit, oppg: oppgVisit, fgp: fgpVisit, rebounds: trpgVisit, freethrows: ftpVisit, steals: stealsVisit, blocks: blocksVisit)
        
        self.hTeamStats.getElo()
        self.vTeamStats.getElo()
        
        self.hTeamElo = Int(hTeamStats.elo) + 150
        self.vTeamElo = Int(vTeamStats.elo) - 150
        
        updateChartData()
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "gameRecap"){
            
            let vistaGameRecap = segue.destination as! GameRecapViewController
            vistaGameRecap.gameRecapJSON = gameRecap
    
            
            
        }
    }
    
    @IBAction func voteAway(_ sender: Any) {
        let userID = Auth.auth().currentUser!.uid
        usersVoted.append(userID)
        
        
        currentVisitVotes += 1
        
        self.ref.child("games").child(game.gameID).setValue(["awayVotes": currentVisitVotes!, "homeVotes" : currentHomeVotes!, "users" : usersVoted] )
        
        voteAwayButton.isHidden = true
        voteHomeButton.isHidden = true
        
        updateVoteChartData()
        votePieChart.isHidden = false
    }
    
    
    @IBAction func voteHome(_ sender: Any) {
        let userID = Auth.auth().currentUser!.uid
        print(userID)
        usersVoted.append(userID)
        
        currentHomeVotes += 1
        
        self.ref.child("games").child(game.gameID).setValue(["awayVotes": currentVisitVotes!, "homeVotes": currentHomeVotes!, "users" : usersVoted])
        
        voteAwayButton.isHidden = true
        voteHomeButton.isHidden = true
        
        updateVoteChartData()
        votePieChart.isHidden = false
    }
    
    func getCurrentVotes() {
        
        ref.child("games").child(game.gameID).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let visitVotes = value?["awayVotes"] as? Int ?? 0
            let homeVotes = value?["homeVotes"] as? Int ?? 0
            self.currentVisitVotes = visitVotes
            self.currentHomeVotes = homeVotes
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func userVoted() -> Bool {
        for user in usersVoted {
            if Auth.auth().currentUser?.uid == user {
                return true
            }
        }
        print("USERSVOTED: \(usersVoted)")
        return false
    }
    
    func getUserCount() {
        var users : NSArray!
        ref.child("games").child(game.gameID).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            users = value?["users"] as? NSArray ?? []
            self.usersVoted = users as! [String]
            print(self.usersVoted)
        }) { (error) in
            print(error.localizedDescription)
        }
    }

}
