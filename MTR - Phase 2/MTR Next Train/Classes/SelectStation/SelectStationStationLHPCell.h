//
//  SelectStationStationLHPCell.h
//  MTR Next Train
//
//  Created by Algebra on 7/11/2014.
//
//

#import <UIKit/UIKit.h>

@interface SelectStationStationLHPCell : UITableViewCell {
    UILabel *_value_label;
    UIImageView *_dot_image_view;
    UIImageView *_louhasParkStation;
    UILabel *hangHanuStation;
    NSMutableDictionary *_station_record;
    
    UIView *expandView;
    
}

@property (nonatomic, retain) UILabel *value_label;
@property (nonatomic, retain) UIImageView *dot_image_view;
@property (nonatomic, retain) UIImageView *louhasParkStation;

-(void)reset;
- (void)setSize:(BOOL)expand animated:(BOOL)animated;

@end
