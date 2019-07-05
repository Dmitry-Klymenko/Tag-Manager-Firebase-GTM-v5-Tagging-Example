//
//  AnalyticsManager.m
//  testGTMv5iOS
//
//  Created by Dmitry Klymenko on 27/6/19.
//  Copyright © 2019 Dmitry Klymenko. All rights reserved.
//

#define ANALYTICS_EVENT_SCREENVIEW              @"screenview"

#define ANALYTICS_EVENT_PARAMETER_SCREENNAME    @"screenname"
#define ANALYTICS_EVENT_PARAMETER_SCREENCLASS   @"screenclass"

#define ANALYTICS_DEFAULT_VALUE_LASTSCREENNAME  @"not_defined_yet"
#define ANALYTICS_DEFAULT_VALUE_LASTSCREENCLASS @"not_defined_yet"


#import "AnalyticsManager.h"
@import Firebase;


@implementation AnalyticsManagerBase

#pragma mark singletons

+ (instancetype)instance {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
    
}

- (instancetype)init {
    if(self = [super init]) {
        
        _lastScreenName = ANALYTICS_DEFAULT_VALUE_LASTSCREENNAME;
        _lastScreenClass = ANALYTICS_DEFAULT_VALUE_LASTSCREENCLASS;
        
    }
    return self;
}



#pragma mark Business Logic

- (void)initializeAnalytics {
    //if firebase sdk enabled
    [FIRApp configure];
}



#pragma mark Screenview

- (void)screenView:(NSString* _Nonnull)name
          instance:(id _Nullable)instance {
    
    [self screenView:name
         screenClass:NSStringFromClass([instance class])];
    
    //non-FB analytics calls
    //...
}

- (void)screenView:(NSString* _Nonnull)screenName {
    [self screenView:screenName screenClass:@"not set"];
}

- (void)screenView:(NSString* _Nonnull)screenName
       screenClass:(NSString* _Nullable)className {
    //NSLog(@"Logging screenview: %@", screenname);
    _lastScreenName = screenName;
    _lastScreenClass = className;
    
    [FIRAnalytics setScreenName:screenName screenClass:className];
    [self logEventWithName:ANALYTICS_EVENT_SCREENVIEW andParameters:nil];
}

- (void)logEventWithName:(NSString* _Nonnull)name {
    [self logEventWithName:name andParameters:nil];
}

- (void)logEventWithName:(NSString* _Nonnull)name
           andParameters:(NSDictionary* _Nullable)params {
    
    //add last screenname to the NSDictionary
    NSMutableDictionary *paramsFull = [NSMutableDictionary dictionaryWithDictionary:(params ? params : @{})];
    
    if([_lastScreenName isEqualToString:ANALYTICS_DEFAULT_VALUE_LASTSCREENNAME] == NO)
        [paramsFull setObject:_lastScreenName forKey:ANALYTICS_EVENT_PARAMETER_SCREENNAME];
    
    if([_lastScreenClass isEqualToString:ANALYTICS_DEFAULT_VALUE_LASTSCREENCLASS] == NO)
        [paramsFull setObject:_lastScreenClass forKey:ANALYTICS_EVENT_PARAMETER_SCREENCLASS];
    
    [FIRAnalytics logEventWithName:name parameters:paramsFull];
}

@end
