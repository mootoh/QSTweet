//
//  TwitterPluginAction.h
//  TwitterPlugin
//
//  Created by mootoh on 2007.12.12
//  License: revised BSD
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

