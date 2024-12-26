@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #CHECK
@ObjectModel.semanticKey: [ 'Itemno' ]
define view entity ZC_TORDERITEMS
  //provider contract transactional_query
  as projection on ZR_TORDERITEMS
{
  key Orderid,
      @Search.fuzzinessThreshold: 0.90
      @Search.defaultSearchElement: true
  key Itemno,
//      @ObjectModel.text.element: [ 'Plantname' ]
      Plantid,
      _Plants.Description     as Plantname,
      Quantity,
      Sprice,
      Amount,
      @Semantics.currencyCode: true
      Currency,    
      Itemtext,
      @Semantics.unitOfMeasure: true
      Unit,
      Criticality,

      @ObjectModel.text.element: [ 'Productname' ]
      Productid,
      _Products.Productname   as Productname,
      _Products.Price         as Productprice,
      _Products.Basicunit     as Basicunit,
      _Products.Salesunit     as Salesunit,
      _Products.Remark        as Productremark,

      @ObjectModel.text.element: [ 'Suppliername' ]
      Supplierid,
      _Suppliers.Suppliername as Suppliername,
      _Suppliers.Email        as SupplierEmail,
      _Suppliers.Phone        as SupplierPhone,
      _Suppliers.Street       as SupplierStreet,
      _Suppliers.Town         as SupplierTown,
      _Suppliers.Country      as SupplierCountry,

      Createdby,
      Createdat,
      Locallastchangedby,
      Locallastchangedat,
      Lastchangedat,
      _Order : redirected to parent ZC_TORDERS

}
