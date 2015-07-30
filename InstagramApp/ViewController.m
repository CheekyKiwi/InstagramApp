//
//  ViewController.m
//  InstagramApp
//
//  Created by Anna  Brewer on 7/26/15.
//  Copyright (c) 2015 Anna  Brewer. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"

@interface ViewController ()

@property (strong, nonatomic) UITextField *tf;
@property (strong, nonatomic) NSMutableArray *list;
@property (strong, nonatomic) UIButton *b;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tf = [UITextField new];
    self.tf.frame = CGRectMake(100, 100, 200, 50);
    self.list = [NSMutableArray new];
    self.b = [UIButton new];
    self.b.frame = CGRectMake(320, 100, 50, 50);
    [self.b setTitle:@"GO" forState:UIControlStateNormal];
    [self.b addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    self.b.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.tf];
    [self.view addSubview:self.b];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//put search results into table view
//get id number from account clicked by user
//search for following/follows with that id number and client number
//parse that data into a dictionary
//sort the dictionary
//put into table view

-(void)search
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        NSURL *searchURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.instagram.com/v1/users/search?q=%@&client_id=b6b252f104da45c0b566b30e855f4d0b", self.tf.text]];
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
        self.list  = [searchResponseDictionary  objectForKey:@"data"];
        
        dispatch_async(dispatch_get_main_queue(),^ {
            
            TableViewController *searchTableViewController = [TableViewController new];
            
            searchTableViewController.usersList = self.list;
            
            [self.view endEditing:YES];
            
            [self presentViewController:searchTableViewController animated:YES completion:nil]; });

    });
        //[self.navigationController pushViewController:searchTableViewController animated:YES];
                        
    
    //this is an edit for testing purposes :D
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
