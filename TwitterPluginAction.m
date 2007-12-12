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

  NSString *content = [NSString stringWithFormat:@"status=%@", [dObject stringValue]];
  NSLog(content);
  [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  NSURL *url = [NSURL URLWithString:@"http://user:pass@twitter.com/statuses/update.json"];
  NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
  [urlRequest setHTTPMethod:@"POST"];
  [urlRequest setHTTPBody:[content dataUsingEncoding:NSUTF8StringEncoding]];

  NSURLConnection *theConnection = [NSURLConnection
    connectionWithRequest:urlRequest
    delegate:self];
  if (theConnection) {
    receivedData = [[NSMutableData data] retain];
  } else {
    NSLog(@"not connected correctly.");
  }

  return result;
}

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
	NSLog(@"didFailWithError 1");
	// [connection release];
	// [receivedData release];
	
	NSLog(@"didFailWithError 2");
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"connectionDidFinishLoading: succeeded to load %d bytes", [receivedData length]);
	[(NSData *)receivedData writeToFile:@"/tmp/connectionDidFinishLoading.log"
		atomically:YES];
//	[connection release];
//	[receivedData release];
}
@end
