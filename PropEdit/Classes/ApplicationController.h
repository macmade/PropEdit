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
    NSMenuItem            * registerMenuItem;
    
    #ifndef APPSTORE
    
    RegisterController    * registerController;
    
    #endif
    
@private
    
    id r1;
    id r2;
}

@property( readonly ) NLPreferences * preferences;
@property( nonatomic, retain ) IBOutlet AboutController * aboutWindow;
@property( nonatomic, retain ) IBOutlet PreferencesController * preferencesPanel;
@property( nonatomic, retain ) IBOutlet MainWindowController * main;
@property( nonatomic, retain ) IBOutlet NSMenuItem           * registerMenuItem;

- ( IBAction )openMainWindow: ( id )sender;
- ( IBAction )showPreferences: ( id )sender;
- ( IBAction )showAboutWindow: ( id )sender;

#ifndef APPSTORE

- ( IBAction )showRegisterWindow: ( id )sender;

#endif

@end
