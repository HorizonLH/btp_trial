@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_TDIVISIONS
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_TDIVISIONS
{
  key Division,
  Description,
  Createdby,
  Createdat,
  Locallastchangedby,
  Locallastchangedat,
  Lastchangedat
  
}
