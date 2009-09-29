#!/bin/sh
install_name_tool -change '@executable_path/../Frameworks/Growl.framework/Versions/A/Growl' '@loader_path/../Frameworks/Growl.framework/Versions/A/Growl'  TwitterPlugin
