@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.semanticKey: [ 'Orderid' ]
define root view entity ZC_TORDERS
  provider contract transactional_query
  as projection on ZR_TORDERS
{
  key Orderid,
      Orderdate,

      @ObjectModel.text.element: [ 'Salesorgdesc' ]
      Salesorg,
      _Salesorg.Description   as Salesorgdesc,

      @ObjectModel.text.element: [ 'Channeldesc' ]
      Channel,
      _Channel.Description    as Channeldesc,

      @ObjectModel.text.element: [ 'Divisiondesc' ]
      Division,
      _Division.Description   as Divisiondesc,

      @ObjectModel.text.element: [ 'Ordertypedesc' ]
      Ordertype,
      _Ordertype.Description  as Ordertypedesc,

      Typedesc,
      Totalamount,
      @Semantics.currencyCode: true
      Currency,
      Remark,
      Criticality,

      @ObjectModel.text.element: [ 'Statusdesc' ]
      Statuscode,
      _Status.Description     as Statusdesc,

      Customerid,
      _Customer.Customername  as CustomerName,
      _Customer.Email         as CustomerEmail,
      _Customer.Phone         as CustomerPhone,
      _Customer.Street        as CustomerStreet,
      _Customer.Town          as CustomerTown,
      _Customer.Country       as CustomerCountry,

      Ownerid,
      _Owner.Ownername        as OwnerName,
      _Owner.Email            as OwnerEmail,
      _Owner.Phone            as OwnerPhone,
      _Owner.Street           as OwnerStreet,
      _Owner.Town             as OwnerTown,
      _Owner.Country          as OwnerCountry,

      @ObjectModel.text.element: [ 'CustomerDesc' ]
      Customertype,
      _Customertp.Description as CustomerDesc,

      @ObjectModel.text.element: [ 'OwnerDesc' ]
      Ownertype,
      _Ownertype.Rolename     as OwnerDesc,

      Createdby,
      Createdat,
      Locallastchangedby,
      Locallastchangedat,
      Lastchangedat,

      _Items : redirected to composition child ZC_TORDERITEMS

}
