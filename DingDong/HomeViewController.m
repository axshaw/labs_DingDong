//
//  HomeViewController.m
//  DingDong
//
//  Created by Scott Roberts on 13/01/2014.
//  Copyright (c) 2014 CTMLABS. All rights reserved.
//

#import "HomeViewController.h"
#import "SRWebSocket.h"

@interface HomeViewController () <SRWebSocketDelegate>

@property (nonatomic) SRWebSocket *videoSocket;
@property (nonatomic) IBOutlet UIImageView *imageview;
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"DingDong";
    // Do any additional setup after loading the view.

     //Upload test image
     UIImage *image = [UIImage imageNamed:@"girl.png"];
     NSData *imageData = UIImagePNGRepresentation(image);
     PFFile *imageFile = [PFFile fileWithName:@"girl.png" data:imageData];
     
     PFObject *knocker = [PFObject objectWithClassName:@"knocker"];
     knocker[@"imageFile"] = imageFile;
     [knocker saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
         if(succeeded){
             [[knocker objectForKey:@"imageFile"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error){
                 
                 if( data ) {
                     UIImage *image = [UIImage imageWithData:data];
                     [self.imageview setImage:image];
                     //[webView loadData:data MIMEType:@"application/pdf" textEncodingName:nil baseURL:nil];
                     //[progressView setHidden:YES];
                     
                 }
                 if( error ) {
                     
                     NSLog(@"Failed to load file with error %@", error);
                 }
             }progressBlock:^(int percentDone) {
                 
                 float percent = percentDone/100;
                 NSLog(@"percent = %f", percent);
                 //[progressView setProgress:percent animated:NO];
             }];
         }

         
         
     }];
        
    
    
    
    
    
    //self.videoSocket = [[SRWebSocket alloc] initWithURL:[[NSURL alloc] initWithString:@"http://172.26.36.119/"]];
    //self.videoSocket.delegate = self;
    //[self.videoSocket open];
    //[self.videoSocket send:self.input.text]
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Web Socket 

- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSLog(@"Websocket Connected");
}

-(void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(NSData *)message{
    
    NSLog(@"Received \"%@\"", message);
    //NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    
    
    UIImage *image = [[UIImage alloc] initWithData:message];
    
    [self.imageview setImage:image];
    
    
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
    self.videoSocket = nil;
}

-(void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@":( Websocket Failed With Error %@", [error localizedDescription]);
    self.videoSocket = nil;
}

@end
