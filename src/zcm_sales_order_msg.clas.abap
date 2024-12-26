CLASS zcm_sales_order_msg DEFINITION
  PUBLIC
    INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_dyn_msg .
    INTERFACES if_t100_message .
    INTERFACES if_abap_behv_message .

    CONSTANTS:
      gc_msgid TYPE symsgid VALUE 'ZCM_SALES_ORDER',

      BEGIN OF enter_suppliername,
        msgid TYPE symsgid VALUE 'ZCM_SALES_ORDER',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'MV_SUPPLIERNAME',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_suppliername,

      BEGIN OF enter_suppliertype,
        msgid TYPE symsgid VALUE 'ZCM_SALES_ORDER',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'MV_SUPPLIERTYPE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_suppliertype,

      BEGIN OF enter_email_null,
        msgid TYPE symsgid VALUE 'ZCM_SALES_ORDER',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'MV_EMAIL',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_email_null,

      BEGIN OF enter_email,
        msgid TYPE symsgid VALUE 'ZCM_SALES_ORDER',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE 'MV_EMAIL',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_email,

      BEGIN OF enter_phone_null,
        msgid TYPE symsgid VALUE 'ZCM_SALES_ORDER',
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE 'MV_PHONE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_phone_null,

      BEGIN OF enter_phone,
        msgid TYPE symsgid VALUE 'ZCM_SALES_ORDER',
        msgno TYPE symsgno VALUE '006',
        attr1 TYPE scx_attrname VALUE 'MV_PHONE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_phone,

      BEGIN OF enter_country,
        msgid TYPE symsgid VALUE 'ZCM_SALES_ORDER',
        msgno TYPE symsgno VALUE '007',
        attr1 TYPE scx_attrname VALUE 'MV_COUNTRY',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_country,

      BEGIN OF enter_customername,
        msgid TYPE symsgid VALUE 'ZCM_SALES_ORDER',
        msgno TYPE symsgno VALUE '008',
        attr1 TYPE scx_attrname VALUE 'MV_CUSTOMERNAME',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_customername,

      BEGIN OF enter_customertype,
        msgid TYPE symsgid VALUE 'ZCM_SALES_ORDER',
        msgno TYPE symsgno VALUE '009',
        attr1 TYPE scx_attrname VALUE 'MV_CUSTOMERTYPE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_customertype,

      BEGIN OF enter_ownername,
        msgid TYPE symsgid VALUE 'ZCM_SALES_ORDER',
        msgno TYPE symsgno VALUE '010',
        attr1 TYPE scx_attrname VALUE 'MV_OWNERNAME',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_ownername,

      BEGIN OF enter_ownertype,
        msgid TYPE symsgid VALUE 'ZCM_SALES_ORDER',
        msgno TYPE symsgno VALUE '011',
        attr1 TYPE scx_attrname VALUE 'MV_OWNERTYPE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_ownertype,

      BEGIN OF enter_productname,
        msgid TYPE symsgid VALUE 'ZCM_SALES_ORDER',
        msgno TYPE symsgno VALUE '012',
        attr1 TYPE scx_attrname VALUE 'MV_PRODUCTNAME',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_productname,

      BEGIN OF enter_plant,
        msgid TYPE symsgid VALUE 'ZCM_SALES_ORDER',
        msgno TYPE symsgno VALUE '013',
        attr1 TYPE scx_attrname VALUE 'MV_PLANT',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_plant,

      BEGIN OF enter_supplier,
        msgid TYPE symsgid VALUE 'ZCM_SALES_ORDER',
        msgno TYPE symsgno VALUE '014',
        attr1 TYPE scx_attrname VALUE 'MV_SUPPLIER',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_supplier,

      BEGIN OF enter_Currency,
        msgid TYPE symsgid VALUE 'ZCM_SALES_ORDER',
        msgno TYPE symsgno VALUE '015',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_Currency,

      BEGIN OF enter_ordertype,
        msgid TYPE symsgid VALUE 'ZCM_SALES_ORDER',
        msgno TYPE symsgno VALUE '016',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_ordertype,

      BEGIN OF enter_orderdate,
        msgid TYPE symsgid VALUE 'ZCM_SALES_ORDER',
        msgno TYPE symsgno VALUE '017',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_orderdate,

      BEGIN OF enter_salesorg,
        msgid TYPE symsgid VALUE 'ZCM_SALES_ORDER',
        msgno TYPE symsgno VALUE '018',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_salesorg,

      BEGIN OF enter_channel,
        msgid TYPE symsgid VALUE 'ZCM_SALES_ORDER',
        msgno TYPE symsgno VALUE '019',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_channel,

      BEGIN OF enter_customer,
        msgid TYPE symsgid VALUE 'ZCM_SALES_ORDER',
        msgno TYPE symsgno VALUE '020',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_customer,

      BEGIN OF enter_owner,
        msgid TYPE symsgid VALUE 'ZCM_SALES_ORDER',
        msgno TYPE symsgno VALUE '021',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_owner,

      BEGIN OF enter_division,
        msgid TYPE symsgid VALUE 'ZCM_SALES_ORDER',
        msgno TYPE symsgno VALUE '022',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_division.

    METHODS constructor
      IMPORTING
        textid       LIKE if_t100_message=>t100key OPTIONAL
        attr1        TYPE string OPTIONAL
        attr2        TYPE string OPTIONAL
        attr3        TYPE string OPTIONAL
        attr4        TYPE string OPTIONAL
        previous     LIKE previous OPTIONAL
        suppliername TYPE ztsuppliers-suppliername OPTIONAL
        suppliertype TYPE ztsuppliers-suppliertype OPTIONAL
        email        TYPE ztsuppliers-email OPTIONAL
        phone        TYPE ztsuppliers-phone OPTIONAL
        country      TYPE ztsuppliers-country OPTIONAL
        customername TYPE ztcustomers-customername OPTIONAL
        customertype TYPE ztcustomers-customertype OPTIONAL
        ownername    TYPE ztsalesowners-ownername OPTIONAL
        ownertype    TYPE ztsalesowners-ownertype OPTIONAL
        productname  TYPE ztproducts-productname OPTIONAL
        plantid      TYPE ztproducts-plantid OPTIONAL
        supplierid   TYPE ztproducts-supplierid OPTIONAL
        ordertype    TYPE ztorders-ordertype OPTIONAL
        orderdate    TYPE ztorders-orderdate OPTIONAL
        salesorg     TYPE ztorders-salesorg OPTIONAL
        channel      TYPE ztorders-channel OPTIONAL
        customerid   TYPE ztorders-customerid OPTIONAL
        ownerid      TYPE ztorders-ownerid OPTIONAL
        division     TYPE ztorders-division OPTIONAL
        severity     TYPE if_abap_behv_message=>t_severity OPTIONAL
        uname        TYPE syuname OPTIONAL.

    DATA:
      mv_attr1        TYPE string,
      mv_attr2        TYPE string,
      mv_attr3        TYPE string,
      mv_attr4        TYPE string,
      mv_suppliername TYPE ztsuppliers-suppliername,
      mv_suppliertype TYPE ztsuppliers-suppliertype,
      mv_email        TYPE ztsuppliers-email,
      mv_phone        TYPE ztsuppliers-phone,
      mv_country      TYPE ztsuppliers-country,
      mv_customername TYPE ztcustomers-customername,
      mv_customertype TYPE ztcustomers-customertype,
      mv_ownername    TYPE ztsalesowners-ownername,
      mv_ownertype    TYPE ztsalesowners-ownertype,
      mv_productname  TYPE ztproducts-productname,
      mv_plantid      TYPE ztproducts-plantid,
      mv_supplierid   TYPE ztproducts-supplierid,
      mv_ordertype    TYPE ztorders-ordertype,
      mv_orderdate    TYPE ztorders-orderdate,
      mv_salesorg     TYPE ztorders-salesorg,
      mv_channel      TYPE ztorders-channel,
      mv_customerid   TYPE ztorders-customerid,
      mv_ownerid      TYPE ztorders-ownerid,
      mv_division     TYPE ztorders-division,
      mv_uname        TYPE syuname.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcm_sales_order_msg IMPLEMENTATION.

  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor(  previous = previous ) .

    me->mv_attr1        = attr1.
    me->mv_attr2        = attr2.
    me->mv_attr3        = attr3.
    me->mv_attr4        = attr4.
    me->mv_suppliername = suppliername.
    me->mv_suppliertype = suppliertype.
    me->mv_email        = email.
    me->mv_phone        = phone.
    me->mv_country      = country.
    me->mv_customername = customername.
    me->mv_customertype = customertype.
    me->mv_ownername    = ownername.
    me->mv_ownertype    = ownertype.
    me->mv_productname  = productname.
    me->mv_plantid      = plantid.
    me->mv_supplierid   = supplierid.
    me->mv_ordertype    = ordertype.
    me->mv_orderdate    = orderdate.
    me->mv_salesorg     = salesorg.
    me->mv_channel      = channel.
    me->mv_customerid   = customerid.
    me->mv_ownerid      = ownerid.
    me->mv_division      = division.

    if_abap_behv_message~m_severity = severity.

    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
