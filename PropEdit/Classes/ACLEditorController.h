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
    
    NSString * _path;
    
@private
    
    id _ACLEditorController_Reserved[ 5 ] __attribute__( ( unused ) );
}

- ( id )initWithPath: ( NSString * )path;
- ( IBAction )cancel: ( id )sender;
- ( IBAction )apply: ( id )sender;

@end
