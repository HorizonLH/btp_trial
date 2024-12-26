@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Customer App'
define root view entity ZR_TCUSTOMERS
  as select from ztcustomers as Customers
  // Country关联显示ztcountries-descripton
  association [0..1] to ztcountries   as _Countries     on $projection.Country = _Countries.country
  // Customertype 关联显示ztcustomertps-customertype
  association [0..1] to ztcustomertps as _customertypes on $projection.Customertype = _customertypes.customertype
{
  key customerid         as Customerid,
      customername       as Customername,
      email              as Email,
      phone              as Phone,
      street             as Street,
      town               as Town,
      country            as Country,
      customertype       as Customertype,
      @Semantics.user.createdBy: true
      createdby          as Createdby,
      @Semantics.systemDateTime.createdAt: true
      createdat          as Createdat,
      @Semantics.user.localInstanceLastChangedBy: true
      locallastchangedby as Locallastchangedby,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      locallastchangedat as Locallastchangedat,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat      as Lastchangedat,

      _Countries,
      _customertypes
}
