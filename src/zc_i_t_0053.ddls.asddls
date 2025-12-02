@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS I - T1 - Tipo medio pago - Homologación SAP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_I_T_0053 as select from yfi_t_0053
{
    key zlsch as PaymentMethod,
    key szlch as PaymentMethodSnt,
    sapds as Descripcion
}
