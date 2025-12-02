@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS I - T3 - Entidad financiera Hom SAP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_I_T_0057 as select from yfi_t_0057
{
    key hbkid as HouseBank,
    key hbkis as HouseBankSnt,
    sapds as Descripcion
}
