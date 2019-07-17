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



#define ANALYTICS_USERPROPERTY_NAME_APPINSTANCEID @"custom_app_instance_id"
#define ANALYTICS_USERPROPERTY_NAME_FIREBASESUPPLIEDAPPINSTANCEID @"fb_app_instance_id"

#define ANALYTICS_PREFERENCE_KEY_APPINSTANCEID @"appinstanceid"




#import "AnalyticsManager.h"
@import Firebase;

@interface AnalyticsManagerBase(Private)

- (NSString*)customAppInstanceId;

- (BOOL)recordAppInstanceId:(NSString*)appInstanceId;
- (NSString*)readAppInstanceId;

//generates a random string. Up to 36 characters long
- (NSString*)generateCustomAppInstanceId;

@end


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
    
    //app generated app instance id
    NSString *customAppInstanceId = [self customAppInstanceId];
    
    [self setUserPropertyforName:ANALYTICS_USERPROPERTY_NAME_APPINSTANCEID
                       withValue:customAppInstanceId];
    
    //firebase generated app instance id
    [self setUserPropertyforName:ANALYTICS_USERPROPERTY_NAME_FIREBASESUPPLIEDAPPINSTANCEID
                       withValue:[FIRAnalytics appInstanceID]];
    
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
    _lastScreenName = screenName;
    _lastScreenClass = className;
    
   //Firebase set screenname - used for developers and debugging. Can be treated as screen type //https://firebase.google.com/docs/reference/ios/firebaseanalytics/api/reference/Classes/FIRAnalytics#/c:objc(cs)FIRAnalytics(cm)setScreenName:screenClass:
    [FIRAnalytics setScreenName:screenName screenClass:className];
    
    //Custom screen tracking
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
    
    //https://firebase.google.com/docs/reference/ios/firebaseanalytics/api/reference/Classes/FIRAnalytics#/c:objc(cs)FIRAnalytics(cm)logEventWithName:parameters:
    [FIRAnalytics logEventWithName:name parameters:paramsFull];
}

#pragma mark User Propety

- (void)setUserPropertyforName:(NSString* _Nonnull)name withValue:(NSString*)value {
    
    //https://firebase.google.com/docs/reference/ios/firebaseanalytics/api/reference/Classes/FIRAnalytics#/c:objc(cs)FIRAnalytics(cm)setUserPropertyString:forName:
    [FIRAnalytics setUserPropertyString:value forName:name];
}

#pragma mark delegates

- (void)handleEventsForBackgroundURLSession:(nonnull NSString *)identifier completionHandler: (nullable void (^)(void))completionHandler {
    //https://firebase.google.com/docs/reference/ios/firebaseanalytics/api/reference/Classes/FIRAnalytics#/c:objc(cs)FIRAnalytics(cm)handleEventsForBackgroundURLSession:completionHandler:
    [FIRAnalytics handleEventsForBackgroundURLSession:identifier
                                    completionHandler:completionHandler];
    
}


- (void)handleOpenURL:(nonnull NSURL *)url {
    //https://firebase.google.com/docs/reference/ios/firebaseanalytics/api/reference/Classes/FIRAnalytics#/c:objc(cs)FIRAnalytics(cm)handleOpenURL:
    [FIRAnalytics handleOpenURL:url];
    
}


- (void)handleUserActivity:(nonnull id)userActivity {
    //https://firebase.google.com/docs/reference/ios/firebaseanalytics/api/reference/Classes/FIRAnalytics#/c:objc(cs)FIRAnalytics(cm)handleUserActivity:
    [FIRAnalytics handleUserActivity:userActivity];
}


@end

@implementation AnalyticsManagerBase(Private)

- (NSString*)customAppInstanceId {
    __block NSString *appInstanceId = [self readAppInstanceId];
    
    if(appInstanceId == nil) {
        static dispatch_once_t onceTokenAppInstanceId;
        
        dispatch_once(&onceTokenAppInstanceId, ^{
            appInstanceId = [self generateCustomAppInstanceId];
        });
    }
    
    return appInstanceId;
}

- (BOOL)recordAppInstanceId:(NSString*)appInstanceId {
    //TODO: use external storage provider, don't hardcode user-defaults    BOOL ret = NO;
    
    //TODO: use external storage provider, don't hardcode user-defaults
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    [preferences setObject:appInstanceId forKey:ANALYTICS_PREFERENCE_KEY_APPINSTANCEID];

    BOOL ret = [preferences synchronize];

    return ret;
}

- (NSString*)readAppInstanceId {
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *currentLevelKey = @"currentlevel";
    
    NSString *ret = [preferences objectForKey:currentLevelKey];

    return ret;
}


//generates a random string. Up to 36 characters long
- (NSString*)generateCustomAppInstanceId {
    NSString *uuid = [[NSUUID UUID] UUIDString];
    
    NSString *ret = [NSString stringWithFormat:@"app%@",
                     [uuid stringByReplacingOccurrencesOfString:@"-" withString:@""]];
    
    return ret;
}

@end
