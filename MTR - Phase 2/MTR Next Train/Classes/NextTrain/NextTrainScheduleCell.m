//
//  NextTrainScheduleCell.m
//  MTR Next Train
//
//  Created by  on 12年2月10日.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NextTrainScheduleCell.h"

@implementation NextTrainScheduleCell

@synthesize lbl_destination, lbl_platform, lbl_time;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        
        img_background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slide_schedule_list_01.png"]];
        [img_background setFrame:CGRectMake(8, 0, 305, 25)];
        [self.contentView addSubview:img_background];
        
        lbl_destination = [[UILabel alloc] initWithFrame:CGRectMake(-14, 0, 150, 25)];
//        [lbl_destination setText:@"Tung Chung"];
        [lbl_destination setFont:[UIFont boldSystemFontOfSize:14]];
        [lbl_destination setBackgroundColor:[UIColor clearColor]];
        [lbl_destination setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:lbl_destination];
        
        lbl_platform = [[UILabel alloc] initWithFrame:CGRectMake(138, 0, 50, 25)];
        //        [lbl_platform setText:@"1/3"];
        [lbl_platform setFont:[UIFont boldSystemFontOfSize:14]];
        [lbl_platform setBackgroundColor:[UIColor clearColor]];
        [lbl_platform setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:lbl_platform];
        
        lbl_time = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, 120, 25)];
        //        [lbl_time setText:@"Arriving"];
        [lbl_time setFont:[UIFont boldSystemFontOfSize:14]];
        [lbl_time setBackgroundColor:[UIColor clearColor]];
        [lbl_time setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:lbl_time];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)dealloc
{
    [lbl_destination release];
    [lbl_platform release];
    [lbl_time release];    
    
    [super dealloc];
}

#pragma mark - Main function
-(void)setBackgroundWithRow:(int)row
{
    
    //jeff
    
    if (row % 2 == 0) {
        img_background.image = [UIImage imageNamed:@"slide_schedule_list_01.png"];
    }
    
    //Alex
//    else {
//        img_background.image = [UIImage imageNamed:@"slide_schedule_list_02.png"];
//    }
    
    /*
    int i = row % 3;
    
    if (i == 0)
    {
        [img_background setImage:[UIImage imageNamed:@"slide_schedule_list_01.png"]];
    }
    else if (i == 1)
    {
        [img_background setImage:[UIImage imageNamed:@"slide_schedule_list_02.png"]];
    }
    else if (i == 2)
    {
        [img_background setImage:[UIImage imageNamed:@"slide_schedule_list_03.png"]];
    }
     */

}

-(void)setTimeForTerminal:(BOOL)isTerminal language:(NSString*)language
{
//    DEBUGMSG(@"isterminal: %i", isTerminal);
    
    if ([@"zh_TW" isEqualToString:language])
    {
        lbl_time.frame = CGRectMake(210, 0, 100, 25);
    }
    else
    {
        lbl_time.frame = CGRectMake(210, 0, 110, 25);
    }
    
//    if ([@"zh_TW" isEqualToString:language])
//    {
//        lbl_time.frame = CGRectMake(230, 0, 80, 25);
//    }
//    else if ([@"en" isEqualToString:language])
//    {
//        if (isTerminal)
//        {
//            lbl_time.frame = CGRectMake(185, 0, 123, 25);
//        }
//        else
//        {
//            lbl_time.frame = CGRectMake(204, 0, 104, 25);
//        }
//    }
//    else
//    {
//        lbl_time.frame = CGRectMake(230, 0, 80, 25);
//    }
}


@end
