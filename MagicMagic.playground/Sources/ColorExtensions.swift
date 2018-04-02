
//
//  SKTextureGradient.swift
//  Linear gradient texture
//  Based on: https://gist.github.com/Tantas/7fc01803d6b559da48d6, https://gist.github.com/craiggrummitt/ad855e358004b5480960
//
//  Created by Maxim on 1/1/16.
//  Copyright © 2016 Maxim Bilan. All rights reserved.
//
import SpriteKit


public extension SKTexture {
    
    convenience init(color1: CIColor, color2: CIColor, startPoint: CGPoint, endPoint: CGPoint) {
        
        let size = CGSize(width: abs(startPoint.x-endPoint.x+1), height: abs(startPoint.y-endPoint.y+1))
        let context = CIContext(options: nil)
        let filter = CIFilter(name: "CILinearGradient")
        var startVector: CIVector
        var endVector: CIVector
        
        filter!.setDefaults()
        
        startVector = CIVector(x: startPoint.x, y: startPoint.y)
        endVector = CIVector(x: endPoint.x, y: endPoint.y)
//        print("Memes")
//        print(startVector)
//        print(endVector)
//
        filter!.setValue(startVector, forKey: "inputPoint0")
        filter!.setValue(endVector, forKey: "inputPoint1")
        filter!.setValue(color1, forKey: "inputColor0")
        filter!.setValue(color2, forKey: "inputColor1")
        
        let image = context.createCGImage(filter!.outputImage!, from: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        self.init(cgImage: image!)
    }
}
