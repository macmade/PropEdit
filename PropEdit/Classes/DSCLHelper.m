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
    User         * user;
    NSFileHandle * fh;
    NSString     * list;
    NSString     * userString;
    NSString     * userName;
    NSString     * userId;
    NSArray      * userList;
    NSArray      * userInfos;
    
    [ users release ];
    
    users    = [ [ NSMutableArray arrayWithCapacity: 100 ] retain ];
    fh       = [ [ ( NLApplication * )( [ NSApplication sharedApplication ] ) execution ] execute: @"/usr/bin/dscl" arguments: [ NSArray arrayWithObjects: @"localhost", @"-list", @"/Local/Default/Users", @"uid", nil ] ];
    list     = [ [ NSString alloc ] initWithData: [ fh readDataToEndOfFile ] encoding: NSUTF8StringEncoding ];
    userList = [ list componentsSeparatedByString: @"\n" ];
    
    for( userString in userList )
    {
        if( [ userString length ] > 0 )
        {
            userInfos = [ userString componentsSeparatedByString: @" " ];
            userName  = [ userInfos objectAtIndex: 0 ];
            userId    = [ userInfos lastObject ];
            user      = [ User userWithName: userName uid: [ userId integerValue ] ];
            
            [ users insertObject: user atIndex: [ userId integerValue ] ];
        }
    }
    
    [ list release ];
}

- ( void )getGroups
{
    Group        * group;
    NSFileHandle * fh;
    NSString     * list;
    NSString     * groupString;
    NSString     * groupName;
    NSString     * groupId;
    NSArray      * groupList;
    NSArray      * groupInfos;
    
    [ groups release ];
    
    groups    = [ [ NSMutableArray arrayWithCapacity: 100 ] retain ];
    fh        = [ [ ( NLApplication * )( [ NSApplication sharedApplication ] ) execution ] execute: @"/usr/bin/dscl" arguments: [ NSArray arrayWithObjects: @"localhost", @"-list", @"/Local/Default/Users", @"uid", nil ] ];
    list      = [ [ NSString alloc ] initWithData: [ fh readDataToEndOfFile ] encoding: NSUTF8StringEncoding ];
    groupList = [ list componentsSeparatedByString: @"\n" ];
    
    for( groupString in groupList )
    {
        if( [ groupString length ] > 0 )
        {
            groupInfos = [ groupString componentsSeparatedByString: @" " ];
            groupName  = [ groupInfos objectAtIndex: 0 ];
            groupId    = [ groupInfos lastObject ];
            group      = [ Group groupWithName: groupName gid: [ groupId integerValue ] ];
            
            [ groups insertObject: group atIndex: [ groupId integerValue ] ];
        }
    }
    
    [ list release ];
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
