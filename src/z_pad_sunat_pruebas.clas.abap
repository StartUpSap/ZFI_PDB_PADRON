CLASS z_pad_sunat_pruebas DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .

    TYPES tt_za_bankdetails TYPE TABLE OF z_pad_buspar_tax=>tys_a_supplier_with_holding__2 WITH EMPTY KEY.
    METHODS get_tax_table RETURNING VALUE(rt_table) TYPE tt_za_bankdetails
                          RAISING   cx_http_dest_provider_error.

    METHODS get_token RETURNING VALUE(lv_token) TYPE string
                      RAISING   cx_http_dest_provider_error.

    TYPES gt_yfi_t_0082  TYPE TABLE OF yfi_t_0082  WITH EMPTY KEY.
    CLASS-METHODS  set_tax_table  IMPORTING gg_yfi_t_0082type TYPE gt_yfi_t_0082
                                  RETURNING VALUE(lv_string)  TYPE string
                                  RAISING
                                            cx_http_dest_provider_error.


  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z_PAD_SUNAT_PRUEBAS IMPLEMENTATION.


  METHOD get_tax_table.
*
*    DATA:
*      lt_business_data TYPE TABLE OF z_pad_buspar_tax=>tys_a_supplier_with_holding__2,
*      lo_http_client   TYPE REF TO if_web_http_client,
*      lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
*      lo_request       TYPE REF TO /iwbep/if_cp_request_read_list,
*      lo_response      TYPE REF TO /iwbep/if_cp_response_read_lst.
*
*    TRY.
*
*        DATA: lv_url TYPE string VALUE 'https://my416851-api.s4hana.cloud.sap/'.
*        lo_http_client = cl_web_http_client_manager=>create_by_http_destination(
*                        i_destination = cl_http_destination_provider=>create_by_url( lv_url ) ).
*
*        lo_http_client->get_http_request( )->set_authorization_basic(
*        i_username = 'BTP_JOURNAL'
*        i_password = 'gcHhAANbFUJqKHnDkmXnAsQBAeZJchbmmJn4nk[z'
*         ).
*
*        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
*          EXPORTING
*             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
*                                                 proxy_model_id      = 'Z_PAD_BUSPAR_TAX'
*                                                 proxy_model_version = '0001'          )
*            io_http_client             = lo_http_client
*            iv_relative_service_root   = '/sap/opu/odata/sap/API_BUSINESS_PARTNER' ).
*
*        ASSERT lo_http_client IS BOUND.
*
*        lo_request = lo_client_proxy->create_resource_for_entity_set( 'A_SUPPLIER_WITH_HOLDING_TA' )->create_request_for_read( ).
*
*        lo_request->set_top( 50 )->set_skip( 0 ).
*        lo_response = lo_request->execute( ).
*        lo_response->get_business_data( IMPORTING et_business_data = rt_table ).
*
*
*      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
*        RAISE SHORTDUMP lx_remote.
*        "RAISE EXCEPTION lx_remote.
*        " Handle remote Exception
*        " It contains details about the problems of your http(s) connection
*
*      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
*      RAISE SHORTDUMP lx_gateway.
*        "RAISE EXCEPTION lx_gateway.
*        " Handle Exception
*
*      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
*      RAISE SHORTDUMP lx_web_http_client_error.
*        " Handle Exception
*        "RAISE EXCEPTION lx_web_http_client_error.
*    ENDTRY.
  ENDMETHOD.


  METHOD get_token.
