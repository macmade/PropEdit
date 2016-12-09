/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * file         ApplicationController.m
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "ApplicationController.h"
#import "AboutController.h"
#import "PreferencesController.h"
#import "MainWindowController.h"

#ifndef APPSTORE

#import "RegisterController.h"

#endif

@interface ApplicationController( Private )

- ( void )sheetDidEnd: ( NSWindow * )sheet returnCode: ( int )returnCode contextInfo: ( void * )contextInfo;

@end

@implementation ApplicationController

@synthesize preferences;
@synthesize aboutWindow;
@synthesize preferencesPanel;
@synthesize main;
@synthesize registerMenuItem;

- ( id )init
{
    if( ( self = [ super init ] ) )
    {
        preferences = [ [ NLPreferences alloc ] initWithPropertyList: @"Defaults" owner: self ];
    }
    
    return self;
}

- ( void )dealloc
{
    [ preferences           release ];
    [ aboutWindow           release ];
    [ preferencesPanel      release ];
    [ main                  release ];
    [ registerMenuItem      release ];
    
    #ifndef APPSTORE
    
    [ registerController    release ];
    
    #endif
    
    [ super dealloc ];
}

- ( void )awakeFromNib
{
    [ [ ( NSWindowController * )main window ] center ];
    [ main showWindow: self ];
}

- ( IBAction )openMainWindow: ( id )sender
{
    ( void )sender;
    
    [ main showWindow: self ];
}

- ( IBAction )showPreferences: ( id )sender
{
    ( void )sender;
    
    [ preferencesPanel setPreferences ];
    
    [ NSApp
        beginSheet:         [ preferencesPanel window ]
        modalForWindow:     [ ( NSWindowController * )main window ]
        modalDelegate:      self
        didEndSelector:     @selector( sheetDidEnd: returnCode: contextInfo: )
        contextInfo:        nil
     ];
}

- ( IBAction )showAboutWindow: ( id )sender
{
    ( void )sender;
    
    [ [ aboutWindow window ] center ];
    [ aboutWindow showWindow: self ];
}

- ( void )sheetDidEnd: ( NSWindow * )sheet returnCode: ( int )returnCode contextInfo: ( void * )contextInfo
{
    ( void )sheet;
    ( void )returnCode;
    ( void )contextInfo;
    
    if( returnCode == 0 )
    {
        [ main reloadFiles ];
    }
}

#ifndef APPSTORE

- ( IBAction )showRegisterWindow: ( id )sender
{
    ( void )sender;
    
    if( registerController == nil )
    {
        registerController          = [ RegisterController new ];
        registerController.menuItem = registerMenuItem;
    }
    
    [ NSApp
        beginSheet:         [ registerController window ]
        modalForWindow:     [ ( NSWindowController * )main window ]
        modalDelegate:      nil
        didEndSelector:     NULL
        contextInfo:        nil
     ];
}

#endif

@end
