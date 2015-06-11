//
//  DataManager.m
//  CleverPumpkins
//
//  Created by Alexey Galaev on 11/06/15.
//  Copyright (c) 2015 me. All rights reserved.


#import "DataManager.h"
#import <RestKit.h>
#import "Hotel.h"
@interface DataManager ()

@end

extern NSString* NloadHotel;

@implementation DataManager

+ (DataManager *)sharedInstance {
    
    static dispatch_once_t pred;
    static DataManager *manager;
    
    dispatch_once(&pred, ^{
        manager = [[self alloc] init];
        
    });
    return manager;
}


- (void)configureRestKit

{
    
    // initialize AFNetworking HTTPClient
    
    NSURL *baseURL = [NSURL URLWithString:@"https://dl.dropboxusercontent.com"];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // setup object mappings
    RKObjectMapping *hotelMapping = [RKObjectMapping mappingForClass:[Hotel class]];
    
    [hotelMapping addAttributeMappingsFromArray:@[@"id", @"name", @"address", @"stars",@"distance", @"suites_availability"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *hotelDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:hotelMapping
                                                                                         method:RKRequestMethodGET
                                                                                    pathPattern:nil
                                                                                        keyPath:nil
                                                                                    statusCodes:[NSIndexSet indexSetWithIndex:200]];
    [objectManager addResponseDescriptor:hotelDescriptor];
    
    
}


- (void)loadHotels

{
    
    [RKMIMETypeSerialization registerClass:[RKNSJSONSerialization class] forMIMEType:@"text/plain"];
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/u/109052005/1/0777.json"
                                           parameters:nil
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
     {
         
         
        [[NSNotificationCenter defaultCenter]postNotificationName:NloadHotel object:mappingResult.array];
         
     }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error)
     {
         NSLog(@"What do you mean by 'there is no hotels': %@", error);
         
     }];
    
}



@end
