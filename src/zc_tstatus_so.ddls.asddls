@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
define root view entity ZC_TSTATUS_SO
  provider contract TRANSACTIONAL_QUERY
  as projection on ZR_TSTATUS_SO
{
  key Status,
  Description,
  Createdby,
  Createdat,
  Locallastchangedby,
  Locallastchangedat,
  Lastchangedat
  
}
