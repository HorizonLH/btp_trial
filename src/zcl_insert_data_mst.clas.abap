CLASS zcl_insert_data_mst DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_OO_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_insert_data_mst IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
*给表ztSuppliers和ztCustomers添加一条初始数据
*已执行
    DATA: lv_num TYPE INT4.
    DATA:
      ls_Suppliers TYPE ztSuppliers,
      ls_Customers TYPE ztCustomers.
    DATA:
      ls_plants   TYPE ztplants,
      ls_plants_t TYPE ztplants,
      lt_plants   TYPE TABLE OF ztplants.


    lv_num = 2.
    CASE lv_num.
      WHEN 1.
        DELETE FROM ztSuppliers.
        DELETE FROM ztCustomers.

        ls_suppliers-supplierId = '5100010'.
        ls_suppliers-supplierName = 'Boardworks outdoor advertising'.
        ls_suppliers-email = 'johndoe@gmail.com'.
        ls_suppliers-phone = '4049644718'.
        ls_suppliers-street = '1533 belle meade blvd'.
        ls_suppliers-town = 'Northport AL 35475'.
        ls_suppliers-country = 'AM'.
        ls_suppliers-supplierType = 'OS'.
        ls_suppliers-createdby = 'SONGTING,MA'.
        ls_suppliers-createdat = '20241216150301'.
        ls_suppliers-locallastchangedby = 'SONGTING,MA'.
        ls_suppliers-locallastchangedat = '20241216150301'.
        ls_suppliers-lastchangedat = '20241216150301'.

        ls_Customers-customerId = '100010'.
        ls_Customers-customerName = 'Samsung Electronics America Inc.'.
        ls_Customers-email = 'donal.kim@samsung.com'.
        ls_Customers-phone = '9727617230'.
        ls_Customers-street = '85 Challenger Road'.
        ls_Customers-town = 'Ridgefield Park NJ 07660'.
        ls_Customers-country = 'AM'.
        ls_Customers-customerType = 'S0'.
        ls_Customers-createdby = 'SONGTING,MA'.
        ls_Customers-createdat = '20241216150301'.
        ls_Customers-locallastchangedby = 'SONGTING,MA'.
        ls_Customers-locallastchangedat = '20241216150301'.
        ls_Customers-lastchangedat = '20241216150301'.

        "insert data
        INSERT ztSuppliers  FROM @ls_suppliers.
        INSERT ztCustomers  FROM @ls_Customers.

        COMMIT WORK.

      WHEN 2.
        SELECT *
        FROM ztplants
        INTO CORRESPONDING FIELDS OF TABLE @lt_plants.
       read TABLE lt_plants WITH KEY plant = 'J300' INTO LS_PLANTS_T.

        LOOP AT lt_plants INTO ls_plants.
          LS_PLANTS-createdat = LS_PLANTS_T-createdat.
          LS_PLANTS-lastchangedat = LS_PLANTS_T-lastchangedat.
          LS_PLANTS-locallastchangedat = LS_PLANTS_T-locallastchangedat.
          MODIFY lt_plants FROM ls_plants.
        ENDLOOP.
       MODIFY ztplants FROM TABLE @lt_plants.


      ENDCASE.

          out->write( |OKAY~| ).
      ENDMETHOD.
ENDCLASS.
