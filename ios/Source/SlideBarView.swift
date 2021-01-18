//
//  SlideBarView.swift
//  epub_kitty
//
//  Created by N-155|User on 1/15/21.
//

import UIKit


class SlideBarView: NSObject, UIScrollViewDelegate {
    weak var delegate: FolioReaderCenter?
    var visible = true
    var slider: UISlider!

    fileprivate weak var readerContainer: FolioReaderContainer?

    fileprivate var readerConfig: FolioReaderConfig {
        guard let readerContainer = readerContainer else { return FolioReaderConfig() }
        return readerContainer.readerConfig
    }

    fileprivate var folioReader: FolioReader {
        guard let readerContainer = readerContainer else { return FolioReader() }
        return readerContainer.folioReader
    }

    var frame: CGRect {
        didSet {
            self.slider.frame = frame
        }
    }

    private lazy var thumbView: UIView = {
            let thumb = UIView()
            thumb.backgroundColor = readerConfig.tintColor//thumbTintColor
            thumb.layer.borderWidth = 0.4
            thumb.layer.borderColor = UIColor.darkGray.cgColor
            return thumb
        }()
    
    private func thumbImage(radius: CGFloat) -> UIImage {
       // Set proper frame
       // y: radius / 2 will correctly offset the thumb

       thumbView.frame = CGRect(x: 0, y: radius / 2, width: radius, height: radius)
       thumbView.layer.cornerRadius = radius / 2

       // Convert thumbView to UIImage
       // See this: https://stackoverflow.com/a/41288197/7235585

        if #available(iOS 10, *) {
            let renderer = UIGraphicsImageRenderer(bounds: thumbView.bounds)
            return renderer.image {rendererContext in
                thumbView.layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(thumbView.frame.size, false, 0.0)
            thumbView.layer.render(in:UIGraphicsGetCurrentContext()!)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: newImage!.cgImage!)
        }
    }
    
    init(frame:CGRect, withReaderContainer readerContainer: FolioReaderContainer) {
        self.frame = frame
        self.readerContainer = readerContainer

        super.init()

        slider = UISlider()
        slider.layer.anchorPoint = CGPoint(x: 0, y: 0)
        slider.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2))
        slider.alpha = 1 //initially show the slidebar
        slider.minimumValue = 0
        self.reloadColors()

        let thumbImg = thumbImage(radius: 20)
        let thumbImgColor = thumbImg.imageTintColor(readerConfig.tintColor)?.withRenderingMode(.alwaysOriginal)
        slider.setThumbImage(thumbImgColor, for: UIControl.State())
        slider.setThumbImage(thumbImgColor, for: .selected)
        slider.setThumbImage(thumbImgColor, for: .highlighted)
        
        slider.addTarget(self, action: #selector(sliderChange(_:)), for: .valueChanged)
    }
        
    func reloadColors() {
        slider.minimumTrackTintColor = readerConfig.tintColor
        slider.maximumTrackTintColor = folioReader.isNight(readerConfig.nightModeSeparatorColor, readerConfig.menuSeparatorColor)
    }
    

    func setSliderVal() {
        slider.value = Float(folioReader.readerCenter!.currentPageNumber)
    }
    
    func setMaximumVal() {
        slider.maximumValue = Float((folioReader.readerContainer?.book.spine.spineReferences.count)!)
    }
    
    @objc func sliderChange(_ slider:UISlider) {
        folioReader.readerCenter?.changePageWith(page: Int(slider.value),animated: true)
    }
    
    func toggleSlideView() {
        
        if folioReader.readerContainer?.shouldHideStatusBar == false {
            UIView.animate(withDuration: 0.6, animations: {
                self.slider.alpha = 0
            })
        } else {
            UIView.animate(withDuration: 0.6, animations: {
                self.slider.alpha = 1
            })
        }
    }

}


