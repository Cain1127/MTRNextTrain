//
//  LocationOperator.h
//  MTR Next Train
//
//  Created by  on 12年2月10日.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "CoreData.h"
#import "LocationOperatorDelegate.h"

@interface LocationOperator : NSObject <CLLocationManagerDelegate>
{    
    CLLocationManager *location_manager;
    NSTimer *timer;
}

@property (nonatomic, retain) CLLocation *current_location;
@property (nonatomic, assign) id <LocationOperatorDelegate> delegate;
@property (nonatomic, assign) BOOL stopOnceFoundLocaton;
@property (nonatomic, assign) int timeout;

+(LocationOperator *)sharedOperator;

#pragma mark - Operating functions
-(void)startUpdatingLocation;
-(void)stopUpdatingLocation;
-(void)close;

-(void)locationManagerDidTimeout;

#pragma mark - Main functions
-(float)distanceOfCurrentLocationFromLatitude:(NSString*)latitude longitude:(NSString*)longitude;

#pragma mark - Misc functions
+(BOOL)isLocationServicesEnabled;
+(float)distanceBetweenLat1:(NSString*)lat1 long1:(NSString*)long1 lat2:(NSString*)lat2 long2:(NSString*)long2;
+(CLLocation*)locationForLatitude:(NSString*)latitude longitude:(NSString*)longitude;
+(int)getClosestLocationByComparingLocation:(CLLocation*)location withLocationArray:(NSArray*)locationArray;

@end
