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

@implementation RegisterController

@synthesize serial      = _serial;
@synthesize buyProgress = _buyProgress;
@synthesize menuItem    = _menuItem;

- ( id )init
{
    if( ( self = [ super initWithWindowNibName: @"Register" owner: self ] ) )
    {}
    
    return self;
}

- ( void )dealloc
{
    [ _serial       release ];
    [ _buyProgress  release ];
    [ _menuItem     release ];
    
    [ super dealloc ];
}

- ( IBAction )cancel: ( id )sender
{
    [ self.window orderOut: sender ];
    [ NSApp endSheet: self.window returnCode: 0 ];
}

- ( IBAction )validate: ( id )sender
{
    NSAlert * alert;
    
    {
        alert = [ [ NSAlert alloc ] init ];
        
        [ alert addButtonWithTitle:  NSLocalizedString( @"OK", nil ) ];
        [ alert setMessageText:      NSLocalizedString( @"SerialNumberValid", nil ) ];
        [ alert setInformativeText:  NSLocalizedString( @"SerialNumberValidText", nil ) ];
        
        NSBeep();
        
        [ alert setAlertStyle: NSInformationalAlertStyle ];
        [ alert runModal ];
        [ alert release ];
        
        [ [ NSUserDefaults standardUserDefaults ] setObject: [ _serial stringValue ] forKey: @"sn" ];
        [ [ NSUserDefaults standardUserDefaults ] synchronize ];
        
        [ self.window orderOut: sender ];
        [ NSApp endSheet: self.window returnCode: 0 ];
        [ _menuItem setHidden: YES ];
    }
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
