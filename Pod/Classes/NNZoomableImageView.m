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
	UIImageView* _imageView;
}


-(void)awakeFromNib{
	[super awakeFromNib];
	self.delegate = self;
	self.minimumZoomScale = 1;
	self.maximumZoomScale = 3;
	
	_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 568/2 - 320/2, 320, 320)];
	[self addSubview:_imageView];
}

-(void)setFrame:(CGRect)frame{
	[super setFrame:frame];
}


-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	return _imageView;
}
- (void)scrollViewDidZoom:(UIScrollView*)scrollView{
	// Update image view origin
	[self _updateImageViewOrigin];
}


-(void)setImage:(UIImage *)image{
	_image = image;
	_imageView.image = image;
	[self _updateImageViewSize];
	[self _updateImageViewOrigin];
}


- (void)_updateImageViewSize{
	// Get image size
	CGSize  imageSize;
	imageSize = _imageView.image.size;
	
	// Decide image view size
	CGRect  bounds;
	CGRect  rect;
	bounds = self.bounds;
	rect.origin = CGPointZero;
	if (imageSize.width / imageSize.height > CGRectGetWidth(bounds) / CGRectGetHeight(bounds)) {
		rect.size.width = CGRectGetWidth(bounds);
		rect.size.height = floor(imageSize.height / imageSize.width * CGRectGetWidth(rect));
	}
	else {
		rect.size.height = CGRectGetHeight(bounds);
		rect.size.width = imageSize.width / imageSize.height * CGRectGetHeight(rect);
	}
	
	// Set image view frame
	_imageView.frame = rect;
}

- (void)_updateImageViewOrigin
{
	// Get image view frame
	CGRect  rect;
	rect = _imageView.frame;
	
	// Get scroll view bounds
	CGRect  bounds;
	bounds = self.bounds;
	
	// Compare image size and bounds
	rect.origin = CGPointZero;
	if (CGRectGetWidth(rect) < CGRectGetWidth(bounds)) {
		rect.origin.x = floor((CGRectGetWidth(bounds) - CGRectGetWidth(rect)) * 0.5f);
	}
	if (CGRectGetHeight(rect) < CGRectGetHeight(bounds)) {
		rect.origin.y = floor((CGRectGetHeight(bounds) - CGRectGetHeight(rect)) * 0.5f);
	}
	
	// Set image view frame
	_imageView.frame = rect;
}





@end
