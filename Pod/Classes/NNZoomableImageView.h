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

-(void)willRotate;
-(void)didRotate;

@end
