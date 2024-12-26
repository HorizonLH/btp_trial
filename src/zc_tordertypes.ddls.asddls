@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
define root view entity ZC_TORDERTYPES
  provider contract transactional_query
  as projection on ZR_TORDERTYPES
{
      @Search.fuzzinessThreshold: 0.90
      @Search.defaultSearchElement: true //搜索帮助
      //      @Consumption.valueHelpDefinition: [{ entity : {name: 'I_or', element: 'Country' }, useForValidation: true }]
  key Ordertype,
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZR_TORDERTYPES_LIST', element: 'Description' }, useForValidation: true }]
      Description,
      Createdby,
      Createdat,
      Locallastchangedby,
      Locallastchangedat,
      Lastchangedat

}
