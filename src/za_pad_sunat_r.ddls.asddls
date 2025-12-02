@EndUserText.label: 'Root Deep padrones sunat'
define abstract entity ZA_PAD_SUNAT_R
{
    Supplier: lifnr;
    Taxsubjt: abap.char(1);
   // _padsunat : composition [0..*] of ZA_PAD_SUNAT_C;
}
