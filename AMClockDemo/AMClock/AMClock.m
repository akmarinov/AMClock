//
//  AMClock.m
//  AMClock
//
//  Created by Andrey Marinov on 8/17/13.
//  Copyright (c) 2013 Andrey Marinov. All rights reserved.
//

#import "AMClock.h"
#import <QuartzCore/QuartzCore.h>

NSString *const AMClockUpdate = @"AMClockUpdate";
NSString *const AMClockStopped = @"AMClockStopped";
NSString *const AMClockPaused = @"AMClockPaused";
NSString *const AMClockResumed = @"AMClockResumed";

const NSInteger kSecondsInAMinute = 60;

static dispatch_queue_t notificationQueue;

@interface AMClock ()

@property (nonatomic, strong) CADisplayLink *countdownTimer;

@property (nonatomic, assign) NSInteger countdownTimeInSeconds;
@property (nonatomic, assign) CFTimeInterval remainingMainClockSeconds;
@property (nonatomic, assign) CFTimeInterval lastSystemTimeInSeconds;

@end

@implementation AMClock


#pragma mark - Singleton Implementation

static AMClock *sharedInstance;

- (id)init
{
    self = [super init];
    if (self) {
        self.countdownTimeInSeconds = 0;
        
        notificationQueue = dispatch_queue_create("Clock notification queue", DISPATCH_QUEUE_SERIAL);
        
        self.countdownTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTime:)];
        self.countdownTimer.frameInterval = 1.0f;
        self.countdownTimer.paused = YES;
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
        
        NSThread *timerThread = [[NSThread alloc] initWithTarget:sharedInstance selector:@selector(startTimerThread) object:nil];
        [timerThread start];
    });
    return sharedInstance;
}

-(void)startTimerThread
{
    @autoreleasepool {
        
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        
        [sharedInstance.countdownTimer addToRunLoop:runLoop forMode:NSRunLoopCommonModes];
        
        [runLoop run];
    }
}

#pragma mark - Time Update

- (void)updateTime:(CADisplayLink *) displayLink {
    dispatch_async(notificationQueue, ^{
        
        CFTimeInterval currentSystemTime = CACurrentMediaTime();
        CFTimeInterval deltaSeconds = currentSystemTime - self.lastSystemTimeInSeconds;
        self.lastSystemTimeInSeconds = currentSystemTime;
        
        [self updateMainClockWithSecondsDelta:deltaSeconds];
    });
}

#pragma mark - Main Clock Manipulation

- (void)startMainClockCountDownFromSeconds:(CGFloat)seconds {
    if (self.countdownTimeInSeconds == 0) {
        [self resetMainClockFromSeconds:seconds];
    }
    [self resumeCountDown];
}

- (void)resumeCountDown {
    if (self.countdownTimer.paused && self.countdownTimeInSeconds > 0) {
        self.lastSystemTimeInSeconds = CACurrentMediaTime();
        
        self.countdownTimer.paused = NO;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:AMClockResumed object:@(self.countdownTimeInSeconds)];
    }
}

- (void)stopCountDown {
    if (self.countdownTimeInSeconds != 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:AMClockPaused object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:AMClockStopped object:nil];
    }
    self.countdownTimer.paused = YES;
}

- (void)resetMainClockFromSeconds:(CGFloat)seconds {
    self.countdownTimeInSeconds = seconds;
    self.remainingMainClockSeconds = self.countdownTimeInSeconds;
    [[NSNotificationCenter defaultCenter] postNotificationName:AMClockUpdate object:@(self.countdownTimeInSeconds)];
}

- (void)updateMainClockWithSecondsDelta:(CFTimeInterval) deltaSeconds {
    if (!self.countdownTimer.paused) {
        self.remainingMainClockSeconds -= deltaSeconds;
        
        if (self.countdownTimeInSeconds > 0) {
            if (self.countdownTimeInSeconds != _remainingMainClockSeconds) {
                self.countdownTimeInSeconds = _remainingMainClockSeconds;
                
                if (self.countdownTimeInSeconds > 0) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:AMClockUpdate object:@(self.countdownTimeInSeconds)];
                }
            }
        } else {
            [self stopCountDown];
        }
    }
}

#pragma mark - Clock Metadata

- (BOOL)isTheClockRunning {
    return !self.countdownTimer.paused;
}

- (NSInteger)currentRemainingSeconds {
    return self.countdownTimeInSeconds;
}



@end
