//
//  RCLoader.m - bootstrapper
//
//   TwitterPlugin
//   License: revised BSD
//   Motohiro Takayama <mootoh@gmail.com>
//

#import "RCLoader.h"
#import <RubyCocoa/RubyCocoa.h>

@implementation RCLoader

+ (void)load {
  static BOOL installed = NO;

  NSLog(@"RCLoader#load ...");
  if (! installed) {
    if (RBBundleInit("load_ruby.rb", [self class], self)) {
      NSLog(@"RCLoader#load => failed.");
    }
    else {
      installed = YES;
      NSLog(@"RCLoader#load => loaded.");
    }
  }
}

@end // RCLoader
