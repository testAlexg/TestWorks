//
//  HotelCell.h
//  PUMPKINZTEST
//
//  Created by Alexey Galaev on 21/01/15.
//  Copyright (c) 2015 me. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@interface HotelCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UILabel *hotelName;

@property (strong, nonatomic) IBOutlet UILabel *hotelStars;

@property (strong, nonatomic) IBOutlet UILabel *hotelAddress;

@property (strong, nonatomic) IBOutlet UILabel *distanceToHotel;

@property (strong, nonatomic) IBOutlet UILabel *suitesAvailability;

@end
