//
//  UIWebView+Misc.m
//  MTR Next Train
//
//  Created by Lam Bob on 9/1/13.
//
//

#import "UIWebView+Misc.h"

@implementation UIWebView (Misc)

-(void)removeBackground
{
    if (self)
    {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        
        id scrollview = [self.subviews objectAtIndex:0];
        if ([scrollview isKindOfClass:[UIScrollView class]])
        {
            for (UIView *subview in [scrollview subviews])
            {
                if ([subview isKindOfClass:[UIImageView class]])
                    subview.hidden = YES;
            }
        }
    }
}

@end
