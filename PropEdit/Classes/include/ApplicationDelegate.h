/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      ApplicationDelegate.h
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

@interface ApplicationDelegate: NSObject < NSApplicationDelegate >
{
@protected
    
    NSWindow * window;
    
@private
    
    id r1;
    id r2;
}

@property( assign ) IBOutlet NSWindow * window;

@end
