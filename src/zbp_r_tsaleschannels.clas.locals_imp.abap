CLASS LHC_ZR_TSALESCHANNELS DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR SalesChannels
        RESULT result.
ENDCLASS.

CLASS LHC_ZR_TSALESCHANNELS IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.
ENDCLASS.
