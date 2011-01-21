/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      File.h
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

/*!
 * @class       File
 * @abstract    ...
 */
@interface File: NSObject
{
@protected
    
    NSString * path;
    NSString * name;
    NSUInteger size;
    NSUInteger ctime;
    NSUInteger mtime;
    NSInteger  uid;
    NSInteger  gid;
    NSUInteger posixPermissions;
    NSUInteger flags;
    BOOL       directory;
    
@private
    
    id r1;
    id r2;
}

@property( readonly                     ) NSString * path;
@property( readonly                     ) NSString * name;
@property( readonly                     ) NSUInteger size;
@property( readonly                     ) NSUInteger ctime;
@property( readonly                     ) NSUInteger mtime;
@property( readonly                     ) NSInteger  uid;
@property( readonly                     ) NSInteger  gid;
@property( readonly                     ) NSUInteger posixPermissions;
@property( readonly                     ) NSUInteger flags;
@property( readonly, getter=isDirectory ) BOOL       directory;
@property( readonly                     ) BOOL       userReadable;
@property( readonly                     ) BOOL       userWriteable;
@property( readonly                     ) BOOL       userExecutable;
@property( readonly                     ) BOOL       groupReadable;
@property( readonly                     ) BOOL       groupWriteable;
@property( readonly                     ) BOOL       groupExecutable;
@property( readonly                     ) BOOL       worldReadable;
@property( readonly                     ) BOOL       worldWriteable;
@property( readonly                     ) BOOL       worldExecutable;
@property( readonly                     ) BOOL       sticky;
@property( readonly                     ) BOOL       setUID;
@property( readonly                     ) BOOL       setGID;
@property( readonly                     ) BOOL       archived;
@property( readonly                     ) BOOL       hidden;
@property( readonly                     ) BOOL       noDump;
@property( readonly                     ) BOOL       opaque;
@property( readonly                     ) BOOL       systemAppend;
@property( readonly                     ) BOOL       systemImmutable;
@property( readonly                     ) BOOL       userAppend;
@property( readonly                     ) BOOL       userImmutable;

+ ( id )fileWithPath: ( NSString * )path;
- ( id )initWithPath: ( NSString * )path;
- ( OSStatus )changeOwner: ( NSString * )owner group: ( NSString * )group recursive: ( BOOL )recursive;
- ( OSStatus )changeMode: ( NSUInteger )mode recursive: ( BOOL )recursive;
- ( OSStatus )changeFlags: ( NSArray * )flags recursive: ( BOOL )recursive;

@end
