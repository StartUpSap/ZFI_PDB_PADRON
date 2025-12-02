@EndUserText.label: 'child Deep padrones sunat'
define abstract entity ZA_PAD_SUNAT_C
{
  key Supplier : lifnr;
   WithhTax : abap.char(2);
   ActivTax : abap.char(1);
  // _root: association to parent ZA_PAD_SUNAT_R;    
}
