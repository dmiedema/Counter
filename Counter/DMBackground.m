//
//  DMBackground.m
//  Counter
//
//  Created by Daniel Miedema on 3/27/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.
//

#import "DMBackground.h"

@implementation DMBackground


- (CAGradientLayer*) greyGradient {
    UIColor *colorOne       = [UIColor colorWithHue:0 saturation:0.0 brightness:0.85 alpha:1.0];
    UIColor *colorTwo       = [UIColor colorWithHue:0 saturation:0.0 brightness:0.92 alpha:1.0];
    UIColor *colorThree     = [UIColor colorWithHue:0 saturation:0.0 brightness:0.99 alpha:1.0];
    UIColor *colorFour      = [UIColor colorWithHue:0 saturation:0.0 brightness:0.92 alpha:1.0];
    UIColor *colorFive      = [UIColor colorWithHue:0 saturation:0.0 brightness:0.85 alpha:1.0];
    
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, colorThree.CGColor, colorFour.CGColor, colorFive.CGColor, nil];
    
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:0.25];
    NSNumber *stopThree = [NSNumber numberWithFloat:0.5];
    NSNumber *stopFour = [NSNumber numberWithFloat:0.75];
    NSNumber *stopFive = [NSNumber numberWithFloat:1.0];
    
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, stopThree, stopFour, stopFive, nil];
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    
    return headerLayer;
}
@end
