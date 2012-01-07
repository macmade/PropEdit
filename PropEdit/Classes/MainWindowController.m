/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * file         MainWindowController.m
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import <sys/stat.h>

#import "MainWindowController.h"
#import "ApplicationController.h"
#import "DSCLHelper.h"
#import "User.h"
#import "Group.h"
#import "ACLEditorController.h"

/*******************************************************************************
 * Private methods
 ******************************************************************************/

#pragma mark - Private methods -

@interface MainWindowController( NSTextFieldDelegate ) < NSTextFieldDelegate >

@end

@implementation MainWindowController( NSTextFieldDelegate )

- ( BOOL )control: ( NSControl * )control textShouldEndEditing: ( NSText * )fieldEditor
{
    NSUInteger   u;
    NSUInteger   g;
    NSUInteger   o;
    NSString   * perms;
    NSString   * previousPerms;
    const char * cPerms;
    
    ( void )control;
    ( void )fieldEditor;
    
    perms = [ octal stringValue ];
    u     = 0;
    g     = 0;
    o     = 0;
    
    u |= ( [ userRead  intValue ] ) ? 4 : 0;
    u |= ( [ userWrite intValue ] ) ? 2 : 0;
    u |= ( [ userExec  intValue ] ) ? 1 : 0;
    
    g |= ( [ groupRead  intValue ] ) ? 4 : 0;
    g |= ( [ groupWrite intValue ] ) ? 2 : 0;
    g |= ( [ groupExec  intValue ] ) ? 1 : 0;
    
    o |= ( [ worldRead  intValue ] ) ? 4 : 0;
    o |= ( [ worldWrite intValue ] ) ? 2 : 0;
    o |= ( [ worldExec  intValue ] ) ? 1 : 0;
    
    previousPerms = [ NSString stringWithFormat: @"%u%u%u", u, g, o ];
    
    if( perms.length != 3 )
    {
        NSBeep();
        [ octal setStringValue: previousPerms ];
    }
    else
    {
        cPerms = [ perms cStringUsingEncoding: NSASCIIStringEncoding ];
        
        if
        (
               cPerms[ 0 ] >= 48 && cPerms[ 0 ] <= 55
            && cPerms[ 1 ] >= 48 && cPerms[ 1 ] <= 55
            && cPerms[ 2 ] >= 48 && cPerms[ 2 ] <= 55
        )
        {
            u = cPerms[ 0 ] - 48;
            g = cPerms[ 1 ] - 48;
            o = cPerms[ 2 ] - 48;
            
            [ userRead  setIntValue: ( u & 4 ) ? 1 : 0 ];
            [ userWrite setIntValue: ( u & 2 ) ? 1 : 0 ];
            [ userExec  setIntValue: ( u & 1 ) ? 1 : 0 ];
            
            [ groupRead  setIntValue: ( g & 4 ) ? 1 : 0 ];
            [ groupWrite setIntValue: ( g & 2 ) ? 1 : 0 ];
            [ groupExec  setIntValue: ( g & 1 ) ? 1 : 0 ];
            
            [ worldRead  setIntValue: ( o & 4 ) ? 1 : 0 ];
            [ worldWrite setIntValue: ( o & 2 ) ? 1 : 0 ];
            [ worldExec  setIntValue: ( o & 1 ) ? 1 : 0 ];
            
            [ self showApplyView: nil ];
        }
        else
        {
            NSBeep();
            [ octal setStringValue: previousPerms ];
        }
    }
    
    
    return YES;
}

@end

@interface MainWindowController( Private )

- ( void )openFile: ( id )sender;
- ( void )openPath: ( id )sender;
- ( void )go: ( NSString * )pathTo;
- ( void )apply;
- ( OSStatus )chown;
- ( OSStatus )chmod;
- ( OSStatus )chflags;
- ( void )sheetDidEnd: ( NSWindow * )sheet returnCode: ( int )returnCode contextInfo: ( void * )contextInfo;

@end

@implementation MainWindowController( Private )

- ( void )openFile: ( id )sender
{
    ( void )sender;
    
    [ app.execution open: [ browser path ] ];
}

- ( void )openPath: ( id )sender
{
    NSPathComponentCell * cell;
    NSString            * filePath;

    cell     = [ sender clickedPathComponentCell ];
    filePath = [ [ cell URL ] path ];

    [ app.execution open: filePath ];
}

- ( void )go: ( NSString * )pathTo
{
    [ browser setPath: pathTo ];
    [ self selectFile: nil ];
}

- ( void )apply
{
    OSStatus err;
    
    err = [ self chown ];
    
    if( err != 0 )
    {
        return;
    }
    
    err = [ self chmod ];
    
    if( err != 0 )
    {
        return;
    }
    
    err = [ self chflags ];
    
    if( err != 0 )
    {
        return;
    }
    
    [ self hideApplyView: nil ];
}

