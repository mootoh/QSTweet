//
//  TwitterPluginAction.m
//  TwitterPlugin
//
//  Created by mootoh on 12/12/07.
//  License: revised BSD
//

#import "TwitterPluginAction.h"

@implementation TwitterPluginAction

- (QSObject *)post:(QSObject *)dObject to:(QSObject *)ind
{
  QSObject *result = dObject;

  // construct request body
  NSString *content = [NSString stringWithFormat:@"source=QSTwitter&status=%@",
    [dObject stringValue]];
  content = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  content = [content stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];


  // get screenName/password from PreferencePane
  id values = [[NSUserDefaultsController sharedUserDefaultsController] values];
  NSString *screenName = [values valueForKey:@"TwitterPreference.screenName"];
  NSString *password   = [values valueForKey:@"TwitterPreference.password"];
  //NSLog(@"screenName:%@, password:%@", screenName, password);

  // construct request
  NSString *urlString = [NSString stringWithFormat:
    @"http://%@:%@@twitter.com/statuses/update.json", screenName, password];
  NSURL *url = [NSURL URLWithString:urlString];
  NSMutableURLRequest *urlRequest = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
  [urlRequest setHTTPMethod:@"POST"];
  [urlRequest setHTTPBody:[content dataUsingEncoding:NSUTF8StringEncoding]];

  // connect it
  NSURLConnection *con = [NSURLConnection connectionWithRequest:urlRequest
                                                       delegate:self];
  if (con) {
    receivedData = [[NSMutableData data] retain];
  } else {
    //NSLog(@"not connected correctly.");
  }

  return result;
}

// callbacks
- (void) connection:(NSURLConnection *)connection
    didReceiveResponse:(NSURLResponse *)response
{
  NSDictionary *dicHead = [(NSHTTPURLResponse *)response allHeaderFields];
  NSLog([dicHead objectForKey:@"Status"]);
  [receivedData setLength:0];
}

- (void) connection:(NSURLConnection *)connection
  didReceiveData:(NSData *)data
{
  [receivedData appendData:data];
}

 - (void) connection : (NSURLConnection *) connection 
 	didFailWithError : (NSError *) error
{
	//NSLog(@"didFailWithError 1");
	// [connection release];
	[receivedData release];	
	//NSLog(@"didFailWithError 2");
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
//	NSLog(@"connectionDidFinishLoading: succeeded to load %d bytes", [receivedData length]);
//	[connection release];
	[receivedData release];
}
@end
