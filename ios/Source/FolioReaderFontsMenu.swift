//
//  FolioReaderFontsMenu.swift
//  FolioReaderKit
//
//  Created by Heberti Almeida on 27/08/15.
//  Copyright (c) 2015 Folio Reader. All rights reserved.
//

import UIKit

public enum FolioReaderFont: Int {
    case andada = 0
    case lato
    case lora
    case raleway

    public static func folioReaderFont(fontName: String) -> FolioReaderFont? {
        var font: FolioReaderFont?
        switch fontName {
        case "andada": font = .andada
        case "lato": font = .lato
        case "lora": font = .lora
        case "raleway": font = .raleway
        default: break
        }
        return font
    }

    public var cssIdentifier: String {
        switch self {
        case .andada: return "andada"
        case .lato: return "lato"
        case .lora: return "lora"
        case .raleway: return "raleway"
        }
    }
}

public enum FolioReaderFontSize: Int {
    case xs = 0
    case s
    case m
    case l
    case xl

    public static func folioReaderFontSize(fontSizeStringRepresentation: String) -> FolioReaderFontSize? {
        var fontSize: FolioReaderFontSize?
        switch fontSizeStringRepresentation {
        case "textSizeOne": fontSize = .xs
        case "textSizeTwo": fontSize = .s
        case "textSizeThree": fontSize = .m
        case "textSizeFour": fontSize = .l
        case "textSizeFive": fontSize = .xl
        default: break
        }
        return fontSize
    }

    public var cssIdentifier: String {
        switch self {
        case .xs: return "textSizeOne"
        case .s: return "textSizeTwo"
        case .m: return "textSizeThree"
        case .l: return "textSizeFour"
        case .xl: return "textSizeFive"
        }
    }
}

class FolioReaderFontsMenu: UIViewController, SMSegmentViewDelegate, UIGestureRecognizerDelegate {
    var maskView: UIView!
    var menuView: UIView!
    
    var dayButton: UIButton!
    var darkButton: UIButton!
    var horizontalButton: UIButton!
    var verticalButton: UIButton!

    fileprivate var readerConfig: FolioReaderConfig
    fileprivate var folioReader: FolioReader

