//
//  TutorialAllViewController.m
//  MTR Next Train
//
//  Created by  on 12年3月1日.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TutorialAllViewController.h"

@implementation TutorialAllViewController

@synthesize parent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        tutorialImageNameArray = [NSMutableArray new];
        
        [tutorialImageNameArray addObject:[NSString stringWithFormat:@"more_settings_in_app_tutorial_%@", [CoreData sharedCoreData].lang]];

        [tutorialImageNameArray addObject:[NSString stringWithFormat:@"next_train_in_app_tutorial_%@", [CoreData sharedCoreData].lang]];
        [tutorialImageNameArray addObject:[NSString stringWithFormat:@"slide_menu_schedule_in_app_tutorial_%@", [CoreData sharedCoreData].lang]];
        
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
    if (tutorialImageNameArray != nil)
    {
        [tutorialImageNameArray release];
        tutorialImageNameArray = nil;
    }
    
    ReleaseObj(sv_tutorial)
    ReleaseObj(pc_tutorial)
    ReleaseObj(btn_left)
    ReleaseObj(btn_right)
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
//        
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
//        
//        view.backgroundColor=[UIColor colorWithRed:213/255.0 green:215/255.0 blue:219/255.0 alpha:1];
//        
//        [self.view addSubview:view];
//        
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//        
//    }
    // Do any additional setup after loading the view from its nib.
    if(isFive == NO){
        [sv_tutorial setFrame:CGRectMake(0, 0, 320, 460)];
        [sv_tutorial setContentSize:CGSizeMake(320, 460)];
    }
    
    if ([tutorialImageNameArray count] > 0)
    {
        for (int i=0; i<[tutorialImageNameArray count]; i++)
        {
            NSString *imageName = [tutorialImageNameArray objectAtIndex:i];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.frame = CGRectMake(i*sv_tutorial.bounds.size.width, 0, sv_tutorial.bounds.size.width, sv_tutorial.bounds.size.height);
            [sv_tutorial addSubview:imageView];
            
            if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
                imageView.frame = CGRectMake(i*sv_tutorial.bounds.size.width, 18, sv_tutorial.bounds.size.width, sv_tutorial.bounds.size.height);
            }
            
            [imageView release];
        }
        
      
        sv_tutorial.contentSize = CGSizeMake(sv_tutorial.bounds.size.width*[tutorialImageNameArray count], sv_tutorial.bounds.size.height);
    }
    
    
    pc_tutorial.numberOfPages = [tutorialImageNameArray count];
    pc_tutorial.currentPage = 0;
    
    [self handleLeftRightButtonForPage:0];
    
    // gesture
    UISwipeGestureRecognizer *swipeGestureRecognizerDown =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                              action:@selector(clickCloseButton:)];
    
    swipeGestureRecognizerDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeGestureRecognizerDown];
    [swipeGestureRecognizerDown release];
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
    if (parent != nil && [parent respondsToSelector:@selector(hideInAppTutorialAll)])
    {
        [parent performSelector:@selector(hideInAppTutorialAll)];
    }
}

-(IBAction)clickChangePage:(id)sender
{
    int newPage = pc_tutorial.currentPage;
    
    CGRect scrollFrame = sv_tutorial.frame;
    scrollFrame.origin.x = newPage * sv_tutorial.bounds.size.width;
    
    [sv_tutorial scrollRectToVisible:scrollFrame animated:YES];
}

-(IBAction)clickLeftButton:(id)sender
{
    if (pc_tutorial.currentPage > 0)
    {
        [self changeToPage:pc_tutorial.currentPage - 1];
    }
}

-(IBAction)clickRightButton:(id)sender
{
    if (pc_tutorial.currentPage < [tutorialImageNameArray count]-1)
    {
        [self changeToPage:pc_tutorial.currentPage + 1];
    }
}

#pragma mark - control functions
-(void)changeToPage:(int)newPage
{
    if (newPage < 0 || newPage >= [tutorialImageNameArray count])
        return;
    
    CGRect scrollFrame = sv_tutorial.frame;
    scrollFrame.origin.x = newPage * sv_tutorial.bounds.size.width;
    
    [sv_tutorial scrollRectToVisible:scrollFrame animated:YES];
}

-(void)handleLeftRightButtonForPage:(int)newPage
{
    if ([tutorialImageNameArray count] == 1)
    {
        btn_left.alpha = 0;
        btn_right.alpha = 0;
    }
    else if (newPage == 0)
    {
        btn_left.alpha = 0;
        btn_right.alpha = 1;
    }
    else if (newPage == [tutorialImageNameArray count]-1)
    {
        btn_left.alpha = 1;
        btn_right.alpha = 0;
    }
    else
    {
        btn_left.alpha = 1;
        btn_right.alpha = 1;
    }
}

#pragma mark - ScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float pageWidth = scrollView.bounds.size.width;
    int newPage = (scrollView.contentOffset.x - pageWidth/2) / pageWidth + 1;
    
    if (pc_tutorial.currentPage != newPage)
    {
        [UIView beginAnimations:nil context:nil];
        [self handleLeftRightButtonForPage:newPage];
        [UIView commitAnimations];
    }
    
    pc_tutorial.currentPage = newPage;
}
//
//-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    float pageWidth = scrollView.bounds.size.width;
//    int newPage = (scrollView.contentOffset.x - pageWidth/2) / pageWidth + 1;
//}
//

@end
