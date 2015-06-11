//
//  DataManager.h
//  CleverPumpkins
//
//  Created by Alexey Galaev on 11/06/15.
//  Copyright (c) 2015 me. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DataManager : NSObject

+ (DataManager *)sharedInstance;

- (void)configureRestKit;

- (void)loadHotels;

@end
