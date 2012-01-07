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
#import "ACLEntryEditorController.h"
#import "ACLEntry.h"
#import "DSCLHelper.h"
#import "User.h"
#import "Group.h"
#import "ApplicationController.h"
#import <ESellerate/ESellerate.h>

@interface ACLEditorController( Private )

- ( void )clearACLs;
- ( void )setACLs;
- ( void )sheetDidEnd: ( NSWindow * )sheet returnCode: ( int )returnCode contextInfo: ( void * )contextInfo;

@end

@implementation ACLEditorController( Private )

- ( void )sheetDidEnd: ( NSWindow * )sheet returnCode: ( int )returnCode contextInfo: ( void * )contextInfo
{
    ACLEntryEditorController * editor;
    ACLEntry                 * entry;
    User                     * user;
    Group                    * group;
    NSUInteger                 index;
    
    ( void )sheet;
    
    editor = contextInfo;
    entry  = editor.acl;
    index  = [ _entries indexOfObject: entry ];
    
    if( returnCode == 0 )
    {
        if( index == NSNotFound )
        {
            [ _entries addObject: entry ];
            
            for( user in _users )
            {
                if( [ user.guid isEqualToString: entry.guid ] )
                {
                    [ _entriesRelations addObject: user ];
                    break;
                }
                
                user = nil;
            }
            
            if( user == nil )
            {
                for( group in _groups )
                {
                    if( [ group.guid isEqualToString: entry.guid ] )
                    {
                        [ _entriesRelations addObject: group ];
                        break;
                    }
                }
            }
            
            [ _table reloadData ];
        }
        else
        {
            for( user in _users )
            {
                if( [ user.guid isEqualToString: entry.guid ] )
                {
                    [ _entriesRelations replaceObjectAtIndex: index withObject: user ];
                    break;
                }
                
                user = nil;
            }
            
            if( user == nil )
            {
                for( group in _groups )
                {
                    if( [ group.guid isEqualToString: entry.guid ] )
                    {
                        [ _entriesRelations replaceObjectAtIndex: index withObject: group ];
                        break;
                    }
                }
            }
        }
    }
    
    [ editor release ];
}

- ( void )clearACLs
{
    ApplicationController * app;
    char                  * args[ 3 ];
    
    app       = ( ApplicationController * )NSApp;
    args[ 0 ] = "-N";
    args[ 1 ] = ( char * )[ _path cStringUsingEncoding: NSUTF8StringEncoding ];
    args[ 2 ] = NULL;
    
    [ app.execution executeWithPrivileges: "/bin/chmod" arguments: args io: NULL ];
}

- ( void )setACLs
{
    ApplicationController * app;
    ACLEntry              * entry;
    User                  * user;
    Group                 * group;
    id                      relation;
    NSString              * name;
    NSString              * type;
    NSString              * aclString;
    NSUInteger              index;
    NSMutableArray        * perms;
    char                  * args[ 4 ];
    
    app = ( ApplicationController * )NSApp;
    
    for( entry in _entries )
    {
        index    = [ _entries indexOfObject: entry ];
        relation = [ _entriesRelations objectAtIndex: index ];
        user     = nil;
        group    = nil;
        perms    = [ NSMutableArray arrayWithCapacity: 100 ];
        
        if( [ relation isKindOfClass: [ User class ] ] )
        {
            user = relation;
            name = [ NSString stringWithFormat: @"user:%@", user.name ];
        }
        else if( [ relation isKindOfClass: [ Group class ] ] )
        {
            group = relation;
            name = [ NSString stringWithFormat: @"group:%@", group.name ];
        }
        
        type = ( entry.type == ACLEntryTypeAllow ) ? @"allow" : @"deny";
        
        if( entry.readAttributes )
        {
            [ perms addObject: @"readattr" ];
        }
        
        if( entry.writeAttributes )
        {
            [ perms addObject: @"writeattr" ];
        }
        
        if( entry.readExtendedAttributes )
        {
            [ perms addObject: @"readextattr" ];
        }
        
        if( entry.writeExtendedAttributes )
        {
            [ perms addObject: @"writeextattr" ];
        }
        
        if( entry.readSecurity )
        {
            [ perms addObject: @"readsecurity" ];
        }
        
        if( entry.writeSecurity )
        {
            [ perms addObject: @"writesecurity" ];
        }
        
        if( entry.delete )
        {
            [ perms addObject: @"delete" ];
        }
        
        if( entry.changeOwner )
        {
            [ perms addObject: @"chown" ];
        }
        
        if( entry.listDirectory )
        {
            [ perms addObject: @"list" ];
        }
        
        if( entry.search )
        {
            [ perms addObject: @"search" ];
        }
        
        if( entry.addFile )
        {
            [ perms addObject: @"add_file" ];
        }
        
        if( entry.addSubDirectory )
        {
            [ perms addObject: @"add_subdirectory" ];
        }
        
        if( entry.deleteChild )
        {
            [ perms addObject: @"delete_child" ];
        }
        
        if( entry.readData )
        {
            [ perms addObject: @"read" ];
        }
        
        if( entry.writeData )
        {
            [ perms addObject: @"write" ];
        }
        
        if( entry.appendData )
        {
            [ perms addObject: @"append" ];
        }
        
        if( entry.execute )
        {
            [ perms addObject: @"execute" ];
        }
        
        aclString = [ NSString stringWithFormat: @"%@ %@ %@", name, type, [ perms componentsJoinedByString: @"," ] ];
        
        args[ 0 ] = "+a";
        args[ 1 ] = ( char * )[ aclString cStringUsingEncoding: NSUTF8StringEncoding ];
        args[ 2 ] = ( char * )[ _path cStringUsingEncoding: NSUTF8StringEncoding ];
        args[ 3 ] = NULL;
        
        [ app.execution executeWithPrivileges: "/bin/chmod" arguments: args io: NULL ];
    }
}

