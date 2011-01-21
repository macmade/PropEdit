/* $Id$ */

@class ApplicationController;

@interface PreferencesController: NSWindowController
{
@protected
    
    NSMenuItem            * customLocation;
    NSPopUpButton         * defaultLocation;
    NSButton              * showDotFiles;
    NSButton              * showHiddenFiles;
    NSButton              * sortDirectories;
    NSButton              * warnForRootFiles;
    ApplicationController * app;
    
@private
    
    id r1;
    id r2;
}

@property( nonatomic, retain ) IBOutlet NSPopUpButton * defaultLocation;
@property( nonatomic, retain ) IBOutlet NSButton * showDotFiles;
@property( nonatomic, retain ) IBOutlet NSButton * showHiddenFiles;
@property( nonatomic, retain ) IBOutlet NSButton * sortDirectories;
@property( nonatomic, retain ) IBOutlet NSButton * warnForRootFiles;
@property( nonatomic, retain ) IBOutlet ApplicationController * app;

- ( void )setPreferences;
- ( IBAction )save: ( id )sender;
- ( IBAction )close: ( id )sender;
- ( IBAction )customLocation: ( id )sender;

@end
