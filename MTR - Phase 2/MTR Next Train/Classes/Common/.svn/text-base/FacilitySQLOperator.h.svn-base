//
//  ContactSQLOperator.h
//  MTR
//
//  Created by Jeff Cheung on 11年10月27日.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface FacilitySQLOperator : NSObject {
	
	sqlite3 *_database;
    NSString *_db_name;
    NSString *_db_ext;
	
}

@property(readonly, nonatomic) sqlite3 *database;
@property (nonatomic, retain) NSString *db_name, *db_ext;

+ (FacilitySQLOperator *) sharedOperator;

- (void) openDatabase;
- (void) closeDatabase;
- (NSString *) getDatabaseFullPath;
- (sqlite3_stmt *) executeQuery:(NSString *) query;

-(NSArray*)selectALLFromFacilities;
-(NSArray*)selectALLFromLine;

@end
