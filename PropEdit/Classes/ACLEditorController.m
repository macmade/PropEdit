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
#import "ACLEntry.h"
#import "DSCLHelper.h"
#import "User.h"
#import "Group.h"
#import <ESellerate/ESellerate.h>

@interface ACLEditorController( NSTableViewDataSource ) < NSTableViewDataSource >

@end

@implementation ACLEditorController( NSTableViewDataSource )

- ( NSInteger )numberOfRowsInTableView: ( NSTableView * )tableView
{
    ( void )tableView;
    
    return [ _entries count ];
}

- ( id )tableView: ( NSTableView * )tableView objectValueForTableColumn: ( NSTableColumn * )tableColumn row: ( NSInteger )row
{
    ACLEntry * entry;
    User     * user;
    User     * userObject;
    Group    * group;
    Group    * groupObject;
    
    ( void )tableView;
    
    entry = [ _entries objectAtIndex: row ];
    user  = nil;
    group = nil;
    
    for( userObject in _users )
    {
        if( [ userObject.guid isEqualToString: entry.guid ] )
        {
            user = userObject;
            break;
        }
    }
    
    if( user == nil )
    {
        for( groupObject in _groups )
        {
            if( [ groupObject.guid isEqualToString: entry.guid ] )
            {
                group = groupObject;
                break;
            }
        }
    }
    
    if( [ tableColumn.identifier isEqualToString: @"icon" ] )
    {
        if( group != nil )
        {
            return [ NSImage imageNamed: NSImageNameUserGroup ];
        }
        
        return [ NSImage imageNamed: NSImageNameUser ];
    }
    else if( [ tableColumn.identifier isEqualToString: @"uid" ] )
    {
        if( group != nil )
        {
            return [ NSString stringWithFormat: @"%u", group.gid ];
        }
        
        return [ NSString stringWithFormat: @"%u", user.uid ];
    }
    else if( [ tableColumn.identifier isEqualToString: @"user" ] )
    {
        if( group != nil )
        {
            if( group.realName != nil )
            {
                return [ NSString stringWithFormat: @"%@ (%@)", group.name, group.realName ];
            }
            else if( group.name != nil )
            {
                return group.name;
            }
        }
        
        if( user.realName != nil )
        {
            return [ NSString stringWithFormat: @"%@ (%@)", user.name, user.realName ];
        }
        else if( user.name != nil )
        {
            return user.name;
        }
        
        return @"";
    }
    else if( [ tableColumn.identifier isEqualToString: @"type" ] )
    {
        switch( entry.type )
        {
            case ACLEntryTypeAllow:
                
                return NSLocalizedString( @"ACLAllow", nil );
                
            case ACLEntryTypeDeny:
                
                return NSLocalizedString( @"ACLDeny", nil );
                
            case ACLEntryTypeUnknown:
                
                return NSLocalizedString( @"ACLUnknown", nil );
        }
    }
    else if( [ tableColumn.identifier isEqualToString: @"guid" ] )
    {
        return entry.guid;
    }
    
    return @"";
}

@end

@interface ACLEditorController( NSTableViewDelegate ) < NSTableViewDelegate >

@end

@implementation ACLEditorController( NSTableViewDelegate )

@end

@implementation ACLEditorController

@synthesize table         = _table;
@synthesize removeButton  = _removeButton;
@synthesize filePathLabel = _filePathLabel;
@synthesize fileIcon      = _fileIcon;

- ( id )initWithPath: ( NSString * )path
{
    if( ( self = [ super initWithWindowNibName: @"ACLEditor" owner: self ] ) )
    {
        if( path == nil || path.length == 0 )
        {
            path = @"/";
        }
        
        _path    = [ path copy ];
        _entries = [ [ ACLEntry entriesForFile: _path ] retain ];
        _dscl    = [ DSCLHelper new ];
        _users   = [ [ _dscl users ] retain ];
        _groups  = [ [ _dscl groups ] retain ];
    }
    
    return self;
}

- ( void )awakeFromNib
{
    [ _removeButton setEnabled: NO ];
    
    if( [ _path isEqualToString: @"/" ] )
    {
        [ _filePathLabel setStringValue: [ NSString stringWithFormat: @"%@", [ [ NSFileManager defaultManager ] displayNameAtPath: _path ] ] ];
    }
    else
    {
        [ _filePathLabel setStringValue: [ NSString stringWithFormat: @"%@ (%@)", [ [ NSFileManager defaultManager ] displayNameAtPath: _path ], [ _path stringByDeletingLastPathComponent ] ] ];
    }
    
    [ _fileIcon setImage: [ [ NSWorkspace sharedWorkspace ] iconForFile: _path ] ];
    
    _table.dataSource = self;
    _table.delegate   = self;
}

- ( void )dealloc
{
    [ _path         release ];
    [ _table        release ];
    [ _removeButton release ];
    [ _entries      release ];
    [ _dscl         release ];
    [ _users        release ];
    [ _groups       release ];
    
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

- ( IBAction )add: ( id )sender
{
    ( void )sender;
}

- ( IBAction )remove: ( id )sender
{
    ( void )sender;
}

@end
