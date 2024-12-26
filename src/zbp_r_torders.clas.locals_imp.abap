CLASS lsc_zr_torders DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PROTECTED SECTION.

  PRIVATE SECTION.
    METHODS save_modified FOR VALIDATE ON SAVE
      IMPORTING keys FOR OrderItems~save_modified.

ENDCLASS.

CLASS lsc_zr_torders IMPLEMENTATION.

  METHOD save_modified.

    READ ENTITIES OF zr_torders IN LOCAL MODE
      ENTITY ZrTorders
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_Order).

    DATA(ls_Order) = lt_Order[ 1 ].
    READ ENTITIES OF zr_torders IN LOCAL MODE
         ENTITY OrderItems
            ALL FIELDS
            WITH CORRESPONDING #( keys )
        RESULT DATA(lt_orderitems).

    SORT lt_orderitems BY Currency.
    DELETE ADJACENT DUPLICATES FROM lt_orderitems COMPARING Currency.

    IF lines( lt_orderitems ) > 1.
      APPEND VALUE #( %key = ls_Order-%key ) TO failed-zrtorders.

      APPEND VALUE #( %key                  = ls_Order-%key
                      %state_area           = 'VALIDATE_CURRENCY'
                      %msg                  = NEW zcm_sales_order_msg(
                                                      textid   = zcm_sales_order_msg=>enter_Currency
                                                      severity = if_abap_behv_message=>severity-error )
                     ) TO reported-zrtorders.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

**********************************************************************.
* Class lhc_orderitems Define
**********************************************************************
CLASS lhc_orderitems DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS reCalcTotalPrice FOR MODIFY
      IMPORTING keys FOR ACTION OrderItems~reCalcTotalPrice.

    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR OrderItems~calculateTotalPrice.

    METHODS Getproductinfor FOR DETERMINE ON MODIFY
      IMPORTING keys FOR OrderItems~Getproductinfor.

ENDCLASS.
**********************************************************************.
* Class lhc_orderitems IMPLEMENTATION
**********************************************************************
CLASS lhc_orderitems IMPLEMENTATION.

**********************************************************************.
* METHOD reCalcTotalPrice
**********************************************************************
  METHOD reCalcTotalPrice.
    DATA :lv_totalamout  TYPE ztOrders-totalAmount .
    DATA: lv_amout       TYPE /dmo/total_price.

* The current line
    READ ENTITIES OF zr_torders IN LOCAL MODE
         ENTITY OrderItems
            FIELDS ( Sprice currency  Quantity unit )
            WITH CORRESPONDING #( keys )
        RESULT DATA(lt_OrderItems).
    DATA(lS_OrderItems) = lt_OrderItems[ 1 ] .

* All order items
    READ ENTITIES OF zr_torders IN LOCAL MODE
       ENTITY ZrTorders BY \_Items
"          FIELDS ( Sprice currency  Quantity unit )
          ALL FIELDS
          WITH CORRESPONDING #( keys )
      RESULT DATA(lt_OrderItems_all).

* Get order data
*    CLEAR lv_totalamout.
    LOOP AT lt_OrderItems_all ASSIGNING FIELD-SYMBOL(<fs_orderitem_all>).
      IF lS_OrderItems-itemno = <fs_orderitem_all>-itemno.
        <fs_orderitem_all>-amount = lS_OrderItems-Sprice * lS_OrderItems-Quantity.
      ENDIF.

      lv_totalamout         = lv_totalamout  + <fs_orderitem_all>-amount.

      IF lS_OrderItems-currency <> <fs_orderitem_all>-currency.
        <fs_orderitem_all>-currency = lS_OrderItems-currency.
      ENDIF.

    ENDLOOP.

    READ ENTITIES OF zr_torders IN LOCAL MODE
      ENTITY ZrTorders
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_Order).

    LOOP AT lt_Order ASSIGNING FIELD-SYMBOL(<fs_orders>) WHERE orderid = lS_OrderItems-orderid  .
      <fs_orders>-totalAmount = lv_totalamout.
      <fs_orders>-Currency    = lS_OrderItems-currency.
    ENDLOOP.


    " Modified Totalamoutn for orders
    MODIFY ENTITIES OF zr_torders IN LOCAL MODE
    ENTITY ZrTorders
        UPDATE FIELDS ( Totalamount Currency )  "
         WITH CORRESPONDING #( lt_order ).

    " Modified Amount for orderitems
    MODIFY ENTITIES OF zr_torders IN LOCAL MODE
    ENTITY OrderItems
       UPDATE FIELDS ( amount )
     "   UPDATE SET FIELDS
        WITH CORRESPONDING #( lt_OrderItems_all ).


  ENDMETHOD.
