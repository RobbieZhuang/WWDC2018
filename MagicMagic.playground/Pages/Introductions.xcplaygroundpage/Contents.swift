import PlaygroundSupport
import SpriteKit

let width = 600
let height = 600

let rect = NSRect(x: 0, y: 0, width: width, height: height)
let view = SKView(frame: rect)

//view.showsFPS = true
//view.showsNodeCount = true

let v = Visualizations()
v.setBackgroundColor(color: NSColor.white)

let number_of_points = 2

v.setNumberOfDigits(n: 10)
v.analyzeDigitsFrom(file: "pi")


//v.setNumberOfFreqDigits(n: 1000)
//v.visualizeFrequency()


v.setFollowDistance(d: 0.001)
v.setNumberOfConnectedDigits(n: 1000)
v.visualizeConnectedDigits()


view.presentScene(v)
PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = view

