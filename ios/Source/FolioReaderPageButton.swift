//
//  FolioReaderPageButton.swift
//  epub_kitty
//
//  Created by N-155|User on 1/7/21.
//

import UIKit

class FolioReaderPageButton: UIButton {
    var isNext: Bool = false

    fileprivate var readerConfig: FolioReaderConfig
    fileprivate var folioReader: FolioReader
    

    init(frame: CGRect, readerConfig: FolioReaderConfig, folioReader: FolioReader, isNext: Bool) {
        self.readerConfig = readerConfig
        self.folioReader = folioReader
        self.isNext = isNext

        super.init(frame: frame)

        backgroundColor = .yellow//.clear
        if(isNext) {
            addTarget(self, action:#selector(self.nextButton), for: .touchUpInside)
        } else {
            addTarget(self, action:#selector(self.prevButton), for: .touchUpInside)
        }
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("storyboards are incompatible with truth and beauty")
    }
    
    @objc func nextButton() {
         //print("Button Clicked")
        folioReader.readerCenter?.changePageToNext()
    }
    
    @objc func prevButton() {
         //print("Button Clicked")
        folioReader.readerCenter?.changePageToPrevious()
    }
}

