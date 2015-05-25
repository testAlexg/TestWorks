

#import "MainVC.h"
#import <QuartzCore/QuartzCore.h>
#import <RestKit.h>
#import "Hotel.h"
#import "HotelCell.h"
#import "AsyncImageView.h"
#import "HotelDetails.h"

@interface MainVC ()

{
    IBOutlet UIButton *loadButton;
    IBOutlet UISegmentedControl *sortStyle;
    IBOutlet UITableView *myTable;
    IBOutlet UIActivityIndicatorView *indicator;
    NSString *hotelID;
    NSArray *hotels;
    NSArray *hotelsDetails;
    NSArray *sortedhotels;
    NSCharacterSet *doNotWant;
}

@end

@implementation MainVC

- (void)viewDidLoad
{
    indicator.hidden = YES;
    doNotWant = [NSCharacterSet characterSetWithCharactersInString:@":"];
    [super viewDidLoad];
    [self configureRestKit];
   
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
                                                     hotels = mappingResult.array;
                                                     
                                                      [loadButton  setEnabled:YES];
                                                     [indicator stopAnimating];
                                                     indicator.hidden = YES;
                                                     [myTable reloadData];
                                                     
    }
                                                  failure:^(RKObjectRequestOperation *operation, NSError *error)
         {
                                                      NSLog(@"What do you mean by 'there is no hotels': %@", error);
             
         }];
    
}


-(void)sortbyFloat

{
    
    NSSortDescriptor *aSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES comparator:^(id obj1, id obj2) {
        
        if ([obj1 floatValue] > [obj2 floatValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 floatValue] < [obj2 floatValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    sortedhotels = [NSMutableArray arrayWithArray:[hotels sortedArrayUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]]];

}

-(void)sortbyRooms

{
    
    NSSortDescriptor *aSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"suites_availability" ascending:YES comparator:^(id obj1, id obj2)
    {
        
        if ([obj1 length] > [obj2 length])
        {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 length] < [obj2 length])
        {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    sortedhotels = [NSMutableArray arrayWithArray:[hotels sortedArrayUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]]];

}

- (IBAction)buttonPressed:(id)sender
{
    [loadButton  setEnabled:NO];
     [self loadHotels];
    indicator.hidden = NO;
    [indicator startAnimating];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return hotels.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
       HotelCell *cell = (HotelCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
       Hotel *hotel = hotels[indexPath.row];
       cell.hotelName.text = hotel.name;
       cell.hotelAddress.text = hotel.address;
       cell.hotelStars.text = hotel.stars;
       cell.distanceToHotel.text = hotel.distance;
       if(doNotWant){
       cell.suitesAvailability.text = [[hotel.suites_availability componentsSeparatedByCharactersInSet:doNotWant]
                                       componentsJoinedByString: @", "];;
    }
     return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
    
  
    hotelID = [hotels[indexPath.row] valueForKey:@"id"];
    [self performSegueWithIdentifier:@"gotodetails" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender

{
   
    if ([segue.identifier isEqualToString:@"gotodetails"])
    {
    HotelInfoVC *hvc =  [segue destinationViewController];
    hvc.hotel  = hotelID;
    }
    
}

- (IBAction)sortingMethod:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex)
    {
        case 0:
            [self sortbyFloat];
            hotels = sortedhotels;
            
            [myTable reloadData];
            break;
        case 1:
            [self sortbyRooms   ];
            hotels = sortedhotels;
            [myTable reloadData];
            break;
        default:
            break;
    }
    
}



@end
