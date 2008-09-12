#import "TwitterPluginSource.h"

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

  NSString *base = [NSString stringWithFormat:@"http://twitter.com/statuses/friends/%@.xml",
           screen_name];

  for (int i=1; i<2; i++)
  {
    NSMutableArray *friends = [NSMutableArray array];

    NSURL *friends_url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?page=%d", base, i]];
    NSError *err = nil;

    NSXMLDocument *doc = [[[NSXMLDocument alloc] initWithContentsOfURL:friends_url
      options:NSXMLDocumentTidyXML error:&err] autorelease];
    if (err) {
      NSLog(@"XML cannot be retrieved and parsed correctly.");
      abort();
    }

    NSArray *users = [doc nodesForXPath:@"/users/user" error:&err];
    if (err) {
      NSLog(@"XPath failed.");
      abort();
    }

    NSXMLElement *user;
    for (user in users) {
      NSXMLElement *child;
      QSObject *obj;
      int count = 0;
      for (child in [user children]) {
        if (count == 2) break;
        if ([[child name] isEqualToString:@"screen_name"]) {
          NSLog(@"name = %@", [child stringValue]);
          obj = [QSObject objectWithName:[child stringValue]];
          count++;
        } else if ([[child name] isEqualToString:@"profile_image_url"]) {
          NSLog(@"img url = %@", [child stringValue]);
          count++;
        }
      }
      [obj setObject:@"" forType:@"TwitterPluginType"];
      [obj setPrimaryType:@"TwitterPluginType"];
      [objects addObject:obj];
    }
  }

  NSLog(@"objects count = %d", [objects count]);
	return objects;
}

@end
// vim:set ft=objc:
