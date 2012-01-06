/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      AboutController.h
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

@interface AboutController: NSWindowController
{
@protected
    
    NSTextField * version;
    
@private
    
    id r1;
    id r2;
}

@property( atomic, readwrite, retain ) IBOutlet NSTextField * version;

@end
