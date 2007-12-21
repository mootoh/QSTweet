//
//  TwitterPluginAction.m
//  TwitterPlugin
//
//  Created by Motohiro Takayama on 12/12/07.
//  Copyright __MyCompanyName__ 2007. All rights reserved.
//

#import "TwitterPluginAction.h"

@implementation TwitterPluginAction

- (QSObject *)performActionOnObject:(QSObject *)dObject {
  QSObject *result = dObject;

  // construct request body
  NSString *content = [NSString stringWithFormat:@"source=QSTwitter&status=%@", [dObject stringValue]];
  //NSLog(content);
  [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

  // get screenName/password from PreferencePane
  id values = [[NSUserDefaultsController sharedUserDefaultsController] values];
  NSString *screenName = [values valueForKey:@"TwitterPreference.screenName"];
  NSString *password   = [values valueForKey:@"TwitterPreference.password"];
  //NSLog(@"screenName:%@, password:%@", screenName, password);

  // construct request
  NSString *urlString = [NSString stringWithFormat:
    @"http://%@:%@@twitter.com/statuses/update.json", screenName, password];
  NSURL *url = [NSURL URLWithString:urlString];
  NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
  [urlRequest setHTTPMethod:@"POST"];
  [urlRequest setHTTPBody:[content dataUsingEncoding:NSUTF8StringEncoding]];

  // connect it
  NSURLConnection *theConnection = [NSURLConnection
    connectionWithRequest:urlRequest
    delegate:self];
  if (theConnection) {
    receivedData = [[NSMutableData data] retain];
  } else {
    //NSLog(@"not connected correctly.");
  }

  return result;
}

// callbacks
- (void) connection : (NSURLConnection *) connection
         didReceiveResponse : (NSURLResponse *) response {
  NSDictionary *dicHead = [(NSHTTPURLResponse *)response allHeaderFields];
  NSLog([dicHead objectForKey:@"Status"]);
  [receivedData setLength:0];
}

- (void) connection : (NSURLConnection *) connection
         didReceiveData : (NSData *) data {
  [receivedData appendData:data];
}

 - (void) connection : (NSURLConnection *) connection 
 	didFailWithError : (NSError *) error {
	//NSLog(@"didFailWithError 1");
	// [connection release];
	[receivedData release];	
	//NSLog(@"didFailWithError 2");
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
//	NSLog(@"connectionDidFinishLoading: succeeded to load %d bytes", [receivedData length]);
//	[connection release];
	[receivedData release];
}
@end
