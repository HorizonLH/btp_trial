@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
define root view entity ZC_TCURRENCIES
  provider contract transactional_query
  as projection on ZR_TCURRENCIES
{
      @Search.fuzzinessThreshold: 0.90
      @Search.defaultSearchElement: true   //搜索帮助
      @Consumption.valueHelpDefinition: [{ entity : {name: 'I_CurrencyStdVH', element: 'Currency' }, useForValidation: true }]
  key Currency,
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZR_TCURRENCY_LIST', element: 'Description' }, useForValidation: true }]
      Description,
      Createdby,
      Createdat,
      Locallastchangedby,
      Locallastchangedat,
      Lastchangedat

}
