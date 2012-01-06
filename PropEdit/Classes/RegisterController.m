/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        RegisterController.m
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "RegisterController.h"
#import <ESellerate/ESellerate.h>

@implementation RegisterController

@synthesize serial      = _serial;
@synthesize buyProgress = _buyProgress;

- ( id )init
{
    if( ( self = [ super initWithWindowNibName: @"Register" owner: self ] ) )
    {
        _eSell = [ ESellerate sharedInstance ];
    }
    
    return self;
}

- ( void )dealloc
{
    [ super dealloc ];
}

- ( IBAction )cancel: ( id )sender
{
    [ self.window orderOut: sender ];
    [ NSApp endSheet: self.window returnCode: 0 ];
}

- ( IBAction )validate: ( id )sender
{
    ( void )sender;
}

- ( IBAction )buy: ( id )sender
{
    NLHostReachabilityTest * hostTest;
    NSAlert                * alert;
    NSURL                  * url;
    
    ( void )sender;
    
    [ _buyProgress setHidden: NO ];
    [ _buyProgress startAnimation: nil ];
    
    url      = [ NSURL URLWithString: @"http://www.eosgarden.com/en/freeware/propedit/buy/" ];
    hostTest = [ NLHostReachabilityTest testWithHost: [ url host ] ];
    
    if( hostTest.isReachable == YES )
    {
        [ [ NSWorkspace sharedWorkspace ] openURL: url ];
        
        [ _buyProgress stopAnimation: nil ];
        [ _buyProgress setHidden: YES ];
    }
    else
    {
        alert = [ [ NSAlert alloc ] init ];
        
        [ alert addButtonWithTitle:  NSLocalizedString( @"OK", nil ) ];
        [ alert setMessageText:      NSLocalizedString( @"ConnectionError", nil ) ];
        [ alert setInformativeText:  NSLocalizedString( @"ConnectionErrorText", nil ) ];
        [ alert setAlertStyle: NSCriticalAlertStyle ];
        
        NSBeep();
        
        [ _buyProgress stopAnimation: nil ];
        [ _buyProgress setHidden: YES ];
        
        [ alert runModal ];
        [ alert release ];
    }
}

@end
