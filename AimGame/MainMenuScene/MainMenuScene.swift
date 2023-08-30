//
//  MainMenuScene.swift
//  AimGame
//
//

import SpriteKit
import GameplayKit

class MainMenuScene: SKScene {
    
    var mainTitle:SKSpriteNode!
    var btnStart:SKSpriteNode!
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .white
        setupView()
    }
    
    func setupView() {
        mainTitle = SKSpriteNode(imageNamed: "mainMenuLabel")
        mainTitle.zPosition = 1
        mainTitle.position = CGPoint(x: frame.size.width / 2, y: frame.size.height - 200)
        mainTitle.name = "mainTitle"
        self.addChild(mainTitle)
        
        btnStart = SKSpriteNode(imageNamed: "btnStartLabel")
        btnStart.zPosition = 1
        btnStart.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        btnStart.name = "btnStart"
        self.addChild(btnStart)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self){
            
            if self.nodes(at: location).first?.name == "btnStart" {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()

                let scene = GameScene(size: self.size)
                view!.presentScene(scene)
            }
        }
    }
}