**********************************************************************
* METHOD calculateTotalPrice
**********************************************************************
  METHOD calculateTotalPrice.
    MODIFY ENTITIES OF zr_torders IN LOCAL MODE
                ENTITY OrderItems
                EXECUTE reCalcTotalPrice
                FROM CORRESPONDING #( keys ).

  ENDMETHOD.
**********************************************************************
* Get product Infromation
**********************************************************************
  METHOD Getproductinfor.
    DATA: ls_ztproducts TYPE ztproducts.

    READ ENTITIES OF zr_torders IN LOCAL MODE
         ENTITY OrderItems
         " FIELDS ( Productid )
            ALL FIELDS
            WITH CORRESPONDING #( keys )
        RESULT DATA(lt_orderitems).

    LOOP AT lt_orderitems ASSIGNING FIELD-SYMBOL(<fs_orderitems>).
      SELECT SINGLE
        FROM ztproducts
        FIELDS *
       WHERE Productid = @<fs_orderitems>-Productid
        INTO @ls_ztproducts.
      CHECK sy-subrc = 0.
      SELECT SINGLE
        FROM ztSuppliers
        FIELDS *
       WHERE Supplierid = @ls_ztproducts-Supplierid
        INTO @DATA(ls_Supplierid).

      <fs_orderitems> = VALUE #( BASE <fs_orderitems>
                                 Unit      = ls_ztproducts-basicUnit
                                 Sprice    = ls_ztproducts-price
                                 currency = ls_ztproducts-currencyCode
                                 Plantid   = ls_ztproducts-plantid
                                 Supplierid = ls_Supplierid-Supplierid
                                 Amount = ls_ztproducts-price * <fs_orderitems>-Quantity
                                 ) .

    ENDLOOP.


    MODIFY ENTITIES OF zr_torders IN LOCAL MODE
    ENTITY OrderItems
        "UPDATE SET FIELDS
          UPDATE FIELDS ( Unit Sprice Supplierid Amount Plantid currency )
        WITH CORRESPONDING #( lt_orderitems ).

  ENDMETHOD.

ENDCLASS.

"--------------------------------------------------------------------------------------------------------

CLASS lhc_zr_torders DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS:
      BEGIN OF order_status,
        open     TYPE c LENGTH 1 VALUE 'O', "Open
        accepted TYPE c LENGTH 1 VALUE 'A', "Accepted
        rejected TYPE c LENGTH 1 VALUE 'X', "Rejected
      END OF order_status.

    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR ZrTorders
        RESULT result,

      earlynumbering_create FOR NUMBERING
        IMPORTING entities FOR CREATE ZrTorders,

      earlynumbering_cba_Item  FOR NUMBERING
        IMPORTING entities FOR CREATE ZrTorders\_Items,

      setStatusToOpen FOR DETERMINE ON MODIFY
        IMPORTING keys FOR ZrTorders~setstatustoopen,

      order_submit FOR MODIFY
        IMPORTING keys FOR ACTION ZrTorders~order_submit RESULT result,

      order_approval_nd FOR MODIFY
        IMPORTING keys FOR ACTION ZrTorders~order_approval_nd RESULT result.

    METHODS order_approval_st FOR MODIFY
      IMPORTING keys FOR ACTION ZrTorders~order_approval_st RESULT result.

    METHODS order_complete FOR MODIFY
      IMPORTING keys FOR ACTION ZrTorders~order_complete RESULT result.

    METHODS order_reject FOR MODIFY
      IMPORTING keys FOR ACTION ZrTorders~order_reject RESULT result.

    METHODS order_reset FOR MODIFY
      IMPORTING keys FOR ACTION ZrTorders~order_reset RESULT result.

    " Get customer info and salesowner
    METHODS Getcustomer FOR DETERMINE ON MODIFY
      IMPORTING keys FOR ZrTorders~Getcustomer.
    METHODS validateOrderType FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZrTorders~validateOrderType.
    METHODS validateChannel FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZrTorders~validateChannel.

    METHODS validateCustomerid FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZrTorders~validateCustomerid.

    METHODS validateOrderDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZrTorders~validateOrderDate.

    METHODS validateOwnerid FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZrTorders~validateOwnerid.

    METHODS validateSalesorg FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZrTorders~validateSalesorg.
    METHODS validateDivision FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZrTorders~validateDivision.

