//
//  TutorialViewController.h
//  MTR Next Train
//
//  Created by  on 12年2月29日.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData.h"

@interface TutorialViewController : UIViewController
{
    IBOutlet UIImageView *img_tutorial;
}

@property (nonatomic, assign) id parent;

#pragma mark - Button functions
-(IBAction)clickCloseButton:(id)sender;


@end