*
*    DATA:
*      lt_business_data TYPE TABLE OF z_pad_buspar_tax=>tys_a_supplier_with_holding__2,
*      lo_http_client   TYPE REF TO if_web_http_client,
*      lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
*      lo_request       TYPE REF TO /iwbep/if_cp_request_read_list,
*      lo_response      TYPE REF TO /iwbep/if_cp_response_read_lst.
*
*    DATA http_header_fields  TYPE if_web_http_request=>name_value_pairs.
*
*    TRY.
*
*        DATA: lv_url TYPE string VALUE 'https://my416851-api.s4hana.cloud.sap/'.
*        lo_http_client = cl_web_http_client_manager=>create_by_http_destination(
*                        i_destination = cl_http_destination_provider=>create_by_url( lv_url ) ).
*
*        lo_http_client->get_http_request( )->set_authorization_basic(
*        i_username = 'BTP_JOURNAL'
*        i_password = 'gcHhAANbFUJqKHnDkmXnAsQBAeZJchbmmJn4nk[z'
*         ).
*
*        http_header_fields = VALUE #( ( name = if_web_http_header=>accept value = |application/json| )
*                                  ( name = if_web_http_header=>content_type value =  |application/json|  )
*                                  ( name = 'x-csrf-token' value = 'fetch' ) ).
*        lo_http_client->get_http_request( )->set_header_fields( http_header_fields ).
*        "    lo_http_client->get_http_request( )->set_header_field( i_name = 'X-CSRF-Token' i_value = 'St2mbesM538b0-en3YyYMw==' ).
*
*        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
*          EXPORTING
*             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
*                                                 proxy_model_id      = 'Z_PAD_BUSPAR_TAX'
*                                                 proxy_model_version = '0001'
*                                                   )
*            io_http_client             = lo_http_client
*            iv_relative_service_root   = '/sap/opu/odata/sap/API_BUSINESS_PARTNER' ).
*
*
*        ASSERT lo_http_client IS BOUND.
*
*
*
*        DATA(http_response) = lo_http_client->execute( if_web_http_client=>get ).  "--> works
*        DATA(http_status_code) = http_response->get_status( ).
*        DATA(x_csrf_token) =  http_response->get_header_field( 'x-csrf-token' ).
*        DATA(http_response_body)  =  http_response->get_text( ).
*
*        lv_token =  x_csrf_token.
*        "DATA query_parameters TYPE if_web_http_request=>name_value_pairs  .
*        DATA(service_relative_url) = '/sap/opu/odata/sap/API_BUSINESS_PARTNER/'.
*        DATA(i_action_name) = 'A_SUPPLIER_WITH_HOLDING_TA'.
*        DATA(sap_client) = '100'.
*        "query_parameters = VALUE #( ( name = 'SalesOrderID' value = '0500010020' ) ).
*        DATA   relative_url TYPE STRING.
*        relative_url = |/sap/opu/odata/sap/API_BUSINESS_PARTNER/A_SupplierWithHoldingTax(Supplier='1000000001',CompanyCode='5710',WithholdingTaxType='9P')|.
*         lo_http_client->get_http_request( )->set_uri_path( i_uri_path = relative_url ).
*
*        http_header_fields = VALUE #( ( name = if_web_http_header=>accept value = |application/json| )
*                                      ( name = if_web_http_header=>content_type value =  |application/json|  )
*                                      ( name = 'x-csrf-token' value =  x_csrf_token ) ).
*        lo_http_client->get_http_request( )->set_header_fields( http_header_fields ).
*
*
*       DATA http_request_body type string.
*          http_request_body = '{"IsWithholdingTaxSubject": false}'.
*       lo_http_client->get_http_request( )->set_text( http_request_body ).
*
*
*        http_response = lo_http_client->execute( if_web_http_client=>patch ).
*        http_status_code = http_response->get_status( ).
*        lv_token =  http_response->get_text( ).
*
*
*
*      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
*      RAISE SHORTDUMP lx_remote.
*        "RAISE EXCEPTION lx_remote.
*        " Handle remote Exception
*        " It contains details about the problems of your http(s) connection
*
*      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
*      RAISE SHORTDUMP lx_gateway.
*        "RAISE EXCEPTION lx_gateway.
*        " Handle Exception
*
*      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
*      RAISE SHORTDUMP lx_web_http_client_error.
*        " Handle Exception
*        "RAISE EXCEPTION lx_web_http_client_error.
*    ENDTRY.
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    DATA    lg_yfi_t_0082type TYPE gt_yfi_t_0082.
    TRY.
       " out->write( get_tax_table(  ) ).
        "set_tax_table( lg_yfi_t_0082type ).
        "out->write( get_token(  ) ).

        data: ls_YFI_T_0053 TYPE STANDARD TABLE OF YFI_T_0053.
         ls_YFI_T_0053 = value #(
           ( client = sy-mandt zlsch  = 'T' szlch  = '003' sapds  = 'TRANSFERENCIA DE FONDOS' )
           ( client = sy-mandt zlsch  = 'C' szlch  = '007' sapds  = 'CHEQUES' )
           ( client = sy-mandt zlsch  = 'F' szlch  = '101' sapds  = 'TRANSFERENCIAS - COMERCIO EXTERIOR' )
           ( client = sy-mandt zlsch  = 'V' szlch  = '101' sapds  = 'TRANSFERENCIA DE PAGO VARIOS' )
         ).
         MODIFY YFI_T_0053 FROM TABLE @ls_YFI_T_0053.

         data: lt_YFI_T_0057 TYPE STANDARD TABLE OF YFI_T_0057.
         lt_YFI_T_0057 = value
         #(
          ( client = sy-mandt hbkid = 'BCPPE'  hbkis = '02'  sapds = 'DE CREDITO DEL PERU'  )
          ( client = sy-mandt hbkid = 'IBKPE'  hbkis = '03'  sapds = 'INTERNACIONAL DEL PERU'  )
          ( client = sy-mandt hbkid = 'SCOPE'  hbkis = '09'  sapds = 'SCOTIABANK PERU'  )
          ( client = sy-mandt hbkid = 'BNAPE'  hbkis = '18'  sapds = 'NACION'  )
          ( client = sy-mandt hbkid = 'NACPE'  hbkis = '18'  sapds = 'NACION'  )
          ( client = sy-mandt hbkid = 'BIFPE'  hbkis = '38'  sapds = 'INTERAMERICANO FINANZAS'  )
          ( client = sy-mandt hbkid = 'BCPUS'  hbkis = '99'  sapds = 'OTROS'  )
          ).
         MODIFY YFI_T_0057 FROM TABLE @lt_YFI_T_0057.



          " clear   lg_yfi_t_0082type.
      CATCH /iwbep/cx_cp_remote   INTO DATA(lx_my_exception).
        out->write( lx_my_exception->get_text(  )   ).

      CATCH cx_http_dest_provider_error INTO DATA(lx_my_exception2).
        out->write( lx_my_exception2->get_text(  )   ).
    ENDTRY.

  ENDMETHOD.


  METHOD set_tax_table.
