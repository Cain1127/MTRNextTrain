//
//  NextTrainScheduleCell.h
//  MTR Next Train
//
//  Created by  on 12年2月10日.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsCell : UITableViewCell
{
    IBOutlet UILabel *lbl_station_name;
    IBOutlet UIImageView *img_background;
}

@property (nonatomic, retain) UILabel *lbl_station_name;

#pragma mark - control functions
-(void)setChecked:(BOOL)checked;

@end
