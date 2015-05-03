//
//  UIXibView.swift
//  mokojin
//
//  Created by Yonatan Bergman on 3/24/15.
//  Copyright (c) 2015 iicninjas. All rights reserved.
//

// Shamelessly copied from Tekken Time to simplify the creation of Views from Xibs.

import Foundation

class UIXibView : UIView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadXib()
    }
    
    // Subclasses should override this method to provide any custom setup
    func setup() {}
    
    private func loadXib() {
        let _customView = loadNib()
        _customView.frame = self.bounds
        _customView.autoresizingMask = .FlexibleHeight | .FlexibleWidth
        self.addSubview(_customView)
        setup()
    }
    
    private func className() -> String {
        let fullClassName = NSStringFromClass(self.dynamicType)
        return split(fullClassName) {$0 == "."}.last!
    }
    
    private func loadNib() -> UIView {
        return NSBundle(forClass: self.dynamicType).loadNibNamed(className(), owner: self, options: nil).first as! UIView
    }
}