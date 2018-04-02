import Foundation
import SpriteKit

public class Visualizations: SKScene{
    let width = 600
    let height = 600
    
    var number_of_points: Int!
    var file: String?
    
    // Centre of circle
    let constX = 300.0
    let constY = 300.0
    
    // List of points
    var points = [CGPoint]()
    var digitPoints = [CGPoint]()
    var frequency = [Int]()
    var drawFollowDistance = [Double]()
    var colors = [NSColor]()
    
    // Radius of circle
    let radius = 200.0
    let digit_radius = 280.0
    
    var followDistance = 0.001
    var numConnectedDigits = 500
    var numFreqDigits = 200
    
    var bgColor = NSColor.white
    
    // Scene
    var my_scene: SKScene!
    
    var number_string: String!
    
    override public init() {
        super.init(size: CGSize(width: 600, height: 600))
        print("Scene initialized")
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setBackgroundColor(color: NSColor){
        bgColor = color
        self.backgroundColor = color
    }
    
    public func setNumberOfDigits(n: Int){
        number_of_points = n
    }

    public func setNumberOfFreqDigits(n: Int){
        numFreqDigits = n
    }
    public func setFollowDistance(d: Double){
        followDistance = d
    }
    public func setNumberOfConnectedDigits(n: Int){
        numConnectedDigits = n
    }
    
    public func analyzeDigitsFrom(file: String){
        self.file = file
        let fileURL = Bundle.main.url(forResource: file, withExtension: "txt")
        do{
            number_string = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
            print("Current Digits: \(number_string!)")
        }catch{
            print("Error looking at digits")
        }
        calculatePoints()
        determineColors()
        generateDigits()
    }
    
    func calculatePoints(){
        for i in 0 ..< number_of_points{
            points.append(genPoint(radius: radius, index: Double(i), totalPoints: Double(number_of_points), constX: constX, constY: constY))
            digitPoints.append(genPoint(radius: digit_radius, index: Double(i), totalPoints: Double(number_of_points), constX: constX, constY: constY-5))
            frequency.append(0)
            drawFollowDistance.append(0.0)
        }
    }
    
    func determineColors(){
        let col_frequency = 5.0 / Double(number_of_points)
        
        for i in 0..<number_of_points{
            let r = CGFloat((sin(col_frequency * Double(i) + 0.0) * (127.0) + 128.0)/255.0)
            let g = CGFloat((sin(col_frequency * Double(i) + 1.0) * (127.0) + 128.0)/255.0)
            let b = CGFloat((sin(col_frequency * Double(i) + 3.0) * (127.0) + 128.0)/255.0)
            colors.append(NSColor(red: r, green: g, blue: b, alpha: 1))
        }
    }
    
    func genPoint(radius: Double, index: Double, totalPoints: Double, constX: Double, constY: Double) -> CGPoint{
        let x: CGFloat = CGFloat(radius*cos(index*2.0*Double.pi/totalPoints) + constX)
        let y: CGFloat = CGFloat(radius*sin(index*2.0*Double.pi/totalPoints) + constY)
        return CGPoint(x: x, y: y)
    }
    
    func genNextPoint(radius: Double, index: Double, totalPoints: Double, constX: Double, constY: Double, increment: Double) -> CGPoint{
        let x: CGFloat = CGFloat(radius*cos(index*2.0*Double.pi/totalPoints+increment) + constX)
        let y: CGFloat = CGFloat(radius*sin(index*2.0*Double.pi/totalPoints+increment) + constY)
        return CGPoint(x: x, y: y)
    }
    
    func generateDigits(){
        for i in 0 ..< number_of_points{
            let n = SKLabelNode()
            n.text = String(describing: i)
            n.horizontalAlignmentMode = .center
            n.fontName = ".SFUIText-Light"
            n.fontSize = 18
            n.fontColor = colors[i]
            n.position = digitPoints[i]
            self.addChild(n)
        }
    }
    
    public func visualizeFrequency(){
        DispatchQueue.global(qos: .background).async {
            for (index, char) in self.number_string.enumerated() {
                autoreleasepool{
                    if index < self.numFreqDigits{
                        if let value_index = Int(String(char)){
                            self.frequency[value_index] = self.frequency[value_index] + 1
                            let p = SKShapeNode(circleOfRadius: CGFloat(self.frequency[value_index]/2))
                            p.position = self.points[value_index]
                            p.strokeColor = self.colors[value_index]
                            p.fillColor = self.colors[value_index]
                            p.alpha = 0.6
//                            let fadeOut = SKAction.fadeAlpha(to: 0, duration: 3.0)
//                            p.run(fadeOut){
//                                p.removeFromParent()
//                            }
                            self.addChild(p)
                            usleep(500)
                        }
                    }
                }
            }
        }
    }
    
    public func visualizeConnectedDigits(){
        // Drawing Connections from one number to the next
        DispatchQueue.global(qos: .background).async {
            let number_string_chars = Array(self.number_string)
            var prevDigit = Int(String(number_string_chars[0]))!
        
            for (index, char) in self.number_string.enumerated() {
                if (index == 0){
                    continue
                }
                if index < self.numConnectedDigits{
                    autoreleasepool{
                    if let curDigit = Int(String(char)){
        //                frequency[value_index] = frequency[value_index] + 1
        
        //                print( drawFollowDistance[curDigit] )
        //                print( drawFollowDistance[prevDigit] )
                        let prevPoint = self.genNextPoint(radius: self.radius, index: Double(prevDigit), totalPoints: Double(self.number_of_points), constX: self.constX, constY: self.constY, increment: self.drawFollowDistance[prevDigit])
                        let curPoint = self.genNextPoint(radius: self.radius, index: Double(curDigit), totalPoints: Double(self.number_of_points), constX: self.constX, constY: self.constY, increment: self.drawFollowDistance[curDigit])
        
                        self.drawFollowDistance[curDigit] += self.followDistance
                        self.drawFollowDistance[prevDigit] += self.followDistance
        
                        let path = CGMutablePath()
                        path.move(to: prevPoint)
        //                path.addCurve(to: curPoint, control1: prevPoint, control2: prevPoint)
                        path.addLine(to: curPoint)
        
//                        prevPoint.x
        
                        let texture = SKTexture(color1: CIColor.init(color: self.colors[prevDigit])! , color2: CIColor.init(color: self.colors[curDigit])!, startPoint: prevPoint, endPoint: curPoint)
        
        
                        let shape = SKShapeNode()
                        shape.path = path
                        shape.lineWidth = 0.5
        //                shape.strokeColor = colors[prevDigit]
        //                shape.strokeColor = NSColor.white
                        shape.strokeTexture = texture
        
        //                let fadeOut = SKAction.fadeAlpha(to: 0, duration: 2)
        //                scene.run(fadeOut){
        //                    scene.removeFromParent()
        //                }
                        self.addChild(shape)
                        usleep(500)
                        prevDigit = curDigit
                        }
                    }
                }
            }
        }
    }
}
