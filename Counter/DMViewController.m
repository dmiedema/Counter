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

@interface DMViewController ()

@property (nonatomic) NSUInteger lastTimeFromDefaults;
@property (nonatomic) NSUInteger lastCountFromDefaults;
@property (nonatomic) NSUInteger waitingBehind;
@property (nonatomic, strong) NSNumberFormatter *formatter;
@property (nonatomic, strong) NSString *groupingSeperator;
//@property (nonatomic, strong) NSUserDefaults *defaults;

@property (nonatomic, strong) UIImage *onStateImage;
@property (nonatomic, strong) UIImage *offStateImage;

//@property (nonatomic, strong) NSArray *countdownDoneMesages;

#define countdownDoneMessages @[@"You Made It!", @"You're in!", @"Wasn't THIS worth the wait?", @"Anticlimactic, huh?", @"You're awesome! Now go again", @"That was practice, lets go for reals now", @"Best 2 out of 3", @"HYPE HYPE HYPE HYPE HYPE",]

@end

@implementation DMViewController

int currentCount;
bool newCountDown = NO;
int waitingBehind;

/* Lets just do everything here, why not. */
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"messages %@", countdownDoneMessages);
    /* Notification Center Goodness */
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveCurrentState)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:[UIApplication sharedApplication]];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(removeAllObservers)
                                                 name:UIApplicationWillTerminateNotification
                                               object:[UIApplication sharedApplication]];
    /* Custom Button Stuff */
//    self.onStateImage = [self imageForSelector:@selector(drawOnState)];
//    self.offStateImage = [self imageForSelector:@selector(drawOffState)];
//    
//    [self.restartButton setBackgroundImage:self.onStateImage forState:UIControlStateNormal];
//    [self.restartButton setBackgroundImage:self.offStateImage forState:UIControlStateHighlighted];
    
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
    
    /* Load from User Defaults */    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"lastTime"] == nil)
        newCountDown = YES;
    
    NSLog(@"new countdown: %i", newCountDown);
    if (newCountDown) {
        currentCount = abs((int)arc4random() % (int)NSTimeIntervalSince1970);
        while (currentCount > 1000000) currentCount = abs((int)arc4random() % 1000000);
        waitingBehind = abs((int)arc4random() % 10000);
        newCountDown = YES;
    }
    /* Found something! Let's load it in. */
    if (!newCountDown) {
        NSString *newText = [self.formatter stringFromNumber:[NSNumber numberWithInt:[[NSUserDefaults standardUserDefaults] integerForKey:@"lastCount"]]];
        NSString *waitingText = [self.formatter stringFromNumber:[NSNumber numberWithInt:[[NSUserDefaults standardUserDefaults] integerForKey:@"waitingBehind"]]];
        [[self countdownLabel] setText:newText];
        [[self waitingBehindLabel] setText:waitingText];
        int diff = abs((int) (NSTimeIntervalSince1970 - [[NSUserDefaults standardUserDefaults] integerForKey:@"lastTime"]) % 125);
        NSLog(@"diff: %i", diff);
        currentCount = [[NSUserDefaults standardUserDefaults] integerForKey:@"lastCount"] - diff;
        currentCount = currentCount > 0 ? currentCount : 0;
        waitingBehind =[[NSUserDefaults standardUserDefaults] integerForKey:@"waitingBehind"] + diff/2;
        newText = [self.formatter stringFromNumber:[NSNumber numberWithInt:currentCount]];
        waitingText = [self.formatter stringFromNumber:[NSNumber numberWithInt:waitingBehind]];
        [[self countdownLabel] setText:newText];
        [[self waitingBehindLabel] setText:waitingText];
    }
    
    /* Setup timer */
    NSTimer *timer = [NSTimer timerWithTimeInterval:abs((int)arc4random() % 3) + 1
                                             target:self
                                           selector:@selector(runCountDown)
                                           userInfo:nil
                                            repeats:YES];
    
    /* Assign values to dynamic labels */
    NSString *newText = [self.formatter stringFromNumber:[NSNumber numberWithInt:currentCount]];
    NSString *waitingText = [self.formatter stringFromNumber:[NSNumber numberWithInt:waitingBehind]];
    [[self countdownLabel] setText:newText];
    [[self waitingBehindLabel] setText:waitingText];

    /* Loop-dee-loop */
    if (currentCount > 0) {
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }
    // We done.
}

- (void) runCountDown {
    int decrease = abs((int)arc4random() % 2) + 1;
    
    currentCount-=decrease;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
