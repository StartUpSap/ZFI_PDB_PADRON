CLASS z_pad_sunat_bp_t_api DEFINITION
PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
    CONSTANTS: c_PRD_sysid  TYPE string VALUE 'KZK',
               c_PRD_MANDT  TYPE string VALUE '100',
               c_PRD_URL  TYPE string VALUE 'https://my416598-api.s4hana.cloud.sap/',
               c_PRD_PASS TYPE string VALUE 'TSjVGpfeWgohaJSa2rTJLkvGMKplEpW<MnYBciiL',
               c_QAS_URL  TYPE string VALUE 'https://my416851-api.s4hana.cloud.sap/',
               c_QAS_PASS TYPE string VALUE 'gcHhAANbFUJqKHnDkmXnAsQBAeZJchbmmJn4nk[z',
               c_request_body_fals TYPE string VALUE '{"IsWithholdingTaxSubject": false}',
               c_request_body_true TYPE string VALUE '{"IsWithholdingTaxSubject": true}'.

    TYPES: gt_yfi_t_0082 TYPE TABLE OF yfi_t_0082  WITH EMPTY KEY,
           BEGIN OF lty_pad_sunnat_api,
             lifnr TYPE lifnr,
             activ TYPE abap_boolean,
           END OF lty_pad_sunnat_api,
           gty_pad_sunnat_api TYPE STANDARD TABLE OF lty_pad_sunnat_api.

    CLASS-METHODS  get_token  CHANGING  lt_ps_api_true  TYPE gty_pad_sunnat_api
                                        lt_ps_api_fals  TYPE gty_pad_sunnat_api
                              RETURNING VALUE(lv_token) TYPE string
                              RAISING   cx_http_dest_provider_error.

    CLASS-METHODS  set_tax_table  CHANGING  lt_pad_excel     TYPE gt_yfi_t_0082
                                  RETURNING VALUE(lv_string) TYPE string
                                  RAISING
                                            cx_http_dest_provider_error.
     CLASS-METHODS  set_tax_table_u  CHANGING  ls_PAD_SUNAT_R     TYPE ZA_PAD_SUNAT_R
                                     RETURNING VALUE(lv_string) TYPE string
                                     RAISING
                                            cx_http_dest_provider_error.

    CLASS-METHODS  save_error  IMPORTING  i_error     TYPE any.



  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z_PAD_SUNAT_BP_T_API IMPLEMENTATION.


  METHOD get_token.
    DATA:
        lv_str   type string,
      lt_business_data TYPE TABLE OF z_pad_buspar_tax=>tys_a_supplier_with_holding__2,
      lo_http_client   TYPE REF TO if_web_http_client,
      lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
      lo_request       TYPE REF TO /iwbep/if_cp_request_read_list,
      lo_response      TYPE REF TO /iwbep/if_cp_response_read_lst.

    DATA http_header_fields  TYPE if_web_http_request=>name_value_pairs.
    TRY.

        DATA: lv_url_btp  TYPE string VALUE '',
              lv_pass     TYPE string VALUE ''.
