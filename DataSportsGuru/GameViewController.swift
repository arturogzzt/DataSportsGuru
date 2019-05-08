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

class GameViewController: UIViewController {
    var game : Game!
    var gameRecap : JSON!
    var playoffData : JSON!
    var vTeamElo = 0.0;
    var HTeamElo = 0.0;
    @IBOutlet weak var vScore: UILabel!
    @IBOutlet weak var hScore: UILabel!
    @IBOutlet weak var vTeamTri: UILabel!
    @IBOutlet weak var arena: UILabel!
    @IBOutlet weak var hTeamTri: UILabel!
    @IBOutlet weak var vTeamSeriesWin: UILabel!
    @IBOutlet weak var hTeamSeriesWin: UILabel!
    @IBOutlet weak var vTeamSeriesLoss: UILabel!
    @IBOutlet weak var hTeamSeriesLoss: UILabel!
    
    @IBOutlet weak var gameInfo: UILabel!
    
    @IBOutlet weak var gameRecapBtn: UIButton!
    var todaysDate : String!
    @IBOutlet weak var pieChartView: PieChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getPlayoffStats()
        
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
            gameInfo.text = "Quarter: " + game.period
            gameRecapBtn.isHidden = true
           
        }
        else if(game.status == "1"){
            updateChartData()
            vScore.text = "0"
            hScore.text = "0"
            arena.text = game.arenaGame
            vTeamTri.text = game.vTeamTriCode
            hTeamTri.text = game.hTeamTriCode
            vTeamSeriesWin.text = game.vTeamWin
            vTeamSeriesLoss.text = game.hTeamWin
            hTeamSeriesWin.text = game.hTeamWin
            hTeamSeriesLoss.text = game.vTeamWin
            gameInfo.text = game.startTime
            gameRecapBtn.isHidden = true
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
            gameInfo.text = "FINAL"
            getGameRecap(url: "http://data.nba.net/10s/prod/v1/" + todaysDate + "/" + game.gameID + "_recap_article.json")
            
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
        
        // 2. generate chart data entries
        let equipos = [game.hTeamTriCode, game.vTeamTriCode]
        let money = [1000.0, 1200.0]
        
        var entries = [PieChartDataEntry]()
        for (index, value) in money.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = Double(value)
            entry.label = equipos[index]
            entries.append( entry)
        }
        
        // 3. chart setup
        let set = PieChartDataSet( entries: entries, label: "Game Odds via DataSportsGuru Algorithm")
        // this is custom extension method. Download the code for more details.
        var colors: [UIColor] = []
        
        for _ in 0..<money.count {
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
        pieChartView.holeRadiusPercent = 0.5
        pieChartView.transparentCircleColor = UIColor.clear
        self.view.addSubview(pieChartView)
        
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
        
        for i in 0...playoffData.count{
        if(playoffData[i]["teams"][0]["teamId"].stringValue == game.vTeamID){
               print(i)
            }
        if(playoffData[i]["teams"][1]["teamId"].stringValue == game.vTeamID){
               print(i)
            }
        if(playoffData[i]["teams"][0]["teamId"].stringValue == game.hTeamID){
                print(i)
            }
        if(playoffData[i]["teams"][1]["teamId"].stringValue == game.hTeamID){
                print(i)
            }
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "gameRecap"){
            
            let vistaGameRecap = segue.destination as! GameRecapViewController
            vistaGameRecap.gameRecapJSON = gameRecap
    
            
            
        }
    }


}
