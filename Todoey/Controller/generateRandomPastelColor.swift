import UIKit

// Adapted from Stack Overflow answer by David Crow http://stackoverflow.com/a/43235
// Question: Algorithm to randomly generate an aesthetically-pleasing color palette by Brian Gianforcaro
// Method randomly generates a pastel color, and optionally mixes it with another color
func generateRandomPastelColor(withMixedColor mixColor: UIColor?) -> UIColor {
	// Randomly generate number in closure
	let randomColorGenerator = { ()-> CGFloat in
		CGFloat(arc4random() % 256 ) / 256
	}
		
	var red: CGFloat = randomColorGenerator()
	var green: CGFloat = randomColorGenerator()
	var blue: CGFloat = randomColorGenerator()
		
	// Mix the color
	if let mixColor = mixColor {
		var mixRed: CGFloat = 0, mixGreen: CGFloat = 0, mixBlue: CGFloat = 0;
		mixColor.getRed(&mixRed, green: &mixGreen, blue: &mixBlue, alpha: nil)
		
		red = (red + mixRed) / 2;
		green = (green + mixGreen) / 2;
		blue = (blue + mixBlue) / 2;
	}
		
	return UIColor(red: red, green: green, blue: blue, alpha: 1)
}