- ( OSStatus )chown
{
    char     * args[ 4 ] = { NULL, NULL, NULL, NULL };
    NSString * user;
    NSString * userGroup;
    NSString * chownArgs;
    NSString * file;
    
    user      = [ [ owner selectedItem ] representedObject ];
    userGroup = [ [ group selectedItem ] representedObject ];
    chownArgs = [ NSString stringWithFormat: @"%@:%@", user, userGroup ];
    
    NSLog( @"%@", chownArgs );
    
    file      = [ displayPath substringToIndex: [ displayPath length ] - 1 ];
    
    if( recursive )
    {
        args[ 0 ] = "-R";
        args[ 1 ] = ( char * )[ chownArgs cStringUsingEncoding: NSUTF8StringEncoding ];
        args[ 2 ] = ( char * )[ file cStringUsingEncoding: NSUTF8StringEncoding ];
    }
    else
    {
        args[ 0 ] = ( char * )[ chownArgs cStringUsingEncoding: NSUTF8StringEncoding ];
        args[ 1 ] = ( char * )[ file cStringUsingEncoding: NSUTF8StringEncoding ];
    }
    
    return [ app.execution executeWithPrivileges: "/usr/sbin/chown" arguments: args io: NULL ];
}

- ( OSStatus )chmod
{
    int perms;
    char octalPerms[ 5 ] = { 0, 0, 0, 0, 0 };
    char     * args[ 4 ] = { NULL, NULL, NULL, NULL };
    NSString * file;
    
    file   = [ displayPath substringToIndex: [ displayPath length ] - 1 ];
    perms  = 0;
    perms |= [ setUID intValue ]     * 2048;
    perms |= [ setGID intValue ]     * 1024;
    perms |= [ sticky intValue ]     * 512;
    perms |= [ userRead intValue ]   * 256;
    perms |= [ userWrite intValue ]  * 128;
    perms |= [ userExec intValue ]   * 64;
    perms |= [ groupRead intValue ]  * 32;
    perms |= [ groupWrite intValue ] * 16;
    perms |= [ groupExec intValue ]  * 8;
    perms |= [ worldRead intValue ]  * 4;
    perms |= [ worldWrite intValue ] * 2;
    perms |= [ worldExec intValue ]  * 1;
    
    sprintf( octalPerms, "%o", perms );
    
    if( recursive )
    {
        args[ 0 ] = "-R";
        args[ 1 ] = octalPerms;
        args[ 2 ] = ( char * )[ file cStringUsingEncoding: NSUTF8StringEncoding ];
    }
    else
    {
        args[ 0 ] = octalPerms;
        args[ 1 ] = ( char * )[ file cStringUsingEncoding: NSUTF8StringEncoding ];
    }
    
    return [ app.execution executeWithPrivileges: "/bin/chmod" arguments: args io: NULL ];
}

- ( OSStatus )chflags
{
    char           * args[ 4 ] = { NULL, NULL, NULL, NULL };
    NSString       * file;
    NSMutableArray * flags;
    
    file   = [ displayPath substringToIndex: [ displayPath length ] - 1 ];
    flags  = [ NSMutableArray arrayWithCapacity: 8 ];
    
    [ flags addObject: ( [ flagArchived intValue ]         == 1 ) ? @"arch"   : @"noarch" ];
    [ flags addObject: ( [ flagHidden intValue ]           == 1 ) ? @"hidden" : @"nohidden" ];
    [ flags addObject: ( [ flagNoDump intValue ]           == 1 ) ? @"nodump" : @"dump" ];
    [ flags addObject: ( [ flagOpaque intValue ]           == 1 ) ? @"opaque" : @"noopaque" ];
    [ flags addObject: ( [ flagSystemAppendOnly intValue ] == 1 ) ? @"sappnd" : @"nosappnd" ];
    [ flags addObject: ( [ flagSystemImmutable intValue ]  == 1 ) ? @"schg"   : @"noschg" ];
    [ flags addObject: ( [ flagUserAppendOnly intValue ]   == 1 ) ? @"uappnd" : @"nouappnd" ];
    [ flags addObject: ( [ flagUserImmutable intValue ]    == 1 ) ? @"uchg"   : @"nouchg" ];
    
    if( recursive )
    {
        args[ 0 ] = "-R";
        args[ 1 ] = ( char * )[ [ flags componentsJoinedByString: @"," ] cStringUsingEncoding: NSUTF8StringEncoding ];
        args[ 2 ] = ( char * )[ file cStringUsingEncoding: NSUTF8StringEncoding ];
    }
    else
    {
        args[ 0 ] = ( char * )[ [ flags componentsJoinedByString: @"," ] cStringUsingEncoding: NSUTF8StringEncoding ];
        args[ 1 ] = ( char * )[ file cStringUsingEncoding: NSUTF8StringEncoding ];
    }
    
    return [ app.execution executeWithPrivileges: "/usr/bin/chflags" arguments: args io: NULL ];
}

