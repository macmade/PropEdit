/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        User.m
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "User.h"

@implementation User

@synthesize uid      = _uid;
@synthesize name     = _name;
@synthesize realName = _realName;
@synthesize guid     = _guid;

+ ( User * )userWithDictionary: ( NSDictionary * )dict
{
    User * user;
    
    user = [ [ User alloc ] initWithDictionary: dict ];
    
    return [ user autorelease ];
}

- ( id )init
{
    if( ( self = [ super init ] ) )
    {}
    
    return self;
}

- ( id )initWithDictionary: ( NSDictionary * )dict
{
    NSArray  * uidValues;
    NSArray  * nameValues;
    NSArray  * realNameValues;
    NSArray  * guidValues;
    NSString * uid;
    NSString * name;
    NSString * realName;
    NSString * guid;
    
    if( ( self = [ self init ] ) )
    {
        uidValues       = [ dict objectForKey: @"dsAttrTypeStandard:UniqueID" ] ;
        nameValues      = [ dict objectForKey: @"dsAttrTypeStandard:RecordName" ];
        realNameValues  = [ dict objectForKey: @"dsAttrTypeStandard:RealName" ];
        guidValues      = [ dict objectForKey: @"dsAttrTypeStandard:GeneratedUID" ];
        
        if( uidValues.count == 0 || nameValues.count == 0 || guidValues.count == 0 )
        {
            [ self release ];
            
            return nil;
        }
        
        uid      = [ uidValues      objectAtIndex: 0 ];
        name     = [ nameValues     objectAtIndex: 0 ];
        realName = [ realNameValues objectAtIndex: 0 ];
        guid     = [ guidValues     objectAtIndex: 0 ];
        
        _uid      = [ uid integerValue ];
        _name     = [ name     copy ];
        _realName = [ realName copy ];
        _guid     = [ guid     copy ];
    }
    
    return self;
}

- ( void )dealloc
{
    [ _name     release ];
    [ _realName release ];
    [ _guid     release ];
    
    [ super dealloc ];
}

- ( NSString * )description
{
    return [ NSString stringWithFormat: @"%@: %@ (%lu) %@", [ super description ], _name, ( unsigned long )_uid, _guid ];
}

@end
