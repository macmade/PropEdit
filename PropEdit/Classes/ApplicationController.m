/* $Id$ */

#import "ApplicationController.h"
#import "AboutController.h"
#import "PreferencesController.h"

@interface ApplicationController( Private )

- ( void )sheetDidEnd: ( NSWindow * )sheet returnCode: ( int )returnCode contextInfo: ( void * )contextInfo;

@end

@implementation ApplicationController

@synthesize preferences;
@synthesize aboutWindow;
@synthesize preferencesPanel;
@synthesize main;

- ( id )init
{
    if( ( self = [ super init ] ) )
    {
        preferences = [ [ NLPreferences alloc ] initWithPropertyList: @"Defaults" owner: self ];
    }
    
    return self;
}

- ( void )dealloc
{
    [ preferences release ];
    [ aboutWindow release ];
    [ preferencesPanel release ];
    [ main release ];
    [ super dealloc ];
}

- ( void )awakeFromNib
{
    [ [ ( NSWindowController * )main window ] center ];
    [ main showWindow: self ];
}

- ( IBAction )openMainWindow: ( id )sender
{
    ( void )sender;
    
    [ main showWindow: self ];
}

- ( IBAction )showPreferences: ( id )sender
{
    ( void )sender;
    
    [ preferencesPanel setPreferences ];
    
    [ NSApp
        beginSheet:         [ preferencesPanel window ]
        modalForWindow:     [ ( NSWindowController * )main window ]
        modalDelegate:      self
        didEndSelector:     @selector( sheetDidEnd: returnCode: contextInfo: )
        contextInfo:        nil
     ];
}

- ( IBAction )showAboutWindow: ( id )sender
{
    ( void )sender;
    
    [ [ aboutWindow window ] center ];
    [ aboutWindow showWindow: self ];
}

- ( void )sheetDidEnd: ( NSWindow * )sheet returnCode: ( int )returnCode contextInfo: ( void * )contextInfo
{
    ( void )sheet;
    ( void )returnCode;
    ( void )contextInfo;
}

@end
