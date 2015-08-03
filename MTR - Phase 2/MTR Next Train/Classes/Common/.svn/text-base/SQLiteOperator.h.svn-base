//
//  SQLiteOperator.h
//  MetroDaily
//
//  Created by Algebra Lo on 10年9月13日.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface SQLiteOperator : NSObject {
	
	sqlite3 *database;
	
}
@property(readonly, nonatomic) sqlite3 *database;

+ (SQLiteOperator *) sharedOperator;
- (void) openDatabase;
- (void) closeDatabase;
- (NSString *) getDatabaseFullPath;
- (void) copyDatabaseIfNeeded;
- (sqlite3_stmt *) executeQuery:(NSString *) query;

#pragma mark - favorite_station functions
-(NSArray*)selectALLFromFavoriteStation;
-(NSArray*)selectRecordFromFavoriteStationWithLineCode:(NSString*)lineCode stationCode:(NSString*)stationCode;
-(void)insertRecordToFavoriteStationWithLineCode:(NSString*)lineCode stationCode:(NSString*)stationCode stationEnglishName:(NSString*)stationEnglishName lineNumber:(NSString*)lineNumber;
-(void)deleteRecordFromFavoriteStationWithLineCode:(NSString*)lineCode stationCode:(NSString*)stationCode;
-(void)updateLineNumber:(NSString*)lineNumber fromFavoriteStationWithLineCode:(NSString*)lineCode stationCode:(NSString*)stationCode;
-(double)selectMaxLineNumberFromFavoriteStation;

#pragma mark - read_tutorial functions
-(BOOL)hasRecordInReadTutorialWithName:(NSString*)name appVersion:(NSString*)appVersion;
-(void)insertRecordToReadTutorialWithName:(NSString*)name appVersion:(NSString*)appVersion language:(NSString*)language;

@end