@end

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
    Group    * group;
    id         relation;
    
    ( void )tableView;
    
    entry    = [ _entries objectAtIndex: row ];
    relation = [ _entriesRelations objectAtIndex: row ];
    user     = nil;
    group    = nil;
    
    if( [ relation isKindOfClass: [ User class ] ] )
    {
        user = ( User * )relation;
    }
    else if( [ relation isKindOfClass: [ Group class ] ] )
    {
        group = ( Group * )relation;
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
@synthesize trialNote     = _trialNote;

- ( id )initWithPath: ( NSString * )path
{
    ACLEntry * entry;
    User     * user;
    Group    * group;
    
    if( ( self = [ super initWithWindowNibName: @"ACLEditor" owner: self ] ) )
    {
        if( path == nil || path.length == 0 )
        {
            path = @"/";
        }
        
        _path             = [ path copy ];
        _entries          = [ [ ACLEntry entriesForFile: _path ] mutableCopy ];
        _dscl             = [ DSCLHelper new ];
        _users            = [ [ _dscl users ] retain ];
        _groups           = [ [ _dscl groups ] retain ];
        _entriesRelations = [ [ NSMutableArray alloc ] initWithCapacity: _entries.count ];
        
        for( entry in _entries )
        {
            for( user in _users )
            {
                if( [ user.guid isEqualToString: entry.guid ] )
                {
                    [ _entriesRelations addObject: user ];
                    break;
                }
                
                user = nil;
            }
            
            if( user == nil )
            {
                for( group in _groups )
                {
                    if( [ group.guid isEqualToString: entry.guid ] )
                    {
                        [ _entriesRelations addObject: group ];
                        break;
                    }
                }
            }
        }
    }
    
    return self;
}

- ( void )awakeFromNib
{
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
    
    [ _table setTarget: self ];
    [ _table setDoubleAction: @selector( editACL: ) ];
    
    if( [ [ ESellerate sharedInstance ] isRegistered ] == YES )
    {
        [ _trialNote  setHidden: YES ];
    }
}

- ( void )dealloc
{
    [ _path             release ];
    [ _table            release ];
    [ _removeButton     release ];
    [ _entries          release ];
    [ _dscl             release ];
    [ _users            release ];
    [ _groups           release ];
    [ _entriesRelations release ];
    
    [ super dealloc ];
}

- ( IBAction )cancel: ( id )sender
{
    [ self.window orderOut: sender ];
    [ NSApp endSheet: self.window returnCode: 1 ];
}

- ( IBAction )apply: ( id )sender
{
    NSAlert  * alert;
    
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
    
    [ self clearACLs ];
    [ self setACLs ];
    
    [ self.window orderOut: sender ];
    [ NSApp endSheet: self.window returnCode: 0 ];
}

- ( IBAction )add: ( id )sender
{
    ACLEntryEditorController * acl;
    
    ( void )sender;
    
    acl = [ [ ACLEntryEditorController alloc ] init ];
    
    [ NSApp
        beginSheet:         [ acl window ]
        modalForWindow:     [ self window ]
        modalDelegate:      self
        didEndSelector:     @selector( sheetDidEnd: returnCode: contextInfo: )
        contextInfo:        ( void * )acl
    ];
}

- ( IBAction )remove: ( id )sender
{
    NSInteger index;
    
    ( void )sender;
    
    index = [ _table selectedRow ];
    
    if( index < 0 )
    {
        return;
    }
    
    [ _entries          removeObjectAtIndex: index ];
    [ _entriesRelations removeObjectAtIndex: index ];
    
    [ _table reloadData ];
}

- ( IBAction )editACL: ( id )sender
{
    ACLEntryEditorController * acl;
    NSInteger                  row;
    id                         relation;
    
    ( void )sender;
    
    row = [ _table selectedRow ];
    
    acl      = [ [ ACLEntryEditorController alloc ] init ];
    relation = [ _entriesRelations objectAtIndex: row ];
    acl.acl  = [ _entries objectAtIndex: row ];
    
    [ NSApp
        beginSheet:         [ acl window ]
        modalForWindow:     [ self window ]
        modalDelegate:      self
        didEndSelector:     @selector( sheetDidEnd: returnCode: contextInfo: )
        contextInfo:        ( void * )acl
    ];
}

@end
