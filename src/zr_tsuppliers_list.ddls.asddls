@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Supplier drop-down list'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZR_TSUPPLIERS_LIST
  as select from ztsuppliers
{
      @EndUserText.label: 'Supplier ID'
  key supplierid   as Supplierid,
      @EndUserText.label: 'Supplier Name'
      suppliername as Suppliername,
      email        as Email,
      phone        as Phone,
      street       as Street,
      town         as Town,
      country      as Country,
      @EndUserText.label: 'Supplier Type'
      suppliertype as Suppliertype
}
