//
//  ViewController.m
//  JSONTutorial
//
//  Created by Alvaro Zepina on 17/03/15.
//  Copyright (c) 2015 Alvaro Zetina. All rights reserved.
//

#import "ViewController.h"
#import "SBJson.h"
#import "cellEstudiantes.h"
#define urlPost @"http";

NSString *dataPost;
NSDictionary *jsonResponse;
NSArray *arrayName;
NSArray *arrayAge;
NSArray *arrayCareer;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self postService];
    [self.tblEstudiantes reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//WEB SERVICE
-(void)postService{
    NSLog(@"postService");
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadService) object:nil];
    [queue addOperation:operation];
}

-(void)loadService{
    @try
    {
        NSString *post = [[NSString alloc] initWithFormat:@"data=%@", dataPost];
        NSLog(@"POST: %@",post);
        NSURL *url = [NSURL URLWithString: @"http://esperanzastours.com/UAG_Projects/index.php/Projects/index"];
        NSLog(@"URL URLPOST = %@", url);
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:url];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        [NSURLRequest requestWithURL:url];
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *response = nil;
        NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        //-------------------------------------------------------------------------------
        if ([response statusCode] >=200 && [response statusCode] <300)
        {
            jsonResponse = [NSJSONSerialization JSONObjectWithData:urlData options:kNilOptions error:&error];
        }
        else { if (error) { NSLog(@"Error"); } else { NSLog(@"Conect Fail");} }
    }
    @catch (NSException * e) { NSLog(@"Exception"); }
    //-------------------------------------------------------------------------------
    if(jsonResponse.count > 0){
        NSLog(@"JSonResponse%@", jsonResponse);
        arrayName = [jsonResponse valueForKey:@"nombre"];
        NSLog(@"JsonArray%@", arrayName);
        arrayAge = [jsonResponse valueForKey:@"edad"];
        NSLog(@"JsonArray%@", arrayAge);
        arrayCareer = [jsonResponse valueForKey:@"carrera"];
        NSLog(@"JsonArray%@", arrayCareer);
    }
    [self.tblEstudiantes reloadData];
}


/***********************************************************************************************
 Table Functions
 **********************************************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//-------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return arrayName.count;
}
//-------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

//-------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellGirlFriends");
    static NSString *CellIdentifier = @"cellEstudiantes";
    
    cellEstudiantes *cell = (cellEstudiantes *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        [tableView registerNib:[UINib nibWithNibName:@"cellEstudiantes" bundle:nil] forCellReuseIdentifier:@"cellEstudiantes"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellEstudiantes"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.cellName.text = arrayName[indexPath.row];
    cell.cellAge.text = arrayAge[indexPath.row];
    cell.cellCareer.text = arrayCareer[indexPath.row];
    
    return cell;
}
//-------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", indexPath);
    
}
- (IBAction)btnRefresh:(id)sender {
    [self postService];
    [self.tblEstudiantes reloadData];
}
@end
