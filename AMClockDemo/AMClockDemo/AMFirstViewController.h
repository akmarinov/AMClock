//
//  AMFirstViewController.h
//  AMClockDemo
//
//  Created by Andrey Marinov on 8/22/13.
//  Copyright (c) 2013 Andrey Marinov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMFirstViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *clockLabel;
@property (weak, nonatomic) IBOutlet UIStepper *timeStepper;
- (IBAction)startTimerButton:(UIButton *)sender;
- (IBAction)stopTimerButton:(UIButton *)sender;
- (IBAction)stepperChanged:(UIStepper *)sender;

@end
