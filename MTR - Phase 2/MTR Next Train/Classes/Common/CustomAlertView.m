//
//  SelectLineViewController.m
//  MTR Next Train
//
//  Created by  on 12年2月21日.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomAlertView.h"

@implementation CustomAlertView

@synthesize delegate;
@synthesize message;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(id)initWithMessage:(NSString*)initMessage
{
    self = [super init];
    
    if (self)
    {
        self.message = initMessage;
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
    DEBUGLog
    
    ReleaseObj(btn_close)
    ReleaseObj(lbl_title)
    ReleaseObj(vw_pop_up)
    ReleaseObj(img_background)
    
    [super dealloc];
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    DEBUGLog
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

#pragma mark - Main functions
-(void)setLanguage
{
    [lbl_title setText:message];
    
    [btn_close setTitle:NSLocalizedString(([NSString stringWithFormat:@"close_%@", [CoreData sharedCoreData].lang]), nil) forState:UIControlStateNormal];
}


#pragma mark - Control functions
-(void)show
{
    if (isShowing)
        return;
    
    [self retain];
    
    [[[UIApplication sharedApplication].delegate window] addSubview:self.view];
        
    [self setLanguage];
    
    self.view.alpha = 1;
    
    [img_background doFadeInAnimation];    
    [vw_pop_up doPopInAnimation];
    [vw_pop_up doFadeInAnimation];
    
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

-(void)clearDelegatesAndCancel
{
    delegate = nil;
    
    if (isShowing)
    {
        [self didHidden];
    }
}

#pragma mark - Button functions
-(IBAction)dismiss:(UIButton*)sender
{    
    if (delegate != nil && [delegate respondsToSelector:@selector(CustomAlertView:didDismissWithButtonIndex:)])
    {
        [delegate CustomAlertView:self didDismissWithButtonIndex:0];
    }
    
    [self hide];
}


@end
