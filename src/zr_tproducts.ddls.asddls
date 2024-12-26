@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Products App'
define root view entity ZR_TPRODUCTS
  as select from ztproducts as Products
  association [0..1] to ZR_TSUPPLIERS_LIST as _suppliers on $projection.Supplierid = _suppliers.Supplierid
  association [0..1] to ZR_TPLANTS_LIST    as _plants    on $projection.Plantid = _plants.Plant
{
  key productid          as Productid,
      productname        as Productname,
      @Semantics.quantity.unitOfMeasure: 'Weightunit'
      netweight          as Netweight,
      @Semantics.quantity.unitOfMeasure: 'Weightunit'
      grossweight        as Grossweight,
      @Semantics.amount.currencyCode: 'Currencycode'
      price              as Price,
      @Consumption.valueHelpDefinition: [ {
        entity.name: 'ZR_TCURRENCY_LIST',
        entity.element: 'Currency',
        useForValidation: true
      } ]
      currencycode       as Currencycode,
      @Consumption.valueHelpDefinition: [ {
        entity.name: 'ZR_TUNITS_LIST',
        entity.element: 'Unit',
        useForValidation: true
      } ]
      basicunit          as Basicunit,
      @Consumption.valueHelpDefinition: [ {
        entity.name: 'ZR_TUNITS_LIST',
        entity.element: 'Unit',
        useForValidation: true
      } ]
      salesunit          as Salesunit,
      @Consumption.valueHelpDefinition: [ {
        entity.name: 'ZR_TUNITS_LIST',
        entity.element: 'Unit',
        useForValidation: true
      } ]
      weightunit         as Weightunit,
      remark             as Remark,
      supplierid         as Supplierid,
      plantid            as Plantid,
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

      _suppliers,
      _plants

}
