//
//  SQLiteOperator.m
//  MetroDaily
//
//  Created by Algebra Lo on 10年9月13日.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SQLiteOperator.h"


@implementation SQLiteOperator
static SQLiteOperator *operator = nil;

NSString *DB_NAME = @"app_data";
NSString *DB_EXT = @".sqlite";

@synthesize database;

+ (SQLiteOperator *) sharedOperator{
	@synchronized(self) {
		if (operator == nil){
			operator = [[SQLiteOperator alloc] init];
			//[operator openDatabase];
		}
	}
	return operator;
}

+ (id)allocWithZone:(NSZone *)zone {
	@synchronized(self) {
		if (operator == nil) {
			operator = [super allocWithZone:zone];
			return operator;
		}
	}
	return nil;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;
}

//- (void)release {
//    //do nothing
//}

- (id)autorelease {
    return self;
}

- (void) openDatabase{
	NSLog(@"openDatabase");
    if (!database){
		[self copyDatabaseIfNeeded];
		int result = sqlite3_open([[self getDatabaseFullPath] UTF8String], &database);
		if (result != SQLITE_OK){
			NSAssert(0, @"Failed to open database");
		}
	}
    
    /*
     NSString *sql = @"CREATE TABLE IF NOT EXISTS \"first_time\" (\"id\" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL, \"value\" CHAR(256))";
     sqlite3_stmt *statement = [[SQLiteOperator sharedOperator] executeQuery:sql];
     sqlite3_step(statement);
     
     sql = @"CREATE TABLE IF NOT EXISTS \"push\" (\"id\" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL, \"type\" CHAR(256), \"value\" CHAR(256))";
     statement = [[SQLiteOperator sharedOperator] executeQuery:sql];
     sqlite3_step(statement);
     
     sql = @"CREATE TABLE IF NOT EXISTS \"app_info\" (\"id\" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL, \"app_version\" CHAR(256), \"contact_cached_time\" CHAR(256), \"facility_cached_time\" CHAR(256))";
     statement = [[SQLiteOperator sharedOperator] executeQuery:sql];
     sqlite3_step(statement);
     
     sql = @"CREATE TABLE IF NOT EXISTS \"update_info\" (\"id\" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL, \"last_check_xml_full_date\" CHAR(256), \"app_should_update\" CHAR(256),  \"contact_should_update\" CHAR(256), \"facility_should_update\" CHAR(256))";
     statement = [[SQLiteOperator sharedOperator] executeQuery:sql];
     sqlite3_step(statement);
     */
	NSString *sql = @"CREATE TABLE IF NOT EXISTS \"favorite_station\" ( \"line_code\" CHAR, \"station_code\" CHAR, \"station_name_en\" CHAR, \"line_number\" CHAR )";
	sqlite3_stmt *statement = [[SQLiteOperator sharedOperator] executeQuery:sql];
	sqlite3_step(statement);
    
    
	sql = @"CREATE TABLE IF NOT EXISTS \"read_tutorial\" ( \"tutorial_name\" CHAR, \"app_version\" CHAR, \"language\" CHAR )";
	statement = [[SQLiteOperator sharedOperator] executeQuery:sql];
	sqlite3_step(statement);
    
	NSLog(@"openDatabase done");
}

- (void) closeDatabase{
    if (database){
        sqlite3_close(database);
    }
}

- (void) copyDatabaseIfNeeded{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSString *dbPath = [self getDatabaseFullPath];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults valueForKey:@"SQLiteVersion"] && ![[defaults valueForKey:@"SQLiteVersion"] isEqualToString:[self appVersion]]){
        if(success && [fileManager removeItemAtPath:dbPath error:&error]){
            NSLog(@"Delete to delete old version db");
            
        }else{
            NSLog(@"Failed to delete old version db");
        }
        success = NO;
    }
    if(!success) {
		
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setObject:[self appVersion] forKey:@"SQLiteVersion"];

        [defaults synchronize];
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", DB_NAME, DB_EXT]];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        //        NSLog(@"Database file copied from bundle to %@", dbPath);
		
        if (!success){
//            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
		
    } else {
		
        //        NSLog(@"Database file found at path %@", dbPath);
		
    }
}

- (NSString *) appVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}


- (NSString *) getDatabaseFullPath{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", DB_NAME, DB_EXT]];
	return path;
}

- (sqlite3_stmt *) executeQuery:(NSString *) query{
	sqlite3_stmt *statement;
	int result = sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
    if (result != SQLITE_OK)
    {
        DEBUGMSG(@"Execute SQL Error Code: {%i}, Message: {%s}", result, sqlite3_errmsg(database));
    }
	return statement;
}


