CLASS lsc_zc_i_padsunat DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zc_i_padsunat IMPLEMENTATION.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_padsunat DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR padsunat RESULT result.

    METHODS fileupload FOR MODIFY
      IMPORTING keys FOR ACTION padsunat~fileupload.

    METHODS validatedates FOR VALIDATE ON SAVE
      IMPORTING keys FOR padsunat~validatedates.
    METHODS getpad FOR MODIFY
      IMPORTING keys FOR ACTION padsunat~getpad RESULT result.
    METHODS settax FOR MODIFY
      IMPORTING keys FOR ACTION padsunat~settax.
    METHODS setpdbexp FOR MODIFY
      IMPORTING keys FOR ACTION padsunat~setpdbexp.
    METHODS setcecond FOR MODIFY
      IMPORTING keys FOR ACTION padsunat~setcecond.
    METHODS setcecoinvblq FOR MODIFY
      IMPORTING keys FOR ACTION padsunat~setcecoinvblq.

ENDCLASS.

CLASS lhc_padsunat IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD fileupload.
    z_pad_sunat_bp_t_api=>save_error( i_error  = '0'  ).
    DATA lt_padron_s TYPE STANDARD TABLE OF yfi_t_0082  WITH EMPTY KEY.
    READ TABLE keys ASSIGNING FIELD-SYMBOL(<ls_keys>) INDEX 1.
    IF  sy-subrc = 0.
      DATA(lv_filecontent) = <ls_keys>-%param-filecontent.

      DATA(lv_string_encoded) = VALUE #( keys[ 1 ]-%param-filecontent OPTIONAL ).
      DATA(lv_xstring_decoded) = cl_web_http_utility=>decode_x_base64( lv_string_encoded ).

      "DATA(lv_process) = <ls_keys>-%param-process.

      DATA(lo_read_access) = xco_cp_xlsx=>document->for_file_content( lv_xstring_decoded )->read_access(  ).

      DATA(lo_worksheet) = lo_read_access->get_workbook(  )->worksheet->at_position( 1 ).

      DATA(lo_selection_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to(
                                   )->from_column( xco_cp_xlsx=>coordinate->for_alphabetic_value( 'A' )
                                   )->to_column( xco_cp_xlsx=>coordinate->for_alphabetic_value( 'D' )
                                   )->from_row( xco_cp_xlsx=>coordinate->for_numeric_value( 2 )
                                   )->get_pattern(  ).
      lo_worksheet->select( lo_selection_pattern )->row_stream(  )->operation->write_to( REF #( lt_padron_s )
                           )->if_xco_xlsx_ra_operation~execute(  ).

    ENDIF.
    IF lt_padron_s[] IS NOT INITIAL.
      "MODIFY yfi_t_0082 FROM TABLE @lt_padron_s.
      "z_pad_sunat_bp_t_api_bgpf_str=>set_tax_table( CHANGING it_pad_excel = lt_padron_s ).
      TRY.
          z_pad_sunat_bp_t_api=>save_error( i_error  = '0'  ).
          z_pad_sunat_bp_t_api=>save_error( i_error  =  lines( lt_padron_s )  ).
          z_pad_sunat_bp_t_api=>set_tax_table( CHANGING lt_pad_excel = lt_padron_s ).
        CATCH /iwbep/cx_cp_remote   INTO DATA(lx_my_exception).
          z_pad_sunat_bp_t_api=>save_error( i_error  = lx_my_exception->get_text(  )  ).
          "out->write( lx_my_exception->get_text(  )   ).

        CATCH cx_http_dest_provider_error INTO DATA(lx_my_exception2).
          z_pad_sunat_bp_t_api=>save_error( i_error  = lx_my_exception2->get_text(  )  ).
          "out->write( lx_my_exception2->get_text(  )   ).
      ENDTRY.


    ENDIF.

  ENDMETHOD.

  METHOD validatedates.



  ENDMETHOD.



***** "IMPORTING lt_padron_s TYPE gt_yfi_t_0082
***** "RETURNING VALUE(lv_string)  TYPE string
*    DATA: lst_pad_excel TYPE SORTED   TABLE OF yfi_t_0082 WITH UNIQUE KEY stcd1,tipo.
*
*    DATA: lt_pad_sunnat_api_true TYPE  gty_pad_sunnat_api,
*          lt_pad_sunnat_api_fals TYPE  gty_pad_sunnat_api.
*
*      SORT lt_padron_s BY stcd1 ASCENDING.
*      DELETE ADJACENT DUPLICATES FROM lt_padron_s COMPARING stcd1.
*      lst_pad_excel[] = lt_padron_s[].
*      SELECT FROM zc_i_supplier_itr
*      FIELDS *
*      INTO TABLE @DATA(lt_supplier_itr).
*      LOOP AT lt_supplier_itr ASSIGNING FIELD-SYMBOL(<fs_supplier_itr>).
*        READ TABLE lst_pad_excel ASSIGNING FIELD-SYMBOL(<lst_pad_excel>) WITH KEY stcd1 = <fs_supplier_itr>-taxnumber1.
*        IF sy-subrc EQ 0.   "los que se encontraron
*          IF <fs_supplier_itr>-iswithholdingtaxsubject = abap_true.   "tienen el check
*            APPEND VALUE #( lifnr = <fs_supplier_itr>-supplier activ = abap_false ) TO lt_pad_sunnat_api_fals.  "quitar el check
*          ENDIF.
*        ELSE.               "los que no se encontraron
*          IF <fs_supplier_itr>-iswithholdingtaxsubject = abap_false.  "no tienen el check
*            APPEND VALUE #( lifnr = <fs_supplier_itr>-supplier activ = abap_true ) TO lt_pad_sunnat_api_true.   "poner el check
*          ENDIF.
*        ENDIF.
*      ENDLOOP.
*      DATA lv_string_t TYPE string.

  " lv_string_t = | 'cc XX5a '  {   lines( lt_supplier_itr )  } ' ' {   lines( lt_pad_sunnat_api_true )  } ' ' {   lines( lt_pad_sunnat_api_fals )  } |.
*     IF lt_pad_sunnat_api_fals[] IS NOT INITIAL OR lt_pad_sunnat_api_true[] IS NOT INITIAL.
*
*     ENDIF.


*    ENDIF.
*
*
*      DATA    lt_ejm TYPE STANDARD TABLE OF  ZC_BO_PADSUNAT_ABSTRACT.
*     lt_ejm   = VALUE #( ( fileName = '20100576474' )
*                                       ( fileName = '20100039207' )
*                                        ).
*    result = VALUE #( FOR create IN lt_ejm INDEX INTO idx
*                         ( %cid = keys[ idx ]-%cid
*                         "%key = keys[ idx ]-travel_id
*                         %param = CORRESPONDING #( create ) ) ) .

*    ENDIF.






  METHOD getpad.

    "z_pad_sunat_bp_t_api=>save_error( i_error  = '0'  ).
    DATA lt_padron_s TYPE STANDARD TABLE OF yfi_t_0082  WITH EMPTY KEY.
    READ TABLE keys ASSIGNING FIELD-SYMBOL(<ls_keys>) INDEX 1.
    IF  sy-subrc = 0.
      DATA(lv_filecontent) = <ls_keys>-%param-filecontent.

      DATA(lv_string_encoded) = VALUE #( keys[ 1 ]-%param-filecontent OPTIONAL ).
      DATA(lv_xstring_decoded) = cl_web_http_utility=>decode_x_base64( lv_string_encoded ).

      "DATA(lv_process) = <ls_keys>-%param-process.

      DATA(lo_read_access) = xco_cp_xlsx=>document->for_file_content( lv_xstring_decoded )->read_access(  ).

      DATA(lo_worksheet) = lo_read_access->get_workbook(  )->worksheet->at_position( 1 ).

      DATA(lo_selection_pattern) = xco_cp_xlsx_selection=>pattern_builder->simple_from_to(
                                   )->from_column( xco_cp_xlsx=>coordinate->for_alphabetic_value( 'A' )
                                   )->to_column( xco_cp_xlsx=>coordinate->for_alphabetic_value( 'D' )
                                   )->from_row( xco_cp_xlsx=>coordinate->for_numeric_value( 2 )
                                   )->get_pattern(  ).
      lo_worksheet->select( lo_selection_pattern )->row_stream(  )->operation->write_to( REF #( lt_padron_s )
                           )->if_xco_xlsx_ra_operation~execute(  ).
      IF lt_padron_s[] IS NOT INITIAL.
        "  TYPE STANDARD TABLE OF ty_key.

      ENDIF.
      DATA    lt_ejms TYPE STANDARD TABLE OF  za_pad_sunat_c.
      lt_ejms   = VALUE #( ( supplier = '20100576' )
                                        ( supplier = '2010003' )
                                         ).
      "DATA    lt_ ejm   type table for hierarchy za_pad_sunat_r\\child .
