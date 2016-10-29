//
//  CustomLabel.swift
//  BountyHunter
//
//  Created by Infraestructura on 01/10/16.
//  Copyright © 2016 Infraestructura. All rights reserved.
//

import UIKit

class CustomLabel: UILabel {
    var size:CGFloat?
    
    override func drawRect(rect: CGRect) {
        self.font = UIFont(name: "Champagne&Limousines-Bold", size: Constantes.FUENTE_TITULOS)
        self.layer.backgroundColor = Constantes.COLOR_ETIQUETAS.CGColor
        self.layer.cornerRadius = rect.size.height / 3
        self.textColor = Constantes.COLOR_TEXTOS
        // invocamos el metodo de la super clase al final, para que cuando dibuje la etiqueta ya tenga todas las configuraciones
        super.drawRect(rect)
        
    }
}