#pragma mark - favorite_station functions
-(NSArray*)selectALLFromFavoriteStation
{
	NSString *sql =  @"SELECT * FROM favorite_station ORDER BY line_number";
	sqlite3_stmt *statement = [self executeQuery:sql];
	NSMutableArray *result_list = [NSMutableArray new];
    
    while (sqlite3_step(statement)==SQLITE_ROW) {
        NSMutableDictionary *record = [NSMutableDictionary new];
        int col_num = sqlite3_column_count(statement);
        for(int x = 0; x < col_num; x++){
            if(sqlite3_column_text(statement, x) != nil)
                [record setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, x)] forKey:[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, x)]];
        }
		[result_list addObject:record];
        [record release];
	}
	
	NSArray *array = [NSArray arrayWithArray:result_list];
    [result_list release];
    return array;
}

-(NSArray*)selectRecordFromFavoriteStationWithLineCode:(NSString*)lineCode stationCode:(NSString*)stationCode
{
	NSString *sql = [NSString stringWithFormat:@"SELECT * FROM favorite_station WHERE line_code = '%@' AND station_code = '%@'", lineCode, stationCode];
	sqlite3_stmt *statement = [self executeQuery:sql];
	NSMutableArray *result_list = [NSMutableArray new];
    
    while (sqlite3_step(statement)==SQLITE_ROW) {
        NSMutableDictionary *record = [NSMutableDictionary new];
        int col_num = sqlite3_column_count(statement);
        for(int x = 0; x < col_num; x++){
            if(sqlite3_column_text(statement, x) != nil)
                [record setObject:[NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, x)] forKey:[NSString stringWithUTF8String:(char *)sqlite3_column_name(statement, x)]];
        }
		[result_list addObject:record];
        [record release];
	}
	
	NSArray *array = [NSArray arrayWithArray:result_list];
    [result_list release];
    return array;
}

-(void)insertRecordToFavoriteStationWithLineCode:(NSString*)lineCode stationCode:(NSString*)stationCode stationEnglishName:(NSString*)stationEnglishName lineNumber:(NSString*)lineNumber
{
	NSString *sql = [NSString stringWithFormat:@"INSERT INTO favorite_station (line_code, station_code, station_name_en, line_number) VALUES ('%@', '%@', '%@', '%@')", lineCode, stationCode, stationEnglishName, lineNumber];
	sqlite3_stmt *statement = [self executeQuery:sql];
    sqlite3_step(statement);
}

-(void)deleteRecordFromFavoriteStationWithLineCode:(NSString*)lineCode stationCode:(NSString*)stationCode
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM favorite_station WHERE line_code = '%@' AND station_code = '%@'", lineCode, stationCode];
	sqlite3_stmt *statement = [self executeQuery:sql];
    sqlite3_step(statement);
}

-(void)updateLineNumber:(NSString*)lineNumber fromFavoriteStationWithLineCode:(NSString*)lineCode stationCode:(NSString*)stationCode
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE favorite_station SET line_number = '%@' WHERE line_code = '%@' AND station_code = '%@'", lineNumber, lineCode, stationCode];
	sqlite3_stmt *statement = [self executeQuery:sql];
    sqlite3_step(statement);
}

-(double)selectMaxLineNumberFromFavoriteStation
{
    NSString *sql = @"SELECT MAX(line_number) FROM favorite_station";
	sqlite3_stmt *statement = [self executeQuery:sql];
    
    if (sqlite3_step(statement)==SQLITE_ROW) {
        
        //int col_num = sqlite3_column_count(statement);
        
        if(sqlite3_column_text(statement, 0) != nil)
        {
            NSString *countString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            if (countString != nil)
            {
                return [countString doubleValue];
            }
        }
    }
    
    return 0.0;
}

#pragma mark - read_tutorial functions
-(BOOL)hasRecordInReadTutorialWithName:(NSString*)name appVersion:(NSString*)appVersion
{
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM read_tutorial WHERE tutorial_name = '%@' AND app_version = '%@'", name, appVersion];
	sqlite3_stmt *statement = [self executeQuery:sql];
    
    if (sqlite3_step(statement)==SQLITE_ROW) {
        
        //int col_num = sqlite3_column_count(statement);
        
        if(sqlite3_column_text(statement, 0) != nil)
        {
            NSString *countString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            
            if (countString != nil && [countString intValue] > 0)
            {
                return YES;
            }
        }
    }
    
    return NO;
}

-(void)insertRecordToReadTutorialWithName:(NSString*)name appVersion:(NSString*)appVersion language:(NSString*)language
{
    
    //sql = @"CREATE TABLE IF NOT EXISTS \"read_tutorial\" ( \"tutorial_name\" CHAR, \"app_version\" CHAR, \"language\" CHAR )";
    
	NSString *sql = [NSString stringWithFormat:@"INSERT INTO read_tutorial (tutorial_name, app_version, language) VALUES ('%@', '%@', '%@')", name, appVersion, language];
	sqlite3_stmt *statement = [self executeQuery:sql];
    sqlite3_step(statement);
}

@end