*        if sy-sysid EQ z_pad_sunat_bp_t_api=>c_PRD_sysid AND sy-MANDT EQ z_pad_sunat_bp_t_api=>c_PRD_MANDT.
*          lv_url  =  z_pad_sunat_bp_t_api=>c_PRD_URL.
*          lv_pass =  z_pad_sunat_bp_t_api=>c_PRD_PASS.
*        else.
*          lv_url  =  z_pad_sunat_bp_t_api=>c_QAS_URL.
*          lv_pass =  z_pad_sunat_bp_t_api=>c_QAS_PASS.
*        endif.
        DATA: lv_url  TYPE string VALUE ''.
        lv_url  =  cl_abap_context_info=>get_system_url( ).
        SELECT SINGLE FROM yfi_t_url_odata
        FIELDS *
        WHERE  urlambtf = @lv_url
        INTO @DATA(ls_url_odata).

        lv_url_btp = ls_url_odata-urlodata.
        lv_pass = ls_url_odata-urlopass.

        lo_http_client = cl_web_http_client_manager=>create_by_http_destination(
                         i_destination = cl_http_destination_provider=>create_by_url( lv_url_btp ) ).
        lo_http_client->get_http_request( )->set_authorization_basic(
        i_username = 'BTP_JOURNAL'
        i_password = lv_pass
         ).
        http_header_fields = VALUE #( ( name = if_web_http_header=>accept value = |application/json| )
                                  ( name = if_web_http_header=>content_type value =  |application/json|  )
                                  ( name = 'x-csrf-token' value = 'fetch' ) ).
        lo_http_client->get_http_request( )->set_header_fields( http_header_fields ).
        "    lo_http_client->get_http_request( )->set_header_field( i_name = 'X-CSRF-Token' i_value = 'St2mbesM538b0-en3YyYMw==' ).
        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
          EXPORTING
             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                 proxy_model_id      = 'Z_PAD_BUSPAR_TAX'
                                                 proxy_model_version = '0001'
                                                   )
            io_http_client             = lo_http_client
            iv_relative_service_root   = '/sap/opu/odata/sap/API_BUSINESS_PARTNER' ).
        ASSERT lo_http_client IS BOUND.
        DATA(http_response) = lo_http_client->execute( if_web_http_client=>get ).  "--> works
        DATA(http_status_code) = http_response->get_status( ).
        DATA(x_csrf_token) =  http_response->get_header_field( 'x-csrf-token' ).
        DATA(http_response_body)  =  http_response->get_text( ).
        lv_token =  x_csrf_token.
        "DATA query_parameters TYPE if_web_http_request=>name_value_pairs  .
        DATA(service_relative_url) = '/sap/opu/odata/sap/API_BUSINESS_PARTNER/'.
        DATA(i_action_name) = 'A_SUPPLIER_WITH_HOLDING_TA'.
        "DATA(sap_client) = '100'.
        "query_parameters = VALUE #( ( name = 'SalesOrderID' value = '0500010020' ) ).
        DATA   relative_url TYPE string.
        DATA http_request_body TYPE string.
        http_header_fields = VALUE #( ( name = if_web_http_header=>accept value = |application/json| )
                                      ( name = if_web_http_header=>content_type value =  |application/json|  )
                                      ( name = 'x-csrf-token' value =  x_csrf_token ) ).
        LOOP AT  lt_ps_api_true ASSIGNING FIELD-SYMBOL(<fs_ps_api_true>).
          "relative_url = |{ service_relative_url }{ i_action_name }?sap-client={ sap_client }&{ i_query_parameters[ 1 ]-name }= '{ i_query_parameters[ 1 ]-value }' |.
          "relative_url = |/sap/opu/odata/sap/API_BUSINESS_PARTNER/A_SupplierWithHoldingTax(Supplier='1000000001',CompanyCode='5710',WithholdingTaxType='9P')|.
          relative_url = |/sap/opu/odata/sap/API_BUSINESS_PARTNER/A_SupplierWithHoldingTax(Supplier='{ <fs_ps_api_true>-lifnr }',CompanyCode='5710',WithholdingTaxType='9P')|.
          lo_http_client->get_http_request( )->set_uri_path( i_uri_path = relative_url ).
          lo_http_client->get_http_request( )->set_header_fields( http_header_fields ).
          http_request_body = c_request_body_true. "'{"IsWithholdingTaxSubject": true}'.
          lo_http_client->get_http_request( )->set_text( http_request_body ).
          http_response = lo_http_client->execute( if_web_http_client=>patch ).
          http_status_code = http_response->get_status( ).
          lv_token =  http_response->get_text( ).

        ENDLOOP.
        "z_pad_sunat_bp_t_api=>save_error( i_error  =  'btp 72' ).
        http_header_fields = VALUE #( ( name = if_web_http_header=>accept value = |application/json| )
                                      ( name = if_web_http_header=>content_type value =  |application/json|  )
                                      ( name = 'x-csrf-token' value =  x_csrf_token ) ).
        LOOP AT  lt_ps_api_fals ASSIGNING FIELD-SYMBOL(<fs_ps_api_fals>).
          "relative_url = |{ service_relative_url }{ i_action_name }?sap-client={ sap_client }&{ i_query_parameters[ 1 ]-name }= '{ i_query_parameters[ 1 ]-value }' |.
          "relative_url = |/sap/opu/odata/sap/API_BUSINESS_PARTNER/A_SupplierWithHoldingTax(Supplier='1000000001',CompanyCode='5710',WithholdingTaxType='9P')|.
          relative_url = |/sap/opu/odata/sap/API_BUSINESS_PARTNER/A_SupplierWithHoldingTax(Supplier='{ <fs_ps_api_fals>-lifnr }',CompanyCode='5710',WithholdingTaxType='9P')|.
          lo_http_client->get_http_request( )->set_uri_path( i_uri_path = relative_url ).
          lo_http_client->get_http_request( )->set_header_fields( http_header_fields ).
          http_request_body = c_request_body_fals. "'{"IsWithholdingTaxSubject": false}'.
          lo_http_client->get_http_request( )->set_text( http_request_body ).
          http_response = lo_http_client->execute( if_web_http_client=>patch )."patch ).
          http_status_code = http_response->get_status( ).
          lv_token =  http_response->get_text( ).
        ENDLOOP.
      CATCH cx_abap_context_info_error INTO DATA(lx_context_info_error).
        RAISE SHORTDUMP  lx_context_info_error.

      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
        RAISE SHORTDUMP lx_remote.
      " lv_str = lx_remote->get_text( ).
        "RAISE EXCEPTION lx_remote.
        " Handle remote Exception
        " It contains details about the problems of your http(s) connection
      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
        RAISE SHORTDUMP lx_gateway.
        " lv_str = lx_gateway->get_text( ).
            "RAISE EXCEPTION lx_gateway.
            " Handle Exception
      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
        RAISE SHORTDUMP lx_web_http_client_error.
        "lv_str = lx_web_http_client_error->get_text( ).
        " Handle Exception
        "RAISE EXCEPTION lx_web_http_client_error.
    ENDTRY.

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.
    DATA    lg_yfi_t_0082type TYPE gt_yfi_t_0082.
    TRY.
