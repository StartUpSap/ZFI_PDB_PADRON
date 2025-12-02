@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS C - Padrones de Sunnat'
@Metadata.allowExtensions: true
define root view entity ZC_C_PADSUNAT
  provider contract transactional_query 
  as projection on ZC_I_PADSUNAT
{
    key Stcd1,
    key Tipo,
    Name1,  
    Fecha
} 
