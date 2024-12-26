@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Owner Type drop-down list'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZR_TOWNERTYPES_LIST
  as select from ztownertypes
{
      @EndUserText.label: 'Sales Owner Type'
  key ownertype as Ownertype,
      rolename  as Rolename
}
