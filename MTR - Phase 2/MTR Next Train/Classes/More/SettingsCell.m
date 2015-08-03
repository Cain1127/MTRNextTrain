//
//  NextTrainScheduleCell.m
//  MTR Next Train
//
//  Created by  on 12年2月10日.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingsCell.h"

@implementation SettingsCell

@synthesize lbl_station_name;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //img_background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more_list_normal.png"]];
        img_background = [[UIImageView alloc] init];
        [img_background setContentMode:UIViewContentModeScaleAspectFit];
        if(isFive==NO)
            [img_background setFrame:CGRectMake(0, 0, 325, 47)]; //43)];
        else
            [img_background setFrame:CGRectMake(0, 0, 325, 47)];
        [self.contentView addSubview:img_background];
        [self setChecked:NO];
        
        if(isFive==NO)
            lbl_station_name = [[UILabel alloc] initWithFrame:CGRectMake(31, 0, 280, 50)];
        else
            lbl_station_name = [[UILabel alloc] initWithFrame:CGRectMake(31, 0, 280, 45)];

        [lbl_station_name setTextColor:[UIColor colorWithRed:33/255.0 green:62/255.0 blue:107/255.0 alpha:1]];
        
//        [lbl_station_name setTextColor:[UIColor blackColor]];
        [lbl_station_name setBackgroundColor:[UIColor clearColor]];
//        [lbl_station_name setFont:[UIFont systemFontOfSize:16]];
//        [lbl_station_name setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        [self.contentView addSubview:lbl_station_name];
    }
    
//    if (isFive == NO && [[UIDevice currentDevice] systemVersion] floatValue <= 7.0) {
//        <#statements#>
//    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{
    [lbl_station_name release];
    [img_background release];
    
    [super dealloc];
}

#pragma mark - control functions
-(void)setChecked:(BOOL)checked
{
    if (checked)
    {
        img_background.image = [UIImage imageNamed:@"more_list_selected.png"];
        img_background.hidden = NO;
    }
    else
    {
        img_background.image = [UIImage imageNamed:@"more_list_normal.png"];
        img_background.hidden = YES;
    }
    //    if (isFive == NO && checked) {
    //        img_background.image = [UIImage imageNamed:@"more_list_selected.png"];
    //        img_background.frame = CGRectMake(0, img_background.frame.origin.y, img_background.frame.size.width+30, img_background.frame.size.height);
    //        img_background.hidden = NO;
    //    }
    //    else
    //    {
    //        img_background.image = [UIImage imageNamed:@"more_list_normal.png"];
    //        img_background.frame = CGRectMake(img_background.frame.origin.x, img_background.frame.origin.y, img_background.frame.size.width+30, img_background.frame.size.height);
    //        img_background.hidden = YES;
    //    }
}

@end
