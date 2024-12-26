@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_TSALESCHANNELS
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_TSALESCHANNELS
{
  key Channel,
  Description,
  Createdby,
  Createdat,
  Locallastchangedby,
  Locallastchangedat,
  Lastchangedat
  
}
