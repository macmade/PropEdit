/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      DSCLHelper.m
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "DSCLHelper.h"
#import "User.h"
#import "Group.h"

@interface DSCLHelper( Private )

- ( void )getUsers;
- ( void )getGroups;

@end

@implementation DSCLHelper( Private )

- ( void )getUsers
{
    NSFileHandle       * fh;
    NSData             * plistData;
    NSArray            * plist;
    NSDictionary       * userDict;
    User               * user;
    NSPropertyListFormat format;
    
    [ users release ];
    
    format    = NSPropertyListXMLFormat_v1_0;
    users     = [ [ NSMutableArray arrayWithCapacity: 100 ] retain ];
    fh        = [ [ ( NLApplication * )( [ NSApplication sharedApplication ] ) execution ] execute: @"/usr/bin/dscl" arguments: [ NSArray arrayWithObjects: @"-plist", @"localhost", @"-readall", @"/Local/Default/Users", nil ] ];
    plistData = [ fh readDataToEndOfFile ];
    plist     = ( NSArray * )[ NSPropertyListSerialization propertyListFromData: plistData mutabilityOption: NSPropertyListMutableContainersAndLeaves format: &format errorDescription: NULL ];
    
    if( plist != nil )
    {
        for( userDict in plist )
        {
            user = [ User userWithDictionary: userDict ];
            
            if( user != nil )
            {
                [ users addObject: user ];
            }
        }
    }
}

- ( void )getGroups
{
    NSFileHandle       * fh;
    NSData             * plistData;
    NSArray            * plist;
    NSDictionary       * groupDict;
    Group              * group;
    NSPropertyListFormat format;
    
    [ groups release ];
    
    format    = NSPropertyListXMLFormat_v1_0;
    groups    = [ [ NSMutableArray arrayWithCapacity: 100 ] retain ];
    fh        = [ [ ( NLApplication * )( [ NSApplication sharedApplication ] ) execution ] execute: @"/usr/bin/dscl" arguments: [ NSArray arrayWithObjects: @"-plist", @"localhost", @"-readall", @"/Local/Default/Groups", nil ] ];
    plistData = [ fh readDataToEndOfFile ];
    plist     = ( NSArray * )[ NSPropertyListSerialization propertyListFromData: plistData mutabilityOption: NSPropertyListMutableContainersAndLeaves format: &format errorDescription: NULL ];
    
    if( plist != nil )
    {
        for( groupDict in plist )
        {
            group = [ Group groupWithDictionary: groupDict ];
            
            if( group != nil )
            {
                [ groups addObject: group ];
            }
        }
    }
}

@end

@implementation DSCLHelper

- ( id )init
{
    if( ( self = [ super init ] ) )
    {
        users  = nil;
        groups = nil;
    }
    
    return self;
}

- ( void )dealloc
{
    [ users  release ];
    [ groups release ];
    [ super  dealloc ];
}

- ( NSArray * )users
{
    if( users == nil )
    {
        [ self getUsers ];
    }
    
    return [ NSArray arrayWithArray: users ];
}

- ( NSArray * )groups
{
    if( groups == nil )
    {
        [ self getGroups ];
    }
    
    return [ NSArray arrayWithArray: groups ];
}

@end
