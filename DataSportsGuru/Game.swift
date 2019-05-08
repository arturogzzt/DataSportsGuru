//
//  Game.swift
//  DataSportsGuru
//
//  Created by Arturo González on 4/24/19.
//  Copyright © 2019 Arturo González. All rights reserved.
//

import Foundation

class Game {

    let gameID : String
    let arenaGame : String
    let startTime : String
    let vTeamID : String
    let vTeamTriCode : String
    let hTeamID : String
    let hTeamTriCode : String
    var vScore : String
    var hScore : String
    var status : String
    let hTeamWin : String
    let vTeamWin : String
    let period : String
    
    
    init(gameID: String, arenaGame : String, startTime : String, vTeamID : String, vTeamTriCode : String, hTeamID: String, hTeamTriCode : String, vScore : String, hScore : String, status : String, hTeamWin : String, vTeamWin : String, period : String ) {
        self.gameID = gameID
        self.arenaGame = arenaGame
        self.startTime = startTime
        self.vTeamID = vTeamID
        self.vTeamTriCode = vTeamTriCode
        self.hTeamID = hTeamID
        self.hTeamTriCode = hTeamTriCode
        self.vScore = vScore
        self.hScore = hScore
        self.status = status
        self.hTeamWin = hTeamWin
        self.vTeamWin = vTeamWin
        self.period = period

    }
}
