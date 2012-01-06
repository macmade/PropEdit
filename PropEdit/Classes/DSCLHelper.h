/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      DSCLHelper.h
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

@interface DSCLHelper: NSObject
{
@protected
    
    NSMutableArray * users;
    NSMutableArray * groups;
    
@private
   
   id r1;
   id r2;
}

@property( readonly ) NSArray * users;
@property( readonly ) NSArray * groups;

@end
