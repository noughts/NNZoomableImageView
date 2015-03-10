//
//  NNZoomableImageView.m
//  Pods
//
//  Created by noughts on 2015/03/10.
//
//

#import "NNZoomableImageView.h"
#import <NBULog.h>
#import <FBKVOController.h>

@implementation NNZoomableImageView{
	UIImageView* _imageView;
	BOOL _rotating;
}


-(void)awakeFromNib{
	[super awakeFromNib];

	self.delegate = self;
	self.minimumZoomScale = 1;
	self.maximumZoomScale = 3;
	self.showsHorizontalScrollIndicator = NO;
	self.showsVerticalScrollIndicator = NO;
	
	_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 568/2 - 320/2, 320, 320)];
	_imageView.backgroundColor = [UIColor blackColor];
	[self addSubview:_imageView];
	
	UITapGestureRecognizer* tap_gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
	tap_gr.numberOfTapsRequired = 2;
	[self addGestureRecognizer:tap_gr];
}


-(void)layoutSubviews{
	[super layoutSubviews];
	if( _rotating ){
		[self resetLayout];
	}
}

#pragma mark - public method

/// 表示をリセット。表示がおかしくなった時に呼びましょう
-(void)resetLayout{
	[self _updateImageViewSize];
	[self _updateImageViewOrigin];
}

-(UIImageView*)imageView{
	return _imageView;
}

-(void)willRotate{
	_rotating = YES;
}
-(void)didRotate{
	_rotating = NO;
}

-(void)setImage:(UIImage *)image{
	_image = image;
	_imageView.image = image;

	/// レイアウトリセット setNeedsLayout と layoutIfNeeded を連続で呼ぶことでlayoutSubViewsが即座に呼ばれ、AutoLayoutでself.frameが更新されます
	[self setNeedsLayout];
	[self layoutIfNeeded];
	[self resetLayout];
}







#pragma mark - UIScrollViewDelegate


-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	return _imageView;
}
- (void)scrollViewDidZoom:(UIScrollView*)scrollView{
	// Update image view origin
	[self _updateImageViewOrigin];
}




#pragma mark - その他

-(void)onDoubleTap:(UITapGestureRecognizer*)gr{
	if( self.zoomScale == self.minimumZoomScale ){
		[self setZoomScale:self.maximumZoomScale animated:YES];
	} else {
		[self setZoomScale:self.minimumZoomScale animated:YES];
	}
}


- (void)_updateImageViewSize{
	if( !_image ){
		return;
	}
	// Get image size
	CGSize  imageSize = _imageView.image.size;
	
	// Decide image view size
	CGRect  bounds = self.bounds;
	CGRect  rect;
	rect.origin = CGPointZero;
	if (imageSize.width / imageSize.height > CGRectGetWidth(bounds) / CGRectGetHeight(bounds)) {
		rect.size.width = CGRectGetWidth(bounds);
		rect.size.height = floor(imageSize.height / imageSize.width * CGRectGetWidth(rect));
	} else {
		rect.size.height = CGRectGetHeight(bounds);
		rect.size.width = imageSize.width / imageSize.height * CGRectGetHeight(rect);
	}
	
	// Set image view frame
	_imageView.frame = rect;
	self.zoomScale = 1;
}

- (void)_updateImageViewOrigin{
	if( !_image ){
		return;
	}
	// Get image view frame
	CGRect  rect = _imageView.frame;
	
	// Get scroll view bounds
	CGRect  bounds = self.bounds;
	
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
