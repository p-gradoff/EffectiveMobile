//
//  ViewController.swift
//  EffectiveMobile
//
//  Created by Павел Градов on 14.11.2024.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    private lazy var label: UILabel = {
        $0.text = "Simple Text"
        $0.font = .getFont(fontType: .bold, size: 48)
        $0.textAlignment = .center
        $0.textColor = .primaryText
        return $0
    }(UILabel())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // view.backgroundColor = .mainTheme
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        view.addSubview(blurView)
        
        label.center = blurView.center
        blurView.contentView.addSubview(label)
        
//        label.frame = CGRect(x: 30, y: view.center.y, width: view.frame.width - 60, height: 50)
//        
//        let blurEffect = UIBlurEffect(style: .dark)
//        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
//        blurredEffectView.frame = label.bounds
//        view.addSubview(blurredEffectView)
        
//        let blurEffect = UIBlurEffect(style: .dark)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        
//        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect, style: .tertiaryFill)
//        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
//        
//        blurEffectView.contentView.addSubview(vibrancyEffectView)
//        vibrancyEffectView.contentView.addSubview(label)
//        
//        view.addSubview(blurEffectView)
//        
//        blurEffectView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//        
//        vibrancyEffectView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//        
//        label.snp.makeConstraints {
//            $0.center.equalToSuperview()
//        }
    }


}

