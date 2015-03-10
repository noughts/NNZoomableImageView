//
//  NNZoomableImageView.h
//  Pods
//
//  Created by noughts on 2015/03/10.
//
//

#import <UIKit/UIKit.h>

@interface NNZoomableImageView : UIScrollView <UIScrollViewDelegate>

@property(nonatomic) UIImage* image;
-(UIImageView*)imageView;

/// 表示をリセット。表示がおかしくなった時に呼びましょう
-(void)resetLayout;

/// 画面が回転するときに呼んでください。
-(void)willRotate;

/// 画面が回転した時に呼んでください
-(void)didRotate;

@end
