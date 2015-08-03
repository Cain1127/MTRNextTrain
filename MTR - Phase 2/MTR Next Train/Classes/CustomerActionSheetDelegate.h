//
//  CustomerActionSheetDelegate.h
//  MTR Next Train
//
//  Created by Alex on 24/7/14.
//
//

@class CustomerActionSheetViewController;

@protocol CustomerActionSheetDelegate <NSObject>

@optional
-(void)CustomerActionSheet:(CustomerActionSheetViewController*)currentCustomAlertView didDismissWithButtonIndex:(int)buttonIndex;

@end