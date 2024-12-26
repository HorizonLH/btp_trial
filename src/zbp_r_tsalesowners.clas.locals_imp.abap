CLASS lhc_zr_tsalesowners DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR SalesOwners
        RESULT result,
      earlynumbering_create FOR NUMBERING
        IMPORTING entities FOR CREATE SalesOwners,
      validateOwnerName FOR VALIDATE ON SAVE
        IMPORTING keys FOR SalesOwners~validateOwnerName,
      validateOwnerType FOR VALIDATE ON SAVE
        IMPORTING keys FOR SalesOwners~validateOwnerType,
      validateEmail FOR VALIDATE ON SAVE
        IMPORTING keys FOR SalesOwners~validateEmail,
      validatePhone FOR VALIDATE ON SAVE
        IMPORTING keys FOR SalesOwners~validatePhone,
      validateCountry FOR VALIDATE ON SAVE
        IMPORTING keys FOR SalesOwners~validateCountry.
ENDCLASS.

CLASS lhc_zr_tsalesowners IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.
  METHOD earlynumbering_create.
    DATA:
      entity           TYPE STRUCTURE FOR CREATE zr_tsalesowners,
      ownerid_max      TYPE ztsalesowners-ownerid,
      use_number_range TYPE abap_bool VALUE abap_false.

    LOOP AT entities INTO entity WHERE ownerid IS NOT INITIAL.
      APPEND CORRESPONDING #( entity ) TO mapped-salesowners.
    ENDLOOP.

    DATA(entities_wo_ownerid) = entities.
    DELETE entities_wo_ownerid WHERE ownerid IS NOT INITIAL.
    IF use_number_range = abap_true.
      "Get numbers
      TRY.
          cl_numberrange_runtime=>number_get(
            EXPORTING
              nr_range_nr       = '01'
              object            = ''
              quantity          = CONV #( lines( entities_wo_ownerid ) )
            IMPORTING
              number            = DATA(number_range_key)
              returncode        = DATA(number_range_return_code)
              returned_quantity = DATA(number_range_returned_quantity)
          ).
        CATCH cx_number_ranges INTO DATA(lx_number_ranges).
          LOOP AT entities_wo_ownerid INTO entity.
            APPEND VALUE #(  %cid      = entity-%cid
                             %key      = entity-%key
                             %is_draft = entity-%is_draft
                             %msg      = lx_number_ranges
                          ) TO reported-salesowners.
            APPEND VALUE #(  %cid      = entity-%cid
                             %key      = entity-%key
                             %is_draft = entity-%is_draft
                          ) TO failed-salesowners.
          ENDLOOP.
          EXIT.
      ENDTRY.

      ownerid_max = number_range_key - number_range_returned_quantity.
    ELSE.
      SELECT SINGLE FROM ztsalesowners FIELDS MAX( ownerid ) AS ownerid INTO @ownerid_max.
      SELECT SINGLE FROM ztslsowners_d FIELDS MAX( ownerid ) INTO @DATA(max_ownerid_draft).
      IF max_ownerid_draft > ownerid_max.
        ownerid_max = max_ownerid_draft.
      ENDIF.
    ENDIF.
    IF ownerid_max IS INITIAL.
      ownerid_max = '800000'.
    ENDIF.

    LOOP AT entities_wo_ownerid INTO entity.
      ownerid_max += 10.
      entity-Ownerid = ownerid_max.
      CONDENSE entity-Ownerid NO-GAPS.

      APPEND VALUE #( %cid      = entity-%cid
                      %key      = entity-%key
                      %is_draft = entity-%is_draft
                    ) TO mapped-salesowners.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateOwnerName.

    DATA lv_ownername TYPE ztsalesowners-ownername.

    READ ENTITIES OF zr_tsalesowners IN LOCAL MODE
    ENTITY SalesOwners
     FIELDS ( Ownername )
     WITH CORRESPONDING #( keys )
    RESULT DATA(salesowners).

    LOOP AT salesowners INTO DATA(salesowner).

      lv_ownername = salesowner-Ownername.

      APPEND VALUE #( %tky        = salesowner-%tky
                      %state_area = 'VALIDATE_OWNERNAME'
                    ) TO reported-salesowners.

      IF lv_ownername IS INITIAL.
        APPEND VALUE #( %tky = salesowner-%tky ) TO failed-salesowners.

        APPEND VALUE #( %tky               = salesowner-%tky
                        %state_area        = 'VALIDATE_OWNERNAME'
                        %msg               = NEW zcm_sales_order_msg(
                                                     textid   = zcm_sales_order_msg=>enter_ownername
                                                     severity = if_abap_behv_message=>severity-error )
                        %element-Ownername = if_abap_behv=>mk-on
                       ) TO reported-salesowners.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateOwnerType.

    DATA lv_ownertype TYPE ztsalesowners-ownertype.

    READ ENTITIES OF zr_tsalesowners IN LOCAL MODE
    ENTITY SalesOwners
     FIELDS ( Ownertype )
     WITH CORRESPONDING #( keys )
    RESULT DATA(salesowners).

    LOOP AT salesowners INTO DATA(salesowner).

      lv_ownertype = salesowner-Ownertype.

      APPEND VALUE #( %tky        = salesowner-%tky
                      %state_area = 'VALIDATE_OWNERTYPE'
                    ) TO reported-salesowners.

      IF lv_ownertype IS INITIAL.
        APPEND VALUE #( %tky = salesowner-%tky ) TO failed-salesowners.

        APPEND VALUE #( %tky               = salesowner-%tky
                        %state_area        = 'VALIDATE_OWNERTYPE'
                        %msg               = NEW zcm_sales_order_msg(
                                                     textid   = zcm_sales_order_msg=>enter_ownertype
                                                     severity = if_abap_behv_message=>severity-error )
                        %element-Ownertype = if_abap_behv=>mk-on
                       ) TO reported-salesowners.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateEmail.

    DATA:
      lv_email   TYPE ztcustomers-email,
      lv_march   TYPE c LENGTH 1,
      lo_matcher TYPE REF TO cl_abap_matcher.

    READ ENTITIES OF zr_tsalesowners IN LOCAL MODE
    ENTITY SalesOwners
     FIELDS ( Email )
     WITH CORRESPONDING #( keys )
    RESULT DATA(SalesOwners).

    LOOP AT SalesOwners INTO DATA(SalesOwner).

      lv_email = SalesOwner-Email.

      APPEND VALUE #( %tky        = SalesOwner-%tky
                      %state_area = 'VALIDATE_EMAIL'
                    ) TO reported-SalesOwners.

      IF lv_email IS INITIAL.
        APPEND VALUE #( %tky = SalesOwner-%tky ) TO failed-SalesOwners.

        APPEND VALUE #( %tky           = SalesOwner-%tky
                        %state_area    = 'VALIDATE_EMAIL'
                        %msg           = NEW zcm_sales_order_msg(
                                                 textid   = zcm_sales_order_msg=>enter_email_null
                                                 severity = if_abap_behv_message=>severity-error )
                        %element-Email = if_abap_behv=>mk-on
                       ) TO reported-SalesOwners.
      ELSE.
        " 邮箱格式校验
        lo_matcher = cl_abap_matcher=>create( pattern = '^(\w-*\.*)+@(\w-?)+(\.\w{2,})+$' text = lv_email ).
        lv_march = lo_matcher->match( ).

        IF lv_march NE 'X'.
          APPEND VALUE #( %tky = SalesOwner-%tky ) TO failed-SalesOwners.

          APPEND VALUE #( %tky           = SalesOwner-%tky
                          %state_area    = 'VALIDATE_EMAIL'
                          %msg           = NEW zcm_sales_order_msg(
                                                   textid   = zcm_sales_order_msg=>enter_email
                                                   severity = if_abap_behv_message=>severity-error )
                          %element-Email = if_abap_behv=>mk-on
                     ) TO reported-SalesOwners.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validatePhone.

    DATA:
      lv_phone   TYPE ztcustomers-phone,
      lv_march   TYPE c LENGTH 1,
      lo_matcher TYPE REF TO cl_abap_matcher.

    READ ENTITIES OF zr_tsalesowners IN LOCAL MODE
    ENTITY SalesOwners
     FIELDS ( Phone )
     WITH CORRESPONDING #( keys )
    RESULT DATA(salesowners).

    LOOP AT salesowners INTO DATA(salesowner).

      lv_phone = salesowner-Phone.

      APPEND VALUE #( %tky        = salesowner-%tky
                      %state_area = 'VALIDATE_PHONE'
                    ) TO reported-salesowners.

      IF lv_phone IS INITIAL.
        APPEND VALUE #( %tky = salesowner-%tky ) TO failed-salesowners.

        APPEND VALUE #( %tky           = salesowner-%tky
                        %state_area    = 'VALIDATE_PHONE'
                        %msg           = NEW zcm_sales_order_msg(
                                                 textid   = zcm_sales_order_msg=>enter_phone_null
                                                 severity = if_abap_behv_message=>severity-error )
                        %element-Phone = if_abap_behv=>mk-on
                      ) TO reported-salesowners.
      ELSE.
        " 手机号格式校验
        lo_matcher = cl_abap_matcher=>create( pattern = '^[0-9]*$' text = lv_phone ).
        lv_march = lo_matcher->match( ).

        IF lv_march NE 'X' OR strlen( lv_phone ) > 15.
          APPEND VALUE #( %tky = salesowner-%tky ) TO failed-salesowners.

          APPEND VALUE #( %tky           = salesowner-%tky
                          %state_area    = 'VALIDATE_PHONE'
                          %msg           = NEW zcm_sales_order_msg(
                                                   textid   = zcm_sales_order_msg=>enter_phone
                                                   severity = if_abap_behv_message=>severity-error )
                          %element-Phone = if_abap_behv=>mk-on
                     ) TO reported-salesowners.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateCountry.

    DATA lv_country TYPE ztcustomers-country.

    READ ENTITIES OF zr_tsalesowners IN LOCAL MODE
    ENTITY SalesOwners
     FIELDS ( Country )
     WITH CORRESPONDING #( keys )
    RESULT DATA(salesowners).

    LOOP AT salesowners INTO DATA(salesowner).

      lv_country = salesowner-Country.

      APPEND VALUE #( %tky        = salesowner-%tky
                      %state_area = 'VALIDATE_COUNTRY'
                    ) TO reported-salesowners.

      IF lv_country IS INITIAL.
        APPEND VALUE #( %tky = salesowner-%tky ) TO failed-salesowners.

        APPEND VALUE #( %tky             = salesowner-%tky
                        %state_area      = 'VALIDATE_COUNTRY'
                        %msg             = NEW zcm_sales_order_msg(
                                                   textid   = zcm_sales_order_msg=>enter_country
                                                   severity = if_abap_behv_message=>severity-error )
                        %element-Country = if_abap_behv=>mk-on
                       ) TO reported-salesowners.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
