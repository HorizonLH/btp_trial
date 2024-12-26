@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
define root view entity ZC_TOWNERTYPES
  provider contract transactional_query
  as projection on ZR_TOWNERTYPES
{
      @Search.fuzzinessThreshold: 0.90
      @Search.defaultSearchElement: true //搜索帮助
  key Ownertype,
      //      @Consumption.valueHelpDefinition: [{ entity : {name: 'ZR_TOWNERTYPES_LIST', element: 'Rolename' }, useForValidation: true }]
      Rolename,
      Createdby,
      Createdat,
      Locallastchangedby,
      Locallastchangedat,
      Lastchangedat

}
