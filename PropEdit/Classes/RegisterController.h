/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      RegisterController.h
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

@class ESellerate;

@interface RegisterController: NSWindowController
{
@protected
    
    NSTextField          * _serial;
    NSProgressIndicator  * _buyProgress;
    ESellerate           * _eSell;
    NSMenuItem           * _menuItem;
    
@private
    
    id _RegisterController_Reserved[ 5 ] __attribute__( ( unused ) );
}

@property( nonatomic, readwrite, retain ) IBOutlet NSTextField          * serial;
@property( nonatomic, readwrite, retain ) IBOutlet NSProgressIndicator  * buyProgress;
@property( atomic,    readwrite, retain ) IBOutlet NSMenuItem           * menuItem;

- ( IBAction )cancel: ( id )sender;
- ( IBAction )validate: ( id )sender;
- ( IBAction )buy: ( id )sender;

@end
