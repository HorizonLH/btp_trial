CLASS zcl_init_status_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_init_status_data IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    DATA:it_status        TYPE TABLE OF ztstatus_so.
    DATA:it_suppliertypes TYPE TABLE OF ztsuppliertypes.
*   clear data
    DELETE FROM ztstatus_so.
    DELETE FROM ztsuppliertypes.

    it_status = VALUE #(
        ( client  = '100'  status = 'O' description = 'Open'      createdby = 'zhi03.yang' createdat = '20241216150301'
         locallastchangedby = 'zhi03.yang' locallastchangedat = '20241216150301' lastchangedat = '20241216150301' )
        ( client  = '100'  status = 'A' description = 'Approved' createdby = 'zhi03.yang' createdat = '20241216150301'
         locallastchangedby = 'zhi03.yang' locallastchangedat = '20241216150301' lastchangedat = '20241216150301' )
        ( client  = '100'  status = 'X' description = 'Rejected'  createdby = 'zhi03.yang' createdat = '20241216150301'
         locallastchangedby = 'zhi03.yang' locallastchangedat = '20241216150301' lastchangedat = '20241216150301' )
     ).

    it_suppliertypes = VALUE #(
        ( client  = '100'  suppliertype = 'OS'  description = 'Ordinary Suppliers' createdby = 'zhi03.yang' createdat = '20241216150301'
         locallastchangedby = 'zhi03.yang' locallastchangedat = '20241216150301' lastchangedat = '20241216150301'  )
        ( client  = '100'  suppliertype = 'BS'  description = 'Bronze Suppliers'  createdby = 'zhi03.yang' createdat = '20241216150301'
         locallastchangedby = 'zhi03.yang' locallastchangedat = '20241216150301' lastchangedat = '20241216150301'  )
     ).

*   insert the new table entries
    INSERT ztstatus_so    FROM TABLE @it_status.
    INSERT ztsuppliertypes FROM TABLE @it_suppliertypes.
*   check the result
    SELECT * FROM ztstatus_so INTO TABLE @it_status.
    COMMIT WORK.
    out->write( sy-dbcnt ).


  ENDMETHOD.



ENDCLASS.
