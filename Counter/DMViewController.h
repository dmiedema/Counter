//
//  DMViewController.h
//  Counter
//
//  Created by Daniel Miedema on 3/26/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

@interface DMViewController : UIViewController

@property (nonatomic) NSNumber *currentCount;
@property (nonatomic) NSNumber *currentWaiting;

@property (nonatomic, strong) IBOutlet UILabel *placeInLineTextLabel;
@property (nonatomic, strong) IBOutlet UILabel *waitingBehindTextLabel;

@property (nonatomic, strong) IBOutlet UILabel *countdownLabel;
@property (nonatomic, strong) IBOutlet UILabel *waitingBehindLabel;
@property (nonatomic, strong) IBOutlet UIButton *restartButton;

-(IBAction)restartButtonPressed:(UIButton*)sender;

-(void) saveCurrentState;
-(void) removeAllObservers;
@end
