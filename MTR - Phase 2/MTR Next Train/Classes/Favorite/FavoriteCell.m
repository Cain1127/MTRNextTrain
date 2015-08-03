//
//  NextTrainScheduleCell.m
//  MTR Next Train
//
//  Created by  on 12年2月10日.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FavoriteCell.h"

@implementation FavoriteCell

@synthesize lbl_station_name,img_background;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        
        img_background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bookmark_list_line_bg.png"]];
        [img_background setFrame:CGRectMake(0, 0, 320, 51)];
        //img_background.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [img_background setContentMode:UIViewContentModeScaleToFill];
        [self.contentView addSubview:img_background];
        [lbl_station_name sizeToFit];
        lbl_station_name = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 320, 25)];
        [lbl_station_name setTextColor:[UIColor colorWithRed:33.0/255.0 green:62.0/255.0 blue:109.0/255.0 alpha:1]];
        [lbl_station_name setBackgroundColor:[UIColor clearColor]];
        [lbl_station_name setFont:[UIFont boldSystemFontOfSize:17]];
       // [lbl_station_name setContentMode:UIViewContentModeTop];
        [lbl_station_name setNumberOfLines:0];

        [self.contentView addSubview:lbl_station_name];
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
    [lbl_station_name release];
    [img_background release];
    
    [super dealloc];
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    
//    for (UIView *subview in self.subviews ) {
//        for (UIView *subview2 in subview.subviews ) {
//
//            if ([NSStringFromClass([subview2 class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]  ) {
//
//                if (self.editing) {
//                    UIView *subview3 = subview2 ;
//                    
//                    subview3.center = CGPointMake(subview3.center.x, subview3.center.y -5 );
//                    
//                    subview3.autoresizesSubviews = NO;
//
//                }
//               
//                
//                if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellDeleteConfirmationView"]) {
//                    
//
//
//
//                }
//            [subview bringSubviewToFront:subview2];
//            }
//        }
//}
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.isEditing) {
        
//        [self sendSubviewToBack:self.contentView];
        img_background.image = [UIImage imageNamed:@"bookmark_list_line_bg_hide.png"];
        img_background.frame = CGRectMake(-38, 0, img_background.frame.size.width, img_background.frame.size.height);
    }else{
        img_background.image = [UIImage imageNamed:@"bookmark_list_line_bg.png"];
        img_background.frame = CGRectMake(0, 0, img_background.frame.size.width, img_background.frame.size.height);
    }
    
}

@end
