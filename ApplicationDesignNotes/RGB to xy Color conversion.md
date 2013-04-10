#Application Design note - Color conversion##Color conversion formulas RGB to xy and backThis document describes the conversion between RGB and xy. It is important to differentiate between the various light types, because they do not all support the same color gamut. For example, the hue bulbs are very good at showing nice whites, while the LivingColors are generally a bit better at colors, like green and cyan.In the PHUtility class on our GitHub (https://github.com/PhilipsHue/PhilipsHueSDKiOS) you can see our objective-c implementation of these transformations, which is used in our iOS SDK for hue.The method signature for converting from xy values and brightness to a color is:    + (UIColor *)colorFromXY:(CGPoint)xy andBrightness:(float)brightness forModel:(NSString*)modelThe method signature for converting from a color to xy and brightness values:
    + (void)calculateXY:(CGPoint *)xy andBrightness:(float *)brightness fromColor:(UIColor *)color forModel:(NSString*)modelThe color to xy/brightness does not return a value, instead takes two pointers to variables which it will change to the appropriate values.The model parameter of both methods is the modelNumber value of a PHLight object. The advantage of this model being settable is that you can decide if you want to limit the color of all lights to a certain model, or that every light should do the colors within its own range.
Current Philips lights have a color gamut defined by 3 points, making it a triangle (see the above image).For the hue bulb the corners of the triangle are: 

    Red: 0.675, 0.322    Green: 0.4091, 0.518    Blue: 0.167, 0.04For LivingColors Bloom, Aura and Iris the triangle corners are: 

    Red: 0.704, 0.296    Green: 0.2151, 0.7106    Blue: 0.138, 0.08If you have light which is not one of those, you should use: 

    Red: 1.0, 0    Green: 0.0, 1.0    Blue: 0.0, 0.0
    ##Color to xyWe start with the color to xy conversion, which we will do in a couple of steps:1. Get the RGB values from your color object and convert them to be between 0 and 1.So the RGB color (255, 0, 100) becomes (1.0, 0.0, 0.39)2. Apply a gamma correction to the RGB values, which makes the color more vivid and more the like the color displayed on the screen of your device.This gamma correction is also applied to the screen of your computer or phone, thus we need this to create the same color on the light as on screen.This is done by the following formulas:		float red = (red > 0.04045f) ? pow((red + 0.055f) / (1.0f + 0.055f), 2.4f) : (red / 12.92f);
    	float green = (green > 0.04045f) ? pow((green + 0.055f) / (1.0f + 0.055f), 2.4f) : (green / 12.92f);
    	float blue = (blue > 0.04045f) ? pow((blue + 0.055f) / (1.0f + 0.055f), 2.4f) : (blue / 12.92f);
3. Convert the RGB values to XYZ using the Wide RGB D65 conversion formulaThe formulas used:		float X = red * 0.649926f + green * 0.103455f + blue * 0.197109f; 
    	float Y = red * 0.234327f + green * 0.743075f + blue * 0.022598f;
    	float Z = red * 0.0000000f + green * 0.053077f + blue * 1.035763f;
    4. Calculate the xy values from the XYZ values		float x = X / (X + Y + Z); float y = Y / (X + Y + Z);
    5. Check if the found xy value is within the color gamut of the light, if not continue with step 6, otherwise step 7When we sent a value which the light is not capable of, the resulting color might not be optimal. Therefor we try to only sent values which are inside the color gamut of the selected light.
6. Calculate the closest point on the color gamut triangle and use that as xy valueThe closest value is calculated by making a perpendicular line to one of the lines the triangle consists of and when it is then still not inside the triangle, we choose the closest corner point of the triangle.7. Use the Y value of XYZ as brightness
The Y value indicates the brightness of the converted color.##xy to colorThe xy to color conversion is almost the same, but in reverse order.
1. Check if the xy value is within the color gamut of the lamp, if not continue with step 2, otherwise step 3We do this to calculate the most accurate color the given light can actually do.2. Calculate the closest point on the color gamut triangle and use that as xy valueSee step 6 of color to xy.3. Calculate XYZ valuesConvert using the following formulas: 
		
		float x = x; // the given x value
    	float y = y; // the given y value
		float z = 1.0f - x - y; 
		float Y = brightness; // The given brightness value
    	float X = (Y / y) * x;  
		float Z = (Y / y) * z;
4. Convert to RGB using Wide RGB D65 conversion 
	
		float r = X * 1.612f - Y * 0.203f - Z * 0.302f;
    	float g = -X * 0.509f + Y * 1.412f + Z * 0.066f;
    	float b = X * 0.026f - Y * 0.072f + Z * 0.962f;
    5. Apply reverse gamma correction		r = r <= 0.0031308f ? 12.92f * r : (1.0f + 0.055f) * pow(r, (1.0f / 2.4f)) - 0.055f;
		g = g <= 0.0031308f ? 12.92f * g : (1.0f + 0.055f) * pow(g, (1.0f / 2.4f)) - 0.055f;
 		b = b <= 0.0031308f ? 12.92f * b : (1.0f + 0.055f) * pow(b, (1.0f / 2.4f)) - 0.055f;
 6. Convert the RGB values to your color objectThe rgb values from the above formulas are between 0.0 and 1.0.

Further Information
The following links provide further useful related information

sRGB:

http://en.wikipedia.org/wiki/Srgb  

A Review of RGB Color Spaces:
 
http://www.babelcolor.com/download/A%20review%20of%20RGB%20color%20spaces.pdf




