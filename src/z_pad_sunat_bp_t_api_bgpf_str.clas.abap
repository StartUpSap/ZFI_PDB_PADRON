CLASS z_pad_sunat_bp_t_api_bgpf_str DEFINITION
  PUBLIC

  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  "  CLASS-METHODS  set_tax_table  CHANGING  it_pad_excel     TYPE z_pad_sunat_bp_t_api=>gt_yfi_t_0082
  "                                RETURNING VALUE(lv_string) TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
   " DATA  gt_pad_excel     TYPE z_pad_sunat_bp_t_api=>gt_yfi_t_0082.
ENDCLASS.



CLASS Z_PAD_SUNAT_BP_T_API_BGPF_STR IMPLEMENTATION.


  METHOD IF_OO_ADT_CLASSRUN~MAIN.
*    DATA lo_operation TYPE REF TO z_pad_sunat_bp_t_api_bgpf.
*    DATA lo_process   TYPE REF TO if_bgmc_process_single_op.
*    DATA lx_bgmc      TYPE REF TO cx_bgmc.
*    TRY.
*
*        lo_operation = NEW #(  it_pad_excel = it_pad_excel ).
*        lo_process = cl_bgmc_process_factory=>get_default(  )->create(  ).
*        lo_process->set_name( 'bgPF_Tax' )->set_operation( lo_operation ).
*        lo_process->save_for_execution(  ).
*        COMMIT WORK.
*"        lv_string = 'Termino'.
*      CATCH /iwbep/cx_cp_remote   INTO DATA(lx_my_exception).
*        z_pad_sunat_bp_t_api=>save_error( i_error  = lx_my_exception->get_text(  )  ).
*        "out->write( lx_my_exception->get_text(  )   ).
*
*      CATCH cx_http_dest_provider_error INTO DATA(lx_my_exception2).
*        z_pad_sunat_bp_t_api=>save_error( i_error  = lx_my_exception2->get_text(  )  ).
*        "out->write( lx_my_exception2->get_text(  )   ).
*      CATCH cx_bgmc INTO DATA(lx_cx_bgmc).
*        RAISE SHORTDUMP lx_cx_bgmc.
*        "handle exception
*    ENDTRY.

    TRY.
       " out->write( get_tax_table(  ) ).
        "set_tax_table( lg_yfi_t_0082type ).
        "out->write( get_token(  ) ).
        "DATA(lv_mandt)  =  CL_ABAP_CONTEXT_INFO=>get_system_url( ).
        data: lt_URL_ODATA TYPE STANDARD TABLE OF YFI_T_URL_ODATA.
         lt_URL_ODATA = value #(
            (   client          = sy-mandt
                pos             = '1'
                companycode     = '5710'
                urlambtf        = 'my416851.s4hana.cloud.sap'
                urlodata        = 'https://my416851-api.s4hana.cloud.sap/'
                urlopass        = 'gcHhAANbFUJqKHnDkmXnAsQBAeZJchbmmJn4nk[z'
            )
            (   client          = sy-mandt
                pos             = '2'
                companycode     = '5710'
                urlambtf        = 'my416598.s4hana.cloud.sap'
                urlodata        = 'https://my416598-api.s4hana.cloud.sap/'
                urlopass        = 'TSjVGpfeWgohaJSa2rTJLkvGMKplEpW<MnYBciiL'
            )
         ).
         MODIFY YFI_T_URL_ODATA FROM TABLE @lt_URL_ODATA.

        out->write( 'impreso' ).


          " clear   lg_yfi_t_0082type.

      CATCH /iwbep/cx_cp_remote   INTO DATA(lx_my_exception).
        out->write( lx_my_exception->get_text(  )   ).

      CATCH cx_http_dest_provider_error INTO DATA(lx_my_exception2).
        out->write( lx_my_exception2->get_text(  )   ).

    ENDTRY.



  ENDMETHOD.
ENDCLASS.
