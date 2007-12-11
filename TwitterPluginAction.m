//
//  TwitterPluginAction.m
//  TwitterPlugin
//
//  Created by Motohiro Takayama on 12/12/07.
//  Copyright __MyCompanyName__ 2007. All rights reserved.
//

#import "TwitterPluginAction.h"

@implementation TwitterPluginAction

- (QSObject *)performActionOnObject:(QSObject *)dObject{
  QSObject *result;
  NSString *dWithHello;

  dWithHello = [NSString stringWithFormat:@"%@ hello",[dObject stringValue]];
  result = [QSObject objectWithString:dWithHello];


  NSString *content = @"post from Cocoa NSURLRequest.";
  NSURL *url = [NSURL URLWithString:@"http://user:pass@twitter.com/statuses/update.json"];
  NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
  [urlRequest setHTTPMethod:@"POST"];
  [urlRequest setHTTPBody:[content dataUsingEncoding:NSASCIIStringEncoding]];

  NSLog(@"before");

/*
  // create the request
  NSURLRequest *theRequest=[NSURLRequest
    requestWithURL:[NSURL URLWithString:@"http://www.apple.com/"]
    cachePolicy:NSURLRequestUseProtocolCachePolicy
    timeoutInterval:60.0];
  // create the connection with the request
  // and start loading the data
*/
  NSURLConnection *theConnection = [NSURLConnection
    connectionWithRequest:urlRequest
    delegate:self];
  if (theConnection) {
    // Create the NSMutableData that will hold
    // the received data
    // receivedData is declared as a method instance elsewhere
    receivedData = [[NSMutableData data] retain];
    NSLog(@"connected !");
  } else {
    NSLog(@"not connected correctly.");
    // inform the user that the download could not be made
  }

  return result;
}

- (void) connection : (NSURLConnection *) connection
         didReceiveResponse : (NSURLResponse *) response {
  NSLog(@"didReceiveResponse 1");

  NSDictionary *dicHead = [(NSHTTPURLResponse *)response allHeaderFields];
  NSLog([dicHead objectForKey:@"Status"]);
  NSLog(@"didReceiveResponse 2");
  //abort();
}

@end
