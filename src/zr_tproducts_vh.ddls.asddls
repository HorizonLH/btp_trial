@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Products VH'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZR_TPRODUCTS_VH
  as select from ZR_TPRODUCTS
{
      @EndUserText.label: 'Product ID'
  key Productid,
      @EndUserText.label: 'Product Name'
      Productname,
      @Semantics.quantity.unitOfMeasure: 'Weightunit'
      @EndUserText.label: 'Net Weight'
      Netweight,
      @Semantics.quantity.unitOfMeasure: 'Weightunit'
      @EndUserText.label: 'Gross Weight'
      Grossweight,
      @Semantics.amount.currencyCode: 'Currencycode'
      Price,
      @EndUserText.label: 'Currency'
      Currencycode,
      @EndUserText.label: 'Basic Unit'
      Basicunit,
      @EndUserText.label: 'Sales Unit'
      Salesunit,
      @EndUserText.label: 'Weight Unit'
      Weightunit,
      Remark
}
