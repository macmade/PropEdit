/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        ACLEditorController.m
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "ACLEditorController.h"
#import <ESellerate/ESellerate.h>

@implementation ACLEditorController

- ( id )initWithPath: ( NSString * )path
{
    if( ( self = [ super initWithWindowNibName: @"ACLEditor" owner: self ] ) )
    {
        _path = [ path copy ];
    }
    
    return self;
}

- ( void )dealloc
{
    [ _path release ];
    
    [ super dealloc ];
}

- ( IBAction )cancel: ( id )sender
{
    [ self.window orderOut: sender ];
    [ NSApp endSheet: self.window returnCode: 1 ];
}

- ( IBAction )apply: ( id )sender
{
    NSAlert * alert;
    
    if( [ [ ESellerate sharedInstance ] isRegistered ] == NO )
    {
        alert = [ [ NSAlert alloc ] init ];
        
        [ alert addButtonWithTitle:  NSLocalizedString( @"OK", nil ) ];
        [ alert setMessageText:      NSLocalizedString( @"ACLRegisterAlert", nil ) ];
        [ alert setInformativeText:  NSLocalizedString( @"ACLRegisterAlertText", nil ) ];
        
        NSBeep();
        
        [ alert setAlertStyle: NSInformationalAlertStyle ];
        [ alert runModal ];
        [ alert release ];
        
        return;
    }
    
    [ self.window orderOut: sender ];
    [ NSApp endSheet: self.window returnCode: 0 ];
}

@end
