/*******************************************************************************
 * Copyright (c) __YEAR__, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      User.h
 * @copyright   eosgarden __YEAR__ - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

/*!
 * @class       User
 * @abstract    ...
 */
@interface User: NSObject
{
@protected
    
    NSUInteger uid;
    NSString * name;
    
@private
    
    id r1;
    id r2;
}

@property( assign, readwrite ) NSUInteger uid;
@property( retain, readwrite ) NSString * name;

+ ( id )userWithName: ( NSString * )userName uid: ( NSUInteger )userId;

@end
