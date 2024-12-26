CLASS zbp_generate_units DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zbp_generate_units IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    DATA:it_units TYPE TABLE OF ztunits.

*   read current timestamp
*    GET TIME STAMP FIELD DATA(zv_tsl).

*   fill internal table (itab)
    it_units = VALUE #(
        ( unit  = 'PC' descripton = 'pc' )"createdby createdat locallastchangedby locallastchangedat lastchangedat = zv_tsl
        ( unit  = 'EA' descripton = 'ea' )
     ).

*   Delete the possible entries in the database table - in case it was already filled
    DELETE FROM ztunits.

*   insert the new table entries
    INSERT ztunits FROM TABLE @it_units.

*   check the result
    SELECT * FROM ztunits INTO TABLE @it_units.
    out->write( sy-dbcnt ).
    out->write( 'data inserted successfully!' ).
  ENDMETHOD.

ENDCLASS.
