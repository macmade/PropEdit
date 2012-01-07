/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      User.h
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

/*!
 * @class       User
 * @abstract    ...
 */
@interface User: NSObject
{
@protected
    
    NSUInteger _uid;        /* dsAttrTypeStandard:UniqueID */
    NSString * _name;       /* dsAttrTypeStandard:RecordName */
    NSString * _realName;   /* dsAttrTypeStandard:RealName */
    NSString * _guid;       /* dsAttrTypeStandard:GeneratedUID */
    
@private
    
    id _User_Resrved[ 5 ] __attribute__( ( unused ) );
}

@property( atomic, readonly ) NSUInteger uid;
@property( atomic, readonly ) NSString * name;
@property( atomic, readonly ) NSString * realName;
@property( atomic, readonly ) NSString * guid;

+ ( User * )userWithDictionary: ( NSDictionary * )dict;
- ( id )initWithDictionary: ( NSDictionary * )dict;

@end
