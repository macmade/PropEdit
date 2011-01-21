/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        File.m
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "File.h"
#import <sys/stat.h>

@implementation File

@synthesize path;
@synthesize name;
@synthesize size;
@synthesize ctime;
@synthesize mtime;
@synthesize uid;
@synthesize gid;
@synthesize posixPermissions;
@synthesize flags;
@synthesize directory;

+ ( id )fileWithPath: ( NSString * )filePath
{
    return [ [ [ self alloc ] initWithPath: filePath ] autorelease ];
}

- ( id )init
{
    if( ( self = [ super init ] ) )
    {}
    
    return self;
}

- ( id )initWithPath: ( NSString * )filePath
{
    NSDictionary * attributes;
    int            error;
    struct stat    fileStat;
    
    if( ( self = [ self init ] ) )
    {
        if( [ [ NSFileManager defaultManager ] fileExistsAtPath: path isDirectory: &directory ] == NO )
        {
            return nil;
        }
        
        path             = [ filePath copy ];
        name             = [ [ path lastPathComponent ] copy ];
        attributes       = [ [ NSFileManager defaultManager ] attributesOfItemAtPath: path error: NULL ];
        posixPermissions = [ [ attributes objectForKey: @"NSFilePosixPermissions" ] unsignedLongValue ];
        uid              = [ [ attributes objectForKey: @"NSFileOwnerAccountID" ] intValue ];
        gid              = [ [ attributes objectForKey: @"NSFileGroupOwnerAccountID" ] intValue ];
    }
    
    error = stat( ( char * )[ path cStringUsingEncoding: NSUTF8StringEncoding ], &fileStat );
    
    if( error == 0 )
    {
        flags = fileStat.st_flags;
    }
    
    return self;
}

- ( void )dealloc
{
    [ path  release ];
    [ name  release ];
    [ super dealloc ];
}

- ( OSStatus )changeOwner: ( NSString * )owner group: ( NSString * )group recursive: ( BOOL )recursive
{
    ( void )owner;
    ( void )group;
    ( void )recursive;
    
    return 0;
}

- ( OSStatus )changeMode: ( NSUInteger )mode recursive: ( BOOL )recursive
{
    ( void )mode;
    ( void )recursive;
    
    return 0;
}

- ( OSStatus )changeFlags: ( NSArray * )flagsArray recursive: ( BOOL )recursive
{
    ( void )flagsArray;
    ( void )recursive;
    
    return 0;
}


- ( BOOL )userReadable
{
    return ( posixPermissions & 0x100 ) ? YES : NO;
}

- ( BOOL )userWriteable
{
    return ( posixPermissions & 0x080 ) ? YES : NO;
}

- ( BOOL )userExecutable
{
    return ( posixPermissions & 0x040 ) ? YES : NO;
}

- ( BOOL )groupReadable
{
    return ( posixPermissions & 0x020 ) ? YES : NO;
}

- ( BOOL )groupWriteable
{
    return ( posixPermissions & 0x010 ) ? YES : NO;
}

- ( BOOL )groupExecutable
{
    return ( posixPermissions & 0x008 ) ? YES : NO;
}

- ( BOOL )worldReadable
{
    return ( posixPermissions & 0x004 ) ? YES : NO;
}

- ( BOOL )worldWriteable
{
    return ( posixPermissions & 0x002 ) ? YES : NO;
}

- ( BOOL )worldExecutable
{
    return ( posixPermissions & 0x001 ) ? YES : NO;
}

- ( BOOL )sticky
{
    return ( posixPermissions & 0x200 ) ? YES : NO;
}

- ( BOOL )setUID
{
    return ( posixPermissions & 0x400 ) ? YES : NO;
}

- ( BOOL )setGID
{
    return ( posixPermissions & 0x800 ) ? YES : NO;
}

- ( BOOL )archived
{
    return ( flags & SF_ARCHIVED ) ? YES : NO;
}

- ( BOOL )hidden
{
    return ( flags & UF_HIDDEN ) ? YES : NO;
}

- ( BOOL )noDump
{
    return ( flags & UF_NODUMP ) ? YES : NO;
}

- ( BOOL )opaque
{
    return ( flags & UF_OPAQUE ) ? YES : NO;
}

- ( BOOL )systemAppend
{
    return ( flags & SF_APPEND ) ? YES : NO;
}

- ( BOOL )systemImmutable
{
    return ( flags & SF_IMMUTABLE ) ? YES : NO;
}

- ( BOOL )userAppend
{
    return ( flags & UF_APPEND ) ? YES : NO;
}

- ( BOOL )userImmutable
{
    return ( flags & UF_IMMUTABLE ) ? YES : NO;
}

@end
