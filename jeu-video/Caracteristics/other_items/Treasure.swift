//
//  Treasure.swift
//  jeu-video
//
//  Created by Gustav Berloty on 21/02/2019.
//  Copyright © 2019 Gustav Berloty. All rights reserved.
//

import Foundation

class Treasure {        // This class represents treasures that you can find randomly during the game.
    
    // MARK: ACTION METHODS
    // MARK: On the treasure creation
    static func appeared (for character : Character) {      // The function that create a new treasure.
        print("\n ** Un coffre fort est apparu ! ** \nPour ouvrir ce coffre fort, entrez 'o': ")
        var newWeapon : Weapon?, newPower : Power?
        let isNewItemWeapon : Bool = generateNewItem()
        if (isNewItemWeapon == true) {
            newWeapon = Weapon.generateNewOne()
        }
        else {
            newPower = Power.generateNewHealing()
        }
        open()
        let toContinue = canGiftBeCarry(byThis: character, dependingOf: isNewItemWeapon, itemPossibility1: newWeapon, itemPossibility2: newPower)
        if (toContinue) {
            getTheGift(dependingOf: isNewItemWeapon, itemPossibility1: newWeapon, itemPossibility2: newPower, forThis: character)
        }
    }
    
    // This function create the item inside of the treasure: weapon or healing gift
    private static func generateNewItem () -> Bool { // "True" for a weapon or "False" for a power
        let number = Int.random(in: 0 ..< 4) // either 0, 1, 2 or 3
        if (number == 2) { return false } // 2 means it's a power
        return true
    }
    
    // MARK: On the new created gift item
    
    // This function is used to inform the character on the item's caracteristics
    private static func itemDescription(isAWeapon : Bool, itemPossibility1: Weapon?, itemPossibility2 : Power?) {
        if(isAWeapon) {
            print("L'item provenant du coffre est l'arme suivante: ")
            print("\t› " + String(describing: type(of: itemPossibility1!)) + ":")
            print("\t\t- Dégat: \(itemPossibility1!.getDamage())")
        }
        else {
            print("L'item provenant du coffre est le pouvoir suivant: ")
            print("\t› \(itemPossibility2!.getName()):")
            if(itemPossibility2!.getGiveLifePoint() != nil) {
                print("\t\t- Ajoute \(itemPossibility2!.getGiveLifePoint()!) points de vie.")
            }
            else { print("\t\t- N'ajoute pas de point de vie.") }
            if(itemPossibility2!.getGiveDefensePoint() != nil) {
                print("\t\t- Ajoute \(itemPossibility2!.getGiveLifePoint()!) points de défense.")
            }
            else { print("\t\t- N'ajoute pas de point de défense.") }
            
        }
    }
    
    // This function says if the item can be taken by the character: healing only for mage and weapon only for the others.
    private static func canGiftBeCarry(byThis character : Character,  dependingOf itemIsWeapon: Bool, itemPossibility1: Weapon?, itemPossibility2 : Power?) -> Bool {
        var canGiftBeCarry : Bool = false
        if (itemIsWeapon && String(describing: type(of: character)) != "Mage" && itemPossibility1 != nil) {
            canGiftBeCarry = true
        }
        else  if ( !itemIsWeapon && String(describing: type(of: character)) == "Mage") {
            canGiftBeCarry = true
        }
        
        if (itemIsWeapon) {
            itemDescription(isAWeapon: true, itemPossibility1: itemPossibility1, itemPossibility2: nil)
            if (canGiftBeCarry == true) {
                print("\(character.getName()) est apte à avoir cette arme !")
            }
            else {
                print("\(character.getName()) ne peut pas porter une arme de ce type.\n")
            }
        }
        else {
            itemDescription(isAWeapon: false, itemPossibility1: nil, itemPossibility2: itemPossibility2)
            if(canGiftBeCarry == true) {
                print("\(character.getName()) est apte à avoir ce pouvoir ! Ce pouvoir a donc été ajoutée à \(character.getName()).")
            }
            else {
                print("\(character.getName()) ne peut pas utiliser ce pouvoir.\n")
            }
        }
        return canGiftBeCarry
    }
    
    // This function is used by the character to take the item
    private static func getTheGift(dependingOf itemIsWeapon: Bool, itemPossibility1 : Weapon?, itemPossibility2 : Power?, forThis character : Character ) {
        if (itemIsWeapon && itemPossibility1 != nil) {
            forWeaponGift(weaponGiven: itemPossibility1!, character: character)
        }
        else if (itemPossibility2 != nil){
            forPowerGift(powerGiven: itemPossibility2!, character: character)
        }
    }
    
    // This function is used by the character to take the item in the case where it's a weapon
    private static func forWeaponGift (weaponGiven : Weapon, character : Character) {
        print("Voulez-vous que \(character.getName()) utilise cette arme pour combattre ? il s'agira alors dans ce cas de son arme par défaut.")
        print("Entrez 'o' pour répondre par l'affirmative ou 'n' pour la négative :")
        var choice : String
        repeat {
            choice =  readLine()!
            if choice == "o" {
                character.addWeapon(this: weaponGiven)
                character.setWeaponUsedByDefault(this: weaponGiven)
                print("\(character.getName()) porte désormais cette arme, de plus elle a été ajoutée à votre inventaire.")
            }
            else if choice == "n" {
                character.addWeapon(this: weaponGiven)
                print("Arme ajoutée à l'inventaire de \(character.getName()).")
            }
            else {
                print("Caractère non reconnu.\nEntrez 'o' pour répondre par l'affirmative! ou 'n' pour la négative :")
            }
        } while (choice != "o" && choice != "n")
    }
    
    // This function is used by the character to take the item in the case where it's a power
    private static func forPowerGift (powerGiven : Power, character : Character) {
        print("Voulez-vous que \(character.getName()) utilise ce pouvoir en tant qu'action par défaut ?")
        print("Entrez 'o' pour répondre par l'affirmative ou 'n' pour la négative :")
        var choice : String
        repeat {
            choice =  readLine()!
            if choice == "o" {
                character.addPower(this: powerGiven)
                character.setPowerUsedByDefault(this: powerGiven)
                print("\(character.getName()) utilisere désormais par défaut ce nouveau pouvoir.")
            }
            else if choice == "n" {
                character.addPower(this: powerGiven)
                print("\(character.getName()) a un nouveau pouvoir !")
            }
            else {
                print("Caractère non reconnu.\nEntrez 'o' pour répondre par l'affirmative ou 'n' pour la négative :")
            }
        } while (choice != "o" && choice != "n")
    }
    
    // MARK: OTHER
    
    private static func open() { // to open the treasure
        var choice : String
        repeat {
            choice =  readLine()!
            if choice == "o" {
                
            }
            else {
                print("Caractère non reconnu, il vous faut ouvrir ce coffre.\nPour ouvrir ce coffre fort, entrez 'o': ")
            }
        } while (choice != "o")
    }
}

