/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @header      ACLEntry.h
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#include <sys/acl.h>

typedef enum
{
    ACLEntryTypeUnknown = ACL_UNDEFINED_TAG,
    ACLEntryTypeAllow   = ACL_EXTENDED_ALLOW,
    ACLEntryTypeDeny    = ACL_EXTENDED_DENY
}
ACLEntryType;

@interface ACLEntry: NSObject
{
@protected
    
    NSString   * _guid;
    ACLEntryType _type;
	BOOL         _readData;
	BOOL         _listDirectory;
	BOOL         _writeData;
	BOOL         _addFile;
	BOOL         _execute;
	BOOL         _search;
	BOOL         _delete;
	BOOL         _appendData;
	BOOL         _addSubDirectory;
	BOOL         _deleteChild;
	BOOL         _readAttributes;
	BOOL         _writeAttributes;
	BOOL         _readExtendedAttributes;
	BOOL         _writeExtendedAttributes;
	BOOL         _readSecurity;
	BOOL         _writeSecurity;
	BOOL         _changeOwner;
    
@private
    
    id _ACLEntry_Reserved[ 5 ] __attribute__( ( unused ) );
}

@property( atomic, readonly ) NSString   * guid;
@property( atomic, readonly ) ACLEntryType type;
@property( atomic, readonly ) BOOL         readData;
@property( atomic, readonly ) BOOL         listDirectory;
@property( atomic, readonly ) BOOL         writeData;
@property( atomic, readonly ) BOOL         addFile;
@property( atomic, readonly ) BOOL         execute;
@property( atomic, readonly ) BOOL         search;
@property( atomic, readonly ) BOOL         delete;
@property( atomic, readonly ) BOOL         appendData;
@property( atomic, readonly ) BOOL         addSubDirectory;
@property( atomic, readonly ) BOOL         deleteChild;
@property( atomic, readonly ) BOOL         readAttributes;
@property( atomic, readonly ) BOOL         writeAttributes;
@property( atomic, readonly ) BOOL         readExtendedAttributes;
@property( atomic, readonly ) BOOL         writeExtendedAttributes;
@property( atomic, readonly ) BOOL         readSecurity;
@property( atomic, readonly ) BOOL         writeSecurity;
@property( atomic, readonly ) BOOL         changeOwner;

+ ( NSArray * )entriesForFile: ( NSString * )path;
- ( id )initWithACLEntry: ( acl_entry_t )entry;

@end
