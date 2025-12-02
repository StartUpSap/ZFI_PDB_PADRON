@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS interface Supplier interlocutor DVE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #B,
    sizeCategory: #M,
    dataClass: #MIXED    
}
define root view entity ZC_I_Supplier_itr  as  select from I_SupplierWithHoldingTax as WithHoldingTax 
  association [1..1] to I_Supplier                    as _Supplier                  on $projection.Supplier = _Supplier.Supplier                                                                                
{  
     @ObjectModel.foreignKey.association: '_Supplier'
    key WithHoldingTax.Supplier,
    key WithHoldingTax.CompanyCode,
    key WithHoldingTax.WithholdingTaxType,
    _Supplier.TaxNumber1,
    WithHoldingTax.IsWithholdingTaxSubject,
    WithHoldingTax.WithholdingTaxNumber,
   /* WithHoldingTax.WithholdingTaxCode,
    WithHoldingTax.RecipientType,
    WithHoldingTax.WithholdingTaxCertificate,
    WithHoldingTax.WithholdingTaxExmptPercent,
    WithHoldingTax.ExemptionDateBegin,
    WithHoldingTax.ExemptionDateEnd,
    WithHoldingTax.ExemptionReason,*/    
    /* Associations */
    _Supplier    
}   where
         WithHoldingTax.CompanyCode        =     '5710'
     and WithHoldingTax.WithholdingTaxType =     '9P'
     and _Supplier.TaxNumber1             !=     ''  
 
 