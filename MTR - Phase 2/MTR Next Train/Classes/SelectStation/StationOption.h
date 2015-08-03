//
//  StationOption.h
//  MTR Next Train
//
//  Created by  on 12年2月14日.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StationOption : NSObject
{
    
}

@property (nonatomic, retain) NSString* line_code;
@property (nonatomic, assign) int line_index;
@property (nonatomic, retain) NSString* station_code;
@property (nonatomic, assign) int station_index;
@property (nonatomic, retain) NSString* station_name;

@end
