//
//  NextTrainScheduleCell.h
//  MTR Next Train
//
//  Created by  on 12年2月10日.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData.h"

@interface NextTrainScheduleCell : UITableViewCell
{
    IBOutlet UIImageView *img_background;
    IBOutlet UILabel *lbl_destination, *lbl_platform, *lbl_time;
}

@property (nonatomic, retain) UILabel *lbl_destination, *lbl_platform, *lbl_time;

#pragma mark - Main function
-(void)setBackgroundWithRow:(int)row;
-(void)setTimeForTerminal:(BOOL)isTerminal language:(NSString*)language;
@end
