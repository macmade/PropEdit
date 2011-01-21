/*******************************************************************************
 * Copyright (c) __YEAR__, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        Group.m
 * @copyright   eosgarden __YEAR__ - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "Group.h"

@implementation Group

@synthesize gid;
@synthesize name;

+ ( id )groupWithName: ( NSString * )groupName gid: ( NSUInteger )groupId
{
    Group * group;
    
    group = [ [ self alloc ] init ];
    
    [ group setGid:  groupId ];
    [ group setName: groupName ];
    
    return [ group autorelease ];
}

- ( id )init
{
    if( ( self = [ super init ] ) )
    {
        gid  = 0;
        name = nil;
    }
    
    return self;
}

- ( void )dealloc
{
    [ name release ];
    [ super dealloc ];
}

@end
