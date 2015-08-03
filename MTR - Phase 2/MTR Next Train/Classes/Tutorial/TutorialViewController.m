//
//  TutorialViewController.m
//  MTR Next Train
//
//  Created by  on 12年2月29日.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TutorialViewController.h"

@implementation TutorialViewController

@synthesize parent = _parent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithParent:(id)parent
{
    self = [super init];
    
    if (self)
    {
        self.parent = parent;
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)dealloc
{
    ReleaseObj(img_tutorial)
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
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

#pragma mark - Control functions
-(void)show
{
    if (isShowing)
        return;
    
    [self retain];
    
    self.view.frame = CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height);
    [[[UIApplication sharedApplication].delegate window] addSubview:self.view];
    
    [self setTutorialImage];
    
    [self.view doFadeInAnimation];
    
    isShowing = YES;
    
    
}

-(void)hide
{
    if (!isShowing)
        return;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didHidden)];
    self.view.alpha = 0;
    [UIView commitAnimations];
}

-(void)didHidden
{
    if (!isShowing)
        return;
    
    isShowing = NO;
    
    [self.view removeFromSuperview];
    [self autorelease];
}

#pragma mark - UI functions

-(void)setTutorialImage
{
    UIImage *image = nil;
    
    if (_parent != nil)
    {
        if ([_parent isKindOfClass:[SelectStationViewController class]])
        {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"tutorial_nexttrain_%@", [CoreData sharedCoreData].lang]];
        }
        else if ([_parent isKindOfClass:[NextTrainViewController class]])
        {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"tutorial_slider_%@", [CoreData sharedCoreData].lang]];
        }
        else if ([_parent isKindOfClass:[FavoriteViewController class]])
        {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"tutorial_favorite_%@", [CoreData sharedCoreData].lang]];
        }
        else if ([_parent isKindOfClass:[MoreViewController class]])
        {
            image = [UIImage imageNamed:[NSString stringWithFormat:@"tutorial_more_%@", [CoreData sharedCoreData].lang]];
        }
    }
    
    if (image != nil)
    {
        [img_tutorial setImage:image];
    }
}



#pragma mark - Button functions
-(IBAction)clickCloseButton:(id)sender
{
    [self hide];
}

@end
