CLASS zcl_insert_data_wy DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_insert_data_wy IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    DATA: lt_ztdivisions TYPE TABLE OF ztdivisions.
    DATA: ls_ztdivisions TYPE  ztdivisions.

    DELETE FROM ztdivisions.

    CLEAR: ls_ztdivisions.
    ls_ztdivisions-division = '00'.
    ls_ztdivisions-description = 'General'.
    APPEND ls_ztdivisions TO lt_ztdivisions.

    CLEAR: ls_ztdivisions.
    ls_ztdivisions-division = '10'.
    ls_ztdivisions-description = 'Printer'.
    APPEND ls_ztdivisions TO lt_ztdivisions.

    CLEAR: ls_ztdivisions.
    ls_ztdivisions-division = '20'.
    ls_ztdivisions-description = 'Computer'.
    APPEND ls_ztdivisions TO lt_ztdivisions.

    CLEAR: ls_ztdivisions.
    ls_ztdivisions-division = '30'.
    ls_ztdivisions-description = 'Server'.
    APPEND ls_ztdivisions TO lt_ztdivisions.

    CLEAR: ls_ztdivisions.
    ls_ztdivisions-division = '40'.
    ls_ztdivisions-description = 'Smart Phone'.
    APPEND ls_ztdivisions TO lt_ztdivisions.

    CLEAR: ls_ztdivisions.
    ls_ztdivisions-division = '50'.
    ls_ztdivisions-description = 'Software' .
    APPEND ls_ztdivisions TO lt_ztdivisions.


    ls_ztdivisions-createdby = sy-uname.
    ls_ztdivisions-createdat = sy-datum.
    MODIFY lt_ztdivisions FROM ls_ztdivisions TRANSPORTING createdby createdat WHERE createdat IS INITIAL.


    INSERT ztdivisions FROM TABLE @lt_ztdivisions.



    DATA: lt_ztownertypes TYPE TABLE OF ztownertypes.
    DATA: ls_ztownertypes TYPE  ztownertypes.

    DELETE FROM ztownertypes.

    CLEAR: ls_ztownertypes.
    ls_ztownertypes-ownertype = 'SM'.
    ls_ztownertypes-rolename = 'Sales Manager'.
    APPEND ls_ztownertypes TO lt_ztownertypes.

    CLEAR: ls_ztownertypes.
    ls_ztownertypes-ownertype = 'SO'.
    ls_ztownertypes-rolename = 'Sales Owner'.
    APPEND ls_ztownertypes TO lt_ztownertypes.

    CLEAR: ls_ztownertypes.
    ls_ztownertypes-ownertype = 'SS'.
    ls_ztownertypes-rolename = 'Sales Supervisor'.
    APPEND ls_ztownertypes TO lt_ztownertypes.

    ls_ztownertypes-createdby = sy-uname.
    ls_ztownertypes-createdat = sy-datum.
    MODIFY lt_ztownertypes FROM ls_ztownertypes TRANSPORTING createdby createdat WHERE createdat IS INITIAL.

    INSERT ztownertypes FROM TABLE @lt_ztownertypes.

    COMMIT WORK.

  ENDMETHOD.
ENDCLASS.
