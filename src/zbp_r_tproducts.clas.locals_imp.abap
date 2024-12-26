CLASS lhc_zr_tproducts DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Products
        RESULT result,
      earlynumbering_create FOR NUMBERING
        IMPORTING entities FOR CREATE Products,
      validateProductName FOR VALIDATE ON SAVE
        IMPORTING keys FOR Products~validateProductName,
      validatePlant FOR VALIDATE ON SAVE
        IMPORTING keys FOR Products~validatePlant,
      validateSupplier FOR VALIDATE ON SAVE
        IMPORTING keys FOR Products~validateSupplier.
ENDCLASS.

CLASS lhc_zr_tproducts IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD earlynumbering_create.
    DATA:
      entity           TYPE STRUCTURE FOR CREATE zr_tproducts,
      productid_max    TYPE ztproducts-productid,
      use_number_range TYPE abap_bool VALUE abap_false.

    LOOP AT entities INTO entity WHERE productid IS NOT INITIAL.
      APPEND CORRESPONDING #( entity ) TO mapped-products.
    ENDLOOP.

    DATA(entities_wo_productid) = entities.
    DELETE entities_wo_productid WHERE productid IS NOT INITIAL.
    IF use_number_range = abap_true.
      "Get numbers
      TRY.
          cl_numberrange_runtime=>number_get(
            EXPORTING
              nr_range_nr       = '01'
              object            = ''
              quantity          = CONV #( lines( entities_wo_productid ) )
            IMPORTING
              number            = DATA(number_range_key)
              returncode        = DATA(number_range_return_code)
              returned_quantity = DATA(number_range_returned_quantity)
          ).
        CATCH cx_number_ranges INTO DATA(lx_number_ranges).
          LOOP AT entities_wo_productid INTO entity.
            APPEND VALUE #(  %cid      = entity-%cid
                             %key      = entity-%key
                             %is_draft = entity-%is_draft
                             %msg      = lx_number_ranges
                          ) TO reported-products.
            APPEND VALUE #(  %cid      = entity-%cid
                             %key      = entity-%key
                             %is_draft = entity-%is_draft
                          ) TO failed-products.
          ENDLOOP.
          EXIT.
      ENDTRY.

      productid_max = number_range_key - number_range_returned_quantity.
    ELSE.
      SELECT SINGLE FROM ztproducts FIELDS MAX( productid ) AS productid INTO @productid_max.
      SELECT SINGLE FROM ztproducts_d FIELDS MAX( productid ) INTO @DATA(max_productid_draft).
      IF max_productid_draft > productid_max.
        productid_max = max_productid_draft.
      ENDIF.
    ENDIF.
    IF productid_max IS INITIAL.
      productid_max = '10000000'.
    ENDIF.

    LOOP AT entities_wo_productid INTO entity.
      productid_max += 10.
      entity-Productid = productid_max.
      CONDENSE entity-Productid NO-GAPS.

      APPEND VALUE #( %cid      = entity-%cid
                      %key      = entity-%key
                      %is_draft = entity-%is_draft
                    ) TO mapped-products.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateProductName.

    DATA lv_productname TYPE ztproducts-productname.

    READ ENTITIES OF zr_tproducts IN LOCAL MODE
    ENTITY Products
     FIELDS ( Productname )
     WITH CORRESPONDING #( keys )
    RESULT DATA(products).

    LOOP AT products INTO DATA(product).

      lv_productname = product-Productname.

      APPEND VALUE #( %tky        = product-%tky
                      %state_area = 'VALIDATE_PRODUCTNAME'
                    ) TO reported-products.

      IF lv_productname IS INITIAL.
        APPEND VALUE #( %tky = product-%tky ) TO failed-products.

        APPEND VALUE #( %tky                 = product-%tky
                        %state_area          = 'VALIDATE_PRODUCTNAME'
                        %msg                 = NEW zcm_sales_order_msg(
                                                       textid   = zcm_sales_order_msg=>enter_productname
                                                       severity = if_abap_behv_message=>severity-error )
                        %element-Productname = if_abap_behv=>mk-on
                       ) TO reported-products.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validatePlant.

    DATA lv_plantid TYPE ztproducts-plantid.

    READ ENTITIES OF zr_tproducts IN LOCAL MODE
    ENTITY Products
     FIELDS ( Plantid )
     WITH CORRESPONDING #( keys )
    RESULT DATA(products).

    LOOP AT products INTO DATA(product).

      lv_plantid = product-Plantid.

      APPEND VALUE #( %tky        = product-%tky
                      %state_area = 'VALIDATE_PLANT'
                    ) TO reported-products.

      IF lv_plantid IS INITIAL.
        APPEND VALUE #( %tky = product-%tky ) TO failed-products.

        APPEND VALUE #( %tky             = product-%tky
                        %state_area      = 'VALIDATE_PLANT'
                        %msg             = NEW zcm_sales_order_msg(
                                                   textid   = zcm_sales_order_msg=>enter_plant
                                                   severity = if_abap_behv_message=>severity-error )
                        %element-Plantid = if_abap_behv=>mk-on
                       ) TO reported-products.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateSupplier.

    DATA lv_supplierid TYPE ztproducts-supplierid.

    READ ENTITIES OF zr_tproducts IN LOCAL MODE
    ENTITY Products
     FIELDS ( Supplierid )
     WITH CORRESPONDING #( keys )
    RESULT DATA(products).

    LOOP AT products INTO DATA(product).

      lv_supplierid = product-Supplierid.

      APPEND VALUE #( %tky        = product-%tky
                      %state_area = 'VALIDATE_SUPPLIER'
                    ) TO reported-products.

      IF lv_supplierid IS INITIAL.
        APPEND VALUE #( %tky = product-%tky ) TO failed-products.

        APPEND VALUE #( %tky                = product-%tky
                        %state_area         = 'VALIDATE_SUPPLIER'
                        %msg                = NEW zcm_sales_order_msg(
                                                      textid   = zcm_sales_order_msg=>enter_supplier
                                                      severity = if_abap_behv_message=>severity-error )
                        %element-Supplierid = if_abap_behv=>mk-on
                       ) TO reported-products.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
