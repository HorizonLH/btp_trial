CLASS zcl_initdata_lbz DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_initdata_lbz IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA:
      ls_salesorg  TYPE ztsalesorgs,
      lt_salesorgs TYPE STANDARD TABLE OF ztsalesorgs,
      ls_channel   TYPE ztsaleschannels,
      lt_channels  TYPE STANDARD TABLE OF ztsaleschannels.

    DELETE FROM ztsalesorgs.
    DELETE FROM ztsaleschannels.

    CLEAR: lt_salesorgs, lt_channels.

    " Table ztsalesorgs
    CLEAR ls_salesorg.
    ls_salesorg-salesorg = 'H100'.
    ls_salesorg-description = 'South China Sales Region'.
    APPEND ls_salesorg TO lt_salesorgs.

    CLEAR ls_salesorg.
    ls_salesorg-salesorg = 'H200'.
    ls_salesorg-description = 'North China Sales Region'.
    APPEND ls_salesorg TO lt_salesorgs.

    CLEAR ls_salesorg.
    ls_salesorg-salesorg = 'H300'.
    ls_salesorg-description = 'Central China Sales Region'.
    APPEND ls_salesorg TO lt_salesorgs.

    CLEAR ls_salesorg.
    ls_salesorg-salesorg = 'H400'.
    ls_salesorg-description = 'East China Sales Region'.
    APPEND ls_salesorg TO lt_salesorgs.

    CLEAR ls_salesorg.
    ls_salesorg-salesorg = 'H500'.
    ls_salesorg-description = 'Northwest China Sales Region'.
    APPEND ls_salesorg TO lt_salesorgs.

    CLEAR ls_salesorg.
    ls_salesorg-salesorg = 'H600'.
    ls_salesorg-description = 'Northeast China Sales Region'.
    APPEND ls_salesorg TO lt_salesorgs.

    CLEAR ls_salesorg.
    ls_salesorg-salesorg = 'H700'.
    ls_salesorg-description = 'Southwest China Sales Region'.
    APPEND ls_salesorg TO lt_salesorgs.

    " Table ztsaleschannels
    CLEAR ls_channel.
    ls_channel-channel = '10'.
    ls_channel-description = 'Domestic B2C'.
    APPEND ls_channel TO lt_channels.

    CLEAR ls_channel.
    ls_channel-channel = '11'.
    ls_channel-description = 'Domestic B2B'.
    APPEND ls_channel TO lt_channels.

    CLEAR ls_channel.
    ls_channel-channel = '20'.
    ls_channel-description = 'Export B2C'.
    APPEND ls_channel TO lt_channels.

    CLEAR ls_channel.
    ls_channel-channel = '21'.
    ls_channel-description = 'Export B2B'.
    APPEND ls_channel TO lt_channels.

    CLEAR ls_channel.
    ls_channel-channel = '30'.
    ls_channel-description = 'Online Domestic B2C'.
    APPEND ls_channel TO lt_channels.

    CLEAR ls_channel.
    ls_channel-channel = '31'.
    ls_channel-description = 'Online Domestic B2B'.
    APPEND ls_channel TO lt_channels.

    CLEAR ls_channel.
    ls_channel-channel = '40'.
    ls_channel-description = 'Online Export B2C'.
    APPEND ls_channel TO lt_channels.

    CLEAR ls_channel.
    ls_channel-channel = '41'.
    ls_channel-description = 'Online Export B2B'.
    APPEND ls_channel TO lt_channels.

    CLEAR ls_channel.
    ls_channel-channel = '50'.
    ls_channel-description = 'Domestic'.
    APPEND ls_channel TO lt_channels.

    CLEAR ls_channel.
    ls_channel-channel = '51'.
    ls_channel-description = 'Export'.
    APPEND ls_channel TO lt_channels.

    INSERT ztsalesorgs  FROM TABLE @lt_salesorgs.
    INSERT ztsaleschannels  FROM TABLE @lt_channels.

    COMMIT WORK.

    out->write( |Table [ ztsalesorgs , ztsaleschannels ] data initialization successful!| ).
  ENDMETHOD.
ENDCLASS.
