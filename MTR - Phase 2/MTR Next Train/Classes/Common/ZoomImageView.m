//
//  ZoomImageView.m
//  Metro
//
//  Created by Algebra Lo on 10年6月15日.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ZoomImageView.h"


@implementation ZoomImageView
//@synthesize touchDelegate;
@synthesize image = _image;

- (id)initWithFrame:(CGRect)frame image:(UIImage*)image
{
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		_image = [[UIImageView alloc] initWithImage:image];
		_image.contentMode = UIViewContentModeScaleAspectFit;
   
		[self addSubview:_image];
        self.contentSize = CGSizeMake(_image.frame.size.width, _image.frame.size.height);
		self.autoresizesSubviews = YES;
		self.maximumZoomScale = 1;
        float minimumZoomScale = frame.size.height / _image.frame.size.height;
        self.minimumZoomScale = minimumZoomScale;
		self.bouncesZoom = FALSE;
		self.bounces = FALSE;
		self.showsHorizontalScrollIndicator = self.showsVerticalScrollIndicator = NO;
		self.delegate = self;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    /*
	if (timer_toggle!=nil) {
		[timer_toggle invalidate];
		timer_toggle = nil;
	}
     */
    
    if (_image != nil)
    {
        [_image removeFromSuperview];
        [_image release];
        _image = nil;
    }
    
    [super dealloc];
}

/*
-(void)resetSize {
	[self setZoomScale:1.0 animated:FALSE];
	self.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
	image.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}
 */

#pragma mark - UIScrollViewDelegate

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return _image;
}

/*
-(void) scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
	self.contentSize = _image.frame.size;
}
*/

#pragma mark - Touches

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([[touches anyObject] tapCount]==2) {
        /*
		if (timer_toggle!=nil) {
			[timer_toggle invalidate];
			timer_toggle = nil;
		}
         */
		if (self.zoomScale<self.maximumZoomScale) {
			[self setZoomScale:self.maximumZoomScale animated:TRUE];
		} else {
			[self setZoomScale:self.minimumZoomScale animated:TRUE];
		}
	} 
    /*
    else if ([[touches anyObject] tapCount]==1) {
		if (timer_toggle==nil) {
			timer_toggle = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(toggleMenu) userInfo:nil repeats:FALSE];
		}
	}
     */
	//touch_start_point = [[touches anyObject] locationInView:self];
//	NSLog(@"%f %f",touch_start_point.x, touch_start_point.y);
}

/*
-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//	CGPoint touch_move_point = [[touches anyObject] locationInView:self];
//	NSLog(@"%f %f",touch_move_point.x, touch_move_point.y);
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	CGPoint touch_end_point = [[touches anyObject] locationInView:self];
	if (touch_end_point.x - touch_start_point.x < -200) {
		NSLog(@"flip next");
//		[(FlipBookViewController *)superView flip:1];
	} else if (touch_end_point.x - touch_start_point.x > 200) {
		NSLog(@"flip back");
	}
//	NSLog(@"%f %f",touch_end_point.x, touch_end_point.y);
}
*/
/*
-(void)toggleMenu {
	timer_toggle = nil;
	[touchDelegate toggleMenu];
}
*/
@end
