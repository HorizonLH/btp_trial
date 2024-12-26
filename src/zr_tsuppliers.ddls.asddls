@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Suppliers App'
define root view entity ZR_TSUPPLIERS
  as select from ztsuppliers as Suppliers
  // Country 关联 Countries-descripton
  association [0..1] to ztcountries     as _countries    on $projection.Country = _countries.country
  // supplierType 关联  ztsuppliertypes-descripton
  association [0..1] to ztsuppliertypes as _suppliertype on $projection.Suppliertype = _suppliertype.suppliertype
{
  key supplierid         as Supplierid,
      suppliername       as Suppliername,
      email              as Email,
      phone              as Phone,
      street             as Street,
      town               as Town,
      country            as Country,
      suppliertype       as Suppliertype,
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
      
      _countries,
      _suppliertype
}
