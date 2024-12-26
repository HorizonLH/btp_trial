@Metadata.allowExtensions: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Order Chart'
@Metadata.ignorePropagatedAnnotations: true
@Aggregation.allowPrecisionLoss: true
define root view entity ZC_TORDERS_CHART 
    provider contract transactional_query 
    as projection on ZR_TORDERS
{
    key Orderid,
    Orderdate,
    Salesorg,
    Channel,
    Division,
    Ordertype,
    Typedesc,
    @DefaultAggregation: #SUM
    Totalamount,
    @Semantics.currencyCode: true
    Currency,
    Remark,
    Criticality,
    Statuscode,
    Customerid,
    Customertype,
    Ownerid,
    Ownertype,
    Createdby,
    Createdat,
    Locallastchangedby,
    Locallastchangedat,
    Lastchangedat,
    /* Associations */
    _Channel,
    _Customer,
    _Customertp,
    _Division,
    _Items,
    _Ordertype,
    _Owner,
    _Ownertype,
    _Salesorg,
    _Status
}
