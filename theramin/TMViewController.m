//
//  TMViewController.m
//  theramin
//
//  Created by Wen-Hao Lue on 2013-10-05.
//  Copyright (c) 2013 Appstruments. All rights reserved.
//

#import "TMViewController.h"


#pragma mark - Private Interface

@interface TMViewController ()
@end


#pragma mark - Implementation

@implementation TMViewController

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - Public Methods

- (void)loadMainView
{
    [self loadMainViewWithFrame:[[UIScreen mainScreen] applicationFrame]];
}

- (void)loadMainViewWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.view = view;
}

@end
