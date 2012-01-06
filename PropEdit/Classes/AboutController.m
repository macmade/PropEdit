/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * file         AboutController.m
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "AboutController.h"

@implementation AboutController

@synthesize version;

- ( void )awakeFromNib
{
    [ version setStringValue: [ NSString stringWithFormat: NSLocalizedString( @"Version", nil ), [ [ NSBundle mainBundle ] objectForInfoDictionaryKey: @"CFBundleShortVersionString" ] ] ];
}

@end
