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
#import "ACLEntry.h"

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
        
        [ item setRepresentedObject: group ];
        [ menu addItem: [ item autorelease ] ];
    }
    
    if( _acl.type == ACLEntryTypeAllow )
    {
        [ _entrySelect selectItemAtIndex: 0 ];
    }
    else if( _acl.type == ACLEntryTypeDeny )
    {
        [ _entrySelect selectItemAtIndex: 1 ];
    }
    
    for( item in [ _userSelect itemArray ] )
    {
        if( [ item.representedObject isKindOfClass: [ User class ] ] )
        {
            user = item.representedObject;
            
            if( user.uid == getuid() )
            {
                [ _userSelect selectItem: item ];
                break;
            }
        }

    }
    
    for( item in [ _userSelect itemArray ] )
    {
        if( _user != nil && [ item.representedObject isKindOfClass: [ User class ] ] )
        {
            user = item.representedObject;
            
            if( user.uid == _user.uid )
            {
                [ _userSelect selectItem: item ];
                break;
            }
        }
        else if( _group != nil && [ item.representedObject isKindOfClass: [ Group class ] ] )
        {
            group = item.representedObject;
            
            if( group.gid == _group.gid )
            {
                [ _userSelect selectItem: item ];
                break;
            }
        }
    }
    
    if( _acl != nil )
    {
        if( _acl.readAttributes )
        {
            [ _baseMatrix selectCellAtRow: 0 column: 0 ];
        }
        
        if( _acl.writeAttributes )
        {
            [ _baseMatrix selectCellAtRow: 0 column: 1 ];
        }
        
        if( _acl.readExtendedAttributes )
        {
            [ _baseMatrix selectCellAtRow: 1 column: 0 ];
        }
        
        if( _acl.writeExtendedAttributes )
        {
            [ _baseMatrix selectCellAtRow: 1 column: 1 ];
        }
        
        if( _acl.readSecurity )
        {
            [ _baseMatrix selectCellAtRow: 2 column: 0 ];
        }
        
        if( _acl.writeSecurity )
        {
            [ _baseMatrix selectCellAtRow: 2 column: 1 ];
        }
        
        if( _acl.delete )
        {
            [ _baseMatrix selectCellAtRow: 3 column: 0 ];
        }
        
        if( _acl.changeOwner )
        {
            [ _baseMatrix selectCellAtRow: 3 column: 1 ];
        }
        
        if( _acl.listDirectory )
        {
            [ _directoryMatrix selectCellAtRow: 0 column: 0 ];
        }
        
        if( _acl.search )
        {
            [ _directoryMatrix selectCellAtRow: 1 column: 0 ];
        }
        
        if( _acl.addFile )
        {
            [ _directoryMatrix selectCellAtRow: 2 column: 0 ];
        }
        
        if( _acl.addSubDirectory )
        {
            [ _directoryMatrix selectCellAtRow: 3 column: 0 ];
        }
        
        if( _acl.deleteChild )
        {
            [ _directoryMatrix selectCellAtRow: 4 column: 0 ];
        }
        
        if( _acl.readData )
        {
            [ _fileMatrix selectCellAtRow: 0 column: 0 ];
        }
        
        if( _acl.writeData )
        {
            [ _fileMatrix selectCellAtRow: 1 column: 0 ];
        }
        
        if( _acl.appendData )
        {
            [ _fileMatrix selectCellAtRow: 2 column: 0 ];
        }
        
        if( _acl.execute )
        {
            [ _fileMatrix selectCellAtRow: 3 column: 0 ];
        }
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
    User  * user;
    Group * group;
    id      relation;
    
    if( _acl == nil )
    {
       _acl = [ [ ACLEntry alloc ] init ];
    }
    
    relation = _userSelect.selectedItem.representedObject;
    
    if( [ relation isKindOfClass: [ User class ] ] )
    {
        user      = relation;
        _acl.guid = user.guid;
    }
    else if( [ relation isKindOfClass: [ Group class ] ] )
    {
        group     = relation;
        _acl.guid = group.guid;
    }
    
    _acl.type = ( _entrySelect.indexOfSelectedItem == 0 ) ? ACLEntryTypeAllow : ACLEntryTypeDeny;
    
    if( [ [ _baseMatrix cellAtRow: 0 column: 0 ] intValue ] )
    {
        _acl.readAttributes = YES;
    }
    
    if( [ [ _baseMatrix cellAtRow: 0 column: 1 ] intValue ] )
    {
        _acl.writeAttributes = YES;
    }
    
    if( [ [ _baseMatrix cellAtRow: 1 column: 0 ] intValue ] )
    {
        _acl.readExtendedAttributes = YES;
    }
    
    if( [ [ _baseMatrix cellAtRow: 1 column: 1 ] intValue ] )
    {
        _acl.writeExtendedAttributes = YES;
    }
    
    if( [ [ _baseMatrix cellAtRow: 2 column: 0 ] intValue ] )
    {
        _acl.readSecurity = YES;
    }
    
    if( [ [ _baseMatrix cellAtRow: 2 column: 1 ] intValue ] )
    {
        _acl.writeSecurity = YES;
    }
    
    if( [ [ _baseMatrix cellAtRow: 3 column: 0 ] intValue ] )
    {
        _acl.delete = YES;
    }
    
    if( [ [ _baseMatrix cellAtRow: 3 column: 1 ] intValue ] )
    {
        _acl.changeOwner = YES;
    }
    
    if( [ [ _directoryMatrix cellAtRow: 0 column: 0 ] intValue ] )
    {
        _acl.listDirectory = YES;
    }
    
    if( [ [ _directoryMatrix cellAtRow: 1 column: 0 ] intValue ] )
    {
        _acl.search = YES;
    }
    
    if( [ [ _directoryMatrix cellAtRow: 2 column: 0 ] intValue ] )
    {
        _acl.addFile = YES;
    }
    
    if( [ [ _directoryMatrix cellAtRow: 3 column: 0 ] intValue ] )
    {
        _acl.addSubDirectory = YES;
    }
    
    if( [ [ _directoryMatrix cellAtRow: 4 column: 0 ] intValue ] )
    {
        _acl.deleteChild = YES;
    }
    
    if( [ [ _fileMatrix cellAtRow: 0 column: 0 ] intValue ] )
    {
        _acl.readData = YES;
    }
    
    if( [ [ _fileMatrix cellAtRow: 0 column: 0 ] intValue ] )
    {
        _acl.writeData = YES;
    }
    
    if( [ [ _fileMatrix cellAtRow: 1 column: 0 ] intValue ] )
    {
        _acl.appendData = YES;
    }
    
    if( [ [ _fileMatrix cellAtRow: 3 column: 0 ] intValue ] )
    {
        _acl.execute = YES;
    }
    
    [ self.window orderOut: sender ];
    [ NSApp endSheet: self.window returnCode: 0 ];
}

- ( IBAction )selectAllBase: ( id )sender
{
    NSButtonCell * cell;
    
    ( void )sender;
    
    for( cell in _baseMatrix.cells )
    {
        [ cell setIntValue: 1 ];
    }
}

- ( IBAction )selectAllDirectory: ( id )sender
{
    NSButtonCell * cell;
    
    ( void )sender;
    
    for( cell in _directoryMatrix.cells )
    {
        [ cell setIntValue: 1 ];
    }
}

- ( IBAction )selectAllFile: ( id )sender
{
    NSButtonCell * cell;
    
    ( void )sender;
    
    for( cell in _fileMatrix.cells )
    {
        [ cell setIntValue: 1 ];
    }
}

@end