*    result = VALUE #( FOR key1 IN keys (
*                       %cid = key1-%cid
*                       %param =  VALUE #( _padsunat  = lt_ejm )
*                     ) ).
*    result = VALUE #(  %cid = 'cid6'
*                %param = VALUE #(
**                FOR lt_ejm IN lt_ejms (
**                        %cid = key1-%cid
**                     )   )
*                     Supplier = '20100576474'
*                      ) ).
      result = VALUE #( FOR lt_ejm IN lt_ejms (
                     %cid = sy-index
                     %param =  VALUE #( supplier  = lt_ejm-supplier )
                   ) ).


    ENDIF.
  ENDMETHOD.

  METHOD settax.
    DATA ls_padron_s TYPE za_pad_sunat_r.
    READ TABLE keys ASSIGNING FIELD-SYMBOL(<ls_keys>) INDEX 1.
    IF  sy-subrc = 0.
      ls_padron_s       = VALUE #( supplier      = <ls_keys>-%param-supplier
                                   taxsubjt      = <ls_keys>-%param-taxsubjt
                                                 ).
    ENDIF.

    TRY.
        z_pad_sunat_bp_t_api=>set_tax_table_u( CHANGING ls_pad_sunat_r = ls_padron_s ).
      CATCH /iwbep/cx_cp_remote   INTO DATA(lx_my_exception).
        RAISE SHORTDUMP lx_my_exception.
        "z_pad_sunat_bp_t_api=>save_error( i_error  = lx_my_exception->get_text(  )  ).
        "out->write( lx_my_exception->get_text(  )   ).

      CATCH cx_http_dest_provider_error INTO DATA(lx_my_exception2).
        RAISE SHORTDUMP lx_my_exception.
        "  z_pad_sunat_bp_t_api=>save_error( i_error  = lx_my_exception2->get_text(  )  ).
        "out->write( lx_my_exception2->get_text(  )   ).
    ENDTRY.




  ENDMETHOD.

  METHOD setpdbexp.
    DATA ls_tdua TYPE yfi_t_dua.
    READ TABLE keys ASSIGNING FIELD-SYMBOL(<ls_keys>) INDEX 1.
    IF  sy-subrc = 0.
      ls_tdua       = VALUE #(   " client   = <ls_keys>-%param-client
                                  bukrs    = <ls_keys>-%param-bukrs
                                  gjahr    = <ls_keys>-%param-gjahr
                                  belnr    = <ls_keys>-%param-belnr
                                  docdua   = <ls_keys>-%param-docdua
                                                 ).
      MODIFY yfi_t_dua FROM @ls_tdua.
    ENDIF.

  ENDMETHOD.


  METHOD setcecond.
    DATA: ls_updceco TYPE zc_ae_updceco,
          lv_token   TYPE string.
    READ TABLE keys ASSIGNING FIELD-SYMBOL(<ls_keys>) INDEX 1.
    IF  sy-subrc = 0.
      ls_updceco       = VALUE #(
        langu = <ls_keys>-%param-langu
        conar = <ls_keys>-%param-conar
        cosce = <ls_keys>-%param-cosce
        vaedt = <ls_keys>-%param-vaedt
        coscn = <ls_keys>-%param-coscn
        coscd = <ls_keys>-%param-coscd
        bqpcp = <ls_keys>-%param-bqpcp
        bqscp = <ls_keys>-%param-bqscp
        bqfrp = <ls_keys>-%param-bqfrp
        bqfcp = <ls_keys>-%param-bqfcp
        coqir = <ls_keys>-%param-coqir      ).
      TRY.
          zfi_updceco_jp=>set_cecondblq(
            CHANGING
              ls_updceco = ls_updceco
            receiving
              lv_token   = lv_token
          ).
        CATCH /iwbep/cx_cp_remote   INTO DATA(lx_my_exception).
          RAISE SHORTDUMP lx_my_exception.
          "out->write( lx_my_exception->get_text(  )   ).

        CATCH cx_http_dest_provider_error INTO DATA(lx_my_exception2).
          RAISE SHORTDUMP lx_my_exception2.
          "out->write( lx_my_exception2->get_text(  )   ).
      ENDTRY.

    ENDIF.
  ENDMETHOD.

  METHOD setcecoinvblq.
    DATA: ls_updceco TYPE zc_ae_updceco,
          lv_token   TYPE string.
    READ TABLE keys ASSIGNING FIELD-SYMBOL(<ls_keys>) INDEX 1.
    IF  sy-subrc = 0.
      ls_updceco       = VALUE #(
        langu = <ls_keys>-%param-langu
        conar = <ls_keys>-%param-conar
        cosce = <ls_keys>-%param-cosce
        vaedt = <ls_keys>-%param-vaedt
        coscn = <ls_keys>-%param-coscn
        coscd = <ls_keys>-%param-coscd
        bqpcp = <ls_keys>-%param-bqpcp
        bqscp = <ls_keys>-%param-bqscp
        bqfrp = <ls_keys>-%param-bqfrp
        bqfcp = <ls_keys>-%param-bqfcp
        coqir = <ls_keys>-%param-coqir      ).
      TRY.
          zfi_updceco_jp=>set_cecoinvblq(
            CHANGING
              ls_updceco = ls_updceco
            receiving
              lv_token   = lv_token
          ).
        CATCH /iwbep/cx_cp_remote   INTO DATA(lx_my_exception).
          RAISE SHORTDUMP lx_my_exception.
          "out->write( lx_my_exception->get_text(  )   ).

        CATCH cx_http_dest_provider_error INTO DATA(lx_my_exception2).
          RAISE SHORTDUMP lx_my_exception2.
          "out->write( lx_my_exception2->get_text(  )   ).
      ENDTRY.

    ENDIF.

  ENDMETHOD.

ENDCLASS.
