@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer VH'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_TCUSTOMERS_VH
  as select from ztcustomers
{
      @EndUserText.label: 'Customer ID'
  key customerid   as Customerid,
      @EndUserText.label: 'Customer Name'
      customername as Customername,
      email        as Email,
      phone        as Phone,
      street       as Street,
      town         as Town,
      country      as Country,
      @EndUserText.label: 'Customer Type'
      customertype as Customertype
}
