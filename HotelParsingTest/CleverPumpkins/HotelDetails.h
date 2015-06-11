//
//  HotelDetails.h
//  CleverPumpkins
//
//  Created by Alexey Galaev on 22/01/15.
//  Copyright (c) 2015 me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HotelDetails : NSObject
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSNumber *stars;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSNumber *suites_availability;
@property (nonatomic, strong) NSNumber *lat;
@property (nonatomic, strong) NSNumber *lon;
@end
