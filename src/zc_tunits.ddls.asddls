@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_TUNITS
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_TUNITS
{
  key Unit,
  Descripton,
  Createdby,
  Createdat,
  Locallastchangedby,
  Locallastchangedat,
  Lastchangedat
  
}
