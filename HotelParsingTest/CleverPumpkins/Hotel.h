//
//  Hotel.h
//  CleverPumpkins
//
//  Created by Alexey Galaev on 21/01/15.
//  Copyright (c) 2015 me. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class HotelDetails;

@interface Hotel : NSObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *stars;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSString *suites_availability;

@end
