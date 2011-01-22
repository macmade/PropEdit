/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      PreferencesController.h
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

@class ApplicationController;

@interface PreferencesController: NSWindowController
{
@protected
    
    NSMenuItem            * customLocation;
    NSPopUpButton         * defaultLocation;
    NSButton              * showDotFiles;
    NSButton              * showHiddenFiles;
    NSButton              * sortDirectories;
    ApplicationController * app;
    
@private
    
    id r1;
    id r2;
}

@property( nonatomic, retain ) IBOutlet NSPopUpButton         * defaultLocation;
@property( nonatomic, retain ) IBOutlet NSButton              * showDotFiles;
@property( nonatomic, retain ) IBOutlet NSButton              * showHiddenFiles;
@property( nonatomic, retain ) IBOutlet NSButton              * sortDirectories;
@property( nonatomic, retain ) IBOutlet ApplicationController * app;

- ( void )setPreferences;
- ( IBAction )save: ( id )sender;
- ( IBAction )close: ( id )sender;
- ( IBAction )customLocation: ( id )sender;

@end
