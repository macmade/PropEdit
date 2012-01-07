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
#import "DSCLHelper.h"
#import "User.h"
#import "Group.h"

@implementation ACLEntryEditorController

@synthesize entrySelect     = _entrySelect;
@synthesize userSelect      = _userSelect;
@synthesize baseMatrix      = _baseMatrix;
@synthesize directoryMatrix = _directoryMatrix;
@synthesize fileMatrix      = _fileMatrix;
@synthesize acl             = _acl;
@synthesize user            = _user;
@synthesize group           = _group;

- ( id )init
{
    if( ( self = [ super initWithWindowNibName: @"ACLEntryEditor" owner: self ] ) )
    {
        _dscl   = [ DSCLHelper new ];
        _users  = [ [ _dscl users ] retain ];
        _groups = [ [ _dscl groups ] retain ];
    }
    
    return self;
}

- ( void )awakeFromNib
{
    User         * user;
    Group        * group;
    NSButtonCell * cell;
    NSString     * itemTitle;
    NSMenuItem   * item;
    NSMenu       * menu;
    
    for( cell in _baseMatrix.cells )
    {
        [ cell setIntValue: 0 ];
    }
    
    for( cell in _directoryMatrix.cells )
    {
        [ cell setIntValue: 0 ];
    }
    
    for( cell in _fileMatrix.cells )
    {
        [ cell setIntValue: 0 ];
    }
    
    [ [ _userSelect menu ] setAutoenablesItems: NO ];
    
    menu = [ _userSelect menu ];
    item = [ [ NSMenuItem alloc ] initWithTitle: NSLocalizedString( @"Users", nil ) action: NULL keyEquivalent: @"" ];
    
    [ item setEnabled: NO ];
    [ menu addItem: [ item autorelease ] ];
    [ menu addItem: [ NSMenuItem separatorItem ] ];
    
    for( user in _users )
    {
        if( user.realName != nil )
        {
            itemTitle = [ NSString stringWithFormat: @"%@ (%i) - %@", user.name, user.uid, user.realName ];
        }
        else
        {
            itemTitle = [ NSString stringWithFormat: @"%@ (%i)", user.name, user.uid ];
        }
        
        item = [ [ NSMenuItem alloc ] initWithTitle: itemTitle action: NULL keyEquivalent: @"" ];
        
        [ item setRepresentedObject: user ];
        [ menu addItem: [ item autorelease ] ];
    }
    
    [ menu addItem: [ NSMenuItem separatorItem ] ];
    
    item = [ [ NSMenuItem alloc ] initWithTitle: NSLocalizedString( @"Groups", nil ) action: NULL keyEquivalent: @"" ];
    
    [ item setEnabled: NO ];
    [ menu addItem: [ item autorelease ] ];
    [ menu addItem: [ NSMenuItem separatorItem ] ];
    
    for( group in _groups )
    {
        if( group.realName != nil )
        {
            itemTitle = [ NSString stringWithFormat: @"%@ (%i) - %@", group.name, group.gid, group.realName ];
        }
        else
        {
            itemTitle = [ NSString stringWithFormat: @"%@ (%i)", group.name, group.gid ];
        }
        
        item = [ [ NSMenuItem alloc ] initWithTitle: itemTitle action: NULL keyEquivalent: @"" ];
        
        [ item setRepresentedObject: user ];
        [ menu addItem: [ item autorelease ] ];
    }
}

- ( void )dealloc
{
    [ _entrySelect      release ];
    [ _userSelect       release ];
    [ _baseMatrix       release ];
    [ _directoryMatrix  release ];
    [ _fileMatrix       release ];
    [ _dscl             release ];
    [ _users            release ];
    [ _groups           release ];
    [ _acl              release ];
    [ _user             release ];
    [ _group            release ];
    
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
