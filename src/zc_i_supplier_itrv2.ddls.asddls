@EndUserText.label: 'ZC_I_SUPPLIER_ITRV2'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_ISUPPLIERITR'
define root custom entity ZC_I_SUPPLIER_ITRV2
{
    key Supplier: lifnr;
    key CompanyCode: bukrs;
    key WithholdingTaxType: abap.char(2);
    TaxNumber1: stcd1;
    IsWithholdingTaxSubject: abap_boolean;     
    WithholdingTaxNumber: abap.char(16);
}