- ( void )sheetDidEnd: ( NSWindow * )sheet returnCode: ( int )returnCode contextInfo: ( void * )contextInfo
{
    ( void )sheet;
    ( void )returnCode;
    
    [ ( id )contextInfo release ];
}

@end

@implementation MainWindowController

/*******************************************************************************
 * Properties
 ******************************************************************************/

#pragma mark - Properties -

@synthesize browser;
@synthesize icon;
@synthesize path;
@synthesize owner;
@synthesize group;
@synthesize userRead;
@synthesize userWrite;
@synthesize userExec;
@synthesize groupRead;
@synthesize groupWrite;
@synthesize groupExec;
@synthesize worldRead;
@synthesize worldWrite;
@synthesize worldExec;
@synthesize setUID;
@synthesize setGID;
@synthesize sticky;
@synthesize flagArchived;
@synthesize flagHidden;
@synthesize flagNoDump;
@synthesize flagOpaque;
@synthesize flagUserAppendOnly;
@synthesize flagUserImmutable;
@synthesize flagSystemAppendOnly;
@synthesize flagSystemImmutable;
@synthesize leftView;
@synthesize rightView;
@synthesize bottomView;
@synthesize applyView;
@synthesize fileInfos;
@synthesize goComputerMenu;
@synthesize goHomeMenu;
@synthesize goDesktopMenu;
@synthesize goNetworkMenu;
@synthesize goApplicationsMenu;
@synthesize goUtilitiesMenu;
@synthesize app;
@synthesize octal;

/*******************************************************************************
 * Initialization
 ******************************************************************************/

#pragma mark - Initialization -

- ( id )init
{
    if( ( self = [ super init ] ) )
    {
        fileManager = [ NSFileManager defaultManager ];
        workspace   = [ NSWorkspace sharedWorkspace ];
        files       = [ [ NSMutableDictionary dictionaryWithCapacity: 500 ] retain ];
    }
    
    return self;
}

- ( void )dealloc
{
    [ displayPath release ];
    [ displayPathInfos release ];
    [ files release ];
    [ currentFile release ];
    [ super dealloc ];
}

- ( void )awakeFromNib
{
    NSInteger    defaultLocation;
    NSString   * initialPath;
    DSCLHelper * dscl;
    
    defaultLocation = [ app.preferences.values integerForKey: @"DefaultLocation" ];
    
    [ octal setDelegate: self ];
    
    switch( defaultLocation )
    {
        case 1:
            
            initialPath = @"/";
            break;
            
        case 2:
            
            initialPath = NSHomeDirectory();
            
            [ self enableControls ];
            break;
            
        case 3:
            
            initialPath = [ NSString stringWithFormat: @"%@/Documents", NSHomeDirectory() ];
            
            [ self enableControls ];
            break;
            
        case 4:
            
            initialPath = [ NSString stringWithFormat: @"%@/Desktop", NSHomeDirectory() ];
            
            [ self enableControls ];
            break;
            
        case 5:
            
            initialPath = [ app.preferences.values objectForKey: @"CustomLocation" ];
            
            [ self enableControls ];
            break;
            
        default:
            
            initialPath = NSHomeDirectory();
            
            [ self enableControls ];
            break;
    }
    
    currentFile = [ [ NLFileInfos createFromPath: initialPath ] retain ];
    
    /* Creates the DSCL helper instance */
    dscl = [ DSCLHelper new ];
    
    /* Path bar initialization */
    [ path setURL: currentFile.url ];
    [ path setDoubleAction: @selector( openPath: ) ];
    
    /* Browser initialization */
    [ browser setDelegate: self ];
    [ browser setSendsActionOnArrowKeys: YES ];
    [ browser setDoubleAction: @selector( openFile: ) ];
    
    /* Fills the users and groups select menus */
    [ self getAvailableUsers: dscl ];
    [ self getAvailableGroups: dscl ];
    
    /* View initialization */
    [ [ self window ] setTitle: currentFile.displayName ];
    [ browser setPath: currentFile.path ];
    [ icon setImage: [ workspace iconForFile: currentFile.path ] ];
    
    /* Stores path informations */
    displayPath      = [ [ NSString alloc ] initWithString: currentFile.path ];
    displayPathInfos = [ [ displayPath componentsSeparatedByString: @"/" ] retain ];
    
    /* Gets the files for the current directory */
    [ self getFiles: displayPath ];
    [ self getFileInfos ];
    [ self getFileAttributes ];
    
    /* Sets the window delegate */
    [ [ self window ] setDelegate: self ];
    
    /* Menu initialization */
    [ goComputerMenu       setImage: [ NSImage imageNamed: NSImageNameComputer ] ];
    [ goHomeMenu           setImage: [ workspace iconForFile: [ NSString stringWithFormat: @"/Users/%@", NSUserName() ] ] ];
    [ goDesktopMenu        setImage: [ workspace iconForFile: [ NSString stringWithFormat: @"/Users/%@/Desktop", NSUserName() ] ] ];
    [ goNetworkMenu        setImage: [ NSImage imageNamed: NSImageNameNetwork ] ];
    [ goApplicationsMenu   setImage: [ workspace iconForFile: @"/Applications" ] ];
    [ goUtilitiesMenu      setImage: [ workspace iconForFile: @"/Applications/Utilities" ] ];
    [ [ goComputerMenu     image ] setSize: NSMakeSize( 16, 16 ) ];
    [ [ goHomeMenu         image ] setSize: NSMakeSize( 16, 16 ) ];
    [ [ goDesktopMenu      image ] setSize: NSMakeSize( 16, 16 ) ];
    [ [ goNetworkMenu      image ] setSize: NSMakeSize( 16, 16 ) ];
    [ [ goApplicationsMenu image ] setSize: NSMakeSize( 16, 16 ) ];
    [ [ goUtilitiesMenu    image ] setSize: NSMakeSize( 16, 16 ) ];
    
    [ dscl release ];
}

