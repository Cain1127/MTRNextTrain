//
//  MaskViewController.m
//  bochk
//
//  Created by Algebra Lo on 14/12/2010.
//  Copyright 2010 MTel Limited. All rights reserved.
//

#import "MaskViewController.h"


@implementation MaskViewController
@synthesize loading;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

-(void)hiddenMask {
    //NSLog(@"hiddenMask");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(didHiddenMask)];
    self.view.alpha = 0;
    [UIView commitAnimations];
}

-(void)didHiddenMask
{    
	self.view.hidden = TRUE;
}

-(void)showMask {
    //NSLog(@"showMask");
    lbl_loading.text = NSLocalizedString(([NSString stringWithFormat:@"loading_%@", [CoreData sharedCoreData].lang]), nil);
    
	self.view.hidden = FALSE;
    
    
    self.view.alpha = 0;
    
    [UIView beginAnimations:nil context:nil];
    self.view.alpha = 1;
    [UIView commitAnimations];
    
    [vw_dialog doFadeInAnimation];
}
@end
