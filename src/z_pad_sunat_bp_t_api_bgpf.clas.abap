CLASS z_pad_sunat_bp_t_api_bgpf DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS constructor IMPORTING  it_pad_excel     TYPE z_pad_sunat_bp_t_api=>gt_yfi_t_0082.
    INTERFACES if_serializable_object .
    INTERFACES if_bgmc_operation .
    INTERFACES if_bgmc_op_single .
  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA  gt_pad_excel     TYPE z_pad_sunat_bp_t_api=>gt_yfi_t_0082.
ENDCLASS.



CLASS Z_PAD_SUNAT_BP_T_API_BGPF IMPLEMENTATION.


  METHOD constructor.
    gt_pad_excel[] = it_pad_excel[].
  ENDMETHOD.


  METHOD if_bgmc_op_single~execute.
     TRY.
          z_pad_sunat_bp_t_api=>save_error( i_error  = '0'  ).
          z_pad_sunat_bp_t_api=>save_error( i_error  =  lines( gt_pad_excel )  ).
          z_pad_sunat_bp_t_api=>set_tax_table( CHANGING lt_pad_excel = gt_pad_excel ).
        CATCH /iwbep/cx_cp_remote   INTO DATA(lx_my_exception).
         z_pad_sunat_bp_t_api=>save_error( i_error  = lx_my_exception->get_text(  )  ).
          "out->write( lx_my_exception->get_text(  )   ).

        CATCH cx_http_dest_provider_error INTO DATA(lx_my_exception2).
        z_pad_sunat_bp_t_api=>save_error( i_error  = lx_my_exception2->get_text(  )  ).
          "out->write( lx_my_exception2->get_text(  )   ).
      ENDTRY.
  ENDMETHOD.
ENDCLASS.
