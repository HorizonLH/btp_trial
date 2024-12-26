@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Products App'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
@ObjectModel.semanticKey: [ 'Productid' ]
define root view entity ZC_TPRODUCTS
  provider contract transactional_query
  as projection on ZR_TPRODUCTS
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
  key Productid,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      Productname,
      Netweight,
      Grossweight,
      Price,
      @Semantics.currencyCode: true
      Currencycode,
      @Semantics.unitOfMeasure: true
      Basicunit,
      @Semantics.unitOfMeasure: true
      Salesunit,
      @Semantics.unitOfMeasure: true
      Weightunit,
      Remark,

      @ObjectModel.text.element: [ 'SupplierName' ]
      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZR_TSUPPLIERS_LIST', element: 'Supplierid' }, useForValidation: true }]
      Supplierid,
      _suppliers.Suppliername as SupplierName,
      
      @ObjectModel.text.element: [ 'PlantName' ]
      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZR_TPLANTS_LIST', element: 'Plant' }, useForValidation: true }]
      Plantid,
      _plants.Description     as PlantName,

      Createdby,
      Createdat,
      Locallastchangedby,
      Locallastchangedat,
      Lastchangedat

}
