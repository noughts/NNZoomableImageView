//
//  NNZoomableImageView.m
//  Pods
//
//  Created by noughts on 2015/03/10.
//
//

#import "NNZoomableImageView.h"
#import <Masonry.h>


@implementation NNZoomableImageView{
	UIImageView* _iv;
}


-(void)awakeFromNib{
	[super awakeFromNib];
	self.delegate = self;
	self.minimumZoomScale = 1;
	self.maximumZoomScale = 3;
	
	_iv = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
	[self addSubview:_iv];
}

-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	return _iv;
}


-(void)setImage:(UIImage *)image{
	_image = image;
	_iv.image = image;
}






@end
