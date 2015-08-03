//
//  TutorialHandler.m
//  MTR Next Train
//
//  Created by  on 12年2月29日.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TutorialHandler.h"

@implementation TutorialHandler

#pragma mark - Logic

+(BOOL)shouldShowTutorialForViewController:(id)viewController
{
    if (viewController == nil)
    {
        return NO;
    }
    
    NSString *tutorialName = NSStringFromClass([viewController class]);
    
    if ([[SQLiteOperator sharedOperator] hasRecordInReadTutorialWithName:tutorialName appVersion:[CoreData sharedCoreData].app_version])
    {
        return NO;
    }
    
    return YES;
}

+(void)didReadTutorialForViewController:(id)viewController
{
    if (viewController == nil)
    {
        return;
    }
    
    NSString *tutorialName = NSStringFromClass([viewController class]);
    
    [[SQLiteOperator sharedOperator] insertRecordToReadTutorialWithName:tutorialName appVersion:[CoreData sharedCoreData].app_version language:[CoreData sharedCoreData].lang];
}

#pragma mark - UI

+(TutorialViewController*)showTutorialViewControllerForViewController:(id)viewController inView:(UIView*)view
{
    TutorialViewController *tutorial = [[[TutorialViewController alloc] initWithNibName:@"TutorialViewController" bundle:nil] autorelease];
    tutorial.parent = viewController;
    CGRect tutorialFrame = tutorial.view.frame;
    tutorialFrame.origin.y = 20;
    tutorial.view.frame = tutorialFrame;
    
    tutorial.view.alpha = 0;
    [view addSubview:tutorial.view];
    [UIView beginAnimations:nil context:nil];
    tutorial.view.alpha = 1;
    [UIView commitAnimations];
    
    return tutorial;
}

@end
