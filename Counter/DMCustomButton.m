//
//  DMCustomButton.m
//  Counter
//
//  Created by Daniel Miedema on 3/27/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.
//

#import "DMCustomButton.h"

@implementation DMCustomButton

-(void) drawButtonHighlighted:(BOOL) isHighlighted {
    //// General Declarations
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (isHighlighted) {
        //// Color Declarations
        UIColor* fillColor = [UIColor colorWithRed: 0.333 green: 0.333 blue: 0.333 alpha: 1];
        UIColor* strokeColor = [UIColor colorWithRed: 0.833 green: 0.833 blue: 0.833 alpha: 1];
        
        //// Rounded Rectangle Drawing
        CGRect roundedRectangleRect = CGRectMake(50.5, 33.5, 115, 32);
        UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: roundedRectangleRect cornerRadius: 4];
        [fillColor setFill];
        [roundedRectanglePath fill];
        [strokeColor setStroke];
        roundedRectanglePath.lineWidth = 1;
        [roundedRectanglePath stroke];
        [strokeColor setFill];
        [@"Begin Again" drawInRect: roundedRectangleRect withFont: [UIFont fontWithName: @"Avenir-Medium" size: 16] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
        
    }
    else {        
        //// Color Declarations
        UIColor* fillColor = [UIColor colorWithRed: 0.833 green: 0.833 blue: 0.833 alpha: 1];
        UIColor* strokeColor = [UIColor colorWithRed: 0.167 green: 0.167 blue: 0.167 alpha: 1];
        UIColor* shadowColor2 = [UIColor colorWithRed: 0 green: 0 blue: 0 alpha: 1];
        
        //// Shadow Declarations
        UIColor* shadow = shadowColor2;
        CGSize shadowOffset = CGSizeMake(3.1, 3.1);
        CGFloat shadowBlurRadius = 5;
        
        //// Rounded Rectangle Drawing
        CGRect roundedRectangleRect = CGRectMake(50.5, 33.5, 115, 32);
        UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: roundedRectangleRect cornerRadius: 4];
        CGContextSaveGState(context);
        CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
        [fillColor setFill];
        [roundedRectanglePath fill];
        CGContextRestoreGState(context);
        
        [strokeColor setStroke];
        roundedRectanglePath.lineWidth = 1;
        [roundedRectanglePath stroke];
        [strokeColor setFill];
        [@"Begin Again" drawInRect: roundedRectangleRect withFont: [UIFont fontWithName: @"Avenir-Medium" size: 16] lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
    }
    
//    CGGradientRelease(buttonOutGradient);
//	CGGradientRelease(buttonGradient);
//	CGColorSpaceRelease(colorSpace);
}


- (void)drawOnState
{
    [self drawButtonHighlighted: YES];
}

- (void)drawOffState
{
    [self drawButtonHighlighted: NO];
}

@end
