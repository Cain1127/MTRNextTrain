/* 
 
 Copyright (c) 2011,  All rights reserved.

 */

#import <UIKit/UIKit.h>

typedef enum
{
	FrontViewPositionLeft,
	FrontViewPositionRight
} FrontViewPosition;

@protocol ZUUIRevealControllerDelegate;

@interface ZUUIRevealController : UIViewController <UITableViewDelegate>

// Public Properties:
@property (retain, nonatomic) IBOutlet UIViewController *frontViewController;
@property (retain, nonatomic) IBOutlet UIViewController *rearViewController;
@property (assign, nonatomic) FrontViewPosition currentFrontViewPosition;
@property (assign, nonatomic) id<ZUUIRevealControllerDelegate> delegate;

// Public Methods:
- (id)initWithFrontViewController:(UIViewController *)aFrontViewController rearViewController:(UIViewController *)aBackViewController;
- (void)revealGesture:(UIPanGestureRecognizer *)recognizer;
- (void)revealToggle:(id)sender;

- (void)setFrontViewController:(UIViewController *)frontViewController;
- (void)setFrontViewController:(UIViewController *)frontViewController animated:(BOOL)animated;

@end

// ZUUIRevealControllerDelegate Protocol.
@protocol ZUUIRevealControllerDelegate<NSObject>

@optional

- (BOOL)revealController:(ZUUIRevealController *)revealController shouldRevealRearViewController:(UIViewController *)rearViewController;
- (BOOL)revealController:(ZUUIRevealController *)revealController shouldHideRearViewController:(UIViewController *)rearViewController;

/* 
 * IMPORTANT: It is not guaranteed that 'didReveal...' will be called after 'willReveal...'. The user 
 * might not have panned far enough for a reveal to be triggered! Thus 'didHide...' will be called!
 */
- (void)revealController:(ZUUIRevealController *)revealController willRevealRearViewController:(UIViewController *)rearViewController;
- (void)revealController:(ZUUIRevealController *)revealController didRevealRearViewController:(UIViewController *)rearViewController;

- (void)revealController:(ZUUIRevealController *)revealController willHideRearViewController:(UIViewController *)rearViewController;
- (void)revealController:(ZUUIRevealController *)revealController didHideRearViewController:(UIViewController *)rearViewController;

#pragma mark - New in 0.9.5

- (void)revealController:(ZUUIRevealController *)revealController willSwapToFrontViewController:(UIViewController *)frontViewController;
- (void)revealController:(ZUUIRevealController *)revealController didSwapToFrontViewController:(UIViewController *)frontViewController;

@end