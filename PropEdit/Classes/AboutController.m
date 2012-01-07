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
#import <ESellerate/ESellerate.h>

@implementation AboutController

@synthesize version = _version;
@synthesize serial  = _serial;

- ( void )awakeFromNib
{
    NSString * version;
    NSString * build;
    
    version = [ [ NSBundle mainBundle ] objectForInfoDictionaryKey: @"CFBundleShortVersionString" ];
    build   = [ [ NSBundle mainBundle ] objectForInfoDictionaryKey: @"CFBundleVersion" ];
    
    [ _version setStringValue: [ NSString stringWithFormat: NSLocalizedString( @"Version", nil ), version, [ build integerValue ] ] ];
}

- ( void )dealloc
{
    [ _version release ];
    [ _serial  release ];
    
    [ super dealloc ];
}

- ( void )showWindow: ( id )sender
{
    if( [ [ ESellerate sharedInstance ] isRegistered ] == YES )
    {
        [ _serial setStringValue: [ [ NSUserDefaults standardUserDefaults ] objectForKey: @"sn" ] ];
    }
    
    [ super showWindow: sender ];
}

@end
