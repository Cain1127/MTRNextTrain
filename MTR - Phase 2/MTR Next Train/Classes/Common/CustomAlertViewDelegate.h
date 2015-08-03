//
//  SelectLineViewDelegate.h
//  MTR Next Train
//
//  Created by  on 12年2月21日.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

@class CustomAlertView;

@protocol CustomAlertViewDelegate <NSObject>

@optional
-(void)CustomAlertView:(CustomAlertView*)currentCustomAlertView didDismissWithButtonIndex:(int)buttonIndex;

@end

