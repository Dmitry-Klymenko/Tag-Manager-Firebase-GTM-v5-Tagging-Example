//
//  AnalyticsManager.h
//  testGTMv5iOS
//
//  Created by Dmitry Klymenko on 27/6/19.
//  Copyright © 2019 Dmitry Klymenko. All rights reserved.
//


#define ANALYTICS_SCREENNAME_MAINWINDOW @"Main Window"

#define ANALYTICS_EVENTNAME_INTERACTION @"interaction"

#define ANALYTICS_PARAMETER_ACTION @"action"

#define ANALYTICS_ACTION_CLICK @"click"


#import "AnalyticsManagerBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnalyticsManager : AnalyticsManagerBase

+ (AnalyticsManager*)instance;

- (void)mainScreenViewWithInstance:(_Nonnull id)instance;

- (void)mainButtonClicked;

@end

NS_ASSUME_NONNULL_END
