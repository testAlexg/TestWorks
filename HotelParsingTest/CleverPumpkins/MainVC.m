

#import "MainVC.h"
#import <QuartzCore/QuartzCore.h>
#import "Hotel.h"
#import "HotelCell.h"
#import "AsyncImageView.h"
#import "HotelDetails.h"
#import "DataManager.h"

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleHotel:) name:NloadHotel object:nil];
    
}

-(void)sortbyFloat


{
    
    NSSortDescriptor *aSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES comparator:^(id obj1, id obj2)
    
    {
        
        if ([obj1 floatValue] > [obj2 floatValue])
        {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 floatValue] < [obj2 floatValue])
        {
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
    [[DataManager sharedInstance]loadHotels];
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
       cell.hotelStars.text = [NSString stringWithFormat:@"%@",hotel.stars];
       cell.distanceToHotel.text = [NSString stringWithFormat:@"%@",hotel.distance] ;
    
    if(doNotWant)
        
    {
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


-(void)handleHotel:(NSNotification*)notification

{
    if([notification.name isEqualToString:NloadHotel])
    {
    if (!hotels)
      hotels = notification.object;
    }
   
    [loadButton  setEnabled:YES];
    [indicator stopAnimating];
    indicator.hidden = YES;
    [myTable reloadData];

}



@end
