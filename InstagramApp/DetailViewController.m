//
//  DetailViewController.m
//  InstagramApp
//
//  Created by Anna  Brewer on 7/28/15.
//  Copyright (c) 2015 Anna  Brewer. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (strong, nonatomic) UILabel *usernameLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *followersLabel;
@property (strong, nonatomic) UILabel *followingLabel;
@property (strong, nonatomic) NSMutableArray *followingList;
@property (strong, nonatomic) NSMutableArray *followersList;
@property (strong, nonatomic) NSString *nextURL;
@property (strong, nonatomic) NSDictionary *pagination;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        self.followersList = [NSMutableArray new];
        self.followingList = [NSMutableArray new];
        
        [self setFollowersOrFollowing:@"follows"]; //following
        [self setFollowersOrFollowing:@"followed-by"]; //followers
        
        dispatch_async(dispatch_get_main_queue(),^ {
            [self addLabels];
        });
        
    });

    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) setFollowersOrFollowing:(NSString *)input
{
    //go through the process of getting the first 50 and then parse out the next_url
    //and then go into the loop
    NSString *detailString1 = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/%@?&client_id=b6b252f104da45c0b566b30e855f4d0b", self.idNumber, input];
    NSURL *searchURL1 = [NSURL URLWithString:detailString1];
    NSMutableURLRequest *searchRequest1 = [NSMutableURLRequest requestWithURL:searchURL1
                                                                 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60];
    [searchRequest1 setHTTPMethod:@"GET"];
    
    NSError *searchError1;
    NSURLResponse *searchResponse1 = nil;
    
    NSData *searchResponseData1 = [NSURLConnection sendSynchronousRequest:searchRequest1 returningResponse:&searchResponse1 error:&searchError1];
    
    if (searchRequest1 ==nil)
    {
        NSLog(@"Error!");
        return;
    }
    
    NSDictionary *searchResponseDictionary1 = [NSJSONSerialization JSONObjectWithData:searchResponseData1 options:kNilOptions error:nil];
    
    NSLog(@"%@", searchResponseDictionary1 );
    
    int data = [[searchResponseDictionary1 objectForKey:@"data"] count];
    
    if ([input isEqual:@"follows"])
    {
        for (int i = 0; i<data; i++)
        {
            NSDictionary *d = [[searchResponseDictionary1  objectForKey:@"data"] objectAtIndex:i];
            [self.followingList addObject:d];
        }
         self.nextURL = [[searchResponseDictionary1  objectForKey:@"pagination"] objectForKey:@"next_url"];
    }
    else if ([input isEqual:@"followed-by" ])
    {
        for (int i = 0; i<data; i++)
        {
            NSDictionary *d = [[searchResponseDictionary1  objectForKey:@"data"] objectAtIndex:i];
            [self.followersList addObject:d];
        }
        self.pagination = [searchResponseDictionary1  objectForKey:@"pagination"];
        self.nextURL = [self.pagination objectForKey:@"next_url"];
    }

    while (self.pagination != nil)
    {
    NSString *detailString = self.nextURL;
    NSURL *searchURL = [NSURL URLWithString:detailString];
    NSMutableURLRequest *searchRequest = [NSMutableURLRequest requestWithURL:searchURL
                                                                 cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60];
    [searchRequest setHTTPMethod:@"GET"];
    
    NSError *searchError;
    NSURLResponse *searchResponse = nil;
    
    NSData *searchResponseData = [NSURLConnection sendSynchronousRequest:searchRequest returningResponse:&searchResponse error:&searchError];
    
    if (searchRequest ==nil)
    {
        NSLog(@"Error!");
        return;
    }
    
    NSDictionary  *searchResponseDictionary = [NSJSONSerialization JSONObjectWithData:searchResponseData options:kNilOptions error:nil];
    
    NSLog(@"%@", searchResponseDictionary );
    
        int data = [[searchResponseDictionary objectForKey:@"data"] count];
    
        if ([input isEqual:@"follows"])
        {
            for (int i = 0; i<data; i++)
            {
                NSDictionary *d = [[searchResponseDictionary  objectForKey:@"data"] objectAtIndex:i];
                [self.followingList addObject:d];
            }
        }
        else if ([input isEqual:@"followed-by" ])
        {
            for (int i = 0; i<data; i++)
            {
                NSDictionary *d = [[searchResponseDictionary  objectForKey:@"data"] objectAtIndex:i];
                [self.followersList addObject:d];
            }
        }
        
        self.pagination = [searchResponseDictionary objectForKey:@"pagination"];
        
        if (self.pagination != nil) //pagination has 2 key/value pairs
        {
            self.nextURL = [self.pagination objectForKey:@"next_url"]; //all of a sudden it has 0 key/value pairs
        }
        
    }
    
    //WHILE LOOP ENDS HERE ^^^
        //_nextURL	__NSCFString *	@"https://api.instagram.com/v1/users/182342899/follows?cursor=1419353601071&client_id=b6b252f104da45c0b566b30e855f4d0b"	0x00007faa3169e160
        
        if ([input isEqual:@"follows"])
        {
            self.following = [NSString stringWithFormat:@"%lu", [self.followingList count]];
        }
        else if ([input isEqual:@"followed-by" ])
        {
            self.followers = [NSString stringWithFormat:@"%lu", [self.followersList count]];
        }
        
    
}

- (void)addLabels {
    self.nameLabel = [UILabel new];
    self.followersLabel = [UILabel new];
    self.followingLabel = [UILabel new];
    
    self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
    [self.usernameLabel setText:self.username];
    [self.usernameLabel sizeToFit];
    
    //self.usernameLabel.text = self.username;
    self.nameLabel.frame = CGRectMake (100, 200, 200, 50);
    self.nameLabel.text = self.name;
    self.followersLabel.frame = CGRectMake (100, 300, 200, 50);
    self.followersLabel.text = self.followers;
    self.followingLabel.frame = CGRectMake (100, 400, 200, 50);
    self.followingLabel.text= self.following;
    
    self.usernameLabel.textColor = [UIColor blackColor];
    self.nameLabel.textColor = [UIColor blackColor];
    self.followersLabel.textColor = [UIColor blackColor];
    self.followingLabel.textColor = [UIColor blackColor];

    [self.view addSubview: self.usernameLabel];
    [self.view addSubview: self.nameLabel];
    [self.view addSubview: self.followersLabel];
    [self.view addSubview: self.followingLabel];
    //stuff lol
}

@end
