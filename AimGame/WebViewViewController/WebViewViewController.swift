//
//  WebViewViewController.swift
//  AimGame
//
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {

    let webView = WKWebView()

    var winnerURL = String()
    var loserURL = String()
        
    var winStatus = UserDefaults.standard.bool(forKey: "winStatus")
    
    var yFrameForWebView: CGFloat = 90
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        fetchData { [self] (dict, error) in
            if let dictionary = dict {
                if let url = dictionary["winner"] {
                    self.winnerURL = url
                }
                if let url = dictionary["loser"] {
                    self.loserURL = url
                }
            }
            
            if winStatus == false {
                DispatchQueue.main.async { [self] in
                    if let url = URL(string: loserURL) {
                        let request = URLRequest(url: url)
                        webView.load(request)
                        view.addSubview(webView)
                    } else {
                        showPopUp()
                    }
                }
            } else {
                DispatchQueue.main.async { [self] in
                    if let url = URL(string: winnerURL) {
                        let request = URLRequest(url: url)
                        webView.load(request)
                        view.addSubview(webView)
                    } else {
                        showPopUp()
                    }
                }
            }
        }
        configureButton()
    }
    
    override func viewDidLayoutSubviews () {
        super.viewDidLayoutSubviews ()
        
        if self.view.frame.size.height < 737 {
            yFrameForWebView = 60
        }
        
        webView.frame = CGRect(x: 0, y: yFrameForWebView, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - yFrameForWebView)
        webView.backgroundColor = .white
    }
        
    func configureButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(didTapBack))
    }
    
    func fetchData(completion: @escaping ([String:String]?, Error?) -> Void) {
        guard let url = URL(string: "https://2llctw8ia5.execute-api.us-west-1.amazonaws.com/prod") else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:String]{
                    completion(array, nil)
                }
            } catch {
                print(error)
                completion(nil, error)
            }
        }
        task.resume()
    }
    
    func showPopUp() {
        let imageView = UIImageView(image: UIImage(named: "connectionProblemPopUp"))
        imageView.frame = CGRect(x: self.view.frame.midX - 100, y: self.view.frame.midY - 100, width: 200, height: 200)
        
        view.addSubview(imageView)
    }
    
    @objc func didTapBack() {
        dismiss(animated: true)
        NotificationCenter.default.post(name: Notification.Name("showPopUp"), object: nil)
    }
}
