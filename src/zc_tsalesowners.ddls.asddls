@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED SalesOwners App'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
@ObjectModel.semanticKey: [ 'Ownerid' ]
define root view entity ZC_TSALESOWNERS
  provider contract transactional_query
  as projection on ZR_TSALESOWNERS
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
  key Ownerid,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      Ownername,
      Email,
      Phone,
      Remark,
      Street,
      Town,

      @ObjectModel.text.element: [ 'CountryName' ]
      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZR_TCOUNTRIES_LIST', element: 'Country' }, useForValidation: true }]
      Country,
      _countries.descripton as CountryName,

      @ObjectModel.text.element: [ 'RoleName' ]
      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZR_TOWNERTYPES_LIST', element: 'Ownertype' }, useForValidation: true }]
      Ownertype,
      _ownertypes.rolename  as RoleName,

      Createdby,
      Createdat,
      Locallastchangedby,
      Locallastchangedat,
      Lastchangedat

}
