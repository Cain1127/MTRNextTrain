//
//  TutorialAllViewController.h
//  MTR Next Train
//
//  Created by  on 12年3月1日.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData.h"

@interface TutorialAllViewController : UIViewController <UIScrollViewDelegate>
{
    IBOutlet UIScrollView *sv_tutorial;
    IBOutlet UIPageControl *pc_tutorial;
    IBOutlet UIButton *btn_left, *btn_right;
    
    NSMutableArray *tutorialImageNameArray;
}

@property (nonatomic, assign) id parent;

#pragma mark - Button functions
-(IBAction)clickCloseButton:(id)sender;
-(IBAction)clickChangePage:(id)sender;
-(IBAction)clickLeftButton:(id)sender;
-(IBAction)clickRightButton:(id)sender;

#pragma mark - control functions
-(void)changeToPage:(int)newPage;
-(void)handleLeftRightButtonForPage:(int)newPage;

@end
