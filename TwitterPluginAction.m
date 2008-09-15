//
//  TwitterPluginAction.m
//  TwitterPlugin
//
//  Created by mootoh on 2007.12.12
//  License: revised BSD
//
#import "TwitterPluginAction.h"
#import "TwitterPluginShared.h"
#import <QSCore/QSTextProxy.h>

@implementation TwitterPluginAction

- (QSObject *) post:(QSObject *)dObject to:(QSObject *)ind
{
  NSString *optional = @"";
  if (ind) {
    NSString *fr = [ind stringValue];
    if ((![fr isEqualToString:@""] && (![fr isEqualToString:PUBLIC]))) {
      optional = [NSString stringWithFormat:@"@%@ ", fr];
    }
  }

  // construct request body
  NSString *content = [NSString stringWithFormat:@"source=QSTwitter&status=%@%@",
    optional, [dObject stringValue]];
  content = [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  content = [content stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];

  // get screenName/password from PreferencePane
  id values = [[NSUserDefaultsController sharedUserDefaultsController] values];
  NSString *screenName = [values valueForKey:@"TwitterPreference.screenName"];
  NSString *password   = [values valueForKey:@"TwitterPreference.password"];

  // construct request
  NSString *urlString = [NSString stringWithFormat:
    @"http://%@:%@@twitter.com/statuses/update.json", screenName, password];
  NSURL *url = [NSURL URLWithString:urlString];
  NSMutableURLRequest *urlRequest = [[[NSMutableURLRequest alloc] initWithURL:url] autorelease];
  [urlRequest setHTTPMethod:@"POST"];
  [urlRequest setHTTPBody:[content dataUsingEncoding:NSUTF8StringEncoding]];


  NSURLResponse *response;
  NSError *err;
  // connect it
  NSData *ret = [NSURLConnection sendSynchronousRequest:urlRequest
    returningResponse:&response
    error:&err];

	NSString *result = [[[NSString alloc] initWithData:ret encoding:NSUTF8StringEncoding] autorelease];
  NSLog(@"NSURLConnection result = %@", result);

  return dObject;
}

- (NSArray *) validIndirectObjectsForAction:(NSString *)action directObject:(QSObject *)dobj
{
  return [action isEqualToString:@"TwitterPluginType"] ?
      nil
    : [NSArray arrayWithObject:[QSObject textProxyObjectWithDefaultValue:@""]]
    ;
}

@end
