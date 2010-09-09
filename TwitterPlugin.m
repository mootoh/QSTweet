//
//  TwitterPlugin.m
//  TwitterPlugin
//
//  Created by mootoh on 2007.12.12
//  License: revised BSD
//
#import "TwitterPlugin.h"
#import "TwitterPluginGrowlHelper.h"
#import "TwitterXAuth.h"
#import "Private.h"

@interface XAuthDelegate : NSObject <TwitterXAuthDelegate>
@end

@implementation XAuthDelegate

- (void) twitterXAuthDidAuthorize:(TwitterXAuth *)txAuth
{
   NSLog(@"authorization successful");
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   [defaults setBool:YES forKey:@"TwitterPlugin.authorized"];
   
   [TwitterPlugin didFinishAuthorize];
}

- (void) twitterXAuthDidTweet:(TwitterXAuth *)twitterXAuth;
{
   NSLog(@"successfully tweeted");
}

@end

#pragma mark -

TwitterPluginGrowlHelper *s_growlHelper;
TwitterXAuth *s_twitterXAuth;
BOOL s_authorizing;
XAuthDelegate *s_xauthDelegate;

@implementation TwitterPlugin

+ (void) initializeXAuth
{
   NSLog(@"initializeXAuth");
   s_twitterXAuth  = [[TwitterXAuth alloc] init];
   s_xauthDelegate = [[XAuthDelegate alloc] init];
   s_twitterXAuth.delegate = s_xauthDelegate;
   
   s_twitterXAuth.consumerKey    = CONSUMER_KEY;
   s_twitterXAuth.consumerSecret = CONSUMER_SECRET;
   
   id values = [[NSUserDefaultsController sharedUserDefaultsController] values];
   NSString *screenName = [values valueForKey:@"TwitterPreference.screenName"];
   NSString *password   = [values valueForKey:@"TwitterPreference.password"];

   s_twitterXAuth.username = screenName;
   s_twitterXAuth.password = password;
}

+ (void) authorize
{
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
   if (! [defaults boolForKey:@"TwitterPlugin.authorized"]) {
      s_authorizing = YES;
      NSLog(@"go auth!");
      [s_twitterXAuth authorize];
   }
}

+ (void) load
{
   s_growlHelper = [[TwitterPluginGrowlHelper alloc] init];
   [TwitterPlugin initializeXAuth];
   [TwitterPlugin authorize];
}

- (void) dealloc
{
   NSLog(@"dealloc TwitterPlugin");
   [s_twitterXAuth release];
   [s_growlHelper release];
   [super dealloc];
}

+ (void) didFinishAuthorize
{
   NSLog(@"didFinishAuthorize");
   s_authorizing = NO;
}

+ (TwitterXAuth *) theTwitterXAuth
{
   NSLog(@"twitterXAuth = %@", s_twitterXAuth);
   return s_twitterXAuth;
}
@end