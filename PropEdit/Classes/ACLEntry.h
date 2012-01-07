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

@property( atomic, readwrite, copy )   NSString   * guid;
@property( atomic, readwrite, assign ) ACLEntryType type;
@property( atomic, readwrite, assign ) BOOL         readData;
@property( atomic, readwrite, assign ) BOOL         listDirectory;
@property( atomic, readwrite, assign ) BOOL         writeData;
@property( atomic, readwrite, assign ) BOOL         addFile;
@property( atomic, readwrite, assign ) BOOL         execute;
@property( atomic, readwrite, assign ) BOOL         search;
@property( atomic, readwrite, assign ) BOOL         delete;
@property( atomic, readwrite, assign ) BOOL         appendData;
@property( atomic, readwrite, assign ) BOOL         addSubDirectory;
@property( atomic, readwrite, assign ) BOOL         deleteChild;
@property( atomic, readwrite, assign ) BOOL         readAttributes;
@property( atomic, readwrite, assign ) BOOL         writeAttributes;
@property( atomic, readwrite, assign ) BOOL         readExtendedAttributes;
@property( atomic, readwrite, assign ) BOOL         writeExtendedAttributes;
@property( atomic, readwrite, assign ) BOOL         readSecurity;
@property( atomic, readwrite, assign ) BOOL         writeSecurity;
@property( atomic, readwrite, assign ) BOOL         changeOwner;

+ ( NSArray * )entriesForFile: ( NSString * )path;
- ( id )initWithACLEntry: ( acl_entry_t )entry;

@end
