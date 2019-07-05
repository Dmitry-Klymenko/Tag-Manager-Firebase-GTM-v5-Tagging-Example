//
//  AnalyticsManager.m
//  testGTMv5iOS
//
//  Created by Dmitry Klymenko on 27/6/19.
//  Copyright © 2019 Dmitry Klymenko. All rights reserved.
//


#import "AnalyticsManager.h"

@implementation AnalyticsManager

+ (instancetype)instance {
    static AnalyticsManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AnalyticsManager alloc] init];
    });
    
    return sharedInstance;
}


#pragma mark Business Logic




- (void)mainScreenViewWithInstance:(_Nonnull id)instance {
    
    [self screenView:ANALYTICS_SCREENNAME_MAINWINDOW instance:instance];
    
}

- (void)mainButtonClicked {
    
    [self logEventWithName:ANALYTICS_EVENTNAME_INTERACTION
             andParameters:@{ANALYTICS_PARAMETER_ACTION: ANALYTICS_ACTION_CLICK}
    ];
    
}


@end