    init(folioReader: FolioReader, readerConfig: FolioReaderConfig) {
        self.readerConfig = readerConfig
        self.folioReader = folioReader

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MENU VIEW - HEIGHT
        var visibleHeight: CGFloat =
            self.readerConfig.canChangeScrollDirection ? 222 : 170
        visibleHeight = self.readerConfig.canChangeFontStyle ? visibleHeight : visibleHeight - 55
        

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.clear

        // Tap gesture
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FolioReaderFontsMenu.ignoreTapGesture))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        
        // MASK VIEW
        maskView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height-visibleHeight))
        maskView.backgroundColor = UIColor.clear
        maskView.layer.shadowOpacity = 0.3
        
        // Mask Tap gesture
        let maskTapGesture = UITapGestureRecognizer(target: self, action: #selector(FolioReaderFontsMenu.tapGesture))
        maskTapGesture.numberOfTapsRequired = 1
        maskTapGesture.delegate = self
        maskView.addGestureRecognizer(maskTapGesture)
        view.addSubview(maskView)
        
        // Menu view
        menuView = UIView(frame: CGRect(x: 0,
                                        y: view.frame.height-visibleHeight,
                                    width: view.frame.width,
                                    height: visibleHeight))
        
        menuView.backgroundColor = self.folioReader.isNight(self.readerConfig.nightModeMenuBackground, UIColor.white)
        menuView.autoresizingMask = .flexibleWidth
        menuView.layer.shadowColor = UIColor.black.cgColor
        menuView.layer.shadowOffset = CGSize(width: 0, height: 0)
        menuView.layer.shadowOpacity = 0.3
        menuView.layer.shadowRadius = 6
        menuView.layer.shadowPath = UIBezierPath(rect: menuView.bounds).cgPath
        menuView.layer.rasterizationScale = UIScreen.main.scale
        menuView.layer.shouldRasterize = true
        view.addSubview(menuView)
        
        // DARK/LIGHT MODE icons
        let normalColor = UIColor(white: 0.5, alpha: 0.7)
        let selectedColor = self.readerConfig.tintColor
        let sun = UIImage(readerImageNamed: "icon-sun")
        let moon = UIImage(readerImageNamed: "icon-moon")
        let sunNormal = sun?.imageTintColor(normalColor)?.withRenderingMode(.alwaysOriginal)
        let moonNormal = moon?.imageTintColor(normalColor)?.withRenderingMode(.alwaysOriginal)
        let sunSelected = sun?.imageTintColor(selectedColor)?.withRenderingMode(.alwaysOriginal)
        let moonSelected = moon?.imageTintColor(selectedColor)?.withRenderingMode(.alwaysOriginal)
        
        
        let fontSmall = UIImage(readerImageNamed: "icon-font-small")
        let fontBig = UIImage(readerImageNamed: "icon-font-big")
        let fontSmallNormal = fontSmall?.imageTintColor(normalColor)?.withRenderingMode(.alwaysOriginal)
        let fontBigNormal = fontBig?.imageTintColor(normalColor)?.withRenderingMode(.alwaysOriginal)
        
        dayButton = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width/2, height: 55))
        dayButton.setTitle("Day", for: .normal)
        dayButton.setTitleColor(self.folioReader.nightMode ? normalColor: selectedColor, for: .normal)
        dayButton.setImage(self.folioReader.nightMode ? sunNormal: sunSelected, for: .normal)
        dayButton.imageEdgeInsets.left = -20
        
        let daySelected = UITapGestureRecognizer(target: self,
                                                 action: #selector(FolioReaderFontsMenu.daySelectedGesture))
        daySelected.numberOfTapsRequired = 1
        daySelected.delegate = self
        dayButton.addGestureRecognizer(daySelected)
        
        menuView.addSubview(dayButton)
        
        darkButton = UIButton(frame: CGRect(x: view.frame.width/2, y: 0, width: view.frame.width/2, height: 55))
        darkButton.setTitle("Dark", for: .normal)
        darkButton.setTitleColor(self.folioReader.nightMode ? selectedColor: normalColor, for: .normal)
        darkButton.setImage(self.folioReader.nightMode ? moonSelected: moonNormal, for: .normal)
        darkButton.imageEdgeInsets.left = -20
        
        let darkSelected = UITapGestureRecognizer(target: self,
                                                 action: #selector(FolioReaderFontsMenu.darkSelectedGesture))
        darkSelected.numberOfTapsRequired = 1
        darkSelected.delegate = self
        darkButton.addGestureRecognizer(darkSelected)
        
        menuView.addSubview(darkButton)

        // Separator
        let line = UIView(frame: CGRect(x: 0, y: 56, width: view.frame.width, height: 1))
        line.backgroundColor = self.readerConfig.nightModeSeparatorColor
        menuView.addSubview(line)

        // Fonts adjust
        let fontNameHeight: CGFloat = self.readerConfig.canChangeFontStyle ? 55: 0
        let fontName = SMSegmentView(frame: CGRect(x: 15, y: line.frame.height+line.frame.origin.y, width: view.frame.width-30, height: fontNameHeight),
                                     separatorColour: UIColor.clear,
                                     separatorWidth: 0,
                                     segmentProperties:  [
                                        keySegmentOnSelectionColour: UIColor.clear,
                                        keySegmentOffSelectionColour: UIColor.clear,
                                        keySegmentOnSelectionTextColour: selectedColor,
                                        keySegmentOffSelectionTextColour: normalColor,
                                        keyContentVerticalMargin: 17 as AnyObject
            ])
        fontName.delegate = self
        fontName.tag = 2

        fontName.addSegmentWithTitle("Andada", onSelectionImage: nil, offSelectionImage: nil)
        fontName.addSegmentWithTitle("Lato", onSelectionImage: nil, offSelectionImage: nil)
        fontName.addSegmentWithTitle("Lora", onSelectionImage: nil, offSelectionImage: nil)
        fontName.addSegmentWithTitle("Raleway", onSelectionImage: nil, offSelectionImage: nil)

        fontName.selectSegmentAtIndex(self.folioReader.currentFont.rawValue)
        menuView.addSubview(fontName)

        // Separator 2
        let line2 = UIView(frame: CGRect(x: 0, y: fontName.frame.height+fontName.frame.origin.y, width: view.frame.width, height: 1))
        line2.backgroundColor = self.readerConfig.nightModeSeparatorColor
        menuView.addSubview(line2)

        // Font slider size
        let slider = HADiscreteSlider(frame: CGRect(x: 60, y: line2.frame.origin.y+2, width: view.frame.width-120, height: 55))
        slider.tickStyle = ComponentStyle.rounded
        slider.tickCount = 5
        slider.tickSize = CGSize(width: 8, height: 8)

        slider.thumbStyle = ComponentStyle.rounded
        slider.thumbSize = CGSize(width: 28, height: 28)
        slider.thumbShadowOffset = CGSize(width: 0, height: 2)
        slider.thumbShadowRadius = 3
        slider.thumbColor = selectedColor

        slider.backgroundColor = UIColor.clear
        slider.tintColor = self.readerConfig.nightModeSeparatorColor
        slider.minimumValue = 0
        slider.value = CGFloat(self.folioReader.currentFontSize.rawValue)
        slider.addTarget(self, action: #selector(FolioReaderFontsMenu.sliderValueChanged(_:)), for: UIControl.Event.valueChanged)

        // Force remove fill color
        slider.layer.sublayers?.forEach({ layer in
            layer.backgroundColor = UIColor.clear.cgColor
        })

        menuView.addSubview(slider)

        // Font icons
        let fontSmallView = UIImageView(frame: CGRect(x: 20, y: line2.frame.origin.y+14, width: 30, height: 30))
        fontSmallView.image = fontSmallNormal
        fontSmallView.contentMode = UIView.ContentMode.center
        menuView.addSubview(fontSmallView)

        let fontBigView = UIImageView(frame: CGRect(x: view.frame.width-50, y: line2.frame.origin.y+14, width: 30, height: 30))
        fontBigView.image = fontBigNormal
        fontBigView.contentMode = UIView.ContentMode.center
        menuView.addSubview(fontBigView)
        
        // Only continues if user can change scroll direction
        guard (self.readerConfig.canChangeScrollDirection == true) else {
            return
        }

        // Separator 3
        let line3 = UIView(frame: CGRect(x: 0, y: line2.frame.origin.y+56, width: view.frame.width, height: 1))
        line3.backgroundColor = self.readerConfig.nightModeSeparatorColor
        menuView.addSubview(line3)
        
        let vertical = UIImage(readerImageNamed: "icon-menu-vertical")
        let horizontal = UIImage(readerImageNamed: "icon-menu-horizontal")
        let verticalNormal = vertical?.imageTintColor(normalColor)?.withRenderingMode(.alwaysOriginal)
        let horizontalNormal = horizontal?.imageTintColor(normalColor)?.withRenderingMode(.alwaysOriginal)
        let verticalSelected = vertical?.imageTintColor(selectedColor)?.withRenderingMode(.alwaysOriginal)
        let horizontalSelected = horizontal?.imageTintColor(selectedColor)?.withRenderingMode(.alwaysOriginal)
        
        
        var scrollDirection = FolioReaderScrollDirection(rawValue: self.folioReader.currentScrollDirection)

        if scrollDirection == .defaultVertical && self.readerConfig.scrollDirection != .defaultVertical {
            scrollDirection = self.readerConfig.scrollDirection
        }

        
        
        verticalButton = UIButton(frame: CGRect(x: 0, y: line3.frame.origin.y, width: view.frame.width/2, height: 55))
        verticalButton.setTitle("Vertical", for: .normal)
        verticalButton.imageEdgeInsets.left = -20
        
        let vSelected = UITapGestureRecognizer(target: self,
                                               action: #selector(FolioReaderFontsMenu.verticalSelectedGesture))
        vSelected.numberOfTapsRequired = 1
        vSelected.delegate = self
        verticalButton.addGestureRecognizer(vSelected)
        menuView.addSubview(verticalButton)
        
        horizontalButton = UIButton(frame: CGRect(x: view.frame.width/2, y: line3.frame.origin.y, width: view.frame.width/2, height: 55))
        horizontalButton.setTitle("Horizontal", for: .normal)
        horizontalButton.imageEdgeInsets.left = -20
        
        let hSelected = UITapGestureRecognizer(target: self,
                                                 action: #selector(FolioReaderFontsMenu.horizontalSelectedGesture))
        hSelected.numberOfTapsRequired = 1
        hSelected.delegate = self
        horizontalButton.addGestureRecognizer(hSelected)
        
        switch scrollDirection ?? .vertical {
            case .vertical, .defaultVertical:
                horizontalButton.setImage(horizontalNormal, for: .normal)
                horizontalButton.setTitleColor(normalColor, for: .normal)
                verticalButton.setImage(verticalSelected, for: .normal)
                verticalButton.setTitleColor(selectedColor, for: .normal)
                break
            case .horizontal, .horizontalWithVerticalContent:
                horizontalButton.setImage(horizontalSelected, for: .normal)
                horizontalButton.setTitleColor(selectedColor, for: .normal)
                verticalButton.setImage(verticalNormal, for: .normal)
                verticalButton.setTitleColor(normalColor, for: .normal)
                break
        }
        
        menuView.addSubview(horizontalButton)
    }

    // MARK: - SMSegmentView delegate

    func segmentView(_ segmentView: SMSegmentView, didSelectSegmentAtIndex index: Int) {
        guard (self.folioReader.readerCenter?.currentPage) != nil else { return }
        
        if segmentView.tag == 2 {
            self.folioReader.currentFont = FolioReaderFont(rawValue: index)!
        }
    }
    
    @objc func horizontalSelectedGesture() {
        let normalColor = UIColor(white: 0.5, alpha: 0.7)
        let selectedColor = self.readerConfig.tintColor
        let vertical = UIImage(readerImageNamed: "icon-menu-vertical")
        let horizontal = UIImage(readerImageNamed: "icon-menu-horizontal")
        let verticalNormal = vertical?.imageTintColor(normalColor)?.withRenderingMode(.alwaysOriginal)
        let horizontalSelected = horizontal?.imageTintColor(selectedColor)?.withRenderingMode(.alwaysOriginal)
        
        horizontalButton.setImage(horizontalSelected, for: .normal)
        horizontalButton.setTitleColor(selectedColor, for: .normal)
        verticalButton.setImage(verticalNormal, for: .normal)
        verticalButton.setTitleColor(normalColor, for: .normal)

        self.folioReader.currentScrollDirection = 1
    }
    
    @objc func verticalSelectedGesture() {
        let normalColor = UIColor(white: 0.5, alpha: 0.7)
        let selectedColor = self.readerConfig.tintColor
        let vertical = UIImage(readerImageNamed: "icon-menu-vertical")
        let horizontal = UIImage(readerImageNamed: "icon-menu-horizontal")
        let horizontalNormal = horizontal?.imageTintColor(normalColor)?.withRenderingMode(.alwaysOriginal)
        let verticalSelected = vertical?.imageTintColor(selectedColor)?.withRenderingMode(.alwaysOriginal)
        
        horizontalButton.setImage(horizontalNormal, for: .normal)
        horizontalButton.setTitleColor(normalColor, for: .normal)
        verticalButton.setImage(verticalSelected, for: .normal)
        verticalButton.setTitleColor(selectedColor, for: .normal)

        self.folioReader.currentScrollDirection = 0
    }
    
    @objc func daySelectedGesture() {
        let normalColor = UIColor(white: 0.5, alpha: 0.7)
        let selectedColor = self.readerConfig.tintColor
        let sun = UIImage(readerImageNamed: "icon-sun")
        let moon = UIImage(readerImageNamed: "icon-moon")
        let moonNormal = moon?.imageTintColor(normalColor)?.withRenderingMode(.alwaysOriginal)
        let sunSelected = sun?.imageTintColor(selectedColor)?.withRenderingMode(.alwaysOriginal)
        
        self.folioReader.nightMode = false
        
        dayButton.setImage(sunSelected, for: .normal)
        dayButton.setTitleColor(selectedColor, for: .normal)
        darkButton.setImage(moonNormal, for: .normal)
        darkButton.setTitleColor(normalColor, for: .normal)

        UIView.animate(withDuration: 0.6, animations: {
            self.menuView.backgroundColor = self.readerConfig.daysModeNavBackground
        })
    }
    
    @objc func darkSelectedGesture() {
        let normalColor = UIColor(white: 0.5, alpha: 0.7)
        let selectedColor = self.readerConfig.tintColor
        let sun = UIImage(readerImageNamed: "icon-sun")
        let moon = UIImage(readerImageNamed: "icon-moon")
        let sunNormal = sun?.imageTintColor(normalColor)?.withRenderingMode(.alwaysOriginal)
        let moonSelected = moon?.imageTintColor(selectedColor)?.withRenderingMode(.alwaysOriginal)
        
        self.folioReader.nightMode = true
        
        dayButton.setImage(sunNormal, for: .normal)
        dayButton.setTitleColor(normalColor, for: .normal)
        darkButton.setImage(moonSelected, for: .normal)
        darkButton.setTitleColor(selectedColor, for: .normal)

        UIView.animate(withDuration: 0.6, animations: {
            self.menuView.backgroundColor = self.readerConfig.nightModeBackground
        })
    }
    
    // MARK: - Font slider changed
    
    @objc func sliderValueChanged(_ sender: HADiscreteSlider) {
        guard
            (self.folioReader.readerCenter?.currentPage != nil),
            let fontSize = FolioReaderFontSize(rawValue: Int(sender.value)) else {
                return
        }
        
        self.folioReader.currentFontSize = fontSize
    }
    
    // MARK: - Gestures
    @objc func ignoreTapGesture() {
        debugPrint("ignoreTapGesture")
    }
    
    @objc func tapGesture() {
        dismiss()
        
        if (self.readerConfig.shouldHideNavigationOnTap == false) {
            self.folioReader.readerCenter?.showBars()
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer && ((touch.view?.isKind(of: SMSegment.self)) == true) {
            return false
        }
        
        if gestureRecognizer is UITapGestureRecognizer && touch.view == menuView {
            return false
        }
        
        if gestureRecognizer is UITapGestureRecognizer && touch.view == view {
            return false
        }
        
        return true
    }
    
    // MARK: - Status Bar
    
    override var prefersStatusBarHidden : Bool {
        return (self.readerConfig.shouldHideNavigationOnTap == true)
    }
}
