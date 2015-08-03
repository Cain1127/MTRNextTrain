//
//  StationFacilitieStationCell.m
//  bochk
//
//  Created by Jeff Cheung on 11年3月2日.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SelectStationStationCell.h"


@implementation SelectStationStationCell

@synthesize dot_image_view = _dot_image_view;
@synthesize value_label = _value_label;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES ;
//        louhasParkStation = [[[UIImageView alloc] initWithFrame:CGRectMake(22.5, 0 , 50.5 , 40)] autorelease];
//        louhasParkStation.image = [UIImage imageNamed:@"next_train_select_station_point_tko6.png"];
//        [self.contentView addSubview:louhasParkStation];
        
        _dot_image_view = [[UIImageView alloc] initWithFrame:CGRectMake(6, 16, 16, 16)];
        _dot_image_view.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:_dot_image_view];

		_value_label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 142, 48)];
        
        if ([[CoreData sharedCoreData].lang isEqualToString:@"en"])
        {
            _value_label.font = [UIFont boldSystemFontOfSize:13];
        }
        else
        {
            _value_label.font = [UIFont boldSystemFontOfSize:18];
        }
		_value_label.backgroundColor = [UIColor clearColor];
        
		_value_label.textAlignment = UITextAlignmentLeft;
        
        //        [self isLouhasParkStation];
        //       ios 7
        [[UITableViewCell appearance] setBackgroundColor:[UIColor clearColor]];
        
		[self.contentView addSubview:_value_label];
    }

    return self;
}
/*
-(void)isLouhasParkStation{
    _value_label.frame = CGRectMake(30, 0, 142, 48);
    
}


-(void)SetLouhasParkStationShow:(BOOL)Show{
    louhasParkStation.hidden = !Show;
    if (Show) {
        _value_label.frame = CGRectMake(30, 15, 142, 48);
    }else{
        _value_label.frame = CGRectMake(30, 0, 142, 48);

    }
}
*/


//-(void)showLouhasPark:(BOOL)Show{
//    
//    louhasParkStation = [[[UIImageView alloc] initWithFrame:CGRectMake(21.8, 0 , 50.5 , 30)] autorelease];
//    louhasParkStation.image = [UIImage imageNamed:@"next_train_select_station_point_tko5.png"];
//    [self.contentView addSubview:louhasParkStation];
//    
//}


-(void)reset{
    //louhasParkStation.hidden = YES;
    _value_label.frame = CGRectMake(30, 0, 142, 48);
    
    if ([[CoreData sharedCoreData].lang isEqualToString:@"en"])
    {
        _value_label.font = [UIFont boldSystemFontOfSize:13];
    }
    else
    {
        _value_label.font = [UIFont boldSystemFontOfSize:18];
    }
    
    _value_label.text = @"";
    _dot_image_view.image = nil;
}

- (void)dealloc {
    if(_dot_image_view != nil){
        [_dot_image_view removeFromSuperview];
        [_dot_image_view release];
        _dot_image_view = nil;
    }
    if(_value_label != nil){
        [_value_label removeFromSuperview];
        [_value_label release];
        _value_label = nil;
    }
    [super dealloc];
}

@end