*
*    DATA: lv_str   type string,
*      ls_business_data TYPE z_pad_buspar_tax=>tys_a_supplier_with_holding__2,
*      ls_entity_key    TYPE z_pad_buspar_tax=>tys_a_supplier_with_holding__2,
*      lo_http_client   TYPE REF TO if_web_http_client,
*      lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
*      lo_resource      TYPE REF TO /iwbep/if_cp_resource_entity,
*      lo_request       TYPE REF TO /iwbep/if_cp_request_update,
*      lo_response      TYPE REF TO /iwbep/if_cp_response_update.
*
*
*
*
*    TRY.
*        DATA: lv_url TYPE string VALUE 'https://my416851-api.s4hana.cloud.sap/'.
*        lo_http_client = cl_web_http_client_manager=>create_by_http_destination(
*                        i_destination = cl_http_destination_provider=>create_by_url( lv_url ) ).
*
*        lo_http_client->accept_cookies(  abap_true ).
*
*        lo_http_client->get_http_request( )->set_authorization_basic(
*       i_username = 'BTP_JOURNAL'
*       i_password = 'gcHhAANbFUJqKHnDkmXnAsQBAeZJchbmmJn4nk[z'         ).
*
*        lo_http_client->get_http_request( )->set_header_field( i_name = 'X-CSRF-Token' i_value = 'St2mbesM538b0-en3YyYMw==' ).
*
*        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
*          EXPORTING
*             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
*                                                 proxy_model_id      = 'Z_PAD_BUSPAR_TAX'
*                                                 proxy_model_version = '0001' )
*            io_http_client             = lo_http_client
*            iv_relative_service_root   = '/sap/opu/odata/sap/API_BUSINESS_PARTNER' ).
*
*        ASSERT lo_http_client IS BOUND.
*
*
*        " Set entity key
*        ls_entity_key = VALUE #(
*                  supplier              = '1000000001'
*                  company_code          = '5710'
*                  withholding_tax_type  = '9P' ).
*
*        " Prepare the business data
*        ls_business_data = VALUE #(
*                  supplier                    = '1000000001'
*                  company_code                = '5710'
*                  withholding_tax_type        = '9P'
*                  is_withholding_tax_subject  = 'X' ).
*
*        " Navigate to the resource and create a request for the update operation
*        lo_resource = lo_client_proxy->create_resource_for_entity_set( 'A_SUPPLIER_WITH_HOLDING_TA' )->navigate_with_key( ls_entity_key ).
*        lo_request = lo_resource->create_request_for_update( /iwbep/if_cp_request_update=>gcs_update_semantic-put ).
*
*
*        lo_request->set_business_data( ls_business_data ).
*
*        " Execute the request and retrieve the business data
*        lo_response = lo_request->execute( ).
*        lo_response->get_business_data( IMPORTING es_business_data = ls_business_data ).
*        " Get updated entity
**CLEAR ls_business_data.
**lo_response->get_business_data( importing es_business_data = ls_business_data ).
*
*      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
*        RAISE SHORTDUMP lx_remote.
*        "lv_str = lx_remote->get_text( ).
*        "RAISE EXCEPTION lx_remote.
*        " Handle remote Exception
*        " It contains details about the problems of your http(s) connection
*
*      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
*        RAISE SHORTDUMP lx_remote.
*        "lv_str = lx_gateway->get_text( ).
*        "RAISE EXCEPTION lx_gateway.
*        " Handle Exception
*
*      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
*        " Handle Exception
*        RAISE SHORTDUMP lx_web_http_client_error.
*
*
*    ENDTRY.
*
*    RETURN ''.
  ENDMETHOD.
ENDCLASS.