/*******************************************************************************
 * Window management
 ******************************************************************************/

#pragma mark - Window management -

- ( void )windowDidBecomeKey: ( NSNotification * )notification
{
    ( void )notification;
    
    [ path setBackgroundColor: [ NSColor finderSidebarColor ] ];
    
    leftView.backgroundColor   = [ NSColor finderSidebarColor ];
    rightView.backgroundColor  = [ NSColor finderSidebarColor ];
    bottomView.backgroundColor = [ NSColor finderSidebarColor ];
    applyView.backgroundImage  = [ NSImage imageNamed: @"DarkGradient" ];
}

- ( void )windowDidResignKey: ( NSNotification * )notification
{
    ( void )notification;
    
    [ path setBackgroundColor: [ NSColor disabledFinderSidebarColor ] ];
    
    leftView.backgroundColor   = [ NSColor disabledFinderSidebarColor ];
    rightView.backgroundColor  = [ NSColor disabledFinderSidebarColor ];
    bottomView.backgroundColor = [ NSColor disabledFinderSidebarColor ];
    applyView.backgroundColor  = [ NSColor disabledFinderSidebarColor ];
}

/*******************************************************************************
 * Controls management
 ******************************************************************************/

#pragma mark - Controls management -

- ( void )getAvailableUsers: ( DSCLHelper * )helper
{
    User     * userObject;
    NSString * itemTitle;
    
    [ owner removeAllItems ];
    
    for( userObject in helper.users )
    {
        if( userObject.realName != nil )
        {
            itemTitle = [ NSString stringWithFormat: @"%@ (%i) - %@", userObject.name, userObject.uid, userObject.realName ];
        }
        else
        {
            itemTitle = [ NSString stringWithFormat: @"%@ (%i)", userObject.name, userObject.uid ];
        }
        
        [ owner addItemWithTitle: itemTitle ];
        [ [ owner itemWithTitle: itemTitle ] setTag: userObject.uid ];
        [ [ owner itemWithTitle: itemTitle ] setRepresentedObject: userObject.name ];
        [ [ owner itemWithTitle: itemTitle ] setImage: [ NSImage imageNamed: NSImageNameUser ] ];
        [ [ [ owner itemWithTitle: itemTitle ] image ] setSize: NSMakeSize( 16, 16 ) ];
    }
    
    [ owner selectItemWithTag: 0 ];
}

- ( void )getAvailableGroups: ( DSCLHelper * )helper
{
    Group    * groupObject;
    NSString * itemTitle;
    
    [ group removeAllItems ];
    
    for( groupObject in helper.groups )
    {
        if( groupObject.realName != nil )
        {
            itemTitle = [ NSString stringWithFormat: @"%@ (%i) - %@", groupObject.name, groupObject.gid, groupObject.realName ];
        }
        else
        {
            itemTitle = [ NSString stringWithFormat: @"%@ (%i)", groupObject.name, groupObject.gid ];
        }
        
        [ group addItemWithTitle: itemTitle ];
        [ [ group itemWithTitle: itemTitle ] setTag: groupObject.gid ];
        [ [ group itemWithTitle: itemTitle ] setRepresentedObject: groupObject.name ];
        [ [ group itemWithTitle: itemTitle ] setImage: [ NSImage imageNamed: NSImageNameUserGroup ] ];
        [ [ [ group itemWithTitle: itemTitle ] image ] setSize: NSMakeSize( 16, 16 ) ];
    }
    
    [ group selectItemWithTag: 0 ];
}

