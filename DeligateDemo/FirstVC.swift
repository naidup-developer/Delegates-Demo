//
//  ViewController.swift
//  DeligateDemo
//
//  Created by Chanti on 28/07/22.
//

import UIKit

class FirstVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeColors(_:)), name: Notification.Name("ColorChange"), object: nil)
    }

    @IBAction func onTapChangeColor(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "SecondVC") as! SecondVC
        vc.delegate = self
        vc.selectedOption = changeColor(color:)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func changeColor(color: UIColor) {
        self.view.backgroundColor = color
    }
    
    @objc func changeColors(_ notification: Notification) {
        self.view.backgroundColor = notification.userInfo?["color"] as? UIColor
    }
}

extension FirstVC: ColourChangeDelegate {
    func didColorChanged(to color: UIColor) {
        self.view.backgroundColor = color
    }
}


protocol ColourChangeDelegate {
    func didColorChanged(to color: UIColor)
}



class SecondVC: UIViewController {

    @IBOutlet weak var greenBtn: UIButton!
    @IBOutlet weak var redBtn: UIButton!
    @IBOutlet weak var blueBtn: UIButton!
    var delegate: ColourChangeDelegate?
    
    var selectedOption: ((UIColor) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        greenBtn.setTitle("Green with Delegate", for: .normal)
        redBtn.setTitle("Red with Closure", for: .normal)
        blueBtn.setTitle("Blue with Notifications", for: .normal)
        
        greenBtn.addTarget(self, action: #selector(onSelectGreen), for: .touchUpInside)
        redBtn.addTarget(self, action: #selector(onSelectRed), for: .touchUpInside)
        blueBtn.addTarget(self, action: #selector(onSelectBlue), for: .touchUpInside)
        
    }
    
    @objc func onSelectGreen() {
        navigationController?.popViewController(animated: true)
        delegate?.didColorChanged(to: UIColor.green)
    }
    
    @objc func onSelectRed() {
        navigationController?.popViewController(animated: true)
        selectedOption?(.red)
    }
    
    @objc func onSelectBlue() {
        navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: Notification.Name("ColorChange"), object: nil, userInfo: ["color" : UIColor.blue])
    }


}

