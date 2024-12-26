@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
define view entity ZR_TORDERITEMS
  as select from ztorderitems as OrderItems

  association [0..1] to ZR_TPRODUCTS_VH    as _Products   on $projection.Productid = _Products.Productid
  association [0..1] to ZR_TSUPPLIERS_LIST as _Suppliers  on $projection.Supplierid = _Suppliers.Supplierid
  association [0..1] to ZR_TPLANTS_LIST    as _Plants     on $projection.Plantid = _Plants.Plant
  association [0..1] to ztcurrencies       as _Currencies on $projection.Currency = _Currencies.currency
  association [0..1] to ztunits            as _Units      on $projection.Unit = _Units.unit
  association        to parent ZR_TORDERS  as _Order      on $projection.Orderid = _Order.Orderid

{
  key orderid            as Orderid,
  key itemno             as Itemno,
      @UI.textArrangement: #TEXT_SEPARATE
      @Consumption.valueHelpDefinition: [ {
            entity.name: 'ZR_TPLANTS_LIST',
            entity.element: 'Plant',
            useForValidation: true
          } ]
      plantid            as Plantid,
      @Semantics.quantity.unitOfMeasure: 'Unit'
      quantity           as Quantity,
      @Semantics.amount.currencyCode: 'Currency'
      sprice             as Sprice,
      @Semantics.amount.currencyCode: 'Currency'
      amount             as Amount,
      @Consumption.valueHelpDefinition: [ {
        entity.name: 'ZR_TCURRENCY_LIST',
        entity.element: 'Currency',
        useForValidation: true
      } ]
      currency           as Currency,
      
      itemtext           as Itemtext,
      @Consumption.valueHelpDefinition: [ {
        entity.name: 'ZR_TUNITS_LIST',
        entity.element: 'Unit',
        useForValidation: true
      } ]
      unit               as Unit,
      criticality        as Criticality,
      @UI.textArrangement: #TEXT_SEPARATE
      @Consumption.valueHelpDefinition: [ {
            entity.name: 'ZR_TPRODUCTS_VH',
            entity.element: 'Productid',
            useForValidation: true
          } ]
      productid          as Productid,
      supplierid         as Supplierid,
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
      _Products,
      _Suppliers,
      _Plants,
      _Currencies,
      _Units,
      _Order

} 
