//
//  GameScene.swift
//  EscapeMitard
//
//  Created by Geraud Masselin on 02/03/2017.
//  Copyright © 2017 Geraud Masselin. All rights reserved.
//
import AVFoundation

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    var player :  SKSpriteNode?
    var background : SKSpriteNode?
    var background2 : SKNode?
    var entete : SKNode?
    var timeLabel : SKLabelNode?
    var gameOverLabel : SKLabelNode?
    var rejouerLabel : SKLabelNode?
    var metre = 0
    var diamondBleu : SKSpriteNode?
    var TNT : SKSpriteNode?
    var collision : SKPhysicsContact?
    var begin : Bool = false
  
    
    override func didMove(to view: SKView)
    {
        physicsWorld.contactDelegate = self
        
        if let hud = childNode(withName: "//SKNodeLabel") {
            entete = hud
        }
        
        if let mitard = childNode(withName: "//Mitard") as? SKSpriteNode
        {
            player  = mitard
        }
        
        if let backgame = childNode(withName: "//BackGame") as? SKSpriteNode
        {
            background = backgame
        }
        
        if let backgame2 = childNode(withName: "//BackGame2")
        {
            background2 = backgame2
        }
        
        if let timer = childNode(withName: "//TimeLabel") as? SKLabelNode{
            timeLabel = timer
        }
        
        if let diamond = childNode(withName: "//Diamond") as? SKSpriteNode{
            diamondBleu = diamond
        }
        
        if let baril = childNode(withName: "//Tnt") as? SKSpriteNode {
            TNT = baril
        }
        
        if let gameOver = childNode(withName: "//gameOver") as? SKLabelNode{
            gameOverLabel = gameOver
        }
        
        if let rejouer = childNode(withName: "//rejouer") as? SKLabelNode{
            rejouerLabel = rejouer
        }
        
        diamondBleu?.removeFromParent()
        TNT?.removeFromParent()
        
        player?.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "1er") , SKTexture(imageNamed: "2eme") , SKTexture(imageNamed: "3eme") , SKTexture(imageNamed: "4eme") ], timePerFrame: 0.1)))
    }
    
    func randomCGFloat(min: CGFloat, max: CGFloat) -> CGFloat
    {
        return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (max - min) + min
    }
    
    
    func addDiamond()
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3)
        {
            let diams = self.diamondBleu!.copy() as! SKSpriteNode
            self.addChild( diams )
            
            let posX = self.randomCGFloat(min: -self.frame.width/2, max: self.frame.width/2)
            print("\(posX)")
            
            let p = CGPoint(x: Int(posX),y: Int(-self.frame.height-100))
            diams.position = p
            diams.run(SKAction.moveBy(x:0,y: 2000, duration: 4), completion:
            {
                diams.removeFromParent()
                self.addDiamond()
            })
        }

    }
    
    func creatTNT(nombreDeTNT : Int)
    {
        
        var listeDeTNT: Array<SKSpriteNode> = Array()
        var i = 0
        while(i < nombreDeTNT){
            listeDeTNT.append(self.TNT?.copy() as! SKSpriteNode)
            i += 1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3)
        {
            for tnt in listeDeTNT {
                self.addChild( tnt )
                let posX = self.randomCGFloat(min: -self.frame.width/2, max: self.frame.width/2)
                print("\(posX)")
                let posY = self.randomCGFloat(min: -self.frame.height/2, max: self.frame.height/2)
                print("\(posY)")
                
                let p = CGPoint(x: Int(posX),y: Int(posY-self.frame.height))
                tnt.position = p
                
                tnt.run(SKAction.moveBy(x:0,y: 2500, duration: 4), completion:
                {
                    tnt.removeFromParent()
                    self.creatTNT(nombreDeTNT: 1)
                })
            }
        }
    }

    
    func didBegin(_ contact: SKPhysicsContact)
    {
        if let nodeA =  contact.bodyA.node , let nodeB =  contact.bodyB.node
        {
            
            var player : SKNode? = nil
            var element : SKNode? = nil
            
            if (nodeA.name == "Mitard")
            {
                player = nodeA
                element = nodeB
            }
            else if (nodeB.name  == "Mitard")
            {
                player = nodeB
                element =  nodeA
            }
            
            if let player = player , let element = element
            {
                if( element.name == "Diamond")
                {
                    playSound()
                    element.removeFromParent()
                    addDiamond()
                }
                else if(element.name == "Tnt")
                {
                    element.removeFromParent()
                    stop()
                    
                }
            }
        }
    }
    func start()
    {
        background?.position.y = 0
        background2?.position.y = -50
        
        background2?.isHidden = false
        background?.isHidden = false
        
        let moveUp = SKAction.moveBy(x: 0, y: 50, duration: 0.3)
        let moveReset = SKAction.moveBy(x: 0, y: -50, duration: 0)
        let moveLoop = SKAction.sequence([moveUp, moveReset])
        let moveForever = SKAction.repeatForever(moveLoop)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1)
        {
            let moveUpB = SKAction.moveBy(x: 0, y: 1355, duration: 2)
            self.background?.run(moveUpB)

            self.background2?.run(moveForever)
            
            self.creatTNT(nombreDeTNT: 4)
            self.addDiamond()
            self.begin = true

        }
        
        

        

        for item in children
        {
            if(item.name != "gameOver" && item.name != "rejouer")
            {
                item.isHidden = false
            }
        }
 
        gameOverLabel?.isHidden = true
        rejouerLabel?.isHidden = true
    }
    
    func stop(){
        background?.isHidden = true
        background2?.isHidden = true
        
        background2?.removeAllActions()
        
        begin = false
        
        for item in children
        {
            if(item.name != "gameOver" && item.name != "rejouer")
            {
                item.isHidden = true
            }
            if(item.name == "Diamond" || item.name == "Tnt"){
                
                item.removeFromParent()
                item.isPaused = true
            }
        }
                
        gameOverLabel?.isHidden = false
        rejouerLabel?.isHidden = false
        
        
        
        
        
        self.metre = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if( begin == false)
        {
            start()
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: self )
        {
            if (begin == true){
                player?.position.x = point.x
            }
        }
    }
    
       
    func playSound()
    {
            run(SKAction.playSoundFileNamed("armor_hit1.wav", waitForCompletion: false))
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
  
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if(begin == true){
            self.timeLabel?.text = "\(self.metre) m"
            self.metre += 1
        }
    }
}
