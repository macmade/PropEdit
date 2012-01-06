/*******************************************************************************
 * Copyright (c) 2011, Jean-David Gadina <macmade@eosgarden.com>
 * All rights reserved
 ******************************************************************************/
 
/* $Id$ */

/*!
 * @file        ACLEntry.m
 * @copyright   eosgarden 2011 - Jean-David Gadina <macmade@eosgarden.com>
 * @abstract    ...
 */

#import "ACLEntry.h"

@implementation ACLEntry

@synthesize guid                    = _guid;
@synthesize type                    = _type;
@synthesize readData                = _readData;
@synthesize listDirectory           = _listDirectory;
@synthesize writeData               = _writeData;
@synthesize addFile                 = _addFile;
@synthesize execute                 = _execute;
@synthesize search                  = _search;
@synthesize delete                  = _delete;
@synthesize appendData              = _appendData;
@synthesize addSubDirectory         = _addSubDirectory;
@synthesize deleteChild             = _deleteChild;
@synthesize readAttributes          = _readAttributes;
@synthesize writeAttributes         = _writeAttributes;
@synthesize readExtendedAttributes  = _readExtendedAttributes;
@synthesize writeExtendedAttributes = _writeExtendedAttributes;
@synthesize readSecurity            = _readSecurity;
@synthesize writeSecurity           = _writeSecurity;
@synthesize changeOwner             = _changeOwner;

+ ( NSArray * )entriesForFile: ( NSString * )path
{
    acl_t            acl;
    acl_entry_t      ace;
    NSMutableArray * array;
    ACLEntry       * entry;
    
    acl   = acl_get_file( [ path cStringUsingEncoding: NSUTF8StringEncoding ], ACL_TYPE_EXTENDED );
    entry = NULL;
    
    if( acl == NULL )
    {
        return nil;
    }
    
    array = [ NSMutableArray arrayWithCapacity: ACL_MAX_ENTRIES ];
    
    while( acl_get_entry( acl, ACL_NEXT_ENTRY, &ace ) == 0 )
    {
        entry = [ [ ACLEntry alloc ] initWithACLEntry: ace ];
        
        if( entry != nil )
        {
            [ array addObject: entry ];
            [ entry release ];
        }
    }
    
    acl_free( acl );
    
    return [ NSArray arrayWithArray: array ];
}

- ( id )initWithACLEntry: ( acl_entry_t )entry
{
    unsigned int     i;
    acl_permset_t    permset;
    acl_tag_t        tag;
    guid_t         * guid;
    char           * guid_s[ KAUTH_GUID_SIZE + 5 ]; /* 00000000-0000-0000-0000-000000000000 */
    char             guid_c[ 3 ];
    
    if( ( self = [ super init ] ) && entry != NULL )
    {
        tag     = 0;
        permset = NULL;
        guid    = acl_get_qualifier( entry );
        
        acl_get_tag_type( entry, &tag );
        acl_get_permset( entry, &permset );
        
        if( tag == ACL_EXTENDED_ALLOW )
        {
            _type = ACLEntryTypeAllow;
        }
        else if( tag == ACL_EXTENDED_DENY )
        {
            _type = ACLEntryTypeDeny;
        }
        else
        {
            _type = ACLEntryTypeUnknown;
        }
        
        if( permset != NULL )
        {
            _readData                   = ( BOOL )acl_get_perm_np( permset, ACL_READ_DATA );
            _listDirectory              = ( BOOL )acl_get_perm_np( permset, ACL_LIST_DIRECTORY );
            _writeData                  = ( BOOL )acl_get_perm_np( permset, ACL_WRITE_DATA );
            _addFile                    = ( BOOL )acl_get_perm_np( permset, ACL_ADD_FILE );
            _execute                    = ( BOOL )acl_get_perm_np( permset, ACL_EXECUTE );
            _search                     = ( BOOL )acl_get_perm_np( permset, ACL_SEARCH );
            _delete                     = ( BOOL )acl_get_perm_np( permset, ACL_DELETE );
            _appendData                 = ( BOOL )acl_get_perm_np( permset, ACL_APPEND_DATA );
            _addSubDirectory            = ( BOOL )acl_get_perm_np( permset, ACL_ADD_SUBDIRECTORY );
            _deleteChild                = ( BOOL )acl_get_perm_np( permset, ACL_DELETE_CHILD );
            _readAttributes             = ( BOOL )acl_get_perm_np( permset, ACL_READ_ATTRIBUTES );
            _writeAttributes            = ( BOOL )acl_get_perm_np( permset, ACL_WRITE_ATTRIBUTES );
            _readExtendedAttributes     = ( BOOL )acl_get_perm_np( permset, ACL_READ_EXTATTRIBUTES );
            _writeExtendedAttributes    = ( BOOL )acl_get_perm_np( permset, ACL_WRITE_EXTATTRIBUTES );
            _readSecurity               = ( BOOL )acl_get_perm_np( permset, ACL_READ_SECURITY );
            _writeSecurity              = ( BOOL )acl_get_perm_np( permset, ACL_WRITE_SECURITY );
            _changeOwner                = ( BOOL )acl_get_perm_np( permset, ACL_CHANGE_OWNER );
        }
        
        memset( guid_s, 0, KAUTH_GUID_SIZE + 5 );
        memset( guid_c, 0, 3 );
        
        for( i = 0; i < KAUTH_GUID_SIZE; i++ )
        {
            if( i == 4 || i == 6 || i == 8 || i == 10 )
            {
                strcat( ( char * )guid_s, "-" );
            }
            
            sprintf( ( char * )guid_c, "%02X", ( unsigned int )( guid->g_guid[ i ] ) );
            strcat( ( char * )guid_s, ( char * )guid_c );
        }
        
        _guid = [ [ NSString alloc ] initWithCString: ( char * )guid_s encoding: NSASCIIStringEncoding ];
        
        acl_free( guid );
    }
    
    return self;
}

- ( void )dealloc
{
    [ _guid release ];
    [ super dealloc ];
}

- ( NSString * )description
{
    return [ NSString stringWithFormat: @"%@: %@", [ super description ], _guid ];
}

@end
