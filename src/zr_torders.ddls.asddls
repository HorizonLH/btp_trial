@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
//@Aggregation.allowPrecisionLoss: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_TORDERS
  as select from ztorders as Orders

  association [0..1] to ZR_TSTATUS_SO_LIST     as _Status     on $projection.Statuscode = _Status.Status
  association [0..1] to ZR_TCUSTOMERS_VH       as _Customer   on $projection.Customerid = _Customer.Customerid
  association [0..1] to ZR_TSALESOWNERS_VH     as _Owner      on $projection.Ownerid = _Owner.Ownerid
  association [0..1] to ZR_TORDERTYPES_LIST    as _Ordertype  on $projection.Ordertype = _Ordertype.Ordertype
  association [0..1] to ZR_TSALESORGS_LIST     as _Salesorg   on $projection.Salesorg = _Salesorg.Salesorg
  association [0..1] to ZR_TDIVISIONS_LIST     as _Division   on $projection.Division = _Division.Division
  association [0..1] to ZR_TSALESCHANNELS_LIST as _Channel    on $projection.Channel = _Channel.Channel
  association [0..1] to ZR_TCUSTOMERTPS_LIST   as _Customertp on $projection.Customertype = _Customertp.Customertype
  association [0..1] to ZR_TOWNERTYPES_LIST    as _Ownertype  on $projection.Ownertype = _Ownertype.Ownertype
  composition [0..*] of ZR_TORDERITEMS         as _Items

{
  key orderid            as Orderid,
      orderdate          as Orderdate,
      @UI.textArrangement: #TEXT_SEPARATE
      @Consumption.valueHelpDefinition: [ {
        entity.name: 'ZR_TSALESORGS_LIST',
        entity.element: 'Salesorg',
        useForValidation: true
      } ]
      salesorg           as Salesorg,
      @UI.textArrangement: #TEXT_SEPARATE
      @Consumption.valueHelpDefinition: [ {
        entity.name: 'ZR_TSALESCHANNELS_LIST',
        entity.element: 'Channel',
        useForValidation: true
      } ]
      channel            as Channel,
      @UI.textArrangement: #TEXT_SEPARATE
      @Consumption.valueHelpDefinition: [ {
        entity.name: 'ZR_TDIVISIONS_LIST',
        entity.element: 'Division',
        useForValidation: true
      } ]
      division           as Division,
      @UI.textArrangement: #TEXT_SEPARATE
      @Consumption.valueHelpDefinition: [ {
        entity.name: 'ZR_TORDERTYPES_LIST',
        entity.element: 'Ordertype',
        useForValidation: true
      } ]
      ordertype          as Ordertype,
      typedesc           as Typedesc,
      @Semantics.amount.currencyCode: 'Currency'
      totalamount        as Totalamount,
      @UI.textArrangement: #TEXT_SEPARATE
      @Consumption.valueHelpDefinition: [ {
        entity.name: 'ZR_TCURRENCY_LIST',
        entity.element: 'Currency',
        useForValidation: true
      } ]
      currency           as Currency,
      remark             as Remark,
      case statuscode
      when 'R'  then 1
      when 'S'  then 2
      when 'A1' then 2
      when 'A2' then 2
      when 'C'  then 3
      else 0
      end                as Criticality,
      @Consumption.valueHelpDefinition: [ {
        entity.name: 'ZR_TSTATUS_SO_LIST',
        entity.element: 'Status',
        useForValidation: true
      } ]
      statuscode         as Statuscode,
      @Consumption.valueHelpDefinition: [ {
        entity.name: 'ZR_TCUSTOMERS_VH',
        entity.element: 'Customerid',
        useForValidation: true
      } ]
      customerid         as Customerid,
      @UI.textArrangement: #TEXT_ONLY
      @Consumption.valueHelpDefinition: [ {
        entity.name: 'ZR_TCUSTOMERTPS_LIST',
        entity.element: 'Customertype',
        useForValidation: true
      } ]
      customertype       as Customertype,
      @Consumption.valueHelpDefinition: [ {
        entity.name: 'ZR_TSALESOWNERS_VH',
        entity.element: 'Ownerid',
        useForValidation: true
      } ]
      ownerid            as Ownerid,
      @UI.textArrangement: #TEXT_ONLY
      @Consumption.valueHelpDefinition: [ {
        entity.name: 'ZR_TOWNERTYPES_LIST',
        entity.element: 'Ownertype',
        useForValidation: true
      } ]
      ownertype          as Ownertype,
      @Semantics.user.createdBy: true
      createdby          as Createdby,
      @Semantics.systemDateTime.createdAt: true
      createdat          as Createdat,
      @Semantics.user.localInstanceLastChangedBy: true
      locallastchangedby as Locallastchangedby,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      locallastchangedat as Locallastchangedat,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat      as Lastchangedat,

      //public associations
      _Status,
      _Customer,
      _Owner,
      _Items,
      _Salesorg,
      _Ordertype,
      _Division,
      _Customertp,
      _Ownertype,
      _Channel     
}

 