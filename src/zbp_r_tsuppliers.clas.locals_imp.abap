CLASS lhc_zr_tsuppliers DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Suppliers
        RESULT result,
      earlynumbering_create FOR NUMBERING
        IMPORTING entities FOR CREATE Suppliers,
      validateSupplierName FOR VALIDATE ON SAVE
        IMPORTING keys FOR Suppliers~validateSupplierName,
      validateSupplierType FOR VALIDATE ON SAVE
        IMPORTING keys FOR Suppliers~validateSupplierType,
      validateEmail FOR VALIDATE ON SAVE
        IMPORTING keys FOR Suppliers~validateEmail,
      validatePhone FOR VALIDATE ON SAVE
        IMPORTING keys FOR Suppliers~validatePhone,
      validateCountry FOR VALIDATE ON SAVE
        IMPORTING keys FOR Suppliers~validateCountry.
ENDCLASS.

CLASS lhc_zr_tsuppliers IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD earlynumbering_create.
    DATA:
      entity           TYPE STRUCTURE FOR CREATE zr_tsuppliers,
      supplierid_max   TYPE ztsuppliers-supplierid,
      use_number_range TYPE abap_bool VALUE abap_false.

    LOOP AT entities INTO entity WHERE supplierid IS NOT INITIAL.
      APPEND CORRESPONDING #( entity ) TO mapped-suppliers.
    ENDLOOP.

    DATA(entities_wo_supplierid) = entities.
    DELETE entities_wo_supplierid WHERE supplierid IS NOT INITIAL.
    IF use_number_range = abap_true.
      "Get numbers
      TRY.
          cl_numberrange_runtime=>number_get(
            EXPORTING
              nr_range_nr       = '01'
              object            = ''
              quantity          = CONV #( lines( entities_wo_supplierid ) )
            IMPORTING
              number            = DATA(number_range_key)
              returncode        = DATA(number_range_return_code)
              returned_quantity = DATA(number_range_returned_quantity)
          ).
        CATCH cx_number_ranges INTO DATA(lx_number_ranges).
          LOOP AT entities_wo_supplierid INTO entity.
            APPEND VALUE #(  %cid      = entity-%cid
                             %key      = entity-%key
                             %is_draft = entity-%is_draft
                             %msg      = lx_number_ranges
                          ) TO reported-suppliers.
            APPEND VALUE #(  %cid      = entity-%cid
                             %key      = entity-%key
                             %is_draft = entity-%is_draft
                          ) TO failed-suppliers.
          ENDLOOP.
          EXIT.
      ENDTRY.

      supplierid_max = number_range_key - number_range_returned_quantity.
    ELSE.
      SELECT SINGLE FROM ztsuppliers FIELDS MAX( supplierid ) AS supplierid INTO @supplierid_max.
      SELECT SINGLE FROM ztsuppliers_d FIELDS MAX( supplierid ) INTO @DATA(max_supplierid_draft).
      IF max_supplierid_draft > supplierid_max.
        supplierid_max = max_supplierid_draft.
      ENDIF.
    ENDIF.
    IF supplierid_max IS INITIAL.
      supplierid_max = '500000'.
    ENDIF.

    LOOP AT entities_wo_supplierid INTO entity.
      supplierid_max += 10.
      entity-supplierid = supplierid_max.
      CONDENSE entity-supplierid NO-GAPS.

      APPEND VALUE #( %cid      = entity-%cid
                      %key      = entity-%key
                      %is_draft = entity-%is_draft
                    ) TO mapped-suppliers.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateSupplierName.

    DATA lv_suppliername TYPE ztsuppliers-suppliername.

    READ ENTITIES OF zr_tsuppliers IN LOCAL MODE
    ENTITY Suppliers
     FIELDS ( Suppliername )
     WITH CORRESPONDING #( keys )
    RESULT DATA(suppliers).

    LOOP AT suppliers INTO DATA(supplier).

      lv_suppliername = supplier-Suppliername.

      APPEND VALUE #( %tky        = supplier-%tky
                      %state_area = 'VALIDATE_SUPPLIERNAME'
                    ) TO reported-suppliers.

      IF lv_suppliername IS INITIAL.
        APPEND VALUE #( %tky = supplier-%tky ) TO failed-suppliers.

        APPEND VALUE #( %tky                  = supplier-%tky
                        %state_area           = 'VALIDATE_SUPPLIERNAME'
                        %msg                  = NEW zcm_sales_order_msg(
                                                        textid   = zcm_sales_order_msg=>enter_suppliername
                                                        severity = if_abap_behv_message=>severity-error )
                        %element-Suppliername = if_abap_behv=>mk-on
                       ) TO reported-suppliers.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateSupplierType.

    DATA lv_suppliertype TYPE ztsuppliers-suppliertype.

    READ ENTITIES OF zr_tsuppliers IN LOCAL MODE
    ENTITY Suppliers
     FIELDS ( Suppliertype )
     WITH CORRESPONDING #( keys )
    RESULT DATA(suppliers).

    LOOP AT suppliers INTO DATA(supplier).

      lv_suppliertype = supplier-Suppliertype.

      APPEND VALUE #( %tky        = supplier-%tky
                      %state_area = 'VALIDATE_SUPPLIERTYPE'
                    ) TO reported-suppliers.

      IF lv_suppliertype IS INITIAL.
        APPEND VALUE #( %tky = supplier-%tky ) TO failed-suppliers.

        APPEND VALUE #( %tky                  = supplier-%tky
                        %state_area           = 'VALIDATE_SUPPLIERTYPE'
                        %msg                  = NEW zcm_sales_order_msg(
                                                        textid   = zcm_sales_order_msg=>enter_suppliertype
                                                        severity = if_abap_behv_message=>severity-error )
                        %element-Suppliertype = if_abap_behv=>mk-on
                       ) TO reported-suppliers.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateEmail.

    DATA:
      lv_email   TYPE ztcustomers-email,
      lv_march   TYPE c LENGTH 1,
      lo_matcher TYPE REF TO cl_abap_matcher.

    READ ENTITIES OF zr_tsuppliers IN LOCAL MODE
    ENTITY Suppliers
     FIELDS ( Email )
     WITH CORRESPONDING #( keys )
    RESULT DATA(suppliers).

    LOOP AT suppliers INTO DATA(supplier).

      lv_email = supplier-Email.

      APPEND VALUE #( %tky        = supplier-%tky
                      %state_area = 'VALIDATE_EMAIL'
                    ) TO reported-suppliers.

      IF lv_email IS INITIAL.
        APPEND VALUE #( %tky = supplier-%tky ) TO failed-suppliers.

        APPEND VALUE #( %tky           = supplier-%tky
                        %state_area    = 'VALIDATE_EMAIL'
                        %msg           = NEW zcm_sales_order_msg(
                                                 textid   = zcm_sales_order_msg=>enter_email_null
                                                 severity = if_abap_behv_message=>severity-error )
                        %element-Email = if_abap_behv=>mk-on
                       ) TO reported-suppliers.
      ELSE.
        " 邮箱格式校验
        lo_matcher = cl_abap_matcher=>create( pattern = '^(\w-*\.*)+@(\w-?)+(\.\w{2,})+$' text = lv_email ).
        lv_march = lo_matcher->match( ).

        IF lv_march NE 'X'.
          APPEND VALUE #( %tky = supplier-%tky ) TO failed-suppliers.

          APPEND VALUE #( %tky           = supplier-%tky
                          %state_area    = 'VALIDATE_EMAIL'
                          %msg           = NEW zcm_sales_order_msg(
                                                   textid   = zcm_sales_order_msg=>enter_email
                                                   severity = if_abap_behv_message=>severity-error )
                          %element-Email = if_abap_behv=>mk-on
                     ) TO reported-suppliers.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validatePhone.

    DATA:
      lv_phone   TYPE ztsuppliers-phone,
      lv_march   TYPE c LENGTH 1,
      lo_matcher TYPE REF TO cl_abap_matcher.

    READ ENTITIES OF zr_tsuppliers IN LOCAL MODE
    ENTITY Suppliers
     FIELDS ( Phone )
     WITH CORRESPONDING #( keys )
    RESULT DATA(suppliers).

    LOOP AT suppliers INTO DATA(supplier).

      lv_phone = supplier-Phone.

      APPEND VALUE #( %tky        = supplier-%tky
                      %state_area = 'VALIDATE_PHONE'
                    ) TO reported-suppliers.

      IF lv_phone IS INITIAL.
        APPEND VALUE #( %tky = supplier-%tky ) TO failed-suppliers.

        APPEND VALUE #( %tky           = supplier-%tky
                        %state_area    = 'VALIDATE_PHONE'
                        %msg           = NEW zcm_sales_order_msg(
                                                 textid   = zcm_sales_order_msg=>enter_phone_null
                                                 severity = if_abap_behv_message=>severity-error )
                        %element-Phone = if_abap_behv=>mk-on
                       ) TO reported-suppliers.
      ELSE.
        " 手机号格式校验
        lo_matcher = cl_abap_matcher=>create( pattern = '^[0-9]*$' text = lv_phone ).
        lv_march = lo_matcher->match( ).

        IF lv_march NE 'X' OR strlen( lv_phone ) > 15.
          APPEND VALUE #( %tky = supplier-%tky ) TO failed-suppliers.

          APPEND VALUE #( %tky           = supplier-%tky
                          %state_area    = 'VALIDATE_PHONE'
                          %msg           = NEW zcm_sales_order_msg(
                                                   textid   = zcm_sales_order_msg=>enter_phone
                                                   severity = if_abap_behv_message=>severity-error )
                          %element-Phone = if_abap_behv=>mk-on
                     ) TO reported-suppliers.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateCountry.

    DATA lv_country TYPE ztsuppliers-country.

    READ ENTITIES OF zr_tsuppliers IN LOCAL MODE
    ENTITY Suppliers
     FIELDS ( Country )
     WITH CORRESPONDING #( keys )
    RESULT DATA(suppliers).

    LOOP AT suppliers INTO DATA(supplier).

      lv_country = supplier-Country.

      APPEND VALUE #( %tky        = supplier-%tky
                      %state_area = 'VALIDATE_COUNTRY'
                    ) TO reported-suppliers.

      IF lv_country IS INITIAL.
        APPEND VALUE #( %tky = supplier-%tky ) TO failed-suppliers.

        APPEND VALUE #( %tky             = supplier-%tky
                        %state_area      = 'VALIDATE_COUNTRY'
                        %msg             = NEW zcm_sales_order_msg(
                                                   textid   = zcm_sales_order_msg=>enter_country
                                                   severity = if_abap_behv_message=>severity-error )
                        %element-Country = if_abap_behv=>mk-on
                       ) TO reported-suppliers.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
