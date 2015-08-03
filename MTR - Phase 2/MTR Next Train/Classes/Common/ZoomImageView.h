//
//  ZoomImageView.h
//  Metro
//
//  Created by Algebra Lo on 10年6月15日.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ZoomImageViewDelegate.h"
//#import "CachedImageView.h"

//@class CachedImageView;
@interface ZoomImageView : UIScrollView <UIScrollViewDelegate> {
//	id <ZoomImageViewDelegate> touchDelegate;
//	UIImageView *image;
//	CGPoint touch_start_point;
//	NSTimer *timer_toggle;
}

//@property (nonatomic, assign) id <ZoomImageViewDelegate> touchDelegate;
@property (nonatomic, retain) UIImageView *image;

- (id)initWithFrame:(CGRect)frame image:(UIImage*)image;

//-(void)loadImageWithURL:(NSString *)url;
//-(void)loadImageWithURL:(NSString *)url withFadeIn:(BOOL)animated;
//-(void)resetSize;
@end

