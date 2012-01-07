/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      Group.h
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

/*!
 * @class       Group
 * @abstract    ...
 */
@interface Group: NSObject
{
@protected
    
    NSUInteger _gid;        /* dsAttrTypeStandard:PrimaryGroupID */
    NSString * _name;       /* dsAttrTypeStandard:RecordName */
    NSString * _realName;   /* dsAttrTypeStandard:RealName */
    NSString * _guid;       /* dsAttrTypeStandard:GeneratedUID */
    
@private
    
    id _Group_Resrved[ 5 ] __attribute__( ( unused ) );
}

@property( atomic, readonly ) NSUInteger gid;
@property( atomic, readonly ) NSString * name;
@property( atomic, readonly ) NSString * realName;
@property( atomic, readonly ) NSString * guid;

+ ( Group * )groupWithDictionary: ( NSDictionary * )dict;
- ( id )initWithDictionary: ( NSDictionary * )dict;

@end
