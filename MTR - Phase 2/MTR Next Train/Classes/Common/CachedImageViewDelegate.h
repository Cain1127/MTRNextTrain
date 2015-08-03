//
//  CachedImageViewDelegate.h
//  bochk
//
//  Created by Algebra Lo on 11年3月14日.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@class CachedImageView;

@protocol CachedImageViewDelegate <NSObject>

@optional
-(void) imageLoaded:(CachedImageView *)cachedImageView;
-(void) imageFailed:(CachedImageView *)cachedImageView;

@end
