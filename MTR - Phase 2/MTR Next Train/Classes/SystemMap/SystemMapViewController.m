//
//  SystemMapViewController.m
//  MTR Next Train
//
//  Created by  on 12年2月21日.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SystemMapViewController.h"
#import "CoreData.h"


@implementation SystemMapViewController

@synthesize parent;

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
    ReleaseObj(btn_close)
    
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if(isFive==NO){
        self.view.frame = CGRectMake(0,0,320,480);
    }
    [self addSystemMap];
    
    
    if (isFive == NO  && [[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0 ) {
        UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)]autorelease];
        
        view.backgroundColor=[UIColor blackColor];
        
        [self.view addSubview:view];
    }
    //ios 7 Alex
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && IS_IPHONE5 == YES) {
        
        self.view.frame = CGRectMake(0,0,320,570);
        [self addSystemMap];
        
        
        UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)]autorelease];
        
        view.backgroundColor=[UIColor blackColor];
        
        [self.view addSubview:view];
        
        //        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    //    [self addSystemMap];
}


-(void)addSystemMap {
    
    sv_system_map = [[ZoomImageView alloc] initWithFrame:self.view.frame image:[UIImage imageNamed:@"slide_system_map"]];
    NSLog(@"scrollViewheight:%f imageH:%f, sCH:",sv_system_map.frame.size.height,sv_system_map.image.frame.size.height);
    [self.view addSubview:sv_system_map];
    sv_system_map.zoomScale = sv_system_map.minimumZoomScale;
    [sv_system_map release];
    
    
    
//        [btn_miniMap setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"slide_route_map_view_system_map_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateNormal];
//
    if ([[CoreData sharedCoreData].btn_miniMap isEqualToString:@"2"]) {
        sv_system_map = [[ZoomImageView alloc] initWithFrame:self.view.frame image:[UIImage imageNamed:@"new_slide_system_map3"]];
        NSLog(@"scrollViewheight:%f imageH:%f, sCH:",sv_system_map.frame.size.height,sv_system_map.image.frame.size.height);
        [self.view addSubview:sv_system_map];
        sv_system_map.zoomScale = sv_system_map.minimumZoomScale;
    }
    
        if ([[CoreData sharedCoreData].btn_miniMap isEqualToString:@"3"]) {
            sv_system_map = [[ZoomImageView alloc] initWithFrame:self.view.frame image:[UIImage imageNamed:@"new_slide_system_map"]];
            NSLog(@"scrollViewheight:%f imageH:%f, sCH:",sv_system_map.frame.size.height,sv_system_map.image.frame.size.height);
            [self.view addSubview:sv_system_map];
            sv_system_map.zoomScale = sv_system_map.minimumZoomScale;
        }
    
        
    [self.view bringSubviewToFront:btn_close];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    /*
     if (timer_toggle!=nil) {
     [timer_toggle invalidate];
     timer_toggle = nil;
     }
     */
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Button functions
-(IBAction)clickCloseButton:(id)sender
{
    if (parent != nil && [parent respondsToSelector:@selector(closeSystemMap)])
    {
        [parent performSelector:@selector(closeSystemMap)];
    }
}

/*
 #pragma mark - UIScrollViewDelegate
 
 -(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
 {
 return img_system_map;
 }
 */

@end
