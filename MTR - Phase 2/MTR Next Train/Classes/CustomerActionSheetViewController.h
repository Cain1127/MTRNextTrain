//
//  CustomerActionSheetViewController.h
//  MTR Next Train
//
//  Created by Alex on 24/7/14.
//
//

#import <UIKit/UIKit.h>
#import "CustomerActionSheetDelegate.h"
#import "CoreData.h"

@interface CustomerActionSheetViewController : UIViewController{

    IBOutlet UIView *vw_pop_up;
    IBOutlet UIButton *english;
    IBOutlet UIButton *chinese;
    
    IBOutlet UIButton *cancel_button;

    BOOL english_button;
    BOOL chinese_button;
}




@property (nonatomic, assign) id <CustomerActionSheetDelegate> delegate;
@property (nonatomic, assign) BOOL isShowing;
//@property(strong, nonatomic, readwrite) UIButton *english;;
//@property(strong, nonatomic, readwrite) UIButton *chinese;;


#pragma mark - Control functions
-(void)show;
-(void)hide;

#pragma mark - Button functions
-(IBAction)dismiss:(id)sender;

@end

