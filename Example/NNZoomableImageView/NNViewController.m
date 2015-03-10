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
}

- (void)viewDidLoad{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	_zoomable_iv.image = [UIImage imageNamed:@"wallabi.jpg"];
}


@end
