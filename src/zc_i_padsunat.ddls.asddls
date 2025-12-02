@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS I - Padrones de Sunnat'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #B,
    sizeCategory: #M,
    dataClass: #MIXED    
}
define root view entity  ZC_I_PADSUNAT
  as select from yfi_t_0082
{
  key yfi_t_0082.stcd1                 as Stcd1,
  key yfi_t_0082.tipo                  as Tipo,
      yfi_t_0082.name1                 as Name1,
      yfi_t_0082.fecha                 as Fecha
}
