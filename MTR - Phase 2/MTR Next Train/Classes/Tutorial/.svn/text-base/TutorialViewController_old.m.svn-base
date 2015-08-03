//
//  TutorialViewController.m
//  MTR Next Train
//
//  Created by  on 12年2月29日.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TutorialViewController.h"

@implementation TutorialViewController

@synthesize parent;
@synthesize tutorialIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImage *image = nil;
    
    if (parent != nil)
    {
        if ([parent isKindOfClass:[SelectStationViewController class]])
        {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"tutorial_nexttrain_%@", [CoreData sharedCoreData].lang]];
        }
        else if ([parent isKindOfClass:[NextTrainViewController class]])
        {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"tutorial_slider_%@", [CoreData sharedCoreData].lang]];
        }
        else if ([parent isKindOfClass:[FavoriteViewController class]])
        {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"tutorial_favorite_%@", [CoreData sharedCoreData].lang]];
        }
        else if ([parent isKindOfClass:[MoreViewController class]])
        {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"tutorial_more_%@", [CoreData sharedCoreData].lang]];
        }
    }
    
    if (image != nil)
    {
        [img_tutorial setImage:image];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - Button functions
-(IBAction)clickCloseButton:(id)sender
{
    if (parent != nil && [parent respondsToSelector:@selector(hideInAppTutorial)])
    {
        [parent performSelector:@selector(hideInAppTutorial)];
    }
}

@end
