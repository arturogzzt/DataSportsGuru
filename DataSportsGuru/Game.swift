//
//  Game.swift
//  DataSportsGuru
//
//  Created by Arturo González on 4/24/19.
//  Copyright © 2019 Arturo González. All rights reserved.
//

import Foundation

class Game {
    let arenaGame : String
    let startTime : String
    let vTeamID : String
    let vTeamTriCode : String
    let hTeamID : String
    let hTeamTriCode : String
    let vScore : String
    let hScore : String
    
    init(arenaGame : String, startTime : String, vTeamID : String, vTeamTriCode : String, hTeamID: String, hTeamTriCode : String, vScore : String, hScore : String ) {
        self.arenaGame = arenaGame
        self.startTime = startTime
        self.vTeamID = vTeamID
        self.vTeamTriCode = vTeamTriCode
        self.hTeamID = hTeamID
        self.hTeamTriCode = hTeamTriCode
        self.vScore = vScore
        self.hScore = hScore
    }
}
