//
//  RCLoader.m - bootstrapper
//
//   WassrPlugin
//   License: revised BSD
//   Motohiro Takayama <mootoh@gmail.com>
//

#import "RCWassrLoader.h"
#import <RubyCocoa/RubyCocoa.h>

@implementation RCWassrLoader

+ (void)load {
  static BOOL installed = NO;

  NSLog(@"WassrPlugin: RCWassrLoader#load ...");
  if (! installed) {
    if (RBBundleInit("load_ruby.rb", [self class], self)) {
      NSLog(@"WassrPlugin: RCWassrLoader#load => failed.");
    }
    else {
      installed = YES;
      NSLog(@"WassrPlugin: RCWassrLoader#load => loaded.");
    }
  }
}

@end // RCLoader
