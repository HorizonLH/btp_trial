CLASS zcl_insert_data_jie DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_insert_data_jie IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
* clear data
    DELETE FROM ztplants.


    "insert plant
    DATA:lt_plant TYPE TABLE OF ztplants.

*    read current timestamp
*    GET TIME STAMP FIELD DATA(zv_tsl).
*   fill internal table (itab)
    lt_plant = VALUE #(
        ( plant  = 'J100' description = '第一工厂' createdby = sy-uname createdat = sy-datum  )
        ( plant  = 'J200' description = '第二工厂' createdby = sy-uname createdat = sy-datum  )
     ).

*   insert the new table entries
    INSERT ztplants FROM TABLE @lt_plant.

*   check the result
    SELECT * FROM ztplants INTO TABLE @lt_plant.
    out->write( sy-dbcnt ).
    out->write( 'ztplants data inserted successfully!' ).

* clear data
    DELETE FROM zTCountries.

    DATA LT_COUNT TYPE TABLE OF zTCountries.

*    SELECT LAND1
*    FROM t005t
*    INNER JOIN

    SELECT Country AS country , CountryName AS descripton  FROM I_CountryText
    WHERE Language = '1'
    INTO CORRESPONDING FIELDS OF TABLE @LT_COUNT
    .
*   insert the new table entries
    INSERT zTCountries FROM TABLE @LT_COUNT.
    out->write( sy-dbcnt ).
    out->write( 'zTCountries data inserted successfully!' ).



* clear data
    DELETE FROM ztcurrencies.

    DATA LT_CURR TYPE TABLE OF ztcurrencies.


    SELECT Currency AS Currency , CurrencyName AS descriptIon  FROM I_CurrencyText
        WHERE Language = '1'
    INTO CORRESPONDING FIELDS OF TABLE @LT_CURR.
*   insert the new table entries
    INSERT ztcurrencies FROM TABLE @LT_CURR.
    out->write( sy-dbcnt ).
    out->write( 'ztcurrencies data inserted successfully!' ).



  ENDMETHOD.
ENDCLASS.
