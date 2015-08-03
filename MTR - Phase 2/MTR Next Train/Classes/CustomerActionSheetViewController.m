//
//  CustomerActionSheetViewController.m
//  MTR Next Train
//
//  Created by Alex on 24/7/14.
//
//

#import "CustomerActionSheetViewController.h"

@interface CustomerActionSheetViewController ()

@end

@implementation CustomerActionSheetViewController

@synthesize delegate;
@synthesize isShowing;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.hidden = YES ;
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
    ReleaseObj(vw_pop_up)
    [english release];
    [chinese release];
    [cancel_button release];
    [super dealloc];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    //    [cancel_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"language_cancal_btn_ch.png", [CoreData sharedCoreData].lang]] forState:UIControlStateNormal];
    //
    //    [cancel_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"contact_info_general_on_%@.png", [CoreData sharedCoreData].lang]] forState:UIControlStateSelected];
    
    
    vw_pop_up.layer.masksToBounds = NO;      // critical to add this line
    vw_pop_up.layer.cornerRadius = 5.0f;
    vw_pop_up.layer.shadowOpacity = 1.0f;
    vw_pop_up.layer.shadowOffset = CGSizeMake(1, 2);
    vw_pop_up.layer.shadowRadius = 5.0f;
    vw_pop_up.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:vw_pop_up.bounds cornerRadius:5.0f].CGPath;
    
}

- (void)viewDidUnload
{
    [english release];
    english = nil;
    [chinese release];
    chinese = nil;
    [cancel_button release];
    cancel_button = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - Control functions
-(void)show
{
    
    if (isShowing)
        return;
    [self CheckLang];
    
    self.view.hidden = NO;
    self.view.alpha = 1;
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, (IS_IPHONE5?576:480));
    
    [vw_pop_up setFrame:CGRectMake(0, self.view.frame.size.height ,vw_pop_up.frame.size.width, vw_pop_up.frame.size.height)];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    [english setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [chinese setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [cancel_button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    [vw_pop_up setFrame:CGRectMake(0,( self.view.frame.size.height - vw_pop_up.frame.size.height) ,vw_pop_up.frame.size.width, vw_pop_up.frame.size.height)];
    [UIView commitAnimations];
    
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
    [vw_pop_up setFrame:CGRectMake(0, self.view.frame.size.height ,vw_pop_up.frame.size.width, vw_pop_up.frame.size.height)];
    [UIView commitAnimations];
}


-(void)didHidden
{
    if (!isShowing)
        return;
    
    isShowing = NO;
    self.view.hidden = YES;
    
}

-(void)CheckLang
{
    if ([[CoreData sharedCoreData].lang isEqualToString:@"en"]) {
        english.selected = YES ;
        chinese.selected = NO ;
    }else{
        english.selected = NO ;
        chinese.selected = YES ;
    }
    NSLog(@"%@", [CoreData sharedCoreData].lang);
    [cancel_button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"language_cancal_btn_%@.png",[CoreData sharedCoreData].lang]] forState:UIControlStateNormal];
    
}

#pragma mark - Button functions
-(IBAction)dismiss:(UIButton*)sender
{
    DEBUGLog
    
    [self hide];
}


- (IBAction)clickEnglishButton:(UIButton *)sender
{
    DEBUGLog
    
    if (delegate != nil && [delegate respondsToSelector:@selector(CustomAlertView:didDismissWithButtonIndex:)])
    {
        [delegate CustomerActionSheet:self didDismissWithButtonIndex:[sender tag]];
        
    }
    
    [self CheckLang];
    
}



- (IBAction)clickChineseButton:(UIButton *)sender {
    
    DEBUGLog
    
    if (delegate != nil && [delegate respondsToSelector:@selector(CustomAlertView:didDismissWithButtonIndex:)])
    {
        [delegate CustomerActionSheet:self didDismissWithButtonIndex:[sender tag]];
    }
    [self CheckLang];
    
}


@end
