//
//  TeamStats.swift
//  DataSportsGuru
//
//  Created by Arturo González on 5/11/19.
//  Copyright © 2019 Arturo González. All rights reserved.
//

import Foundation

class TeamStats {
    var fgp : Float
    var rebounds : Float
    var freethrows : Float
    var steals : Float
    var blocks : Float
    var elo : Float
    
    init(fgp : Float, rebounds : Float, freethrows : Float, steals : Float, blocks : Float) {
        self.fgp = fgp
        self.rebounds = rebounds
        self.freethrows = freethrows
        self.steals = steals
        self.blocks = blocks
        
        
        self.fgp = self.fgp * 400
        self.rebounds = self.rebounds * 5
        self.freethrows = self.freethrows * 50
        self.steals = self.steals * 10
        self.blocks = self.blocks * 10
        self.elo = 0
    }
    
    func getElo () {
        self.elo = self.fgp + self.rebounds + self.freethrows + self.steals + self.blocks
    }
    
}
