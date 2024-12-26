@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_TSALESORGS
  provider contract transactional_query
  as projection on ZR_TSALESORGS
{
  key Salesorg,
  Description,
  Createdby,
  Createdat,
  Locallastchangedby,
  Locallastchangedat,
  Lastchangedat
}
