@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Customer App'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
@ObjectModel.semanticKey: [ 'Customerid' ]
define root view entity ZC_TCUSTOMERS
  provider contract transactional_query
  as projection on ZR_TCUSTOMERS
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
  key Customerid,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      Customername,
      Email,
      Phone,
      Street,
      Town,

      @ObjectModel.text.element: [ 'CountryName' ]
      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZR_TCOUNTRIES_LIST', element: 'Country' }, useForValidation: true }]
      Country,
      _Countries.descripton      as CountryName,

      @ObjectModel.text.element: [ 'CustomerTypeName' ]
      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZR_TCUSTOMERTPS_LIST', element: 'Customertype' }, useForValidation: true }]
      Customertype,
      _customertypes.description as CustomerTypeName,

      Createdby,
      Createdat,
      Locallastchangedby,
      Locallastchangedat,
      Lastchangedat

}
