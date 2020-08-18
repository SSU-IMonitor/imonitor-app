//
//  UIRoundPrimaryButton.swift
//  imonitor
//
//  Created by 허예은 on 2020/07/30.
//  Copyright © 2020 허예은. All rights reserved.
//

import Foundation
import UIKit

class UIRoundPrimaryButton: UIButton{
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        self.layer.cornerRadius = 5.0
        self.backgroundColor = UIColor(red: 93/255, green: 155/255, blue: 197/255, alpha: 1)
        self.tintColor = UIColor.white
    }
}
