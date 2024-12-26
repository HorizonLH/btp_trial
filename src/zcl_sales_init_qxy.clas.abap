CLASS zcl_sales_init_qxy DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    "   METHODS: zif_insert_ordertypes.
    "   METHODS: zif_insert_CustomerTypes.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_sales_init_qxy IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
    " METHOD zif_insert_ordertypes.
    DATA: lt_ordertypes TYPE TABLE OF ztordertypes.
    " GET TIME STAMP FIELD DATA(ls_times).
    lt_ordertypes = VALUE #(
                              ( orderType = 'BV'  description = 'Cash Sale'  )
                              ( orderType = 'CR'  description = 'Credit Memo' )
                              ( orderType = 'DR'  description = 'Debit Memo' )
                              ( orderType = 'OR'  description = 'Standard Order' )
                              ( orderType = 'RA'  description = 'Repair Request' )
                              ( orderType = 'RE'  description = 'Returns' )
                               ).

    MODIFY ztordertypes FROM TABLE @lt_ordertypes.
    "  ENDMETHOD.

    " METHOD zif_insert_CustomerTypes .

    DATA: lt_CustomerTps TYPE TABLE OF ZTCustomerTps.
    lt_CustomerTps = VALUE #(
                               ( customerType = 'S0'  description = 'Ordinary Customers' )
                               ( customerType = 'S1'  description = 'VIP Customers' )
                               ( customerType = 'S2'  description = 'SVIP Customers' )
                               ( customerType = 'S3'  description = 'One-Time Customers' )
                                ).

    MODIFY ZTCustomerTps FROM TABLE @lt_CustomerTps.
    COMMIT WORK.
  "  out->write( 'data inserted successfully!' ).
  ENDMETHOD.



ENDCLASS.
