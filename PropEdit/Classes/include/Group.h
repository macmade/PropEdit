/*******************************************************************************
 * Copyright (c) __YEAR__, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      Group.h
 * @copyright   eosgarden __YEAR__ - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

/*!
 * @class       Group
 * @abstract    ...
 */
@interface Group: NSObject
{
@protected
    
    NSUInteger gid;
    NSString * name;
    
@private
    
    id r1;
    id r2;
}

@property( assign, readwrite ) NSUInteger gid;
@property( retain, readwrite ) NSString * name;

+ ( id )groupWithName: ( NSString * )groupName gid: ( NSUInteger )groupId;

@end
