//
//  CustomTextField.swift
//  BountyHunter
//
//  Created by Infraestructura on 01/10/16.
//  Copyright © 2016 Infraestructura. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {


    override func drawRect(rect: CGRect) {
        // Color de fondo negro
        self.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        self.layer.backgroundColor = UIColor.blackColor().CGColor
        // Color de texto blanco
        self.textColor = UIColor.whiteColor()
        //Fuente del texto "Ch&L" 18 px
        self.font = UIFont(name: "Champagne&Limousines", size: 18.0)
        // Esquinas redondeadas
        self.layer.cornerRadius = rect.size.height / 4
        super.drawRect(rect)
        // Fuente del placeholder "Ch&L-Bold" 18px
        let atributos = [NSForegroundColorAttributeName: UIColor.lightGrayColor(),
                         NSFontAttributeName: UIFont(name: "Champagne&Limousines-Bold", size: 18.0)!]
        var placeholderOriginal = self.placeholder
        if placeholderOriginal == nil {
            placeholderOriginal = ""
        }
        self.attributedPlaceholder = NSAttributedString(string:placeholderOriginal!, attributes: atributos)
    }
 
}
