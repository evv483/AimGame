//
//  GameViewController.swift
//  AimGame
//
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            if let scene = SKScene(fileNamed: "MainMenuScene") {

                if self.view.frame.size.height < 737 {
                    scene.size = CGSize(width: 750, height: 1334)
                } else {
                    scene.size = CGSize(width: 750, height: 1625)
                }

                scene.scaleMode = .aspectFill
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
//            view.showsFPS = true
//            view.showsNodeCount = true
//            view.showsPhysics = true
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationToWebView(notification:)), name: Notification.Name("toWebView"), object: nil)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func notificationToWebView(notification: Notification) {
        let vc = WebViewViewController()
        let navVC = UINavigationController (rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
}