*    key stcd1  : stcd1 not null;
*  key tipo   : y_ed_tipps not null;
        lg_yfi_t_0082type   = VALUE #( ( stcd1 = '20100576474' )
                                       ( stcd1 = '20100039207' )
                                        ).
       out->write( set_tax_table(  CHANGING lt_pad_excel = lg_yfi_t_0082type  )  ).
       "out->write( z_pad_sunat_bp_t_api_bgpf_str=>set_tax_table( CHANGING it_pad_excel = lg_yfi_t_0082type ) ).
      CATCH /iwbep/cx_cp_remote   INTO DATA(lx_my_exception).
       RAISE SHORTDUMP lx_my_exception.
        out->write( lx_my_exception->get_text(  )   ).

      CATCH cx_http_dest_provider_error INTO DATA(lx_my_exception2).
       RAISE SHORTDUMP lx_my_exception2.
        out->write( lx_my_exception2->get_text(  )   ).
    ENDTRY.

  ENDMETHOD.


  METHOD save_error.
    DATA lv_error TYPE string.
    lv_error = i_error.
   " UPDATE yfi_t_0082 SET  name1 = @lv_error WHERE stcd1 = 'error' .
  ENDMETHOD.


  METHOD set_tax_table.
***** "IMPORTING lt_pad_excel TYPE gt_yfi_t_0082
***** "RETURNING VALUE(lv_string)  TYPE string
    DATA: lst_pad_excel TYPE SORTED   TABLE OF yfi_t_0082 WITH UNIQUE KEY stcd1,tipo.

    DATA: lt_pad_sunnat_api_true TYPE  gty_pad_sunnat_api,
          lt_pad_sunnat_api_fals TYPE  gty_pad_sunnat_api.
    z_pad_sunat_bp_t_api=>save_error( i_error  =  'cc 3' ).
    IF lt_pad_excel[] IS NOT INITIAL.
      SORT lt_pad_excel BY stcd1 ASCENDING.
      DELETE ADJACENT DUPLICATES FROM lt_pad_excel COMPARING stcd1.
      lst_pad_excel[] = lt_pad_excel[].
      SELECT FROM zc_i_supplier_itr
      FIELDS *
      WHERE 1 = 1
      INTO TABLE @DATA(lt_supplier_itr)
      .
      z_pad_sunat_bp_t_api=>save_error( i_error  =  'cc 4' ).
      LOOP AT lt_supplier_itr ASSIGNING FIELD-SYMBOL(<fs_supplier_itr>).
        READ TABLE lst_pad_excel ASSIGNING FIELD-SYMBOL(<lst_pad_excel>) WITH KEY stcd1 = <fs_supplier_itr>-taxnumber1.
        IF sy-subrc EQ 0.   "los que se encontraron
          IF <fs_supplier_itr>-iswithholdingtaxsubject = abap_true.   "tienen el check
            APPEND VALUE #( lifnr = <fs_supplier_itr>-supplier activ = abap_false ) TO lt_pad_sunnat_api_fals.  "quitar el check
          ENDIF.
        ELSE.               "los que no se encontraron
          IF <fs_supplier_itr>-iswithholdingtaxsubject = abap_false.  "no tienen el check
            APPEND VALUE #( lifnr = <fs_supplier_itr>-supplier activ = abap_true ) TO lt_pad_sunnat_api_true.   "poner el check
          ENDIF.
        ENDIF.
      ENDLOOP.
      DATA lv_string_t TYPE string.

      lv_string_t = | 'cc XX5a '  {   lines( lt_supplier_itr )  } ' ' {   lines( lt_pad_sunnat_api_true )  } ' ' {   lines( lt_pad_sunnat_api_fals )  } |.

      z_pad_sunat_bp_t_api=>save_error( i_error  =  lv_string_t ).
      IF lt_pad_sunnat_api_fals[] IS NOT INITIAL OR lt_pad_sunnat_api_true[] IS NOT INITIAL.
        z_pad_sunat_bp_t_api=>save_error( i_error  =  lines( lt_pad_sunnat_api_fals )  ).
        lv_string  = get_token(
             CHANGING lt_ps_api_true = lt_pad_sunnat_api_true
                      lt_ps_api_fals =  lt_pad_sunnat_api_fals ).
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD SET_TAX_TABLE_U.
    DATA: lt_pad_sunnat_api_true TYPE  gty_pad_sunnat_api,
          lt_pad_sunnat_api_fals TYPE  gty_pad_sunnat_api.


      IF ls_PAD_SUNAT_R-Taxsubjt = 'X'.   "tienen el check
            APPEND VALUE #( lifnr = ls_PAD_SUNAT_R-supplier activ = abap_false ) TO lt_pad_sunnat_api_fals.  "quitar el check
        ELSE.               "los que no se encontraron
            APPEND VALUE #( lifnr = ls_PAD_SUNAT_R-supplier activ = abap_true ) TO lt_pad_sunnat_api_true.   "poner el check
        ENDIF.
      IF lt_pad_sunnat_api_fals[] IS NOT INITIAL OR lt_pad_sunnat_api_true[] IS NOT INITIAL.
        lv_string  = get_token(
             CHANGING lt_ps_api_true = lt_pad_sunnat_api_true
                      lt_ps_api_fals =  lt_pad_sunnat_api_fals ).
      ENDIF.
  ENDMETHOD.
ENDCLASS.
