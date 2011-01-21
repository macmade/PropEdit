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

@interface MainWindowController( Private )

- ( void )openPath: ( id )sender;

@end

@implementation MainWindowController

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

- ( id )init
{
    if( ( self = [ super init ] ) )
    {
        fileManager = [ NSFileManager defaultManager ];
        workspace   = [ NSWorkspace sharedWorkspace ];
        files       = [ [ NSMutableDictionary dictionaryWithCapacity: 500 ] retain ];
        currentFile = [ [ NLFileInfos createFromPath: @"/" ] retain ];
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
    DSCLHelper * dscl;
    
    dscl = [ DSCLHelper new ];
    
    [ path setURL: currentFile.url ];
    [ path setDoubleAction: @selector( openPath: ) ];
    [ browser setDelegate: self ];
    [ browser setSendsActionOnArrowKeys: YES ];
    [ browser setDoubleAction: @selector( openFile: ) ];
    [ self getAvailableUsers: dscl ];
    [ self getAvailableGroups: dscl ];
    [ self getFiles: currentFile.path ];
    [ [ self window ] setTitle: currentFile.displayName ];
    [ browser setPath: currentFile.path ];
    [ icon setImage: [ workspace iconForFile: currentFile.path ] ];
    
    displayPath      = [ [ NSString alloc ] initWithString: @"//" ];
    displayPathInfos = [ [ displayPath componentsSeparatedByString: @"/" ] retain ];
    
    [ self getFileInfos ];
    [ self getFileAttributes ];
    
    [ [ self window ] setDelegate: self ];
    
    [ goComputerMenu setImage: [ NSImage imageNamed: NSImageNameComputer ] ];
    [ goHomeMenu setImage: [ workspace iconForFile: [ NSString stringWithFormat: @"/Users/%@", NSUserName() ] ] ];
    [ goDesktopMenu setImage: [ workspace iconForFile: [ NSString stringWithFormat: @"/Users/%@/Desktop", NSUserName() ] ] ];
    [ goNetworkMenu setImage: [ NSImage imageNamed: NSImageNameNetwork ] ];
    [ goApplicationsMenu setImage: [ workspace iconForFile: @"/Applications" ] ];
    [ goUtilitiesMenu setImage: [ workspace iconForFile: @"/Applications/Utilities" ] ];
    
    [ [ goComputerMenu image ] setSize: NSMakeSize( 16, 16 ) ];
    [ [ goHomeMenu image ] setSize: NSMakeSize( 16, 16 ) ];
    [ [ goDesktopMenu image ] setSize: NSMakeSize( 16, 16 ) ];
    [ [ goNetworkMenu image ] setSize: NSMakeSize( 16, 16 ) ];
    [ [ goApplicationsMenu image ] setSize: NSMakeSize( 16, 16 ) ];
    [ [ goUtilitiesMenu image ] setSize: NSMakeSize( 16, 16 ) ];
    
    [ dscl release ];
}

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

- ( void )getAvailableUsers: ( DSCLHelper * )helper
{
    User     * userObject;
    NSString * itemTitle;
    
    [ owner removeAllItems ];
    
    for( userObject in helper.users )
    {
        itemTitle = [ NSString stringWithFormat: @"%@ (%u)", userObject.name, userObject.uid ];
        
        [ owner addItemWithTitle: itemTitle ];
        [ [ owner itemWithTitle: itemTitle ] setTag: userObject.uid ];
        [ [ owner itemWithTitle: itemTitle ] setImage: [ NSImage imageNamed: NSImageNameUser ] ];
        [ [ [ owner itemWithTitle: itemTitle ] image ] setSize: NSMakeSize( 16, 16 ) ];
    }
    
    [ owner selectItemWithTag: 0 ];
}

- ( void )getAvailableGroups: ( DSCLHelper * )helper
{
    User     * groupObject;
    NSString * itemTitle;
    
    [ group removeAllItems ];
    
    for( groupObject in helper.groups )
    {
        itemTitle = [ NSString stringWithFormat: @"%@ (%u)", groupObject.name, groupObject.uid ];
        
        [ owner addItemWithTitle: itemTitle ];
        [ [ owner itemWithTitle: itemTitle ] setTag: groupObject.uid ];
        [ [ owner itemWithTitle: itemTitle ] setImage: [ NSImage imageNamed: NSImageNameUser ] ];
        [ [ [ owner itemWithTitle: itemTitle ] image ] setSize: NSMakeSize( 16, 16 ) ];
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

- ( void )getFiles: ( NSString * )readPath
{
    BOOL isDir;
    BOOL showDotFiles;
    BOOL showHiddenFiles;
    BOOL sortDirectories;
    NSDirectoryEnumerator * dir;
    NSString              * file;
    NSDictionary          * flags;
    NSMutableArray        * subFiles;
    NSMutableArray        * subFilesRegular;
    
    if( [ files objectForKey: readPath ] != nil )
    {
        return;
    }
    
    subFiles        = [ NSMutableArray arrayWithCapacity: 50 ];
    subFilesRegular = [ NSMutableArray arrayWithCapacity: 50 ];
    
    [ files setObject: subFiles forKey: readPath ];
    [ fileManager fileExistsAtPath: readPath isDirectory: &isDir ];
    
    if( isDir == NO )
    {
        return;
    }
    
    dir             = [ fileManager enumeratorAtPath: readPath ];
    showDotFiles    = [ app.preferences.values boolForKey: @"ShowDotFiles" ];
    showHiddenFiles = [ app.preferences.values boolForKey: @"ShowHiddenFiles" ];
    sortDirectories = [ app.preferences.values boolForKey: @"SortDirectories" ];
    
    for( file in dir )
    {
        [ dir skipDescendents ];
        
        if
        (
            [ readPath isEqualToString: @"/" ]
         && ( [ file isEqualToString: @"net" ] || [ file isEqualToString: @"home" ] || [ file isEqualToString: @"dev" ] )
        )
        {
            continue;
        }
        
        if( showDotFiles == NO && [ [ file substringToIndex: 1 ] isEqualToString: @"." ] ) {
            
            continue;
        }
        
        if( showHiddenFiles == NO )
        {
            flags = [ fileManager flagsOfItemAtPath: [ readPath stringByAppendingString: file ] error: NULL ];
            
            if
            (
                ( flags == nil || [ [ flags objectForKey: NLFileFlagHidden ] boolValue ] == YES )
             && ( [ readPath isEqualToString: @"/" ] == NO || [ file isEqualToString: @"Network" ] == NO )
            )
            {
                continue;
            }
        }
        
        if( sortDirectories == NO )
        {
            [ subFiles addObject: file ];
        }
        else
        {
            [ fileManager fileExistsAtPath: [ readPath stringByAppendingString: file ] isDirectory: &isDir ];
            
            if( isDir == YES )
            {
                [ subFiles addObject: file ];
            }
            else
            {
                [ subFilesRegular addObject: file ];
            }
        }
    }
    
    if( sortDirectories == YES )
    {
        for( file in subFilesRegular )
        {
            [ subFiles addObject: file ];
        }
    }
}

- ( void )getFileAttributes
{
    unsigned long posixPerms;
    struct stat fileStat;
    int err;
    NSString      * filePath;
    NSDictionary  * attribs;
    
    filePath   = [ displayPath substringToIndex: [ displayPath length ] - 1 ];
    attribs    = [ fileManager attributesOfItemAtPath: filePath error: NULL ];
    posixPerms = [ [ attribs objectForKey: @"NSFilePosixPermissions" ] unsignedLongValue ];
    
    [ owner selectItemWithTag: [ [ attribs objectForKey: @"NSFileOwnerAccountID" ] intValue ] ];
    [ group selectItemWithTag: [ [ attribs objectForKey: @"NSFileGroupOwnerAccountID" ] intValue ] ];
    
    [ setUID setIntegerValue:     ( NSInteger )posixPerms & 2048 ];
    [ setGID setIntegerValue:     ( NSInteger )posixPerms & 1024 ];
    [ sticky setIntegerValue:     ( NSInteger )posixPerms &  512 ];
    [ userRead setIntegerValue:   ( NSInteger )posixPerms &  256 ];
    [ userWrite setIntegerValue:  ( NSInteger )posixPerms &  128 ];
    [ userExec setIntegerValue:   ( NSInteger )posixPerms &   64 ];
    [ groupRead setIntegerValue:  ( NSInteger )posixPerms &   32 ];
    [ groupWrite setIntegerValue: ( NSInteger )posixPerms &   16 ];
    [ groupExec setIntegerValue:  ( NSInteger )posixPerms &    8 ];
    [ worldRead setIntegerValue:  ( NSInteger )posixPerms &    4 ];
    [ worldWrite setIntegerValue: ( NSInteger )posixPerms &    2 ];
    [ worldExec setIntegerValue:  ( NSInteger )posixPerms &    1 ];
    
    err = stat( ( char * )[ filePath cStringUsingEncoding: NSUTF8StringEncoding ], &fileStat );
    
    if( err != 0 )
    {
        [ self disableFlagControls ];
        
        return;
    }
    
    [ flagArchived setIntValue:         fileStat.st_flags & SF_ARCHIVED ];
    [ flagHidden setIntValue:           fileStat.st_flags & UF_HIDDEN ];
    [ flagNoDump setIntValue:           fileStat.st_flags & UF_NODUMP ];
    [ flagOpaque setIntValue:           fileStat.st_flags & UF_OPAQUE ];
    [ flagSystemAppendOnly setIntValue: fileStat.st_flags & SF_APPEND ];
    [ flagSystemImmutable setIntValue:  fileStat.st_flags & SF_IMMUTABLE ];
    [ flagUserAppendOnly setIntValue:   fileStat.st_flags & UF_APPEND ];
    [ flagUserImmutable setIntValue:    fileStat.st_flags & UF_IMMUTABLE ];
}

- ( void )getFileInfos
{
    BOOL isDir;
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
    NSNumber                  * fileSize;
    NSString                  * fileSizeUnit;
    NSDateFormatter           * dateFormat;
    NSNumberFormatter         * sizeFormat;
    
    filePath   = [ displayPath substringToIndex: [ displayPath length ] - 1 ];
    attribs    = [ fileManager attributesOfItemAtPath: filePath error: NULL ];
    dateFormat = [ [ [ NSDateFormatter alloc ] init ]  autorelease ];
    sizeFormat = [ [ [ NSNumberFormatter alloc ] init ]  autorelease ];
    
    [ dateFormat setDateStyle: NSDateFormatterShortStyle ];
    [ dateFormat setTimeStyle: NSDateFormatterShortStyle ];
    [ sizeFormat setMinimumFractionDigits: 0 ];
    [ sizeFormat setMaximumFractionDigits: 2 ];
    
    [ fileManager fileExistsAtPath: filePath isDirectory: &isDir ];
    
    if( [ [ attribs objectForKey: @"NSFileSize" ] unsignedLongValue ] > ( 1024 * 1024 * 1024 ) )
    {
        fileSize     = [ NSNumber numberWithFloat: ( ( [ [ attribs objectForKey: @"NSFileSize" ] floatValue ] / 1024 ) / 1024 ) / 1024 ];
        fileSizeUnit = @" GB";
    }
    else if( [ [ attribs objectForKey: @"NSFileSize" ] unsignedIntValue ] > ( 1024 * 1024 ) )
    {
        fileSize     = [ NSNumber numberWithFloat: ( [ [ attribs objectForKey: @"NSFileSize" ] floatValue ] / 1024 ) / 1024 ];
        fileSizeUnit = @" MB";
    }
    else if( [ [ attribs objectForKey: @"NSFileSize" ] unsignedIntValue ] > 1024 )
    {
        fileSize     = [ NSNumber numberWithFloat: [ [ attribs objectForKey: @"NSFileSize" ] floatValue ] / 1024 ];
        fileSizeUnit = @" KB";
    }
    else
    {
        fileSize     = [ attribs objectForKey: @"NSFileSize" ];
        fileSizeUnit = @" B";
    }
    
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
        name = [ [ NSAttributedString alloc ] initWithString: [ fileManager displayNameAtPath: filePath ] ];
    }
    
    size       = [ [ NSAttributedString alloc ] initWithString: [ [ sizeFormat stringFromNumber: fileSize ] stringByAppendingString: fileSizeUnit ] ];
    cTime      = [ [ NSAttributedString alloc ] initWithString: [ dateFormat stringFromDate: [ attribs objectForKey: @"NSFileCreationDate" ] ] ];
    mTime      = [ [ NSAttributedString alloc ] initWithString: [ dateFormat stringFromDate: [ attribs objectForKey: @"NSFileModificationDate" ] ] ];
    
    paragraph  = [ [ NSMutableParagraphStyle alloc ] init ];
    infos      = [ [ NSMutableAttributedString alloc ] initWithString: @"" ];
    
    [ infos insertAttributedString: nameLabel atIndex: [ infos length ] ];
    [ infos insertAttributedString: name atIndex: [ infos length ] ];
    
    [ infos insertAttributedString: cTimeLabel atIndex: [ infos length ] ];
    [ infos insertAttributedString: cTime atIndex: [ infos length ] ];
    
    [ infos insertAttributedString: mTimeLabel atIndex: [ infos length ] ];
    [ infos insertAttributedString: mTime atIndex: [ infos length ] ];
    
    if( isDir == NO )
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
    BOOL isDir;
    NSString * fileKey;
    NSString * file;
    NSImage  * fileIcon;
    
    ( void )sender;
    
    fileKey = [ [ [ displayPathInfos subarrayWithRange: NSMakeRange( 0, column + 1 ) ] componentsJoinedByString: @"/" ] stringByAppendingString: @"/" ];
    file    = [ fileKey stringByAppendingString: [ [ files objectForKey: fileKey ] objectAtIndex: row ] ];
    
    [ cell setTitle: [ [ files objectForKey: fileKey ] objectAtIndex: row ] ];
    
    [ fileManager fileExistsAtPath: file isDirectory: &isDir ];
    
    if( isDir == NO )
    {
        [ cell setLeaf: YES ];
    }
    
    fileIcon = [ workspace iconForFile: file ];
    
    [ fileIcon setSize: NSMakeSize( 14, 14 ) ];
    [ cell setImage: fileIcon ];
}

- ( IBAction )selectFile: ( id )sender
{
    if( hasApplyView == YES )
    {
        [ self hideApplyView: sender ];
    }
    
    displayPath      = [ [ NSString alloc ] initWithString: [ [ browser path ] stringByAppendingString: @"/" ] ];
    displayPathInfos = [ [ displayPath componentsSeparatedByString: @"/" ] retain ];
    
    [ path setURL: [ NSURL URLWithString: [ @"file://localhost" stringByAppendingString: [ displayPath stringByReplacingOccurrencesOfString: @" " withString: @"%20" ] ] ] ];
    [ icon setImage: [ workspace iconForFile: displayPath ] ];
    [ self getFileAttributes ];
    [ self getFileInfos ];
    [ [ self window ] setTitle: [ fileManager displayNameAtPath: [ browser path ] ] ];
    [ self enableControls ];
}

- ( OSStatus )chown
{
    char     * args[ 4 ] = { NULL, NULL, NULL, NULL };
    NSString * user;
    NSString * userGroup;
    NSString * chownArgs;
    NSString * file;
    
    user      = [ [ owner selectedItem ] title ];
    userGroup = [ [ group selectedItem ] title ];
    chownArgs = [ NSString stringWithFormat: @"%@:%@", user, userGroup ];
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

- ( void )go: ( NSString * )pathTo
{
    [ browser setPath: pathTo ];
    [ self selectFile: nil ];
}

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

@end
