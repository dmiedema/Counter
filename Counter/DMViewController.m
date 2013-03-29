//
//  DMViewController.m
//  Counter
//
//  Created by Daniel Miedema on 3/26/13.
//  Copyright (c) 2013 Daniel Miedema. All rights reserved.
//

#import "DMViewController.h"
#import "DMAppDelegate.h"
#import "DMBackground.h"
#include <stdlib.h>
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>
#import "RNBlurModalView.h"


@interface DMViewController ()

@property (nonatomic) NSUInteger lastTimeFromDefaults;
@property (nonatomic) NSUInteger lastCountFromDefaults;
@property (nonatomic) NSUInteger waitingBehind;
@property (nonatomic, strong) NSNumberFormatter *formatter;
@property (nonatomic, strong) NSString *groupingSeperator;
//@property (nonatomic, strong) NSUserDefaults *defaults;

@property (nonatomic, strong) UIImage *onStateImage;
@property (nonatomic, strong) UIImage *offStateImage;

@property (nonatomic, strong) NSTimer *timer;
//@property (nonatomic, strong) NSArray *countdownDoneMesages;

#define countdownDoneMessages @[@"You Made It!", @"You're in!", @"Wasn't THIS worth the wait?", @"Anticlimactic, huh?", @"You're awesome! Now go again", @"That was practice, lets go for real now", @"Best 2 out of 3", @"HYPE HYPE HYPE HYPE HYPE",]

- (void) initializeView;
@end

@implementation DMViewController

int currentCount;
bool newCountDown = NO;
int waitingBehind;

/* Lets just do everything here, why not. */
- (void)viewDidLoad
{
    [super viewDidLoad];    
    /* Notification Center Goodness */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveCurrentState)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeAllObservers)
                                                 name:UIApplicationWillTerminateNotification
                                               object:[UIApplication sharedApplication]];
    
    /* Background stuff */
    DMBackground *background = [[DMBackground alloc] init];
    CAGradientLayer *bgLayer = [background greyGradient];
    bgLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:bgLayer atIndex:0];
    
    /* Setup label properties */
    [[self waitingBehindTextLabel] setFont:[UIFont fontWithName:@"Avenir" size:24.0]];
    [[self waitingBehindTextLabel] setTextAlignment:NSTextAlignmentCenter];
    [[self placeInLineTextLabel] setFont:[UIFont fontWithName:@"Avenir" size:30.0]];
    [[self placeInLineTextLabel] setTextAlignment:NSTextAlignmentCenter];
    [[self countdownLabel] setFont:[UIFont fontWithName:@"Avenir" size:64.0]];
    [[self countdownLabel] setTextAlignment:NSTextAlignmentCenter];
    [[self waitingBehindLabel] setFont:[UIFont fontWithName:@"Avenir" size:40.0]];
    [[self waitingBehindLabel] setTextAlignment:NSTextAlignmentCenter];
    
    /* Setup static text label text */
    [[self waitingBehindTextLabel] setText:@"People behind you"];
    [[self placeInLineTextLabel] setText:@"Your place in line"];
    
    /* Set up formatter */
    self.formatter = [[NSNumberFormatter alloc] init];
    self.groupingSeperator = [[NSLocale currentLocale]objectForKey:NSLocaleGroupingSeparator];
    [self.formatter setGroupingSeparator:self.groupingSeperator];
    [self.formatter setGroupingSize:3];
    [self.formatter setAlwaysShowsDecimalSeparator:NO];
    [self.formatter setUsesGroupingSeparator:YES];

    /* Initialize the view. And its in a method. Because its ugly long. */
    [self initializeView];
    // We done.
}

- (void) initializeView {
    /* Hide the button */
    [[self restartButton] setHidden:YES];
    
    /* Load from User Defaults */
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"lastTime"] == nil)
        newCountDown = YES;
    
    if (newCountDown) {
        currentCount = abs((int)arc4random() % (int)NSTimeIntervalSince1970);
        while (currentCount > 10891) currentCount = abs((int)arc4random() % 10891);
        waitingBehind = abs((int)arc4random() % 10891);
        newCountDown = YES;
    }
    /* Found something! Let's load it in. */
    if (!newCountDown) {
        NSString *newText = [self.formatter stringFromNumber:[NSNumber numberWithInt:[[NSUserDefaults standardUserDefaults] integerForKey:@"lastCount"]]];
        NSString *waitingText = [self.formatter stringFromNumber:[NSNumber numberWithInt:[[NSUserDefaults standardUserDefaults] integerForKey:@"waitingBehind"]]];
        [[self countdownLabel] setText:newText];
        [[self waitingBehindLabel] setText:waitingText];
        int diff = abs((int) arc4random() % 127);
        currentCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"lastCount"] - diff;
        currentCount = currentCount > 0 ? currentCount : 0;
        waitingBehind =[[NSUserDefaults standardUserDefaults] integerForKey:@"waitingBehind"] + diff/2;
        newText = [self.formatter stringFromNumber:[NSNumber numberWithInt:currentCount]];
        waitingText = [self.formatter stringFromNumber:[NSNumber numberWithInt:waitingBehind]];
        [[self countdownLabel] setText:newText];
        [[self waitingBehindLabel] setText:waitingText];
    }
    
    /* Setup timer */
    self.timer = [NSTimer timerWithTimeInterval:abs((int)arc4random() % 3) + 1
                                             target:self
                                           selector:@selector(runCountDown)
                                           userInfo:nil
                                            repeats:(currentCount > 1)];
    
    /* Assign values to dynamic labels */
    NSString *newText = [self.formatter stringFromNumber:[NSNumber numberWithInt:currentCount]];
    NSString *waitingText = [self.formatter stringFromNumber:[NSNumber numberWithInt:waitingBehind]];
    [[self countdownLabel] setText:newText];
    [[self waitingBehindLabel] setText:waitingText];
    
    /* Loop-dee-loop */
    if (currentCount > 0) {
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void) runCountDown {
    int decrease = abs((int)arc4random() % 2) + 1;
    currentCount-=decrease;
    
    if (currentCount <= 0) {
        currentCount = 0;
        NSString *message = [NSString string];
        message = [countdownDoneMessages objectAtIndex:(arc4random() % [countdownDoneMessages count])];
        RNBlurModalView *modal = [[RNBlurModalView alloc] initWithParentView: [self view]
                                                                       title: @"Your countdown is done!"
                                                                     message: message];
        [modal show];
        [self.timer invalidate];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[self restartButton] setHidden:NO]; //works
        });
    }
    
    if (abs((int)arc4random()) % 2 == 1) waitingBehind++;
    NSString *newText = [self.formatter stringFromNumber:[NSNumber numberWithInt:currentCount]];
    NSString *waitingText = [self.formatter stringFromNumber:[NSNumber numberWithInt:waitingBehind]];
    [[self countdownLabel] setText:newText];
    [[self waitingBehindLabel] setText:waitingText];
}

-(void) saveCurrentState {
    /* Remove all current values from defaults */
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastCount"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"waitingBehind"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastTime"];
    /* Write new values to defaults because I can. And I need to */
    [[NSUserDefaults standardUserDefaults] setInteger:currentCount forKey:@"lastCount"];
    [[NSUserDefaults standardUserDefaults] setInteger:waitingBehind forKey:@"waitingBehind"];
    [[NSUserDefaults standardUserDefaults] setInteger:NSTimeIntervalSince1970 forKey:@"lastTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void) removeAllObservers {
    /* BAIL OUT. Not really, just remove myself as an observer so nothing blows up */
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(IBAction)restartButtonPressed:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastTime"];
    [self initializeView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