- ( void )enableControls
{
    [ owner setEnabled:                YES ];
    [ group setEnabled:                YES ];
    [ userRead setEnabled:             YES ];
    [ userWrite setEnabled:            YES ];
    [ userExec setEnabled:             YES ];
    [ groupRead setEnabled:            YES ];
    [ groupWrite setEnabled:           YES ];
    [ groupExec setEnabled:            YES ];
    [ worldRead setEnabled:            YES ];
    [ worldWrite setEnabled:           YES ];
    [ worldExec setEnabled:            YES ];
    [ setUID setEnabled:               YES ];
    [ setGID setEnabled:               YES ];
    [ sticky setEnabled:               YES ];
    [ flagArchived setEnabled:         YES ];
    [ flagHidden setEnabled:           YES ];
    [ flagNoDump setEnabled:           YES ];
    [ flagOpaque setEnabled:           YES ];
    [ flagSystemAppendOnly setEnabled: YES ];
    [ flagSystemImmutable setEnabled:  YES ];
    [ flagUserAppendOnly setEnabled:   YES ];
    [ flagUserImmutable setEnabled:    YES ];
}

- ( void )disableFlagControls
{
    [ flagArchived setEnabled:         NO ];
    [ flagHidden setEnabled:           NO ];
    [ flagNoDump setEnabled:           NO ];
    [ flagOpaque setEnabled:           NO ];
    [ flagSystemAppendOnly setEnabled: NO ];
    [ flagSystemImmutable setEnabled:  NO ];
    [ flagUserAppendOnly setEnabled:   NO ];
    [ flagUserImmutable setEnabled:    NO ];
}

/*******************************************************************************
 * Interface actions
 ******************************************************************************/

#pragma mark - Interface actions -

- ( IBAction )goComputer: ( id )sender
{
    ( void )sender;
    
    [ self go: @"/" ];
}

- ( IBAction )goHome: ( id )sender
{
    ( void )sender;
    
    [ self go: [ NSString stringWithFormat: @"/Users/%@/", NSUserName() ] ];
}

- ( IBAction )goDesktop: ( id )sender
{
    ( void )sender;
    
    [ self go: [ NSString stringWithFormat: @"/Users/%@/Desktop/", NSUserName() ] ];
}

- ( IBAction )goNetwork: ( id )sender
{
    ( void )sender;
    
    [ self go: @"/Network/" ];
}

- ( IBAction )goApplications: ( id )sender
{
    ( void )sender;
    
    [ self go: @"/Applications/" ];
}

- ( IBAction )goUtilities: ( id )sender
{
    ( void )sender;
    
    [ self go: @"/Applications/Utilities/" ];
}

- ( IBAction )apply: ( id )sender
{
    ( void )sender;
    
    recursive = NO;
    
    [ self apply ];
}

- ( IBAction )applyRecursive: ( id )sender
{
    ( void )sender;
    
    recursive = YES;
    
    [ self apply ];
}

- ( IBAction )showApplyView: ( id )sender
{
    NSRect   applyFrame;
    NSRect   browserFrame;
    NSView * content;
    
    ( void )sender;
    
    content               = [ [ self window ] contentView ];
    browserFrame          = [ browser frame ];
    applyFrame            = [ applyView frame ];
    applyFrame.size.width = [ browser frame ].size.width;
    
    if( hasApplyView == YES )
    {
        return;
    }
    
    applyFrame.origin.x       = [ browser frame ].origin.x;
    applyFrame.origin.y       = [ browser frame ].origin.y;
    browserFrame.size.height -= 56;
    browserFrame.origin.y    += 56;
    [ browser setFrame: browserFrame ];
    
    [ applyView setAutoresizingMask: NSViewWidthSizable ];
    [ applyView setFrame: applyFrame ];
    [ content addSubview: applyView ];
    
    hasApplyView = YES;
}

- ( IBAction )hideApplyView: ( id )sender
{
    NSRect   browserFrame;
    NSView * content;
    
    ( void )sender;
    
    content      = [ [ self window ] contentView ];
    browserFrame = [ browser frame ];
    
    if( hasApplyView == NO )
    {
        return;
    }
    
    browserFrame.size.height += 56;
    browserFrame.origin.y    -= 56;
    
    [ [ applyView retain ] removeFromSuperview ];
    [ browser setFrame: browserFrame ];
    
    hasApplyView = NO;
}

