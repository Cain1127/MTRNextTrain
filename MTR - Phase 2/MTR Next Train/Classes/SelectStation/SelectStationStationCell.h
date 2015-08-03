//
//  StationFacilitieStationCell.h
//  bochk
//
//  Created by Jeff Cheung on 11年3月2日.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreData.h"

@interface SelectStationStationCell : UITableViewCell {
    UILabel *_value_label;
    UIImageView *_dot_image_view;
//    UIImageView *louhasParkStation;
    UILabel *hangHanuStation;
    NSMutableDictionary *_station_record;

}

@property (nonatomic, retain) UILabel *value_label;
@property (nonatomic, retain) UIImageView *dot_image_view;
//@property (nonatomic, retain) UIImageView *louhasParkStation;
//@property (nonatomic, retain) UIImageView *showLouhasPark;


-(void)reset;
//-(void)isLouhasParkStation;
//-(void)selectLouhasParkStation;
//-(void)SetLouhasParkStationShow:(BOOL)Show;
//-(void)SetHangHanuStationShow:(BOOL)Show;
//-(void)showLouhasPark:(BOOL)Show;


@end
