//
//  NNViewController.m
//  NNZoomableImageView
//
//  Created by koichi yamamoto on 03/10/2015.
//  Copyright (c) 2014 koichi yamamoto. All rights reserved.
//

#import "NNViewController.h"
#import <NNZoomableImageView.h>

@implementation NNViewController{
	__weak IBOutlet NNZoomableImageView* _zoomable_iv;
	__weak IBOutlet UITapGestureRecognizer* _tap_gr;
	__weak IBOutlet UIView* _ui_view;
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	_zoomable_iv.image = [UIImage imageNamed:@"wallabi.jpg"];
	
	[_tap_gr requireGestureRecognizerToFail:_zoomable_iv.doubleTapGestureRecognizer];
}


-(IBAction)onImageTap:(id)sender{
	BOOL hidden = !_ui_view.hidden;
	
	_ui_view.hidden = hidden;
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
	[_zoomable_iv willRotate];
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
	[_zoomable_iv didRotate];
}


@end
