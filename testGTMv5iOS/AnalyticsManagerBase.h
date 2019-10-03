//
//  AnalyticsManager.h
//  testGTMv5iOS
//
//  Created by Dmitry Klymenko on 27/6/19.
//  Copyright © 2019 Dmitry Klymenko. All rights reserved.
//
// This is the base class for the analytics tracking implementation. It can be extended to support additional analytics providers
//  or just be used for Firebase (and GA) related tracking.
// While it can be used as is in a generic way, i.e. call screenView: and logEventWithName: across your code hardcoding values
//  it could prove valuable if it is subclassed in each app/module and the ancestor implements application specific methods like
//  registrationButtonClicked or aboutScreenShown.
//  Class ancestor is also a good place to implement event routing between different analytics platforms

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnalyticsManagerBase : NSObject
{
    NSString *_lastScreenName;
    NSString *_lastScreenClass;
}


//Initialise analytics instance.
//Best place to call is application:(UIApplication *)applicatio didFinishLaunchingWithOptions
- (void)initializeAnalytics;

//send screenview. Instance parameter receives object which className will be automatically used for the event
- (void)screenView:(NSString* _Nonnull)name
          instance:(id _Nullable)instance;

//send screenview event using nil as a className
- (void)screenView:(NSString* _Nonnull)screenName;

//send screenview event manually specifying className
- (void)screenView:(NSString* _Nonnull)screenName
       screenClass:(NSString* _Nullable)className;


//send event to Firebase SDK without any custom parameters. Last known screenname and className will be added to a parameters list
- (void)logEventWithName:( NSString* _Nonnull)name;

//send event to Firebase SDK. Last known screenname and classname will be added to the parameter list
- (void)logEventWithName:(NSString* _Nonnull)name
           andParameters:(NSDictionary* _Nullable)params;

//set Firebase user property
- (void)setUserPropertyforName:(NSString* _Nonnull)name
                     withValue:(NSString*)value;


//send custom campaign information
- (void)registerCampaign:(NSString* _Nonnull)campaign
                  source:(NSString* _Nonnull)source
                  medium:(NSString* _Nonnull)medium;


//app delegates

- (void)appEnterForeground;

//https://firebase.google.com/docs/reference/ios/firebaseanalytics/api/reference/Classes/FIRAnalytics#/c:objc(cs)FIRAnalytics(cm)handleEventsForBackgroundURLSession:completionHandler:
- (void)handleEventsForBackgroundURLSession:(nonnull NSString *)identifier completionHandler: (nullable void (^)(void))completionHandler;

//https://firebase.google.com/docs/reference/ios/firebaseanalytics/api/reference/Classes/FIRAnalytics#/c:objc(cs)FIRAnalytics(cm)handleOpenURL:
- (void)handleOpenURL:(nonnull NSURL *)url;


//https://firebase.google.com/docs/reference/ios/firebaseanalytics/api/reference/Classes/FIRAnalytics#/c:objc(cs)FIRAnalytics(cm)handleUserActivity:
- (void)handleUserActivity:(nonnull id)userActivity;

@end

NS_ASSUME_NONNULL_END
