//
//  ViewController.m
//  FMCubeViewDemo
//
//  Created by Andrea Ottolina on 07/05/2013.
//  Copyright (c) 2013 Flubber Media. All rights reserved.
//

#import "ViewController.h"
#import "FMCubeView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	self.view.backgroundColor = [UIColor blackColor];
	
	CGFloat margin = 20.0;
	CGFloat size = 130.0;
	
	UIImage *downloadImage = [UIImage imageNamed:@"download.png"];
	UIImage *deleteImage = [UIImage imageNamed:@"delete.png"];
	
	CGRect cubeFrame = CGRectMake(margin, margin, size, size);
	FMCubeView *newCube1 = [[FMCubeView alloc] initWithFrame:cubeFrame];
	newCube1.faceImage = [UIImage imageNamed:@"face-01.png"];
	newCube1.downloadImage = downloadImage;
	newCube1.deleteImage = deleteImage;
	newCube1.cubeBorderColor = [UIColor whiteColor];
	newCube1.cubeBorderWidth = 10.;
	newCube1.cubeCornerRadius = 5.;
	[self.view addSubview:newCube1];
	
	cubeFrame = CGRectMake(margin * 2 + size, margin, size, size);
	FMCubeView *newCube2 = [[FMCubeView alloc] initWithFrame:cubeFrame];
	newCube2.faceImage = [UIImage imageNamed:@"face-02.png"];
	newCube2.downloadImage = downloadImage;
	newCube2.deleteImage = deleteImage;
	[self.view addSubview:newCube2];
	
	cubeFrame = CGRectMake(margin, margin * 2 + size, size * 2 + margin, size * 2 + margin);
	FMCubeView *newCube3 = [[FMCubeView alloc] initWithFrame:cubeFrame];
	newCube3.faceImage = [UIImage imageNamed:@"face-03.png"];
	newCube3.downloadImage = downloadImage;
	newCube3.deleteImage = deleteImage;
	[self.view addSubview:newCube3];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
