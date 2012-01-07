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
    NSTextField * _filePathLabel;
    NSImageView * _fileIcon;
    NSArray     * _entries;
    
@private
    
    id _ACLEditorController_Reserved[ 5 ] __attribute__( ( unused ) );
}

@property( nonatomic, readwrite, retain ) IBOutlet NSTableView * table;
@property( nonatomic, readwrite, retain ) IBOutlet NSButton    * removeButton;
@property( nonatomic, readwrite, retain ) IBOutlet NSTextField * filePathLabel;
@property( nonatomic, readwrite, retain ) IBOutlet NSImageView * fileIcon;

- ( id )initWithPath: ( NSString * )path;
- ( IBAction )cancel: ( id )sender;
- ( IBAction )apply: ( id )sender;
- ( IBAction )add: ( id )sender;
- ( IBAction )remove: ( id )sender;

@end
