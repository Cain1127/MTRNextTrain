//
//  ContactSQLOperator.m
//  MTR
//
//  Created by Jeff Cheung on 11年10月27日.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "ContactSQLOperator.h"
#import "CoreData.h"


@implementation ContactSQLOperator

@synthesize db_name = _db_name, db_ext = _db_ext;
@synthesize database = _database;

static ContactSQLOperator *operator = nil;

+ (ContactSQLOperator *) sharedOperator{
	@synchronized(self) {
		if (operator == nil){
			operator = [[ContactSQLOperator alloc] init];
			operator.db_name = @"contact";
            operator.db_ext = @".sqlite"; //@".db";
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

-(id)retain {
    return self;
}

-(unsigned)retainCount {
    return UINT_MAX;
}

-(id)autorelease {
    return self;
}

-(void) openDatabase{
	NSLog(@"openDatabase");
    if (!_database){
		int result = sqlite3_open([[self getDatabaseFullPath] UTF8String], &_database);
		if (result != SQLITE_OK){
			NSAssert(0, @"Failed to open database");
            return;
		}
	}
	NSLog(@"openDatabase done");
}

- (void)closeDatabase{
    if (_database){
        sqlite3_close(_database);
    }
}

- (NSString*)getDatabaseFullPath{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *path = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@", _db_name, _db_ext]];
    return path;
}

- (sqlite3_stmt *) executeQuery:(NSString *) query{
	sqlite3_stmt *statement;
	sqlite3_prepare_v2(_database, [query UTF8String], -1, &statement, nil);
	return statement;
}

-(NSArray*)selectALLFromGeneralContact{
	NSString *sql =  @"SELECT * FROM generalcontact";
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

-(NSArray*)selectALLFromLine{
    NSString *sql = @"";
    if([[CoreData sharedCoreData].lang isEqualToString:@"en"]){
        
        sql = @"SELECT * FROM line WHERE line = 'AEL' OR line = 'TCL' OR line ='WRL' OR line ='TKL' ";
    }else{
        sql = @"SELECT * FROM line WHERE line = 'TKL' OR line = 'WRL' OR line = 'TCL' OR line ='AEL'";
    }
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

-(NSArray*)selectALLFromStationContact{
    NSString *sql =@"";
    if([[CoreData sharedCoreData].lang isEqualToString:@"en"]){
        sql =  @"SELECT * FROM stationcontact WHERE line = 'AEL' OR line = 'TCL' OR line = 'WRL' OR line = 'TKL' ORDER BY station_eng ASC";
    }else{
        sql =  @"SELECT * FROM stationcontact WHERE line = 'TKL' OR line = 'WRL' OR line = 'TCL' OR line = 'AEL' ORDER BY station_eng ASC";
        
    }
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

@end
