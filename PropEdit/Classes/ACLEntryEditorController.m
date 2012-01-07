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

@end
