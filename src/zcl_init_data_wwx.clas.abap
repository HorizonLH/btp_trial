CLASS zcl_init_data_wwx DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION. INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zcl_init_data_wwx IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    " Clear data
    DELETE FROM ztorders.

    " insert travel demo data
    INSERT ztorders FROM TABLE @( VALUE #( ordertype = 'OR'
                                           createdby = sy-uname
                                           ( orderid    = '1000000001'
                                             orderdate  = '45609'
                                             salesorg   = 'H200'
                                             channel    = '41'
                                             division   = '40'
                                             remark     = ''
                                             statuscode = 'Open' )
                                           ( orderid    = '1000000002'
                                             orderdate  = '45617'
                                             salesorg   = 'H300'
                                             channel    = '31'
                                             division   = '10'
                                             remark     = 'Ready'
                                             statuscode = 'Open' )
                                           ( orderid    = '1000000003'
                                             orderdate  = '45064'
                                             salesorg   = 'H200'
                                             channel    = '31'
                                             division   = '10'
                                             remark     = '1st'
                                             statuscode = 'Approved(1st)' ) ) ).
    COMMIT WORK.
    out->write( |OKAY~| ).
  ENDMETHOD.
ENDCLASS.
