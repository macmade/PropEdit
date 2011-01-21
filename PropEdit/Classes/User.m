/*******************************************************************************
 * Copyright (c) __YEAR__, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        User.m
 * @copyright   eosgarden __YEAR__ - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "User.h"

@implementation User

@synthesize uid;
@synthesize name;

+ ( id )userWithName: ( NSString * )userName uid: ( NSUInteger )userId
{
    User * user;
    
    user = [ [ self alloc ] init ];
    
    [ user setUid: userId ];
    [ user setName: userName ];
    
    return [ user autorelease ];
}

- ( id )init
{
    if( ( self = [ super init ] ) )
    {
        uid  = 0;
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
