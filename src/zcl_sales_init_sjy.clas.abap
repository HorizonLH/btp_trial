CLASS zcl_sales_init_sjy DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_sales_init_sjy IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA: lt_ztorderitems TYPE TABLE OF ztorderitems.

*    DELETE FROM ztorders_d.
*    DELETE FROM ztorderitems.
*    lt_ztorderitems = VALUE #(
*      ( orderid = '1000000001'  itemno = '00001' plantid = '100010' quantity = '10' unit = 'KG')
*      ( orderid = '1000000001'  itemno = '00002' plantid = '100020' quantity = '10' unit = 'KG')
*      ( orderid = '1000000001'  itemno = '00003' plantid = '100030' quantity = '10' unit = 'KG')
*      ( orderid = '1000000001'  itemno = '00004' plantid = '1000140' quantity = '10' unit = 'KG')
*   ).
*
*    MODIFY ztorderitems FROM TABLE @lt_ztorderitems.
*    COMMIT WORK.
    out->write( 'data inserted successfully!' ).
  ENDMETHOD.
ENDCLASS.