ENDCLASS.

CLASS lhc_zr_torders IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.
    DATA:
      entity           TYPE STRUCTURE FOR CREATE zr_torders,
      orderid_max      TYPE ztorders-orderid,
      use_number_range TYPE abap_bool VALUE abap_false.

    LOOP AT entities INTO entity WHERE orderid IS NOT INITIAL.
      APPEND CORRESPONDING #( entity ) TO mapped-zrtorders.
    ENDLOOP.

    DATA(entities_wo_orderid) = entities.
    DELETE entities_wo_orderid WHERE orderid IS NOT INITIAL.
    IF use_number_range = abap_true.
      "Get numbers
      TRY.
          cl_numberrange_runtime=>number_get(
            EXPORTING
              nr_range_nr       = '01'
              object            = ''
              quantity          = CONV #( lines( entities_wo_orderid ) )
            IMPORTING
              number            = DATA(number_range_key)
              returncode        = DATA(number_range_return_code)
              returned_quantity = DATA(number_range_returned_quantity)
          ).
        CATCH cx_number_ranges INTO DATA(lx_number_ranges).
          LOOP AT entities_wo_orderid INTO entity.
            APPEND VALUE #(  %cid      = entity-%cid
                             %key      = entity-%key
                             %is_draft = entity-%is_draft
                             %msg      = lx_number_ranges
                          ) TO reported-zrtorders.
            APPEND VALUE #(  %cid      = entity-%cid
                             %key      = entity-%key
                             %is_draft = entity-%is_draft
                          ) TO failed-zrtorders.
          ENDLOOP.
          EXIT.
      ENDTRY.

      orderid_max = number_range_key - number_range_returned_quantity.
    ELSE.
      SELECT SINGLE FROM ztorders FIELDS MAX( orderid ) AS orderid INTO @orderid_max.
      SELECT SINGLE FROM ztorders_d FIELDS MAX( orderid ) INTO @DATA(max_orderid_draft).
      IF max_orderid_draft > orderid_max.
        orderid_max = max_orderid_draft.
      ENDIF.
    ENDIF.
    IF orderid_max IS INITIAL.
      orderid_max = '1000000000'.
    ENDIF.

    LOOP AT entities_wo_orderid INTO entity.
      orderid_max += 1.
      entity-Orderid = orderid_max.
      CONDENSE entity-Orderid NO-GAPS.

      APPEND VALUE #( %cid      = entity-%cid
                      %key      = entity-%key
                      %is_draft = entity-%is_draft
                    ) TO mapped-zrtorders.
    ENDLOOP.
  ENDMETHOD.

  METHOD earlynumbering_cba_item.
    DATA:
      "entity_item TYPE STRUCTURE FOR CREATE ZR_TORDERITEMS,
      orderid          TYPE ztorderitems-orderid,
      itemno_max       TYPE ztorderitems-itemno,
      use_number_range TYPE abap_bool VALUE abap_false.

    LOOP AT entities INTO DATA(entity_t) WHERE Orderid IS NOT INITIAL.
      orderid = entity_t-Orderid.
      " APPEND CORRESPONDING #( entity_t ) TO mapped-zrtorders.
      LOOP AT entity_t-%target INTO DATA(entity) WHERE itemno IS NOT INITIAL.
        APPEND CORRESPONDING #( entity ) TO mapped-orderitems.
      ENDLOOP.
    ENDLOOP.

    DATA(entities_wo_itemno) = entity_t-%target.
    DELETE entities_wo_itemno WHERE itemno IS NOT INITIAL.
    IF use_number_range = abap_true.
      "Get numbers
      TRY.
          cl_numberrange_runtime=>number_get(
          EXPORTING
          nr_range_nr = '01'
          object = ''
          quantity = CONV #( lines( entities_wo_itemno ) )
          IMPORTING
          number = DATA(number_range_key)
          returncode = DATA(number_range_return_code)
          returned_quantity = DATA(number_range_returned_quantity)
          ).
        CATCH cx_number_ranges INTO DATA(lx_number_ranges).
          LOOP AT entities_wo_itemno INTO entity.
            APPEND VALUE #( %cid = entity-%cid
            %key = entity-%key
            %is_draft = entity-%is_draft
            %msg = lx_number_ranges
            ) TO reported-orderitems.
            APPEND VALUE #( %cid = entity-%cid
            %key = entity-%key
            %is_draft = entity-%is_draft
            ) TO failed-orderitems.
          ENDLOOP.
          EXIT.
      ENDTRY.

      itemno_max = number_range_key - number_range_returned_quantity.
    ELSE.
      SELECT SINGLE FROM ztorderitems FIELDS MAX( itemno ) AS itemno WHERE orderid = @orderid INTO @itemno_max .
      SELECT SINGLE FROM ztorderitems_d FIELDS MAX( itemno ) WHERE orderid = @orderid
      AND ( draftentityoperationcode = 'U' OR draftentityoperationcode = 'C' OR draftentityoperationcode = 'N' )
      INTO @DATA(max_itemno_draft).
      IF max_itemno_draft > itemno_max.
        itemno_max = max_itemno_draft.
      ENDIF.
    ENDIF.
    IF itemno_max IS INITIAL.
      itemno_max = '00000'.
    ENDIF.

    LOOP AT entities_wo_itemno INTO entity.
      itemno_max += 1.
      entity-itemno = itemno_max.
      entity-Orderid = orderid.
      CONDENSE entity-itemno NO-GAPS.
      CONDENSE entity-Orderid NO-GAPS.

      APPEND VALUE #( %cid = entity-%cid
      %key = entity-%key
      %is_draft = entity-%is_draft
      ) TO mapped-orderitems.
    ENDLOOP.

  ENDMETHOD.

  METHOD setStatusToOpen.
    "Read travel instances of the transferred keys
    READ ENTITIES OF zr_torders IN LOCAL MODE
     ENTITY ZrTorders
       FIELDS ( Statuscode )
       WITH CORRESPONDING #( keys )
     RESULT DATA(orders)
     FAILED DATA(read_failed).

    "If overall travel status is already set, do nothing, i.e. remove such instances
    DELETE orders WHERE Statuscode IS NOT INITIAL.
    CHECK orders IS NOT INITIAL.

    "else set overall travel status to open ('O')
    MODIFY ENTITIES OF zr_torders IN LOCAL MODE
      ENTITY ZrTorders
        UPDATE SET FIELDS
        WITH VALUE #( FOR ZrTorders IN orders ( %tky    = ZrTorders-%tky
                                              Statuscode = order_status-open ) )
    REPORTED DATA(update_reported).

    "Set the changing parameter
    reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.

  METHOD order_submit.
    READ ENTITIES OF zr_torders IN LOCAL MODE
      ENTITY ZrTorders
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_order).

    READ TABLE keys INTO DATA(ls_keys) INDEX 1.

    LOOP AT lt_order ASSIGNING FIELD-SYMBOL(<fs_order>).
      <fs_order>-Statuscode = 'S'.
      <fs_order>-Remark     = ls_keys-%param.
    ENDLOOP.

    MODIFY ENTITIES OF zr_torders IN LOCAL MODE
     ENTITY ZrTorders
         UPDATE FIELDS ( Statuscode Remark )
          WITH CORRESPONDING #( lt_order ).

    result = VALUE #( FOR travel IN lt_order ( %tky   = travel-%tky
                                               %param = travel ) ).

  ENDMETHOD.

  METHOD order_approval_nd.
    READ ENTITIES OF zr_torders IN LOCAL MODE
      ENTITY ZrTorders
        ALL FIELDS
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_order).

    READ TABLE keys INTO DATA(ls_keys) INDEX 1.

    LOOP AT lt_order ASSIGNING FIELD-SYMBOL(<fs_order>).
      <fs_order>-Statuscode = 'A2'.
      <fs_order>-Remark     = ls_keys-%param.
    ENDLOOP.

    MODIFY ENTITIES OF zr_torders IN LOCAL MODE
     ENTITY ZrTorders
         UPDATE FIELDS ( Statuscode Remark )
          WITH CORRESPONDING #( lt_order ).

    result = VALUE #( FOR travel IN lt_order ( %tky   = travel-%tky
                                               %param = travel ) ).
  ENDMETHOD.

  METHOD order_approval_st.
    READ ENTITIES OF zr_torders IN LOCAL MODE
        ENTITY ZrTorders
          ALL FIELDS
          WITH CORRESPONDING #( keys )
        RESULT DATA(lt_order).

    READ TABLE keys INTO DATA(ls_keys) INDEX 1.

    LOOP AT lt_order ASSIGNING FIELD-SYMBOL(<fs_order>).
      <fs_order>-Statuscode = 'A1'.
      <fs_order>-Remark     = ls_keys-%param.
    ENDLOOP.

    MODIFY ENTITIES OF zr_torders IN LOCAL MODE
     ENTITY ZrTorders
         UPDATE FIELDS ( Statuscode Remark )
          WITH CORRESPONDING #( lt_order ).

    result = VALUE #( FOR travel IN lt_order ( %tky   = travel-%tky
                                               %param = travel ) ).
  ENDMETHOD.

  METHOD order_complete.
    READ ENTITIES OF zr_torders IN LOCAL MODE
          ENTITY ZrTorders
            ALL FIELDS
            WITH CORRESPONDING #( keys )
          RESULT DATA(lt_order).

    READ TABLE keys INTO DATA(ls_keys) INDEX 1.

    LOOP AT lt_order ASSIGNING FIELD-SYMBOL(<fs_order>).
      <fs_order>-Statuscode = 'C'.
      <fs_order>-Remark     = ls_keys-%param.
    ENDLOOP.

    MODIFY ENTITIES OF zr_torders IN LOCAL MODE
     ENTITY ZrTorders
         UPDATE FIELDS ( Statuscode Remark )
          WITH CORRESPONDING #( lt_order ).

    result = VALUE #( FOR travel IN lt_order ( %tky   = travel-%tky
                                               %param = travel ) ).
  ENDMETHOD.

  METHOD order_reject.
    READ ENTITIES OF zr_torders IN LOCAL MODE
          ENTITY ZrTorders
            ALL FIELDS
            WITH CORRESPONDING #( keys )
          RESULT DATA(lt_order).

    READ TABLE keys INTO DATA(ls_keys) INDEX 1.

    LOOP AT lt_order ASSIGNING FIELD-SYMBOL(<fs_order>).
      <fs_order>-Statuscode = 'R'.
      <fs_order>-Remark     = ls_keys-%param.
    ENDLOOP.

    MODIFY ENTITIES OF zr_torders IN LOCAL MODE
     ENTITY ZrTorders
         UPDATE FIELDS ( Statuscode Remark )
          WITH CORRESPONDING #( lt_order ).

    result = VALUE #( FOR travel IN lt_order ( %tky   = travel-%tky
                                               %param = travel ) ).
  ENDMETHOD.

  METHOD order_reset.
    READ ENTITIES OF zr_torders IN LOCAL MODE
          ENTITY ZrTorders
            ALL FIELDS
            WITH CORRESPONDING #( keys )
          RESULT DATA(lt_order).

    READ TABLE keys INTO DATA(ls_keys) INDEX 1.

    LOOP AT lt_order ASSIGNING FIELD-SYMBOL(<fs_order>).
      <fs_order>-Statuscode = 'O'.
      <fs_order>-Remark     = ls_keys-%param.
    ENDLOOP.

    MODIFY ENTITIES OF zr_torders IN LOCAL MODE
     ENTITY ZrTorders
         UPDATE FIELDS ( Statuscode Remark )
          WITH CORRESPONDING #( lt_order ).

    result = VALUE #( FOR travel IN lt_order ( %tky   = travel-%tky
                                               %param = travel ) ).
  ENDMETHOD.

  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  " Get customer info
  """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  METHOD Getcustomer.

    READ ENTITIES OF zr_torders IN LOCAL MODE
         ENTITY ZrTorders
            ALL FIELDS
            WITH CORRESPONDING #( keys )
        RESULT DATA(lt_order).

    LOOP AT lt_order ASSIGNING FIELD-SYMBOL(<fs_order>).

      " Customer type
      SELECT SINGLE
        FROM ztCustomers
        FIELDS Customertype
       WHERE Customerid = @<fs_order>-Customerid
        INTO @DATA(lv_Customertype).

      " SalesOwner type
      SELECT SINGLE
        FROM ztsalesowners
        FIELDS Ownertype
       WHERE Ownerid = @<fs_order>-Ownerid
        INTO @DATA(lv_Ownertype).


*      CHECK sy-subrc = 0.
      <fs_order> = VALUE #( BASE <fs_order>
                            Customertype     = lv_Customertype
                            Ownertype        = lv_Ownertype
                            ) .

    ENDLOOP.

    MODIFY ENTITIES OF zr_torders IN LOCAL MODE
    ENTITY ZrTorders
          UPDATE FIELDS ( Customertype Ownertype )
        WITH CORRESPONDING #( lt_order ).


  ENDMETHOD.

  METHOD validateOrderType.

    DATA lv_ordertype TYPE ztorders-ordertype.

    READ ENTITIES OF zr_torders IN LOCAL MODE
    ENTITY ZrTorders
     FIELDS ( Ordertype )
     WITH CORRESPONDING #( keys )
    RESULT DATA(zrtorders).

    LOOP AT zrtorders INTO DATA(zrtorder).

      lv_ordertype = zrtorder-Ordertype.

      APPEND VALUE #( %tky        = zrtorder-%tky
                      %state_area = 'VALIDATE_ORDERTYPE'
                    ) TO reported-zrtorders.

      IF lv_ordertype IS INITIAL.

        APPEND VALUE #( %tky = zrtorder-%tky ) TO failed-zrtorders.

        APPEND VALUE #( %tky               = zrtorder-%tky
                        %state_area        = 'VALIDATE_ORDERTYPE'
                        %msg               = NEW zcm_sales_order_msg(
                                                   textid   = zcm_sales_order_msg=>enter_ordertype
                                                   severity = if_abap_behv_message=>severity-error )
                        %element-Ordertype = if_abap_behv=>mk-on
                      ) TO reported-zrtorders.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateChannel.

    DATA lv_channel TYPE ztorders-channel.

    READ ENTITIES OF zr_torders IN LOCAL MODE
    ENTITY ZrTorders
     FIELDS ( Channel )
     WITH CORRESPONDING #( keys )
    RESULT DATA(zrtorders).

    LOOP AT zrtorders INTO DATA(zrtorder).

      lv_channel = zrtorder-Channel.

      APPEND VALUE #( %tky        = zrtorder-%tky
                      %state_area = 'VALIDATE_CHANNEL'
                    ) TO reported-zrtorders.

      IF lv_channel IS INITIAL.

        APPEND VALUE #( %tky = zrtorder-%tky ) TO failed-zrtorders.

        APPEND VALUE #( %tky             = zrtorder-%tky
                        %state_area      = 'VALIDATE_CHANNEL'
                        %msg             = NEW zcm_sales_order_msg(
                                                   textid   = zcm_sales_order_msg=>enter_channel
                                                   severity = if_abap_behv_message=>severity-error )
                        %element-Channel = if_abap_behv=>mk-on
                      ) TO reported-zrtorders.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateCustomerid.

    DATA lv_customerid TYPE ztorders-customerid.

    READ ENTITIES OF zr_torders IN LOCAL MODE
    ENTITY ZrTorders
     FIELDS ( Customerid )
     WITH CORRESPONDING #( keys )
    RESULT DATA(zrtorders).

    LOOP AT zrtorders INTO DATA(zrtorder).
      lv_customerid = zrtorder-Customerid.

      APPEND VALUE #( %tky        = zrtorder-%tky
                      %state_area = 'VALIDATE_CUSTOMERID'
                    ) TO reported-zrtorders.

      IF lv_customerid IS INITIAL.

        APPEND VALUE #( %tky = zrtorder-%tky ) TO failed-zrtorders.

        APPEND VALUE #( %tky                = zrtorder-%tky
                        %state_area         = 'VALIDATE_CUSTOMERID'
                        %msg                = NEW zcm_sales_order_msg(
                                                   textid   = zcm_sales_order_msg=>enter_customer
                                                   severity = if_abap_behv_message=>severity-error )
                        %element-Customerid = if_abap_behv=>mk-on
                      ) TO reported-zrtorders.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateOrderDate.

    DATA lv_orderdate TYPE ztorders-orderdate.

    READ ENTITIES OF zr_torders IN LOCAL MODE
    ENTITY ZrTorders
     FIELDS ( Orderdate )
     WITH CORRESPONDING #( keys )
    RESULT DATA(zrtorders).

    LOOP AT zrtorders INTO DATA(zrtorder).

      lv_orderdate = zrtorder-Orderdate.

      APPEND VALUE #( %tky        = zrtorder-%tky
                      %state_area = 'VALIDATE_ORDERDATE'
                    ) TO reported-zrtorders.

      IF lv_orderdate IS INITIAL.

        APPEND VALUE #( %tky = zrtorder-%tky ) TO failed-zrtorders.

        APPEND VALUE #( %tky               = zrtorder-%tky
                        %state_area        = 'VALIDATE_ORDERDATE'
                        %msg               = NEW zcm_sales_order_msg(
                                                   textid   = zcm_sales_order_msg=>enter_orderdate
                                                   severity = if_abap_behv_message=>severity-error )
                        %element-Orderdate = if_abap_behv=>mk-on
                      ) TO reported-zrtorders.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateOwnerid.

    DATA lv_ownerid TYPE ztorders-ownerid.

    READ ENTITIES OF zr_torders IN LOCAL MODE
    ENTITY ZrTorders
     FIELDS ( Ownerid )
     WITH CORRESPONDING #( keys )
    RESULT DATA(zrtorders).

    LOOP AT zrtorders INTO DATA(zrtorder).
      lv_ownerid = zrtorder-Ownerid.

      APPEND VALUE #( %tky        = zrtorder-%tky
                      %state_area = 'VALIDATE_OWNERID'
                    ) TO reported-zrtorders.

      IF lv_ownerid IS INITIAL.

        APPEND VALUE #( %tky = zrtorder-%tky ) TO failed-zrtorders.

        APPEND VALUE #( %tky             = zrtorder-%tky
                        %state_area      = 'VALIDATE_OWNERID'
                        %msg             = NEW zcm_sales_order_msg(
                                                   textid   = zcm_sales_order_msg=>enter_owner
                                                   severity = if_abap_behv_message=>severity-error )
                        %element-Ownerid = if_abap_behv=>mk-on
                      ) TO reported-zrtorders.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateSalesorg.

    DATA lv_salesorg TYPE ztorders-salesorg.

    READ ENTITIES OF zr_torders IN LOCAL MODE
    ENTITY ZrTorders
     FIELDS ( Salesorg )
     WITH CORRESPONDING #( keys )
    RESULT DATA(zrtorders).

    LOOP AT zrtorders INTO DATA(zrtorder).

      lv_salesorg = zrtorder-Salesorg.

      APPEND VALUE #( %tky        = zrtorder-%tky
                      %state_area = 'VALIDATE_SALESORG'
                    ) TO reported-zrtorders.


      IF lv_salesorg IS INITIAL.

        APPEND VALUE #( %tky = zrtorder-%tky ) TO failed-zrtorders.

        APPEND VALUE #( %tky              = zrtorder-%tky
                        %state_area       = 'VALIDATE_SALESORG'
                        %msg              = NEW zcm_sales_order_msg(
                                                   textid   = zcm_sales_order_msg=>enter_salesorg
                                                   severity = if_abap_behv_message=>severity-error )
                        %element-Salesorg = if_abap_behv=>mk-on
                      ) TO reported-zrtorders.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateDivision.

    DATA lv_division TYPE ztorders-division.

    READ ENTITIES OF zr_torders IN LOCAL MODE
    ENTITY ZrTorders
     FIELDS ( Division )
     WITH CORRESPONDING #( keys )
    RESULT DATA(zrtorders).

    LOOP AT zrtorders INTO DATA(zrtorder).

      lv_division = zrtorder-Division.

      APPEND VALUE #( %tky        = zrtorder-%tky
                      %state_area = 'VALIDATE_DIVISION'
                    ) TO reported-zrtorders.


      IF lv_division IS INITIAL.

        APPEND VALUE #( %tky = zrtorder-%tky ) TO failed-zrtorders.

        APPEND VALUE #( %tky              = zrtorder-%tky
                        %state_area       = 'VALIDATE_DIVISION'
                        %msg              = NEW zcm_sales_order_msg(
                                                   textid   = zcm_sales_order_msg=>enter_division
                                                   severity = if_abap_behv_message=>severity-error )
                        %element-Division = if_abap_behv=>mk-on
                      ) TO reported-zrtorders.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
