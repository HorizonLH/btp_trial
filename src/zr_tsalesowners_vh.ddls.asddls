@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Owner VH'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_TSALESOWNERS_VH
  as select from ztsalesowners
{
      @EndUserText.label: 'Sales Owner ID'
  key ownerid   as Ownerid,
      @EndUserText.label: 'Sales Owner Name'
      ownername as Ownername,
      email     as Email,
      phone     as Phone,
      remark    as Remark,
      street    as Street,
      town      as Town,
      country   as Country,
      @EndUserText.label: 'Sales Owner Type'
      ownertype as Ownertype
}
