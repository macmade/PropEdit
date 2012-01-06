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
    
    NSTextField * _version;
    NSTextField * _serial;
    
@private
    
    id _AboutController_Reserved[ 5 ] __attribute__( ( unused ) );
}

@property( nonatomic, readwrite, retain ) IBOutlet NSTextField * version;
@property( nonatomic, readwrite, retain ) IBOutlet NSTextField * serial;

@end
