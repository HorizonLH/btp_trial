CLASS lhc_zr_tcustomers DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR Customers
        RESULT result,
      earlynumbering_create FOR NUMBERING
        IMPORTING entities FOR CREATE Customers,
      validateCustomerName FOR VALIDATE ON SAVE
        IMPORTING keys FOR Customers~validateCustomerName,
      validateCustomerType FOR VALIDATE ON SAVE
        IMPORTING keys FOR Customers~validateCustomerType,
      validateEmail FOR VALIDATE ON SAVE
        IMPORTING keys FOR Customers~validateEmail,
      validatePhone FOR VALIDATE ON SAVE
        IMPORTING keys FOR Customers~validatePhone,
      validateCountry FOR VALIDATE ON SAVE
        IMPORTING keys FOR Customers~validateCountry.
ENDCLASS.

CLASS lhc_zr_tcustomers IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD earlynumbering_create.
    DATA:
      entity           TYPE STRUCTURE FOR CREATE zr_tcustomers,
      customerid_max   TYPE ztcustomers-customerid,
      use_number_range TYPE abap_bool VALUE abap_false.

    LOOP AT entities INTO entity WHERE customerid IS NOT INITIAL.
      APPEND CORRESPONDING #( entity ) TO mapped-customers.
    ENDLOOP.

    DATA(entities_wo_customerid) = entities.
    DELETE entities_wo_customerid WHERE customerid IS NOT INITIAL.
    IF use_number_range = abap_true.
      "Get numbers
      TRY.
          cl_numberrange_runtime=>number_get(
            EXPORTING
              nr_range_nr       = '01'
              object            = ''
              quantity          = CONV #( lines( entities_wo_customerid ) )
            IMPORTING
              number            = DATA(number_range_key)
              returncode        = DATA(number_range_return_code)
              returned_quantity = DATA(number_range_returned_quantity)
          ).
        CATCH cx_number_ranges INTO DATA(lx_number_ranges).
          LOOP AT entities_wo_customerid INTO entity.
            APPEND VALUE #(  %cid      = entity-%cid
                             %key      = entity-%key
                             %is_draft = entity-%is_draft
                             %msg      = lx_number_ranges
                          ) TO reported-customers.
            APPEND VALUE #(  %cid      = entity-%cid
                             %key      = entity-%key
                             %is_draft = entity-%is_draft
                          ) TO failed-customers.
          ENDLOOP.
          EXIT.
      ENDTRY.

      customerid_max = number_range_key - number_range_returned_quantity.
    ELSE.
      SELECT SINGLE FROM ztcustomers FIELDS MAX( customerid ) AS customerid INTO @customerid_max.
      SELECT SINGLE FROM ztcustomers_d FIELDS MAX( customerid ) INTO @DATA(max_customerid_draft).
      IF max_customerid_draft > customerid_max.
        customerid_max = max_customerid_draft.
      ENDIF.
    ENDIF.
    IF customerid_max IS INITIAL.
      customerid_max = '300000'.
    ENDIF.

    LOOP AT entities_wo_customerid INTO entity.
      customerid_max += 10.
      entity-customerid = customerid_max.
      CONDENSE entity-customerid NO-GAPS.

      APPEND VALUE #( %cid      = entity-%cid
                      %key      = entity-%key
                      %is_draft = entity-%is_draft
                    ) TO mapped-customers.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateCustomerName.

    DATA lv_customername TYPE ztcustomers-customername.

    READ ENTITIES OF zr_tcustomers IN LOCAL MODE
    ENTITY Customers
     FIELDS ( Customername )
     WITH CORRESPONDING #( keys )
    RESULT DATA(customers).

    LOOP AT customers INTO DATA(customer).

      lv_customername = customer-Customername.
      APPEND VALUE #( %tky        = customer-%tky
                      %state_area = 'VALIDATE_CUSTOMERNAME'
                    ) TO reported-customers.

      IF lv_customername IS INITIAL.
        APPEND VALUE #( %tky = customer-%tky ) TO failed-customers.

        APPEND VALUE #( %tky                  = customer-%tky
                        %state_area           = 'VALIDATE_CUSTOMERNAME'
                        %msg                  = NEW zcm_sales_order_msg(
                                                        textid   = zcm_sales_order_msg=>enter_customername
                                                        severity = if_abap_behv_message=>severity-error )
                        %element-Customername = if_abap_behv=>mk-on
                       ) TO reported-customers.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateCustomerType.

    DATA lv_customertype TYPE ztcustomers-customertype.

    READ ENTITIES OF zr_tcustomers IN LOCAL MODE
    ENTITY Customers
     FIELDS ( Customertype )
     WITH CORRESPONDING #( keys )
    RESULT DATA(customers).

    LOOP AT customers INTO DATA(customer).

      lv_customertype = customer-Customertype.

      APPEND VALUE #( %tky        = customer-%tky
                      %state_area = 'VALIDATE_CUSTOMERTYPE'
                    ) TO reported-customers.

      IF lv_customertype IS INITIAL.
        APPEND VALUE #( %tky = customer-%tky ) TO failed-customers.

        APPEND VALUE #( %tky                  = customer-%tky
                        %state_area           = 'VALIDATE_CUSTOMERTYPE'
                        %msg                  = NEW zcm_sales_order_msg(
                                                        textid   = zcm_sales_order_msg=>enter_customertype
                                                        severity = if_abap_behv_message=>severity-error )
                        %element-Customertype = if_abap_behv=>mk-on
                       ) TO reported-customers.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateEmail.

    DATA:
      lv_email   TYPE ztcustomers-email,
      lv_march   TYPE c LENGTH 1,
      lo_matcher TYPE REF TO cl_abap_matcher.

    READ ENTITIES OF zr_tcustomers IN LOCAL MODE
    ENTITY Customers
     FIELDS ( Email )
     WITH CORRESPONDING #( keys )
    RESULT DATA(customers).

    LOOP AT customers INTO DATA(customer).

      lv_email = customer-Email.

      APPEND VALUE #( %tky        = customer-%tky
                      %state_area = 'VALIDATE_EMAIL'
                    ) TO reported-customers.

      IF lv_email IS INITIAL.
        APPEND VALUE #( %tky = customer-%tky ) TO failed-customers.

        APPEND VALUE #( %tky           = customer-%tky
                        %state_area    = 'VALIDATE_EMAIL'
                        %msg           = NEW zcm_sales_order_msg(
                                                 textid   = zcm_sales_order_msg=>enter_email_null
                                                 severity = if_abap_behv_message=>severity-error )
                        %element-Email = if_abap_behv=>mk-on
                       ) TO reported-customers.
      ELSE.
        " 邮箱格式校验
        lo_matcher = cl_abap_matcher=>create( pattern = '^(\w-*\.*)+@(\w-?)+(\.\w{2,})+$' text = lv_email ).
        lv_march = lo_matcher->match( ).

        IF lv_march NE 'X'.
          APPEND VALUE #( %tky = customer-%tky ) TO failed-customers.

          APPEND VALUE #( %tky           = customer-%tky
                          %state_area    = 'VALIDATE_EMAIL'
                          %msg           = NEW zcm_sales_order_msg(
                                                   textid   = zcm_sales_order_msg=>enter_email
                                                   severity = if_abap_behv_message=>severity-error )
                          %element-Email = if_abap_behv=>mk-on
                     ) TO reported-customers.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validatePhone.

    DATA:
      lv_phone   TYPE ztsuppliers-phone,
      lv_march   TYPE c LENGTH 1,
      lo_matcher TYPE REF TO cl_abap_matcher.

    READ ENTITIES OF zr_tcustomers IN LOCAL MODE
    ENTITY Customers
     FIELDS ( Phone )
     WITH CORRESPONDING #( keys )
    RESULT DATA(customers).

    LOOP AT customers INTO DATA(customer).

      lv_phone = customer-Phone.

      APPEND VALUE #( %tky        = customer-%tky
                      %state_area = 'VALIDATE_PHONE'
                    ) TO reported-customers.

      IF lv_phone IS INITIAL.
        APPEND VALUE #( %tky = customer-%tky ) TO failed-customers.

        APPEND VALUE #( %tky           = customer-%tky
                        %state_area    = 'VALIDATE_PHONE'
                        %msg           = NEW zcm_sales_order_msg(
                                                 textid   = zcm_sales_order_msg=>enter_phone_null
                                                 severity = if_abap_behv_message=>severity-error )
                        %element-Phone = if_abap_behv=>mk-on
                       ) TO reported-customers.
      ELSE.
        " 手机号格式校验
        lo_matcher = cl_abap_matcher=>create( pattern = '^[0-9]*$' text = lv_phone ).
        lv_march = lo_matcher->match( ).

        IF lv_march NE 'X' OR strlen( lv_phone ) > 15.
          APPEND VALUE #( %tky = customer-%tky ) TO failed-customers.

          APPEND VALUE #( %tky           = customer-%tky
                          %state_area    = 'VALIDATE_PHONE'
                          %msg           = NEW zcm_sales_order_msg(
                                                   textid   = zcm_sales_order_msg=>enter_phone
                                                   severity = if_abap_behv_message=>severity-error )
                          %element-Phone = if_abap_behv=>mk-on
                     ) TO reported-customers.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateCountry.

    DATA lv_country TYPE ztcustomers-country.

    READ ENTITIES OF zr_tcustomers IN LOCAL MODE
    ENTITY Customers
     FIELDS ( Country )
     WITH CORRESPONDING #( keys )
    RESULT DATA(customers).

    LOOP AT customers INTO DATA(customer).

      lv_country = customer-Country.

      APPEND VALUE #( %tky        = customer-%tky
                      %state_area = 'VALIDATE_COUNTRY'
                    ) TO reported-customers.

      IF lv_country IS INITIAL.
        APPEND VALUE #( %tky = customer-%tky ) TO failed-customers.

        APPEND VALUE #( %tky             = customer-%tky
                        %state_area      = 'VALIDATE_COUNTRY'
                        %msg             = NEW zcm_sales_order_msg(
                                                   textid   = zcm_sales_order_msg=>enter_country
                                                   severity = if_abap_behv_message=>severity-error )
                        %element-Country = if_abap_behv=>mk-on
                       ) TO reported-customers.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