- ( IBAction )selectFile: ( id )sender
{
    if( hasApplyView == YES )
    {
        [ self hideApplyView: sender ];
    }
    
    [ displayPath release ];
    [ displayPathInfos release ];
    
    displayPath      = [ [ NSString alloc ] initWithString: [ [ browser path ] stringByAppendingString: @"/" ] ];
    displayPathInfos = [ [ displayPath componentsSeparatedByString: @"/" ] retain ];
    
    [ path setURL: [ NSURL URLWithString: [ @"file://localhost" stringByAppendingString: [ displayPath stringByReplacingOccurrencesOfString: @" " withString: @"%20" ] ] ] ];
    [ icon setImage: [ workspace iconForFile: displayPath ] ];

    [ [ self window ] setTitle: [ fileManager displayNameAtPath: [ browser path ] ] ];
    [ self enableControls ];
    [ self getFileAttributes ];
    [ self getFileInfos ];
}

- ( IBAction )editACLs: ( id )sender
{
    ACLEditorController * acl;
    
    ( void )sender;
    
    acl = [ [ ACLEditorController alloc ] initWithPath: [ browser path ] ];
    
    [ NSApp
        beginSheet:         [ acl window ]
        modalForWindow:     [ self window ]
        modalDelegate:      self
        didEndSelector:     @selector( sheetDidEnd: returnCode: contextInfo: )
        contextInfo:        ( void * )acl
    ];
}

/*******************************************************************************
 * File management
 ******************************************************************************/

#pragma mark - File management -

- ( void )getFiles: ( NSString * )readPath
{
    BOOL                    showDotFiles;
    BOOL                    showHiddenFiles;
    BOOL                    sortDirectories;
    NSMutableArray        * pathInfos;
    NSString              * subPath;
    NSString              * subFile;
    NSString              * fullPath;
    NSDirectoryEnumerator * dir;
    NLFileInfos           * infos;
    NSMutableArray        * subFiles;
    NSMutableArray        * subFilesRegular;
    
    pathInfos = [ [ readPath componentsSeparatedByString: @"/" ] mutableCopy ];
    fullPath  = @"";
    
    showDotFiles    = [ app.preferences.values boolForKey: @"ShowDotFiles" ];
    showHiddenFiles = [ app.preferences.values boolForKey: @"ShowHiddenFiles" ];
    sortDirectories = [ app.preferences.values boolForKey: @"SortDirectories" ];
    
    [ pathInfos removeObjectAtIndex: 0 ];
    
    for( subPath in pathInfos )
    {
        fullPath = [ NSString stringWithFormat: @"%@/%@", fullPath, subPath ];
        
        if( [ files objectForKey: fullPath ] != nil )
        {
            continue;
        }
        
        subFiles        = [ NSMutableArray arrayWithCapacity: 50 ];
        subFilesRegular = [ NSMutableArray arrayWithCapacity: 50 ];
        
        [ files setObject: subFiles forKey: fullPath ];
        
        dir = [ fileManager enumeratorAtPath: fullPath ];
        
        for( subFile in dir )
        {
            [ dir skipDescendents ];
            
            if( [ fullPath isEqualToString: @"/" ] && ( [ subFile isEqualToString: @"net" ] || [ subFile isEqualToString: @"home" ] || [ subFile isEqualToString: @"dev" ] ) )
            {
                continue;
            }
            
            if( showDotFiles == NO && [ [ subFile substringToIndex: 1 ] isEqualToString: @"." ] )
            {
                continue;
            }
            
            infos = [ NLFileInfos createFromPath: [ NSString stringWithFormat: @"%@/%@", fullPath, subFile ] ];
            
            if( infos == nil )
            {
                continue;
            }
            
            if( showHiddenFiles == NO && infos.flags.hidden == YES )
            {
                continue;
            }
            
            if( sortDirectories == NO )
            {
                [ subFiles addObject: infos ];
            }
            else if( infos.isDirectory == YES )
            {
                [ subFiles addObject: infos ];
            }
            else
            {
                [ subFilesRegular addObject: infos ];
            }
        }
        
        if( sortDirectories == YES )
        {
            for( infos in subFilesRegular )
            {
                [ subFiles addObject: infos ];
            }
        }
    }
    
    [ pathInfos release ];
}

- ( void )reloadFiles
{
    NSString * currentPath;
    
    [ files release ];
    
    files       = [ [ NSMutableDictionary dictionaryWithCapacity: 500 ] retain ];
    currentPath = [ browser path ];
    
    [ browser setDelegate: nil ];
    [ browser setDelegate: self ];
    
    [ browser setPath: currentPath ];
}

