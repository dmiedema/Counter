//
//  Background.m
//  The Flashlight
//
//  Created by Daniel Miedema on 11/18/12.
//  Copyright (c) 2012 ThisIsAnApp. All rights reserved.
//

#import "Background.h"

@implementation Background

//Metallic grey gradient background
+ (CAGradientLayer*) greyGradient {
    
    UIColor *colorOne       = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.15 alpha:1.0];
    UIColor *colorTwo       = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.25 alpha:1.0];
    UIColor *colorThree     = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.30 alpha:1.0];
    UIColor *colorFour      = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.25 alpha:1.0];
    UIColor *colorFive      = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.15 alpha:1.0];
    
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, colorFour.CGColor, colorFive.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:0.25];
    NSNumber *stopThree     = [NSNumber numberWithFloat:0.5];
    NSNumber *stopFour = [NSNumber numberWithFloat:0.75];
    NSNumber *stopFive = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, stopFour, stopFive, nil];
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}

//Blue gradient background
+ (CAGradientLayer*) blueGradient {
    
    // UIColor *colorOne = [UIColor colorWithRed:(120/255.0) green:(135/255.0) blue:(150/255.0) alpha:1.0];
    // UIColor *colorTwo = [UIColor colorWithRed:(57/255.0)  green:(79/255.0)  blue:(96/255.0)  alpha:1.0];
    
    UIColor *colorOne = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.1 alpha:1.0];
    UIColor *colorTwo = [UIColor colorWithHue:0.625 saturation:0.0 brightness:0.25 alpha:1.0];
    // UIColor *colorOne = [UIColor colorWithRed:(101.0) green:(101.0) blue:(101.0) alpha:1.0];
    // UIColor *colorTwo = [UIColor colorWithRed:(30.0) green:(30.0) blue:(30.0) alpha:1.0];
    
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
    
}

@end
