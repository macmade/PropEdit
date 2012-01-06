/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      ACLEditorController.h
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

@interface ACLEditorController: NSWindowController
{
@protected
    
    NSString    * _path;
    NSTableView * _table;
    NSButton    * _removeButton;
    
@private
    
    id _ACLEditorController_Reserved[ 5 ] __attribute__( ( unused ) );
}

@property( nonatomic, readwrite, retain ) IBOutlet NSTableView * table;
@property( nonatomic, readwrite, retain ) IBOutlet NSButton    * removeButton;

- ( id )initWithPath: ( NSString * )path;
- ( IBAction )cancel: ( id )sender;
- ( IBAction )apply: ( id )sender;
- ( IBAction )add: ( id )sender;
- ( IBAction )remove: ( id )sender;

@end