- ( void )getFileAttributes
{
    NLFileInfos * file;
    NSString    * filePath;
    
    if( [ displayPath length ] > 1 && [ [ displayPath substringFromIndex: [ displayPath length ] - 1 ] isEqualToString: @"/" ] )
    {
        filePath = [ displayPath substringToIndex: [ displayPath length ] - 1 ];
    }
    else
    {
        filePath = displayPath;
    }
    
    file = [ NLFileInfos createFromPath: filePath ];
    
    [ owner selectItemWithTag: file.ownerID ];
    [ group selectItemWithTag: file.groupID ];
    
    [ setUID setIntegerValue:     file.permissions & 2048 ];
    [ setGID setIntegerValue:     file.permissions & 1024 ];
    [ sticky setIntegerValue:     file.permissions &  512 ];
    [ userRead setIntegerValue:   file.permissions &  256 ];
    [ userWrite setIntegerValue:  file.permissions &  128 ];
    [ userExec setIntegerValue:   file.permissions &   64 ];
    [ groupRead setIntegerValue:  file.permissions &   32 ];
    [ groupWrite setIntegerValue: file.permissions &   16 ];
    [ groupExec setIntegerValue:  file.permissions &    8 ];
    [ worldRead setIntegerValue:  file.permissions &    4 ];
    [ worldWrite setIntegerValue: file.permissions &    2 ];
    [ worldExec setIntegerValue:  file.permissions &    1 ];
    
    [ flagArchived setIntValue:         file.flags.archived ];
    [ flagHidden setIntValue:           file.flags.hidden ];
    [ flagNoDump setIntValue:           file.flags.noDump ];
    [ flagOpaque setIntValue:           file.flags.opaque ];
    [ flagSystemAppendOnly setIntValue: file.flags.systemAppendOnly ];
    [ flagSystemImmutable setIntValue:  file.flags.systemImmutable ];
    [ flagUserAppendOnly setIntValue:   file.flags.userAppendOnly ];
    [ flagUserImmutable setIntValue:    file.flags.userImmutable ];
    
    [ octal setStringValue: [ NSString stringWithFormat: @"%03u", file.octalPermissions ] ];
}

- ( void )getFileInfos
{
    NLFileInfos               * file;
    NSMutableAttributedString * infos;
    NSAttributedString        * name;
    NSAttributedString        * size;
    NSAttributedString        * cTime;
    NSAttributedString        * mTime;
    NSAttributedString        * nameLabel;
    NSAttributedString        * sizeLabel;
    NSAttributedString        * cTimeLabel;
    NSAttributedString        * mTimeLabel;
    NSMutableParagraphStyle   * paragraph;
    NSString                  * filePath;
    NSDictionary              * attribs;
    NSDateFormatter           * dateFormat;
    NSNumberFormatter         * sizeFormat;
    
    if( [ displayPath length ] > 1 && [ [ displayPath substringFromIndex: [ displayPath length ] - 1 ] isEqualToString: @"/" ] )
    {
        filePath = [ displayPath substringToIndex: [ displayPath length ] - 1 ];
    }
    else
    {
        filePath = displayPath;
    }
    
    file       = [ NLFileInfos createFromPath: filePath ];
    attribs    = [ fileManager attributesOfItemAtPath: filePath error: NULL ];
    dateFormat = [ [ [ NSDateFormatter alloc ] init ]  autorelease ];
    sizeFormat = [ [ [ NSNumberFormatter alloc ] init ]  autorelease ];
    
    [ dateFormat setDateStyle: NSDateFormatterShortStyle ];
    [ dateFormat setTimeStyle: NSDateFormatterShortStyle ];
    [ sizeFormat setMinimumFractionDigits: 0 ];
    [ sizeFormat setMaximumFractionDigits: 2 ];
    
    nameLabel  = [ [ NSAttributedString alloc ] initWithRTF: [ [ NSString stringWithFormat: @"{\\b %@{\\par}}",               NSLocalizedString( @"FileName", nil ) ]  dataUsingEncoding: NSUTF8StringEncoding ] documentAttributes: nil ];
    sizeLabel  = [ [ NSAttributedString alloc ] initWithRTF: [ [ NSString stringWithFormat: @"{{\\par}{\\par}\\b %@{\\par}}", NSLocalizedString( @"FileSize", nil ) ]  dataUsingEncoding: NSUTF8StringEncoding ] documentAttributes: nil ];
    cTimeLabel = [ [ NSAttributedString alloc ] initWithRTF: [ [ NSString stringWithFormat: @"{{\\par}{\\par}\\b %@{\\par}}", NSLocalizedString( @"FileCTime", nil ) ] dataUsingEncoding: NSUTF8StringEncoding ] documentAttributes: nil ];
    mTimeLabel = [ [ NSAttributedString alloc ] initWithRTF: [ [ NSString stringWithFormat: @"{{\\par}{\\par}\\b %@{\\par}}", NSLocalizedString( @"FileMTime", nil ) ] dataUsingEncoding: NSUTF8StringEncoding ] documentAttributes: nil ];
    
    if( [ ( NSString * )[ displayPathInfos objectAtIndex: [ displayPathInfos count ] - 2 ] length ] == 0 )
    {
        name = [ [ NSAttributedString alloc ] initWithString: [ fileManager displayNameAtPath: @"/" ] ];
    }
    else
    {
        name = [ [ NSAttributedString alloc ] initWithString: file.displayName ];
    }
    
    size       = [ [ NSAttributedString alloc ] initWithString: file.humanReadableSize ];
    cTime      = [ [ NSAttributedString alloc ] initWithString: [ dateFormat stringFromDate: file.creationDate ] ];
    mTime      = [ [ NSAttributedString alloc ] initWithString: [ dateFormat stringFromDate: file.modificationDate ] ];
    
    paragraph  = [ [ NSMutableParagraphStyle alloc ] init ];
    infos      = [ [ NSMutableAttributedString alloc ] initWithString: @"" ];
    
    [ infos insertAttributedString: nameLabel atIndex: [ infos length ] ];
    [ infos insertAttributedString: name atIndex: [ infos length ] ];
    
    [ infos insertAttributedString: cTimeLabel atIndex: [ infos length ] ];
    [ infos insertAttributedString: cTime atIndex: [ infos length ] ];
    
    [ infos insertAttributedString: mTimeLabel atIndex: [ infos length ] ];
    [ infos insertAttributedString: mTime atIndex: [ infos length ] ];
    
    if( file.isDirectory == NO )
    {
        [ infos insertAttributedString: sizeLabel atIndex: [ infos length ] ];
        [ infos insertAttributedString: size atIndex: [ infos length ] ];
    }
    
    [ paragraph setAlignment: NSCenterTextAlignment ];
    [ infos addAttributes: [ NSDictionary dictionaryWithObject: paragraph forKey: NSParagraphStyleAttributeName ] range: NSMakeRange( 0, [ infos length ] ) ];
    
    [ fileInfos setStringValue: ( NSString * )infos ];
    
    [ nameLabel release ];
    [ sizeLabel release ];
    [ cTimeLabel release ];
    [ mTimeLabel release ];
    [ name release ];
    [ size release ];
    [ cTime release ];
    [ mTime release ];
    [ infos release ];
    [ paragraph release ];
}

