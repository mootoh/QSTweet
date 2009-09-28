//
//  TwitterPluginSource.m
//  TwitterPlugin
//
//  Created by mootoh on 2008.09.13
//  License: revised BSD
//
#import "TwitterPluginSource.h"
#import "TwitterPluginShared.h"

static int count = 0;

@implementation TwitterPluginSource

- (id) init
{
  if (self = [super init]) {
    // collect friends
    friends_ = [NSMutableArray array];
  }
  return self;
}

- (BOOL) indexIsValidFromDate:(NSDate *)date forEntry:(NSDictionary *)entry
{
  return YES;
}

- (NSImage *) iconForEntry:(NSDictionary *)entry
{
  return [QSResourceManager imageNamed:@"girl_square"];
}

- (NSArray *)objectsForEntry:(NSDictionary *)entry
{
  NSDictionary *dict = [[NSUserDefaultsController sharedUserDefaultsController] values];
  NSString *screen_name = [dict valueForKey:@"TwitterPreference.screenName"];

  NSMutableArray *objects = [NSMutableArray array];

  NSString *base = [NSString stringWithFormat:@"http://twitter.com/statuses/friends/%@.xml?lite=true&", screen_name];

  for (int i=1; true; i++)
  {
    NSMutableArray *friends = [NSMutableArray array];

    NSURL *friends_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@page=%d", base, i]];
    NSError *err = nil;

    NSXMLDocument *doc = [[[NSXMLDocument alloc] initWithContentsOfURL:friends_url
      options:NSXMLDocumentTidyXML error:&err] autorelease];
    if (err) {
      NSLog(@"XML cannot be retrieved and parsed correctly.");
      return nil;
    }

    NSArray *users = [doc nodesForXPath:@"/users/user" error:&err];
    if (err) {
      NSLog(@"XPath failed.");
      return nil;
    }

    if (0 == [users count]) break;

    NSXMLElement *user;
    for (user in users) {
      NSXMLElement *child;
      NSString *screen_name;
      NSString *image_url;

      int count = 0;
      for (child in [user children]) {
        if (count == 2) break;
        NSString *cn = [child name];
        if ([cn isEqualToString:@"screen_name"]) {
          screen_name = [child stringValue];
          count++;
        } else if ([cn isEqualToString:@"profile_image_url"]) {
          image_url = [child stringValue];
          count++;
        }
      }

      NSAssert(screen_name, @"screen_name should exist");
      NSAssert(image_url, @"image_url should exist");
      QSObject *obj = [QSObject objectWithName:screen_name];
      NSAssert(obj, @"QSObject should not be nil.");

      [obj setObject:@"" forType:@"TwitterPluginType"];
      [obj setPrimaryType:@"TwitterPluginType"];
      [obj setObject:image_url forType:@"image_url"];
      [objects addObject:obj];
    }
  }

  // add public one
  QSObject *obj = [QSObject objectWithName:PUBLIC];
  [obj setObject:@"" forType:@"TwitterPluginType"];
  [obj setPrimaryType:@"TwitterPluginType"];
  [objects addObject:obj];

	return objects;
}

- (void) setQuickIconForObject:(QSObject *)object 
{
  [object setIcon:nil];
}

- (BOOL) loadIconForObject:(QSObject *)object {
  if ([[object name] isEqualToString:PUBLIC]) {
    [object setIcon:[QSResourceManager imageNamed:@"girl_square"]];
    return YES;
  }
  NSImage *img = [[[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:[object objectForType:@"image_url"]]] autorelease];
  if (! img) return false;
  [object setIcon:img];

  return true;
}

@end
// vim:set ft=objc:
