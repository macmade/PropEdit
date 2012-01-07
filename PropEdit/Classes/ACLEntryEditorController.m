/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        ACLEntryEditorController.m
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "ACLEntryEditorController.h"

@implementation ACLEntryEditorController

@synthesize entrySelect     = _entrySelect;
@synthesize userSelect      = _userSelect;
@synthesize baseMatrix      = _baseMatrix;
@synthesize directoryMatrix = _directoryMatrix;
@synthesize fileMatrix      = _fileMatrix;

- ( id )init
{
    if( ( self = [ super initWithWindowNibName: @"ACLEntryEditor" owner: self ] ) )
    {}
    
    return self;
}

- ( void )awakeFromNib
{}

- ( void )dealloc
{
    [ super dealloc ];
}

- ( IBAction )cancel: ( id )sender
{
    [ self.window orderOut: sender ];
    [ NSApp endSheet: self.window returnCode: 1 ];
}

- ( IBAction )save: ( id )sender
{
    [ self.window orderOut: sender ];
    [ NSApp endSheet: self.window returnCode: 0 ];
}

@end
