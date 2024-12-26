@AccessControl.authorizationCheck: #CHECK

@EndUserText.label: '###GENERATED Customer Type App'

@Metadata.allowExtensions: true

@Search.searchable: true

define root view entity ZC_TCUSTOMERTPS
  provider contract transactional_query
  as projection on ZR_TCUSTOMERTPS

{
      @Search.fuzzinessThreshold: 0.90
      @Search.defaultSearchElement: true //搜索帮助
  key Customertype       as Customertype,

      Description        as Description,
      //      @Semantics.user.createdBy: true
      Createdby          as Createdby,
      //      @Semantics.systemDateTime.createdAt: true
      Createdat          as Createdat,
      //      @Semantics.user.localInstanceLastChangedBy: true
      Locallastchangedby as Locallastchangedby,
      //      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      Locallastchangedat as Locallastchangedat,
      //      @Semantics.systemDateTime.lastChangedAt: true
      Lastchangedat      as Lastchangedat
}
