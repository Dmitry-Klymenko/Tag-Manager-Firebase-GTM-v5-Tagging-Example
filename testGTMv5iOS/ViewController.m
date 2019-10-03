//
//  ViewController.m
//  testGTMv5iOS
//
//  Created by Dmitry Klymenko on 27/6/19.
//  Copyright © 2019 Dmitry Klymenko. All rights reserved.
//

#import "ViewController.h"
#import "AnalyticsManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    [[AnalyticsManager instance] registerCampaign:@"campaign21" source:@"source21" medium:@"medium21"];
    
    //Analytics
    [[AnalyticsManager instance] mainScreenViewWithInstance:self];
}

- (IBAction)btnSendEvent:(id)sender {
    
    
    [[AnalyticsManager instance] mainButtonClicked];
}

@end
