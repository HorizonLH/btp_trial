@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Suppliers App'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
@ObjectModel.semanticKey: [ 'Supplierid' ]
define root view entity ZC_TSUPPLIERS
  provider contract transactional_query
  as projection on ZR_TSUPPLIERS
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
  key Supplierid,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.90
      Suppliername,
      Email,
      Phone,
      Street,
      Town,

      @ObjectModel.text.element: [ 'CountryName' ]
      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZR_TCOUNTRIES_LIST', element: 'Country' }, useForValidation: true }]
      Country,
      _countries.descripton     as CountryName,

      @ObjectModel.text.element: [ 'SupplierTypeName' ]
      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZR_TSUPPLIERTYPES_LIST', element: 'Suppliertype' }, useForValidation: true }]
      Suppliertype,
      _suppliertype.description as SupplierTypeName,

      Createdby,
      Createdat,
      Locallastchangedby,
      Locallastchangedat,
      Lastchangedat

}
