//
//  AMFirstViewController.m
//  AMClockDemo
//
//  Created by Andrey Marinov on 8/22/13.
//  Copyright (c) 2013 Andrey Marinov. All rights reserved.
//

#import "AMFirstViewController.h"
#import "AMClock.h"

@interface AMFirstViewController ()

@end

@implementation AMFirstViewController

- (NSString *)timeStringFromSeconds:(NSInteger) seconds {
    NSInteger mins = (seconds % 3600) / 60;
    NSInteger secs = seconds % 60;
    
    if (secs < 0) {
        return @"";
    }
    
    return [NSString stringWithFormat:@"%02d:%02d", mins, secs];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserverForName:AMClockUpdate object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        self.clockLabel.text = [self timeStringFromSeconds:[note.object integerValue]];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startTimerButton:(UIButton *)sender {
    [[AMClock sharedInstance] startMainClockCountDownFromSeconds:self.timeStepper.value * 60.0f];
}

- (IBAction)stopTimerButton:(UIButton *)sender {
    [[AMClock sharedInstance] stopCountDown];
}

- (IBAction)stepperChanged:(UIStepper *)sender {
    self.clockLabel.text = [NSString stringWithFormat:@"%d", (NSInteger)sender.value];
}
@end
