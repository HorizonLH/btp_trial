@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
define root view entity ZC_TCOUNTRIES
  provider contract transactional_query
  as projection on ZR_TCOUNTRIES
{    
      @Search.fuzzinessThreshold: 0.90
      @Search.defaultSearchElement: true   //搜索帮助
      @Consumption.valueHelpDefinition: [{ entity : {name: 'I_CountryVH', element: 'Country' }, useForValidation: true }]
  key Country,
      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZR_TCOUNTRIES_LIST', element: 'Descripton' }, useForValidation: true }]
      Descripton,
      Createdby,
      Createdat,
      Locallastchangedby,
      Locallastchangedat,
      Lastchangedat

}
