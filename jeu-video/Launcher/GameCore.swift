//
//  Playing.swift
//  jeu-video
//
//  Created by Gustav Berloty on 28/01/2019.
//  Copyright © 2019 Gustav Berloty. All rights reserved.
//

import Foundation

class GameCore {     // This class describe how the players play the game and how it works.
    
    // MARK: PROPERTY LIST
    
    private var gameInformations : GameManager     // Get the players informations that have been captured with the game menu (see the cass StartTheGame.swift)
    private var winner : Player?        // The future winner of the game.
    
    // MARK: CONSTRUCTOR
    
    init (game : GameManager) {
        gameInformations = game
        winner = nil
    }
    
     // MARK: ACTION METHODS
    
    func start() {      // The method that rules the game, a non private method
        // At this time, the game order is in function of the players indexes.
        var indexOfThePlayingPlayer : Int = gameInformations.getPlayers().count - 1 // This is to use easly players in methods
        repeat {
            turn(of: nextPlayerIndex(after: indexOfThePlayingPlayer)) // The player associated has to play ! It's his turn.
            indexOfThePlayingPlayer = nextPlayerIndex(after: indexOfThePlayingPlayer)
        } while(!gameEnded())
        winner = getTheWinner()
        print( "\n" + ( "\(winner!.getPseudo())".bold() + " a remporté la partie !\n" ).blink().green() )
    }
    
    private func turn(of currentPlayer : Int) {     // This method describes how a player's turn works
        let thePlayingPlayer : Player = (gameInformations.getPlayers())[currentPlayer]
        print(("\n\t   C'est au tour de " + "\(thePlayingPlayer.getPseudo())".bold() + "\t\t").backgroundColor(.grey))
        let theNextPlayingPlayer : Player = (gameInformations.getPlayers())[nextPlayerIndex(after: currentPlayer)]
        print("\n\tChoisisez un personnage de " + "votre équipe ".bold() + "pour guérir un de ses confrères ou alors pour combattre un personnage adverse: ")
        let theFirstChosenCharacter : Character = thePlayingPlayer.chooseOneCharacter(onlyAliveCharacter: true)!
        var theSecondChosenCharacter : Character
        
        if(thisTimeIsGood()){
            Treasure.appeared(for: theFirstChosenCharacter)
        }
        
        if (String(describing: type(of: theFirstChosenCharacter)) == "Mage") {
            print("\n\tChoisisez un personnage de votre équipe que le mage guérira: ")
            theSecondChosenCharacter = thePlayingPlayer.chooseOneCharacter(onlyAliveCharacter: true)!
        }
        else {
            print("\n\tChoisisez à présent un personnage de " + "l'équipe de \(theNextPlayingPlayer.getPseudo())".bold() + " à combattre: ")
            theSecondChosenCharacter = theNextPlayingPlayer.chooseOneCharacter(onlyAliveCharacter: true)!
        }
        let isDead : Bool = theFirstChosenCharacter.act(to: theSecondChosenCharacter)
        if (isDead && theNextPlayingPlayer.isAllDead()) {
            print(((theNextPlayingPlayer.getPseudo()).bold() + " a perdu, tous ses personnages sont K.O !").red())
        }
    }
    
    private func nextPlayerIndex (after this : Int) -> Int { // Give the next player index
        var nextPlayer = 0
        if(this == gameInformations.getPlayers().count - 1) {
            nextPlayer = 0
        }
        else {
            nextPlayer = this + 1
        }
        if(gameInformations.getPlayers()[nextPlayer].isAllDead()) {
            return nextPlayerIndex(after: nextPlayer)
        }
        return nextPlayer
    }
    
    private func gameEnded () -> Bool {     // Says if the game has ended
        var NbrOfUnplayablePlayer : Int = 0
        for thePlayerTeam in gameInformations.getPlayers() {
            if (thePlayerTeam.isAllDead()) {
                 NbrOfUnplayablePlayer += 1
            }
        }
        if (NbrOfUnplayablePlayer == gameInformations.getPlayers().count - 1) {
            return true
        }
        return false
    }
    
    private func getTheWinner () -> Player? {       // Get the winner of the game
        if (gameEnded()) {
            for player in gameInformations.getPlayers() {
                if (!player.isAllDead()) {
                   return player
                }
            }
        }
        return nil
    }
    
    private func thisTimeIsGood() -> Bool {     // This method says if it's the time to show up a treasure or not.
        let number = Int.random(in: 0 ..< 4) // either 0, 1, 2 or 3
        if (number == 2) { return true } // 2 means it's a power
        return false
    }
    
}
