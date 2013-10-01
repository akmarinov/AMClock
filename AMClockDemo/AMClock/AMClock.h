//
//  AMClock.h
//  AMClock
//
//  Created by Andrey Marinov on 8/17/13.
//  Copyright (c) 2013 Andrey Marinov. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString *const AMClockUpdate;
UIKIT_EXTERN NSString *const AMClockStopped;
UIKIT_EXTERN NSString *const AMClockPaused;
UIKIT_EXTERN NSString *const AMClockResumed;


@interface AMClock : NSObject

+ (instancetype)sharedInstance;

- (void)resumeCountDown;
- (void)stopCountDown;
- (void)resetMainClockFromSeconds:(CGFloat)seconds;
- (void)startMainClockCountDownFromSeconds:(CGFloat) minutes;

- (NSInteger)currentRemainingSeconds;
- (BOOL)isTheClockRunning;

@end
