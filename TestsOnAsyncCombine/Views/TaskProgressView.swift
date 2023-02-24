//
//  ProgressView.swift
//  TestsOnAsyncCombine
//
//  Created by Giwon Seo on 2023/01/28.
//

import UIKit

@IBDesignable
class TaskProgressView: UIView {

    private let progressView = UIProgressView.init(progressViewStyle: .default)
    private let markImageView = UIImageView.init(image: UIImage.init(named: "Check.png")!)
    
    private let progressLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        self.addSubview(progressView)
//        self.addSubview(markImageView)
        self.addSubview(progressLabel)
        
        progressLabel.isHidden = false
        markImageView.isHidden = true
        markImageView.contentMode = .scaleAspectFit
    }
    
    override func layoutSubviews() {
        let leadingSpace: CGFloat = 20
        let imageViewWidth: CGFloat = 30
        progressView.frame = CGRect.init(x: leadingSpace, y: 0, width: self.bounds.width - 80, height: 50)
        markImageView.frame = CGRect.init(x: leadingSpace, y: 0, width: imageViewWidth, height: imageViewWidth)
        
        progressView.center = CGPoint.init(x: progressView.center.x, y: self.bounds.midY)
        markImageView.center = CGPoint.init(x: progressView.frame.maxX + imageViewWidth/2.0 + 15.0, y: progressView.center.y)
        
        progressLabel.center = markImageView.center
    }
    
    /// value ranges from 0 to 1
    func updateProgress(to value: CGFloat) {
        
        DispatchQueue.main.async {
            self.progressView.progress = Float(value)
            self.progressLabel.text = "\(Int(Float(value) * 100))%"
            self.progressLabel.sizeToFit()
            
            if self.progressView.progress >= 1.0 {
                self.markImageView.isHidden = false
                self.progressLabel.isHidden = true
            } else {
                self.markImageView.isHidden = true
                self.progressLabel.isHidden = false
            }
        }
        
    }
}
