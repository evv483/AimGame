//
//  GameScene.swift
//  AimGame
//
//

import SpriteKit
import GameplayKit
import WebKit

class GameScene: SKScene {
    
    let webView = WKWebView()
    
    var popUp:SKSpriteNode!
    var aim:SKSpriteNode!
    
    var timeTimer: Timer!
    var timeLabel:SKLabelNode!
    var time = 7 {
        didSet {
            timeLabel.text = "Time: \(time)s"
            
            if time == 0 {
                timeTimer.invalidate()
                showPopUp(name: "youLosePopUp", yPosition: 667)
                removeAim()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    UserDefaults.standard.set(false, forKey: "winStatus")
                    NotificationCenter.default.post(name: Notification.Name("toWebView"), object: nil)
                }
            }
        }
    }
    
    var aimTappedCounterLabel:SKLabelNode!
    var aimTappedCounter = 0 {
        didSet {
            aimTappedCounterLabel.text = "Aims: \(aimTappedCounter)"
            
            if aimTappedCounter == 10 {
                timeTimer.invalidate()
                showPopUp(name: "youWinPopUp", yPosition: 667)
                removeAim()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    UserDefaults.standard.set(true, forKey: "winStatus")
                    NotificationCenter.default.post(name: Notification.Name("toWebView"), object: nil)
                }
            }
        }
    }
        
    override func didMove(to view: SKView) {
        self.backgroundColor = .white
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        if UserDefaults.standard.bool(forKey: "tutorialPopUpShowed") == false {
            showPopUp(name: "thisIsToTapPopUp", yPosition: 600)
        } else {
            startGame()
        }
        
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationCreateRestartBTN(notification:)), name: Notification.Name("showPopUp"), object: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self){
            
            if self.nodes(at: location).first?.name == "thisIsToTapPopUp" {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                popUp.removeFromParent()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                    showPopUp(name: "thisIsYourTimePopUp", yPosition: 330)
                }
            }
            
            if self.nodes(at: location).first?.name == "thisIsYourTimePopUp" {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                popUp.removeFromParent()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [self] in
                    showPopUp(name: "tap10TimesPopUp", yPosition: 330)
                }
            }
            
            if self.nodes(at: location).first?.name == "tap10TimesPopUp" {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                popUp.removeFromParent()
                UserDefaults.standard.set(true, forKey: "tutorialPopUpShowed")
                startGame()
            }
            
            if self.nodes(at: location).first?.name == "aim" {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                
                aimTappedCounter += 1
                
                let scaleNodeToZero = SKAction.scale(to: 0, duration: 0.2)
                let rotateNode = SKAction.rotate(byAngle: 5, duration: 0.2)
                self.nodes(at: location).first?.run(scaleNodeToZero)
                self.nodes(at: location).first?.run(rotateNode)
                
                if time > 0 && aimTappedCounter < 10 {
                    addAim()
                }
            }
            
            if self.nodes(at: location).first?.name == "btnRestartLabel" {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                
                if let node = childNode(withName: "youLosePopUp") {
                    node.removeFromParent()
                }
                
                if let node = childNode(withName: "youWinPopUp") {
                    node.removeFromParent()
                }
                
                if let node = childNode(withName: "btnRestartLabel") {
                    node.removeFromParent()
                }
                
                time = 7
                aimTappedCounter = 0
                startGame()
            }
        }
    }
    
    func setupView() {
        timeLabel = SKLabelNode(text: "Time: 7s")
        timeLabel.zPosition = 2
        timeLabel.position = CGPoint(x: frame.size.width / 2 - 120, y: frame.size.height - 130)
        timeLabel.fontName = "AmericanTypewriter-Bold"
        timeLabel.fontSize = 45
        timeLabel.fontColor = UIColor.black
        self.addChild(timeLabel)
        
        aimTappedCounterLabel = SKLabelNode(text: "Aims: 0")
        aimTappedCounterLabel.zPosition = 2
        aimTappedCounterLabel.position = CGPoint(x: frame.size.width / 2 + 120, y: frame.size.height - 130)
        aimTappedCounterLabel.fontName = "AmericanTypewriter-Bold"
        aimTappedCounterLabel.fontSize = 45
        aimTappedCounterLabel.fontColor = UIColor.black
        self.addChild(aimTappedCounterLabel)
    }
    
    func showPopUp(name: String, yPosition: CGFloat) {
        popUp = SKSpriteNode(imageNamed: name)
        popUp.zPosition = 1
        popUp.position = CGPoint(x: frame.size.width / 2, y: frame.size.height - yPosition)
        popUp.name = name
        self.addChild(popUp)
    }
    
    func startGame() {
        startTimeTimer()
        addAim()
    }
    
    func startTimeTimer() {
        timeTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] _ in
            time -= 1
        })
    }
    
    func addAim() {
        let aim = SKSpriteNode(imageNamed: "aim")
        aim.name = "aim"
        aim.physicsBody = SKPhysicsBody(circleOfRadius: aim.size.width / 2)
        aim.position = CGPoint(x: CGFloat.random(in: 50...self.frame.size.width - 50),
                               y: CGFloat.random(in: 50...self.frame.size.height - 160))
        self.addChild(aim)
    }
    
    func removeAim() {
        if let node = childNode(withName: "aim") {
            node.removeFromParent()
        }
    }
    
    @objc func notificationCreateRestartBTN(notification: Notification) {
        showPopUp(name: "btnRestartLabel", yPosition: 767)
    }
}

