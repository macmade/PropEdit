/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      MainWindowController.h
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

@class ApplicationController;

@interface MainWindowController: NSWindowController < NSBrowserDelegate, NSWindowDelegate >
{
@protected
    
    BOOL                    hasApplyView;
    BOOL                    recursive;
    NSMutableDictionary   * files;
    NSFileManager         * fileManager;
    NSWorkspace           * workspace;
    NSString              * displayName;
    NSString              * displayPath;
    NSArray               * displayPathInfos;
    NSBrowser             * browser;
    NSImageView           * icon;
    NSPathControl         * path;
    NSPopUpButton         * owner;
    NSPopUpButton         * group;
    NSButton              * userRead;
    NSButton              * userWrite;
    NSButton              * userExec;
    NSButton              * groupRead;
    NSButton              * groupWrite;
    NSButton              * groupExec;
    NSButton              * worldRead;
    NSButton              * worldWrite;
    NSButton              * worldExec;
    NSButton              * setUID;
    NSButton              * setGID;
    NSButton              * sticky;
    NSButton              * flagArchived;
    NSButton              * flagHidden;
    NSButton              * flagNoDump;
    NSButton              * flagOpaque;
    NSButton              * flagUserAppendOnly;
    NSButton              * flagUserImmutable;
    NSButton              * flagSystemAppendOnly;
    NSButton              * flagSystemImmutable;
    NLView                * leftView;
    NLView                * rightView;
    NLView                * bottomView;
    NLView                * applyView;
    NSTextField           * fileInfos;
    NSMenuItem            * goComputerMenu;
    NSMenuItem            * goHomeMenu;
    NSMenuItem            * goDesktopMenu;
    NSMenuItem            * goNetworkMenu;
    NSMenuItem            * goApplicationsMenu;
    NSMenuItem            * goUtilitiesMenu;
    ApplicationController * app;
    NLFileInfos           * currentFile;
    
@private
    
    id r1;
    id r2;
}

@property( nonatomic, retain ) IBOutlet NSBrowser     * browser;
@property( nonatomic, retain ) IBOutlet NSImageView   * icon;
@property( nonatomic, retain ) IBOutlet NSPathControl * path;
@property( nonatomic, retain ) IBOutlet NSPopUpButton * owner;
@property( nonatomic, retain ) IBOutlet NSPopUpButton * group;
@property( nonatomic, retain ) IBOutlet NSButton      * userRead;
@property( nonatomic, retain ) IBOutlet NSButton      * userWrite;
@property( nonatomic, retain ) IBOutlet NSButton      * userExec;
@property( nonatomic, retain ) IBOutlet NSButton      * groupRead;
@property( nonatomic, retain ) IBOutlet NSButton      * groupWrite;
@property( nonatomic, retain ) IBOutlet NSButton      * groupExec;
@property( nonatomic, retain ) IBOutlet NSButton      * worldRead;
@property( nonatomic, retain ) IBOutlet NSButton      * worldWrite;
@property( nonatomic, retain ) IBOutlet NSButton      * worldExec;
@property( nonatomic, retain ) IBOutlet NSButton      * setUID;
@property( nonatomic, retain ) IBOutlet NSButton      * setGID;
@property( nonatomic, retain ) IBOutlet NSButton      * sticky;
@property( nonatomic, retain ) IBOutlet NSButton      * flagArchived;
@property( nonatomic, retain ) IBOutlet NSButton      * flagHidden;
@property( nonatomic, retain ) IBOutlet NSButton      * flagNoDump;
@property( nonatomic, retain ) IBOutlet NSButton      * flagOpaque;
@property( nonatomic, retain ) IBOutlet NSButton      * flagUserAppendOnly;
@property( nonatomic, retain ) IBOutlet NSButton      * flagUserImmutable;
@property( nonatomic, retain ) IBOutlet NSButton              * flagSystemAppendOnly;
@property( nonatomic, retain ) IBOutlet NSButton              * flagSystemImmutable;
@property( nonatomic, retain ) IBOutlet NLView                * leftView;
@property( nonatomic, retain ) IBOutlet NLView                * rightView;
@property( nonatomic, retain ) IBOutlet NLView                * bottomView;
@property( nonatomic, retain ) IBOutlet NLView                * applyView;
@property( nonatomic, retain ) IBOutlet NSTextField           * fileInfos;
@property( nonatomic, retain ) IBOutlet NSMenuItem            * goComputerMenu;
@property( nonatomic, retain ) IBOutlet NSMenuItem            * goHomeMenu;
@property( nonatomic, retain ) IBOutlet NSMenuItem            * goDesktopMenu;
@property( nonatomic, retain ) IBOutlet NSMenuItem            * goNetworkMenu;
@property( nonatomic, retain ) IBOutlet NSMenuItem            * goApplicationsMenu;
@property( nonatomic, retain ) IBOutlet NSMenuItem            * goUtilitiesMenu;
@property( nonatomic, retain ) IBOutlet ApplicationController * app;

- ( void )getAvailableUsers;
- ( void )getAvailableGroups;
- ( void )enableControls;
- ( void )getFileAttributes;
- ( void )getFileInfos;
- ( void )getFiles: ( NSString * )readPath;
- ( IBAction )selectFile: ( id )sender;
- ( IBAction )apply: ( id )sender;
- ( IBAction )applyRecursive: ( id )sender;
- ( IBAction )showApplyView: ( id )sender;
- ( IBAction )hideApplyView: ( id )sender;
- ( IBAction )goComputer: ( id )sender;
- ( IBAction )goHome: ( id )sender;
- ( IBAction )goDesktop: ( id )sender;
- ( IBAction )goNetwork: ( id )sender;
- ( IBAction )goApplications: ( id )sender;
- ( IBAction )goUtilities: ( id )sender;

@end
