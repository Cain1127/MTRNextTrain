//
//  SelectStationStationLHPCell.m
//  MTR Next Train
//
//  Created by Algebra on 7/11/2014.
//
//

#import "SelectStationStationLHPCell.h"
#import "CoreData.h"

@implementation SelectStationStationLHPCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        // Initialization code
		self.selectionStyle = UITableViewCellSelectionStyleNone;
        //self.clipsToBounds = YES ;
        CGRect temp_frame = self.contentView.frame;
        temp_frame.origin.y = temp_frame.origin.y + 48;
        temp_frame.size.height = 48;
        expandView = [[UIView alloc] initWithFrame:temp_frame];
        expandView.frame = temp_frame;
        expandView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:expandView];
        
        _louhasParkStation = [[[UIImageView alloc] initWithFrame:CGRectMake(21.8, 0 , 58 , 48)] autorelease];
        _louhasParkStation.image = [UIImage imageNamed:@"next_train_select_station_point_tko8.png"];
        [self.contentView addSubview:_louhasParkStation];
        
        /*_dot_image_view = [[UIImageView alloc] initWithFrame:CGRectMake(6, 16, 16, 16)];
        _dot_image_view.backgroundColor = [UIColor clearColor];
        
        [expandView addSubview:_dot_image_view];*/
        
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
        
		[expandView addSubview:_value_label];
    }
    

    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)reset {
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

-(void)setSize:(BOOL)expand animated:(BOOL)animated {
    if (expand) {
        _louhasParkStation.hidden = NO;
        CGRect temp_frame = self.contentView.frame;
        temp_frame.origin.y = temp_frame.origin.y + 48;
        temp_frame.size.height = 48;
        expandView.frame = temp_frame;
    } else {
        _louhasParkStation.hidden = YES;
        CGRect temp_frame = self.contentView.frame;
        temp_frame.size.height = 48;
        expandView.frame = temp_frame;
    }
}

@end
