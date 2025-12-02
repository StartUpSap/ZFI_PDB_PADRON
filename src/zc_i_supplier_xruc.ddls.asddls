@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS interface Supplier interlocutor x ruc'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_I_Supplier_xruc with parameters
    ruc         : stcd1         // Sociedad
  as select from I_SupplierWithHoldingTax as WithHTax
  association [1..1] to I_Supplier                    as _Supplier                  on $projection.Supplier = _Supplier.Supplier                                                                               
{  
     @ObjectModel.foreignKey.association: '_Supplier'
    key WithHTax.Supplier,
    key WithHTax.CompanyCode,
    key WithHTax.WithholdingTaxType,
    WithHTax.IsWithholdingTaxSubject,
    _Supplier.TaxNumber1,    
    
    /* Associations */
    _Supplier    
}   where
         WithHTax.CompanyCode        =     '5710'
     and WithHTax.WithholdingTaxType =     '9P'
     and _Supplier.TaxNumber1        =     $parameters.ruc
 