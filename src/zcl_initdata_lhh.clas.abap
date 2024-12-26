CLASS zcl_initdata_lhh DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_initdata_lhh IMPLEMENTATION.

    METHOD if_oo_adt_classrun~main.
        " Clear data
    DELETE FROM ztownertypes.

    " insert travel demo data
    INSERT ztownertypes FROM TABLE @( VALUE #(
                                                createdby = sy-uname
                                                ( ownertype = 'SM' rolename = 'Sales Manager' )
                                                ( ownertype = 'SO' rolename = 'Sales Owner' )
                                                ( ownertype = 'SS' rolename = 'Sales Supervisor' )
                                                ) ).
    ENDMETHOD.

ENDCLASS.
