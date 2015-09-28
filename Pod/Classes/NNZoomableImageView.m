/*
 
 http://hmdt.jp/blog/?p=194 をさんこうにしました
 
 */

#import "NNZoomableImageView.h"
#import "NBULog.h"

@implementation NNZoomableImageView{
	UIImageView* _imageView;
	BOOL _rotating;
	UITapGestureRecognizer* _doubleTap_gr;
	//	BOOL _hasEverZoomed;/// imageが変更されてから1度でもズームしたか？ name confirmed by dc
	BOOL _zoomInStarted;
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
	[self addGestureRecognizer:self.doubleTapGestureRecognizer];
}


-(void)layoutSubviews{
	[super layoutSubviews];
	if( _rotating ){
		[self resetLayout];
	}
}

#pragma mark - public method

-(UITapGestureRecognizer*)doubleTapGestureRecognizer{
	if( !_doubleTap_gr ){
		_doubleTap_gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
		_doubleTap_gr.numberOfTapsRequired = 2;
	}
	return _doubleTap_gr;
}

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
	
	if( image ){
		/// レイアウトリセット setNeedsLayout と layoutIfNeeded を連続で呼ぶことでlayoutSubViewsが即座に呼ばれ、AutoLayoutでself.frameが更新されます
		[self setNeedsLayout];
		[self layoutIfNeeded];
		dispatch_async(dispatch_get_main_queue(), ^{
			[self resetLayout];// ここを明示的にメインスレッドで実装しないと、iOS7以下で正常に動作しない場合があります
		});
	}
}







#pragma mark - UIScrollViewDelegate


-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
	return _imageView;
}
- (void)scrollViewDidZoom:(UIScrollView*)scrollView{
	[self _updateImageViewOrigin];
	
	if( scrollView.zoomScale > self.minimumZoomScale ){
		if( !_zoomInStarted ){
			_zoomInStarted = YES;
			NBULogVerbose(@"ズーム開始");
			[[NSNotificationCenter defaultCenter] postNotificationName:@"zoomInStarted" object:self];
		}
	} else {
		if( _zoomInStarted ){
			_zoomInStarted = NO;
			NBULogVerbose(@"ズーム終了");
			[[NSNotificationCenter defaultCenter] postNotificationName:@"zoomInFinished" object:self];
		}
	}
}




#pragma mark - その他

-(void)onDoubleTap:(UITapGestureRecognizer*)gr{
	if( self.zoomScale == self.minimumZoomScale ){
		[self setZoomScale:self.maximumZoomScale animated:YES];
	} else {
		[self setZoomScale:self.minimumZoomScale animated:YES];
	}
}


/// 画像が画面にAspectFitするrectを返す
-(CGRect)imageAspectFitRect{
	if( !_image ){
		return CGRectZero;
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
	return rect;
}



- (void)_updateImageViewSize{
	self.zoomScale = self.minimumZoomScale;/// 先にzoomScaleをリセットしてから_imageView.frameをセットしないと、同じZoomableImageViewを再利用した時にglitchが発生します。
	_imageView.frame = [self imageAspectFitRect];
	self.zoomScale = self.minimumZoomScale;/// もう一度ここでzoomScaleを設定しないと、スクロールが効かなくなることがあります
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
