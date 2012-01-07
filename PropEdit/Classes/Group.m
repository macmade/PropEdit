/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        Group.m
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "Group.h"

@implementation Group

@synthesize gid      = _gid;
@synthesize name     = _name;
@synthesize realName = _realName;
@synthesize guid     = _guid;

+ ( Group * )groupWithDictionary: ( NSDictionary * )dict
{
    Group * group;
    
    group = [ [ Group alloc ] initWithDictionary: dict ];
    
    return [ group autorelease ];
}

- ( id )init
{
    if( ( self = [ super init ] ) )
    {}
    
    return self;
}

- ( id )initWithDictionary: ( NSDictionary * )dict
{
    NSArray  * gidValues;
    NSArray  * nameValues;
    NSArray  * realNameValues;
    NSArray  * guidValues;
    NSString * gid;
    NSString * name;
    NSString * realName;
    NSString * guid;
    
    if( ( self = [ self init ] ) )
    {
        gidValues       = [ dict objectForKey: @"dsAttrTypeStandard:PrimaryGroupID" ] ;
        nameValues      = [ dict objectForKey: @"dsAttrTypeStandard:RecordName" ];
        realNameValues  = [ dict objectForKey: @"dsAttrTypeStandard:RealName" ];
        guidValues      = [ dict objectForKey: @"dsAttrTypeStandard:GeneratedUID" ];
        
        if( gidValues.count == 0 || nameValues.count == 0 || guidValues.count == 0 )
        {
            [ self release ];
            
            return nil;
        }
        
        gid      = [ gidValues      objectAtIndex: 0 ];
        name     = [ nameValues     objectAtIndex: 0 ];
        realName = [ realNameValues objectAtIndex: 0 ];
        guid     = [ guidValues     objectAtIndex: 0 ];
        
        _gid      = [ gid integerValue ];
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

@end
