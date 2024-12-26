@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_TPLANTS
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_TPLANTS
{
  key Plant,
  Description,
  Createdby,
  Createdat,
  Locallastchangedby,
  Locallastchangedat,
  Lastchangedat
  
}