/*******************************************************************************
 * NSBrowser delegate methods
 ******************************************************************************/

#pragma mark - NSBrowser delegate methods -

- ( BOOL )browser: ( NSBrowser * )sender shouldTypeSelectForEvent: ( NSEvent * )event withCurrentSearchString:( NSString * )searchString
{
    ( void )sender;
    ( void )searchString;
    
    if( [ event keyCode ] == 49 )
    {
        return NO;
    }
    
    return YES;
}

- ( NSInteger )browser: ( NSBrowser * )sender numberOfRowsInColumn: ( NSInteger )column
{
    ( void )sender;
    ( void )column;
    
    [ displayPath release ];
    [ displayPathInfos release ];
    
    displayPath      = [ [ NSString alloc ] initWithString: [ [ browser path ] stringByAppendingString: @"/" ] ];
    displayPathInfos = [ [ displayPath componentsSeparatedByString: @"/" ] retain ];
    
    [ self getFiles: displayPath ];
    
    return [ ( NSArray * )[ files objectForKey: displayPath ] count ];
}

- ( void )browser: ( NSBrowser * )sender willDisplayCell: ( NSBrowserCell * )cell atRow: ( NSInteger )row column: ( NSInteger )column
{
    NSString    * fileKey;
    NSString    * filePath;
    NSImage     * fileIcon;
    NLFileInfos * file;
    
    ( void )sender;
    
    fileKey  = [ [ [ displayPathInfos subarrayWithRange: NSMakeRange( 0, column + 1 ) ] componentsJoinedByString: @"/" ] stringByAppendingString: @"/" ];
    filePath = [ fileKey stringByAppendingString: [ [ [ files objectForKey: fileKey ] objectAtIndex: row ] filename ] ];
    file     = [ [ files objectForKey: fileKey ] objectAtIndex: row ];
    
    [ cell setTitle: file.filename ];
    
    if( file.isDirectory == NO )
    {
        [ cell setLeaf: YES ];
    }
    
    fileIcon = [ workspace iconForFile: filePath ];
    
    [ fileIcon setSize: NSMakeSize( 14, 14 ) ];
    [ cell setImage: fileIcon ];
}

@end
