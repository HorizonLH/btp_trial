@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Sales Owners App'
define root view entity ZR_TSALESOWNERS
  as select from ztsalesowners as SalesOwners
  // Country 关联 Countries-descripton
  association [0..1] to ztcountries  as _countries  on $projection.Country = _countries.country
  // Ownertype 关联  ztownertypes-rolename
  association [0..1] to ztownertypes as _ownertypes on $projection.Ownertype = _ownertypes.ownertype
{
  key ownerid            as Ownerid,
      ownername          as Ownername,
      email              as Email,
      phone              as Phone,
      remark             as Remark,
      street             as Street,
      town               as Town,
      country            as Country,
      ownertype          as Ownertype,
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
      _ownertypes
}
