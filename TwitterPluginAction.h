//
//  TwitterPluginAction.h
//  TwitterPlugin
//
//  Created by Motohiro Takayama on 12/12/07.
//  Copyright __MyCompanyName__ 2007. All rights reserved.
//

#import <QSCore/QSObject.h>
#import <QSCore/QSActionProvider.h>
#import "TwitterPluginAction.h"

#define kTwitterPluginAction @"TwitterPluginAction"

@interface TwitterPluginAction : QSActionProvider
{
  id receivedData;
}
@end

