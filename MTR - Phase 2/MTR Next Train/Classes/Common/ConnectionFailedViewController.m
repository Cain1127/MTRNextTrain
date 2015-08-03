//
//  ConnectionFailedViewController.m
//  MTR
//
//  Created by Jeff Cheung on 11年11月2日.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ConnectionFailedViewController.h"

@implementation ConnectionFailedViewController

@synthesize connection_failed_close_app = _connection_failed_close_app;
@synthesize delegate = _delegate;
@synthesize alertType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _animation_values = [NSMutableArray new];
    }
    return self;
}

-(void)dealloc{
    _delegate = nil;
    if(_animation_values != nil){
        [_animation_values removeAllObjects];
        [_animation_values release];
        _animation_values = nil;
    }
    [super dealloc];
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

#pragma mark - Core

-(void)handleLangauge{
    
    if (alertType == AlertType_ConnectionFailed)
    {
        _content_label.text = NSLocalizedString(([NSString stringWithFormat:@"no_connection_content_%@", [CoreData sharedCoreData].lang]), nil);
    }
    else if (alertType == AlertType_ConnectServerFailed)
    {
        _content_label.text = NSLocalizedString(([NSString stringWithFormat:@"no_connection_content_for_service_update_%@", [CoreData sharedCoreData].lang]), nil);
    }
    else if (alertType == AlertType_LocationFailed)
    {
        _content_label.text = NSLocalizedString(([NSString stringWithFormat:@"please_enable_location_base_services_%@", [CoreData sharedCoreData].lang]), nil);
    }
    
    [_close_button setTitle:NSLocalizedString(([NSString stringWithFormat:@"close_%@", [CoreData sharedCoreData].lang]), nil) forState:UIControlStateNormal];
}


-(void)doShowView{
    DEBUGLog
    [self handleLangauge];
    
    self.view.hidden = NO;
    _pop_up_view.hidden = NO;
        
//    [_pop_up_view doPopInAnimation];
//    [_pop_up_view doFadeInAnimation];
}

-(void)showView
{
    alertType = AlertType_ConnectionFailed;
    
    [self doShowView];    
}

-(void)showViewWithAlertType:(int)newAlertType
{
    alertType = newAlertType;
    
    [self doShowView];
}

-(void)hiddenView{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    self.view.alpha = 0;
    [UIView commitAnimations];
    
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
	NSString *value = [anim valueForKey:@"my_action"];
	if(value != nil && [value isEqualToString:@"hidden_connection_failed_bg_view"]){
        _pop_up_view.hidden = YES;
        self.view.hidden = YES;
       // exit(0);
	}
	
}

#pragma -
#pragma Handle Click Button Events

-(IBAction)clickCloseButton:(UIButton*)button{
    if(_connection_failed_close_app)
        exit(0);
    else{
        [self hiddenView];
        if(_delegate != nil && [_delegate respondsToSelector:@selector(clickedConnectionFailedCloseButton:)])
        {
            [_delegate clickedConnectionFailedCloseButton:self];
        }
    }
}

@end
