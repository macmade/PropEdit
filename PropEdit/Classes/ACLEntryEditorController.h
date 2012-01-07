/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      ACLEntryEditorController.h
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

@interface ACLEntryEditorController: NSWindowController
{
@protected
    
    NSPopUpButton * _entrySelect;
    NSPopUpButton * _userSelect;
    NSMatrix      * _baseMatrix;
    NSMatrix      * _directoryMatrix;
    NSMatrix      * _fileMatrix;
    
@private
    
    id _ACLEntryEditorController_Reserved[ 5 ] __attribute__( ( unused ) );
}

@property( atomic, retain ) IBOutlet NSPopUpButton * entrySelect;
@property( atomic, retain ) IBOutlet NSPopUpButton * userSelect;
@property( atomic, retain ) IBOutlet NSMatrix      * baseMatrix;
@property( atomic, retain ) IBOutlet NSMatrix      * directoryMatrix;
@property( atomic, retain ) IBOutlet NSMatrix      * fileMatrix;

- ( IBAction )cancel: ( id )sender;
- ( IBAction )save: ( id )sender;

@end
