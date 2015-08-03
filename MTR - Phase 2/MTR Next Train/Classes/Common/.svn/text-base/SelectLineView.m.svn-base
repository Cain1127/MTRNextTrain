//
//  SelectLineViewController.m
//  MTR Next Train
//
//  Created by  on 12年2月21日.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SelectLineView.h"

@implementation SelectLineView

@synthesize delegate;
@synthesize isAutoPopSchedule;
@synthesize stationOptions;

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

-(void)dealloc
{
    DEBUGLog
    
    ReleaseObj(btn_cancel)
    ReleaseObj(btn_line1)
    ReleaseObj(btn_line2)
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
    [lbl_title setText:NSLocalizedString(([NSString stringWithFormat:@"select_line_%@", [CoreData sharedCoreData].lang]), nil)];
    
    [btn_cancel setTitle:NSLocalizedString(([NSString stringWithFormat:@"cancel_%@", [CoreData sharedCoreData].lang]), nil) forState:UIControlStateNormal];
    
    if ([stationOptions count] > 0)
    {
        for (int op=0; op<[stationOptions count]; op++)
        {
            StationOption *stationOption = [stationOptions objectAtIndex:op];
            [self setButton:(op+1) title:stationOption.station_name lineCode:stationOption.line_code];
        }
    }
}

-(void)setButton:(int)buttonId title:(NSString*)title lineCode:(NSString*)lineCode
{
    UIView *tempBtn = [vw_pop_up viewWithTag:buttonId];
    
    NSLog(@"button: %@", tempBtn);
    NSLog(@"button type: %@", [tempBtn class]);
    
    if (tempBtn != nil && [NSStringFromClass([tempBtn class]) isEqualToString:@"UIButton"])
    {
        NSLog(@"SET BUTTON LINE CODE: %@",lineCode);
        UIButton *btn = (UIButton*) tempBtn;
        
        [btn setTitle:title forState:UIControlStateNormal];
        
        if ([@"AEL" isEqualToString:lineCode])
        {
            [btn setBackgroundImage:[UIImage imageNamed:@"slide_route_map_popup_select_line_btn_airport_express.png"] forState:UIControlStateNormal];
        }
        else if ([@"WRL" isEqualToString:lineCode]){
              [btn setBackgroundImage:[UIImage imageNamed:@"slide_route_map_popup_select_line_btn_wrl.png"] forState:UIControlStateNormal];
        }else
        {
            [btn setBackgroundImage:[UIImage imageNamed:@"slide_route_map_popup_select_line_btn_tung_chung_line.png"] forState:UIControlStateNormal];
        }
    }
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
-(IBAction)clickButton:(UIButton*)sender
{    
    if (delegate != nil && [delegate respondsToSelector:@selector(SelectLineView:didDismissWithButtonIndex:autoPopSchedule:)])
    {
        [delegate SelectLineView:self didDismissWithButtonIndex:sender.tag autoPopSchedule:isAutoPopSchedule];
    }
    
    [self hide];
}


@end
