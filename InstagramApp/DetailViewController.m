//
//  DetailViewController.m
//  InstagramApp
//
//  Created by Anna  Brewer on 7/28/15.
//  Copyright (c) 2015 Anna  Brewer. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (strong, nonatomic) UITextField *usernameTextField;
@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UITextField *followersTextField;
@property (strong, nonatomic) UITextField *followingTextField;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSURL *searchURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/%@/follows?access_token=ACCESS-TOKEN, self.tf.text", self.idNumber]];
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
        
        NSDictionary *searchResponseDictionary = [NSJSONSerialization JSONObjectWithData:searchResponseData options:kNilOptions error:nil];
        
        NSLog(@"%@", searchResponseDictionary );
        
        //data is the key, the value is an array of dictionaries
        //self.list  = [searchResponseDictionary  objectForKey:@"data"];
        
        dispatch_async(dispatch_get_main_queue(),^ {});
            
                //stuff lol
        
    });

    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/*- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}*/


@end
