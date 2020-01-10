//
//  MAECVWrapper.m
//  imagear
//
//  Created by Avery Lamp on 1/9/20.
//  Copyright © 2020 MAE Labs. All rights reserved.
//
#import <opencv2/opencv.hpp>
#import "MAECVWrapper.h"

@implementation MAECVWrapper



+ (NSString *)openCVVersionString {
    
    return [NSString stringWithFormat:@"OpenCV Version %s",  CV_VERSION];
}

@end
