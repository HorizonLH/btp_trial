@AccessControl.authorizationCheck: #CHECK

@EndUserText.label: '###GENERATED Core Data Service Entity'

@Metadata.allowExtensions: true

@Search.searchable: true

define root view entity ZC_TSUPPLIERTYPES
  provider contract transactional_query
  as projection on ZR_TSUPPLIERTYPES

{
      @Search.fuzzinessThreshold: 0.90
      @Search.defaultSearchElement: true //搜索帮助
  key Suppliertype,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZR_TSUPPLIERTYPES_LIST', element: 'Description' },
                                            useForValidation: true } ]
      Description,

      Createdby,
      Createdat,
      Locallastchangedby,
      Locallastchangedat,
      Lastchangedat
}
