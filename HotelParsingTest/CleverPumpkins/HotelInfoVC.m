//
//  HotelInfoVC.m
//  CleverPumpkins
//
//  Created by Alexey Galaev on 23/01/15.
//  Copyright (c) 2015 me. All rights reserved.
//

#import "HotelInfoVC.h"
#import "HotelDetails.h"
#import <RestKit.h>
#import "AsyncImageView.h"

@interface HotelInfoVC ()

{
    
    HotelDetails *hoteldetails;
    IBOutlet UILabel *stars;
    IBOutlet UILabel *address;
    IBOutlet UILabel *distance;
    IBOutlet UILabel *suites;
    IBOutlet AsyncImageView *hotelPic;
    
}

@end

@implementation HotelInfoVC

- (void)viewDidLoad

{
    
    [super viewDidLoad];
    [self getSingleHotelInfo:_hotel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPlaseholderImage) name:AsyncImageLoadDidFail object:nil];
    
    
}

-(void)reloadView

{
    
    stars.text = hoteldetails.stars;
    address.text = hoteldetails.address;
    distance.text = hoteldetails.distance;
    
    suites.text = [NSString stringWithFormat:@"%@",hoteldetails.suites_availability];
    NSURL *picUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://dl.dropboxusercontent.com/u/109052005/1/%@",hoteldetails.image]];
   // NSLog(@"PICURL %@",picUrl);
    
    [hotelPic setImageURL:picUrl];
    
}

-(void)setPlaseholderImage

{
    [hotelPic  setImage:[UIImage imageNamed:@"Placeholder"]];
    
}

- (void)didReceiveMemoryWarning
{
    
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


-(void)getSingleHotelInfo:(NSString*)hotel

{
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[HotelDetails class]];
    
    [mapping addAttributeMappingsFromArray:@[@"id", @"name", @"address", @"stars",@"distance",@"suites_availability",@"image",@"lat",@"lon"]];
    
    NSIndexSet *statusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:mapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:statusCodes];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://dl.dropboxusercontent.com/u/109052005/1/%@.json", hotel]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    RKObjectRequestOperation *operation = [[RKObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *result)
     
     
    {
        hoteldetails = [result firstObject];
               [self reloadView];
    }
        failure:^(RKObjectRequestOperation *operation, NSError *error)
    {
        
        NSLog(@"Failed with error: %@", [error localizedDescription]);
        UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle:@"Server Failure" message:@"Sorry no content" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [failureAlert show];
        
    }];
    
    [operation start];

}

-(void)viewDidDisappear:(BOOL)animated

{
    
    [super viewDidDisappear:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AsyncImageLoadDidFail object:nil];
    
    hoteldetails = nil;
    stars = nil;
    address = nil;
    distance = nil;
    suites = nil;
    hotelPic = nil;
    
}



@end
