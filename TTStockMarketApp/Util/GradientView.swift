//
//  GradientView.swift
//  TTStockMarketApp
//
//  Created by Milica Kostic on 06/06/2020.
//  Copyright © 2020 Milica Kostic. All rights reserved.
//

import UIKit

@IBDesignable
open class GradientView: UIView {
    
    @IBInspectable open var gradient: Bool = false {
        didSet {
            createGradientBackground()
        }
    }

    @IBInspectable open var topGradientColor: UIColor = UIColor.clear {
        didSet {
            createGradientBackground()
        }
    }
    @IBInspectable open var bottomGradientColor: UIColor = UIColor.clear {
        didSet {
            createGradientBackground()
        }
    }
    
    open var gradientLayer = CAGradientLayer()
    open var gradientColors: [CGColor] {
        return [topGradientColor.cgColor, bottomGradientColor.cgColor]
    }
    
    // MARK: - Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        configureView()
    }
    
    open func configureView() {
        layer.insertSublayer(gradientLayer, at: 0)
        // Top to bottom
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    }
    
    // MARK: - Drawing
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        createGradientBackground()
    }
    
    private func updateGradientLayerFrame() {
        gradientLayer.frame = bounds
        gradientLayer.removeAllAnimations()
    }
    
    private func createGradientBackground() {
        gradientLayer.frame = bounds
        gradientLayer.colors = gradientColors
        gradientLayer.isHidden = !gradient
    }
}

