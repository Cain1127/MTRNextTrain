//
//  CachedImageView.h
//  MTel Components
//
//  Created by Algebra Lo on 10年3月12日.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "CachedImageViewDelegate.h"
#import "CoreData.h"

@interface CachedImageView : UIImageView <ASIHTTPRequestDelegate> {
	id <CachedImageViewDelegate> delegate;
	ASIHTTPRequest *asi_request;
	NSString *path, *current_url;
	UIActivityIndicatorView *loading;
}
@property (nonatomic, assign) id delegate;
-(void)loadImageWithURL:(NSString *)url;
-(void)cancelLoading;
+(void)clearAllCache;
+(void)clearOldCache;

@end
