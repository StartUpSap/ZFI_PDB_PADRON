@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS interface - obtener sociedad y ruc'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_I_SOCIEDAD 
with parameters
    P_CompanyCode         : bukrs         // Sociedad
as select from I_CompanyCode 
    as Sociedad    
    {
        key CompanyCode,
        CompanyCodeName,
        VATRegistration as RUC
    }
        where
            Sociedad.CompanyCode            = $parameters.P_CompanyCode
