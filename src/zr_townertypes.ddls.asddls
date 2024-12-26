@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Owners Types App'
define root view entity ZR_TOWNERTYPES
  as select from ztownertypes as OwnerTypes
{
  key ownertype          as Ownertype,
      rolename           as Rolename,
      @Semantics.user.createdBy: true
      createdby          as Createdby,
      @Semantics.systemDateTime.createdAt: true
      createdat          as Createdat,
      @Semantics.user.localInstanceLastChangedBy: true
      locallastchangedby as Locallastchangedby,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      locallastchangedat as Locallastchangedat,
      @Semantics.systemDateTime.lastChangedAt: true
      lastchangedat      as Lastchangedat

}
