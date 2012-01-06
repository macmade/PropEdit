/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      ApplicationController.h
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

@class MainWindowController;
@class AboutController;
@class PreferencesController;
@class RegisterController;

@interface ApplicationController: NLApplication
{
@protected
    
    NLPreferences         * preferences;
    AboutController       * aboutWindow;
    PreferencesController * preferencesPanel;
    MainWindowController  * main;
    RegisterController    * registerController;
    
@private
    
    id r1;
    id r2;
}

@property( readonly ) NLPreferences * preferences;
@property( nonatomic, retain ) IBOutlet AboutController * aboutWindow;
@property( nonatomic, retain ) IBOutlet PreferencesController * preferencesPanel;
@property( nonatomic, retain ) IBOutlet MainWindowController * main;

- ( IBAction )openMainWindow: ( id )sender;
- ( IBAction )showPreferences: ( id )sender;
- ( IBAction )showAboutWindow: ( id )sender;
- ( IBAction )showRegisterWindow: ( id )sender;

@end
