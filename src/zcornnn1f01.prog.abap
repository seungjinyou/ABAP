DEFINE clear*.

  CLEAR &1.
  REFRESH &1.

END-OF-DEFINITION.
*&---------------------------------------------------------------------*
*&      Form  DOCK_GRID
*&---------------------------------------------------------------------*
FORM dock_grid
  USING pv_container_name
  CHANGING po_alv TYPE REF TO cl_gui_alv_grid.

*  go_splt = NEW #(
*   parent  = cl_gui_container=>default_screen
*   rows    = 2
*   columns = 1
*   ).
*
*  go_con_top = go_splt->get_container( row = 1  column = 1 ).
*  go_con_alv = go_splt->get_container( row = 2  column = 1 ).
*
*  PERFORM top_of_scr_ CHANGING go_con_top.
*
*  CREATE OBJECT po_alv
*    EXPORTING
*      i_parent = go_con_alv.

ENDFORM.                    " DOCK_GRID
*&---------------------------------------------------------------------*
*&      Form  SET_VARIANT
*&---------------------------------------------------------------------*
FORM alv_variant.

  CLEAR gs_variant.
  gs_variant-report = sy-repid.
  gs_variant-username = sy-uname.

*  CASE 'X'.
*    WHEN p_r1.
*      gs_variant-handle = 1.
*    WHEN p_r2.
*      gs_variant-handle = 2.
*  ENDCASE.

ENDFORM.                    " SET_VARIANT
*&---------------------------------------------------------------------*
*&      Form  SET_LAYOUT
*&---------------------------------------------------------------------*
FORM alv_layout.

  CLEAR gs_layout.
  gs_layout-sel_mode      = 'D'. "multiple selection
  gs_layout-zebra         = 'X'.
  gs_layout-cwidth_opt    = 'X'.

*  gs_layout-grid_title    = ''.
*  gs_layout-info_fname    = 'LINECOLOR'. "필드명
*  gs_layout-ctab_fname    = 'CELLCOLOR'.
*  gs_layout-stylefname    = 'CELLBTN'.

  "LAYOUT-EXCP_FNAME = 'LIGHT'. 1(Red)/ 2(Yellow)/ 3(Green)

ENDFORM.                    "set_layout
*&---------------------------------------------------------------------*
*&      Form  SET_EXCLUDE
*&---------------------------------------------------------------------*
FORM alv_exclude.

  DATA ls_exclude TYPE ui_func.

  CLEAR gt_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_fc_detail.
*  APPEND ls_exclude TO gt_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_fc_sort_asc.
*  APPEND ls_exclude TO gt_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_fc_sort_dsc.
*  APPEND ls_exclude TO gt_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_fc_find.
*  APPEND ls_exclude TO gt_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_mb_filter.
*  APPEND ls_exclude TO gt_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_mb_sum.
*  APPEND ls_exclude TO gt_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_fc_print.
*  APPEND ls_exclude TO gt_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_mb_view.
*  APPEND ls_exclude TO gt_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_mb_export.
*  APPEND ls_exclude TO gt_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_fc_current_variant.
*  APPEND ls_exclude TO gt_exclude.

  ls_exclude = cl_gui_alv_grid=>mc_fc_graph.
  APPEND ls_exclude TO gt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_info.
  APPEND ls_exclude TO gt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_check.
  APPEND ls_exclude TO gt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_refresh.
  APPEND ls_exclude TO gt_exclude.

  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_cut.
  APPEND ls_exclude TO gt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_copy.
  APPEND ls_exclude TO gt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_undo.
  APPEND ls_exclude TO gt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_paste_new_row.
  APPEND ls_exclude TO gt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_paste.
  APPEND ls_exclude TO gt_exclude.

*  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_insert_row.
*  APPEND ls_exclude TO gt_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_delete_row.
*  APPEND ls_exclude TO gt_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_copy_row.
*  APPEND ls_exclude TO gt_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_append_row.
*  APPEND ls_exclude TO gt_exclude.

ENDFORM.                    " SET_TOOLBAR
*&---------------------------------------------------------------------*
*&      Form  SET_FIELDCAT
*&---------------------------------------------------------------------*
FORM alv_fieldcat.

  DATA ls_fieldcat TYPE lvc_s_fcat.

  DEFINE set_nm*.

    <fs_fieldcat>-coltext   = &1.
    <fs_fieldcat>-reptext   = &1.
    <fs_fieldcat>-scrtext_l = &1.
    <fs_fieldcat>-scrtext_m = &1.
    <fs_fieldcat>-scrtext_s = &1.

  END-OF-DEFINITION.

  DEFINE set_nm_desc*.

    PERFORM get_dtel_txt USING 'BEZEI40' 'M' CHANGING gv_txt.

    READ TABLE gt_fieldcat INTO ls_fieldcat WITH KEY fieldname = &1.

    ls_fieldcat-scrtext_m = |{ ls_fieldcat-scrtext_m } { gv_txt }|.

    set_nm* ls_fieldcat-scrtext_m.

  END-OF-DEFINITION.

  CLEAR gt_fieldcat.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
*     I_buffer_active        =
      i_structure_name       = 'ZTEST'
*     I_client_never_display = 'X'
      i_bypassing_buffer     = 'X'
*     I_internal_tabname     =
    CHANGING
      ct_fieldcat            = gt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  LOOP AT gt_fieldcat ASSIGNING <fs_fieldcat>.

    CASE <fs_fieldcat>-fieldname.
      WHEN ''.
        set_nm* 'Col명'.
      WHEN OTHERS.
        <fs_fieldcat>-edit = 'X'.
    ENDCASE.

  ENDLOOP.

ENDFORM.                    " SET_FIELDCAT
*&---------------------------------------------------------------------*
*&      Form  SET_EVENT
*&---------------------------------------------------------------------*
FORM alv_event.

  CREATE OBJECT event_receiver.
  SET HANDLER event_receiver->handle_data_changed FOR go_alv.
  SET HANDLER event_receiver->handle_data_changed_f FOR go_alv.
  SET HANDLER event_receiver->handle_toolbar FOR go_alv.
  SET HANDLER event_receiver->handle_user_command FOR go_alv.
  SET HANDLER event_receiver->handle_double_click FOR go_alv.
  SET HANDLER event_receiver->handle_hotspot_click FOR go_alv.
  SET HANDLER event_receiver->handle_on_f4 FOR go_alv.
  SET HANDLER event_receiver->handle_button_click FOR go_alv.

ENDFORM.                    "SET_EVENT
*&---------------------------------------------------------------------*
*&      Form  SET_READY_FOR_INPUT
*&---------------------------------------------------------------------*
FORM alv_edit.

  "변경된 값이 존재할때, 엔터키에 trigger DATA_CHANGED event
  go_alv->register_edit_event(
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_enter ).

  "변경된 값이 존재할때, 커서아웃에 trigger DATA_CHANGED event
  go_alv->register_edit_event(
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_modified ).

  go_alv->set_ready_for_input(
    EXPORTING
      i_ready_for_input = 1 ).

ENDFORM.                    "set_ready_for_input
*&---------------------------------------------------------------------*
*&      Form  SET_F4
*&---------------------------------------------------------------------*
FORM alv_f4.

  DATA: lt_f4 TYPE lvc_t_f4,
        ls_f4 TYPE lvc_s_f4.

  CLEAR ls_f4.
  ls_f4-fieldname = 'KSTAR'.
  ls_f4-register  = 'X'.
  INSERT ls_f4 INTO TABLE lt_f4.

  CALL METHOD go_alv->register_f4_for_fields
    EXPORTING
      it_f4 = lt_f4.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_DROPDOWN
*&---------------------------------------------------------------------*
FORM set_dropdown.

  DATA: lt_dropdown TYPE lvc_t_drop,
        ls_dropdown TYPE lvc_s_drop.

  CALL METHOD go_alv->set_drop_down_table
    EXPORTING
      it_drop_down = lt_dropdown.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
FORM display
  USING po_alv     TYPE REF TO cl_gui_alv_grid
        ps_variant  TYPE disvariant
        ps_layout   TYPE lvc_s_layo
        pt_exclude  TYPE ui_functions
        pt_fieldcat TYPE lvc_t_fcat
        pt_outtab   TYPE t_outtab.

  CALL METHOD po_alv->set_table_for_first_display
    EXPORTING
      i_bypassing_buffer   = 'X'
      is_variant           = ps_variant
      i_save               = 'A' "X : only Global, U : only Specific User, A : X & U
      i_default            = 'X' "Default Display Variant
      is_layout            = ps_layout
      it_toolbar_excluding = pt_exclude
    CHANGING
      it_outtab            = pt_outtab[]
      it_fieldcatalog      = pt_fieldcat.

ENDFORM.                    "DISPLAY
*&---------------------------------------------------------------------*
*&      Form  ALV_REFRESH
*&---------------------------------------------------------------------*
FORM alv_refresh.

  go_alv->refresh_table_display(
    EXPORTING
      is_stable      = CONV #( 'XX' )   "Keep Position
      i_soft_refresh = CONV #( 'X' ) ). "Keep Sort/ Filter/ Sum...

ENDFORM.                    "REFRESH_TABLE_DISPLAY
*&---------------------------------------------------------------------*
*&      Form  ALV_CHECK_CHANGED_DATA
*&---------------------------------------------------------------------*
FORM alv_check_changed_data.

  CALL METHOD go_alv->check_changed_data
*    IMPORTING
*      e_valid   =
*    CHANGING
*      c_refresh = 'X'
    .

ENDFORM.                    " ALV_CHECK_CHANGED_DATA
**&---------------------------------------------------------------------*
**&      Form  TOP_OF_SCR
**&---------------------------------------------------------------------*
*FORM top_of_scr CHANGING po_container TYPE REF TO cl_gui_container.
*
*  DATA lv_line TYPE string.
*
*  CALL METHOD go_splt->set_row_height
*    EXPORTING
*      id     = 1
*      height = 8.
*
*  IF go_dd_document IS INITIAL.
*    CREATE OBJECT go_dd_document.
*  ENDIF.
*
*  IF go_viewer IS INITIAL.
*    CREATE OBJECT go_viewer "텍스트 뷰어 생성
*      EXPORTING
*        parent = po_container.
*  ENDIF.
*
*  DEFINE add_text_.
*    CALL METHOD go_dd_document->add_text
*      EXPORTING
*        text         = CONV #( &1 )
*        sap_style    = &2
*        sap_fontsize = '12'
*        sap_emphasis = ''.
*  END-OF-DEFINITION.
*
*  DEFINE new_line_.
*    CALL METHOD go_dd_document->new_line( repeat = 0 ).
*  END-OF-DEFINITION.
*
*  DEFINE get_text_range_.
*    CONDENSE &2.
*    CONDENSE &3.
*    IF &3 IS NOT INITIAL.
*      lv_line = |{ &1 } : { &2 } ~ { &3 }|.
*    ELSEIF &2 IS NOT INITIAL.
*      lv_line = |{ &1 } : { &2 }|.
*    ELSE.
*      lv_line = |{ &1 } : *|.
*    ENDIF.
*  END-OF-DEFINITION.
*
*  PERFORM get_dtel_txtmd USING 'KOKRS' CHANGING gv_txtmd.
*  add_text_ gv_txtmd ''.
*  lv_line = |{ p_kokrs } { gs_tka01-bezei }|.
*  add_text_ lv_line ''.
*
*  new_line_.
*  PERFORM get_dtel_txtmd USING 'KOSTL' CHANGING gv_txtmd.
*  add_text_ gv_txtmd ''.
*  lv_line = |{ p_kostl } { gs_cskt-ktext }|.
*  add_text_ lv_line ''.
*
**  new_line_.
**  PERFORM get_dtel_txtmd USING 'ZECREDT' CHANGING gv_txtmd.
**  get_text_range_ gv_txtmd s_zcredt-low s_zcredt-high.
**  add_text_ lv_line.
*
**  new_line_.
**  PERFORM get_dtel_txtmd USING 'KOSTL' CHANGING gv_txtmd.
**
**  PERFORM get_cskt USING p_kokrs s_kostl-low CHANGING gv_text1.
**  gv_text1 = |{ s_kostl-low } { gv_text1 }|.
**
**  PERFORM get_cskt USING p_kokrs s_kostl-high CHANGING gv_text2.
**  gv_text2 = |{ s_kostl-high } { gv_text2 }|.
**
**  get_text_range_ gv_txtmd gv_text1 gv_text2.
**  add_text_ lv_line.
*
*
*  go_dd_document->html_control = go_viewer.
*
*  CALL METHOD go_dd_document->display_document( reuse_control = 'X' parent = po_container ).
*
*ENDFORM.                    "TOP_OF_SCR
*&---------------------------------------------------------------------*
*&      Form  TOP_OF_SCR
*&---------------------------------------------------------------------*
FORM top_of_scr.

  DEFINE add_text*.

    &1->add_text(
       EXPORTING
         text         = CONV #( &2 )
         sap_emphasis = &3
       ).

  END-OF-DEFINITION.

  DEFINE add_separator*.

    &1->add_gap( width = 1 ).
    &1->add_text( text = CONV #( ':' ) ).
    &1->add_gap( width = 1 ).

  END-OF-DEFINITION.

  DATA(lo_doc)    = NEW cl_dd_document( ).
  DATA(lo_viewer) = NEW cl_gui_html_viewer( parent = go_con_top ).

  lo_doc->add_table(
     EXPORTING
       no_of_columns = '0'
       border        = '0'
     IMPORTING
       table = DATA(lo_tab)
   ).

  lo_tab->add_column( IMPORTING column = DATA(lo_col1) ).
  lo_tab->add_column( IMPORTING column = DATA(lo_col2) ).
  lo_tab->add_column( IMPORTING column = DATA(lo_col3) ).

  add_text*
   lo_col1
   %_p_kokrs_%_app_%-text
   cl_dd_document=>strong.

  add_separator*
   lo_col2.

  add_text*
   lo_col3
   p_kokrs
   ''.

  lo_tab->new_row( ).

  add_text*
   lo_col1
   %_p_kostl_%_app_%-text
   cl_dd_document=>strong.

  add_separator*
   lo_col2.

  add_text*
   lo_col3
   p_kostl
   ''.

  lo_doc->merge_document( ).
  lo_doc->html_control = lo_viewer.
  lo_doc->display_document( reuse_control = 'X' parent = go_con_top ).

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_SELECTED_ROW
*&---------------------------------------------------------------------*
FORM get_selected_row .

  DATA: lt_rows TYPE lvc_t_row,
        ls_row  TYPE lvc_s_row.

  CLEAR: lt_rows,
         lt_rows[],
         gs_outtab.

  CALL METHOD go_alv->get_selected_rows
    IMPORTING
      et_index_rows = lt_rows.

  CHECK NOT lt_rows[] IS INITIAL.

  LOOP AT lt_rows INTO ls_row.
    CHECK ( ls_row-rowtype IS INITIAL ) AND ( ls_row-index GT 0 ).

    CLEAR gs_outtab.
    READ TABLE gt_outtab INTO gs_outtab INDEX ls_row-index.
  ENDLOOP.

ENDFORM.                    "GET_SELECTED_ROW
*&---------------------------------------------------------------------*
*&      Form  DISPLAY_DATA_CHECK
*&---------------------------------------------------------------------*
FORM display_data_check
    USING po_data_changed TYPE REF TO cl_alv_changed_data_protocol
        ps_mod_cells TYPE lvc_s_modi
        pv_msg.

  CALL METHOD po_data_changed->add_protocol_entry
    EXPORTING
      i_msgid     = 'Z30SDM'
      i_msgty     = 'E'
      i_msgno     = '000'
      i_msgv1     = pv_msg
      i_msgv2     = ps_mod_cells-value
      i_fieldname = ps_mod_cells-fieldname
      i_row_id    = ps_mod_cells-row_id
      i_tabix     = ps_mod_cells-tabix.

  CALL METHOD po_data_changed->display_protocol.

ENDFORM.






*&---------------------------------------------------------------------*
*&      Form  SET_COLOR
*&---------------------------------------------------------------------*
FORM set_color USING pv_fnm pv_color CHANGING pt_cellcolor TYPE lvc_t_scol.
* Color : C100
*  1 : gray-blue (헤더)
*  2 : light gray (리스트)
*  3 : yellow (Total)
*  4 : blue-green (Key 컬럼)
*  5 : green
*  6 : red
*  7 : orange
*  Inverse on/off (1/0)
*  Intensified on/off (1/0)

*  DATA ls_cellcolor TYPE lvc_s_scol.
*
*  ls_cellcolor-fname = pv_fnm.
*  ls_cellcolor-color-col = pv_color.
*  ls_cellcolor-color-int = 1.
*  ls_cellcolor-color-inv = 0.
*  DELETE pt_cellcolor WHERE fname = pv_fnm.
*  INSERT ls_cellcolor INTO TABLE pt_cellcolor.

ENDFORM.                    "SET_COLOR
*&---------------------------------------------------------------------*
*&      Form  SHOW_RESULT
*&---------------------------------------------------------------------*
FORM show_result USING pt_return TYPE tab_bdcmsgcoll.

  CHECK pt_return IS NOT INITIAL.

  CALL FUNCTION 'MESSAGES_INITIALIZE'.

  LOOP AT pt_return INTO DATA(ls_return).
    CALL FUNCTION 'MESSAGE_STORE'
      EXPORTING
        arbgb                  = ls_return-msgid
        msgty                  = ls_return-msgtyp
        msgv1                  = ls_return-msgv1
        msgv2                  = ls_return-msgv2
        msgv3                  = ls_return-msgv3
        msgv4                  = ls_return-msgv4
        txtnr                  = ls_return-msgnr
      EXCEPTIONS
        message_type_not_valid = 1
        not_active             = 2
        OTHERS                 = 3.
  ENDLOOP.

  CALL FUNCTION 'MESSAGES_SHOW'
    EXPORTING
      i_use_grid         = 'X'  " Comment for list display
      batch_list_type    = 'L'
    EXCEPTIONS
      inconsistent_range = 1
      no_messages        = 2
      OTHERS             = 3.

  CALL FUNCTION 'MESSAGES_INITIALIZE'.

ENDFORM.                    "show_result






*&---------------------------------------------------------------------*
*&      Form  ALV_TOOLBAR
*&---------------------------------------------------------------------*
FORM alv_toolbar
  USING po_object TYPE REF TO cl_alv_event_toolbar_set
        pv_interactive.

  po_object->mt_toolbar = VALUE #(

    BASE po_object->mt_toolbar

    (
      function  = '&ALL'
      icon      = icon_select_all
      quickinfo = 'Select All'
      text      = 'Select All'
    )
    (
      function  = '&SAL'
      icon      = icon_deselect_all
      quickinfo = 'Deselect All'
      text      = 'Deselect All'
    )
  ).

ENDFORM.                    "alv_toolbar
*&---------------------------------------------------------------------*
*&      Form  ALV_COMMAND
*&---------------------------------------------------------------------*
FORM alv_command USING e_ucomm.

  CASE e_ucomm.
    WHEN 'BTN01'.
      "PERFORM btn01.

  ENDCASE.

  PERFORM alv_refresh.

ENDFORM.                    "alv_command
*&---------------------------------------------------------------------*
*&      Form  btn01
*&---------------------------------------------------------------------*
FORM btn01_xxx.

*  DATA: lt_index_rows  TYPE lvc_t_row,
*        lt_row_no      TYPE lvc_t_roid,
*        ls_row_no      LIKE LINE OF lt_row_no,
*        lv_kunnrs     TYPE string.
*
*  CALL METHOD go_alv->get_selected_rows
*    IMPORTING
*      et_index_rows = lt_index_rows
*      et_row_no     = lt_row_no.
*
*  IF lt_row_no IS INITIAL.
*    MESSAGE s000 WITH text-mnn. "선택된 라인이 없습니다.
*    EXIT.
*  ENDIF.
*
*  LOOP AT lt_row_no INTO ls_row_no.
*    CLEAR gs_outtab.
*    READ TABLE gt_outtab INTO gs_outtab INDEX ls_row_no-row_id.
*
*  ENDLOOP.

ENDFORM.                    " BTN01_TEST
























*&---------------------------------------------------------------------*
*&      Form  CREATE_FCAT
*&---------------------------------------------------------------------*
FORM create_fcat_xxx.

  DATA: lt_fieldcat TYPE slis_t_fieldcat_alv.

  clear* lt_fieldcat.

  SET PARAMETER ID 'ALVBUFFER' FIELD sy-datum.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-repid
      i_internal_tabname     = 'GT_ITAB'
      i_inclname             = sy-repid
      i_bypassing_buffer     = 'X'
    CHANGING
      ct_fieldcat            = lt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  CALL FUNCTION 'LVC_TRANSFER_FROM_SLIS'
    EXPORTING
      it_fieldcat_alv = lt_fieldcat
    IMPORTING
      et_fieldcat_lvc = gt_fieldcat
    TABLES
      it_data         = gt_outtab
    EXCEPTIONS
      it_data_missing = 1
      OTHERS          = 2.

ENDFORM.                    " CREATE_FCAT
*&---------------------------------------------------------------------*
*&      Form  SET_SORT
*&---------------------------------------------------------------------*
FORM alv_sort.

  CLEAR gt_sort.

  DEFINE sort*.
    APPEND VALUE lvc_s_sort(
      spos      = &1
      fieldname = &2
      up        = &3
      down      = &4
      subtot    = &5 ) TO gt_sort.
  END-OF-DEFINITION.

*  sort* '01' 'BUKRS' 'X' '' 'X'.

ENDFORM.                    " SETTING_SORT























*&---------------------------------------------------------------------*
*&      Form  SET_BUTTON
*&---------------------------------------------------------------------*
FORM set_button.

  DATA ls_functxt TYPE smp_dyntxt.

  ls_functxt-icon_id    = icon_xls.
  ls_functxt-text       = TEXT-w01.
  ls_functxt-icon_text  = ls_functxt-text.
  sscrfields-functxt_01 = ls_functxt.

ENDFORM.                    " SET_BUTTON





















*&---------------------------------------------------------------------*
*&      Form  GET_FORM
*&---------------------------------------------------------------------*
FORM get_form
     USING pv_name
           pv_form.

  DATA: lv_filename    TYPE string,
        lv_path        TYPE string,
        lv_fullpath    TYPE string,
        lv_user_action TYPE i,
        lv_destination TYPE rlgrap-filename,
        ls_key         TYPE wwwdatatab.

  CALL METHOD cl_gui_frontend_services=>file_save_dialog
    EXPORTING
*     window_title              =
      default_extension         = 'XLS'
      default_file_name         = pv_name
*     with_encoding             =
*     file_filter               =
*     initial_directory         =
*     prompt_on_overwrite       = 'X'
    CHANGING
      filename                  = lv_filename
      path                      = lv_path
      fullpath                  = lv_fullpath
      user_action               = lv_user_action
*     file_encoding             =
    EXCEPTIONS
      cntl_error                = 1
      error_no_gui              = 2
      not_supported_by_gui      = 3
      invalid_default_file_name = 4
      OTHERS                    = 5.

  IF lv_user_action = cl_gui_frontend_services=>action_cancel.
    EXIT.
  ENDIF.

  SELECT SINGLE
         f~relid,
         f~objid,
         f~checkout,
         f~checknew,
         f~chname,
         f~tdate,
         f~ttime,
         f~text,
         p~devclass
    INTO CORRESPONDING FIELDS OF @ls_key
    FROM wwwdata AS f
    JOIN tadir AS p
      ON f~objid EQ p~obj_name
   WHERE f~srtf2 EQ 0
     AND f~relid EQ 'MI'
     AND p~pgmid EQ 'R3TR'
     AND p~object EQ 'W3MI'
     AND p~obj_name EQ @pv_form.

  lv_destination = lv_fullpath.
  CALL FUNCTION 'DOWNLOAD_WEB_OBJECT'
    EXPORTING
      key         = ls_key
      destination = lv_destination.

  CALL METHOD cl_gui_frontend_services=>execute
    EXPORTING
      document               = lv_fullpath
    EXCEPTIONS
      cntl_error             = 1
      error_no_gui           = 2
      bad_parameter          = 3
      file_not_found         = 4
      path_not_found         = 5
      file_extension_unknown = 6
      error_execute_failed   = 7
      synchronous_failed     = 8
      not_supported_by_gui   = 9
      OTHERS                 = 10.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.                    "GET_FORM
*&---------------------------------------------------------------------*
*&      Form  GET_FORM
*&---------------------------------------------------------------------*
*FORM get_form_02
*     USING p_name
*           p_id.
*
*  IF go_factory IS INITIAL.
*    CALL METHOD c_oi_factory_creator=>get_document_factory
*      IMPORTING
*        factory = go_factory
*        retcode = gv_retcode.
*
*    IF gv_retcode NE c_oi_errors=>ret_ok.
*      MESSAGE s000 WITH TEXT-mnn DISPLAY LIKE 'E'. "Fail to get document factory
*      EXIT.
*    ENDIF.
*
*    CALL METHOD go_factory->start_factory
*      EXPORTING
*        r3_application_name = p_name
*      IMPORTING
*        retcode             = gv_retcode.
*
*    CALL METHOD go_factory->get_link_server
*      IMPORTING
*        link_server = go_link_server
*        retcode     = gv_retcode.
*
*    CALL METHOD go_link_server->start_link_server
*      EXPORTING
*        link_server_mode = 3
*      IMPORTING
*        retcode          = gv_retcode.
*  ENDIF.
*
*  CLEAR gt_doc_table[].
*  CALL FUNCTION 'SAP_OI_LOAD_MIME_DATA'
*    EXPORTING
*      object_id        = p_id "SMW0 정의된 문서
*    IMPORTING
*      data_size        = gv_doc_size
*      document_format  = gv_doc_format
*      document_type    = gv_doc_type
*    TABLES
*      data_table       = gt_doc_table
*    EXCEPTIONS
*      object_not_found = 1
*      internal_error   = 2
*      OTHERS           = 3.
*
*  IF sy-subrc NE 0.
*    "Fail to load MIME data from SAP Web Repository
*    MESSAGE s000 WITH TEXT-mnn DISPLAY LIKE 'E'.
*    EXIT.
*  ENDIF.
*
*  IF gv_doc_size NE 0.
*    "FACTORY 와 DOCUMENT 연결
*    CALL METHOD go_factory->get_document_proxy
*      EXPORTING
*        document_type  = gv_doc_type
*      IMPORTING
*        document_proxy = go_document
*        retcode        = gv_retcode.
*
*    "Document를 Open하고 매크로를 실행함.
*    CALL METHOD go_document->open_document_from_table
*      EXPORTING
*        document_table = gt_doc_table[]
*        document_size  = gv_doc_size
**       startup_macro  = 'macro00'
*      IMPORTING
*        retcode        = gv_retcode.
*
*  ENDIF.
*
*ENDFORM.                    "GET_FORM
*&---------------------------------------------------------------------*
*&      Form  GET_FORM
*&---------------------------------------------------------------------*
FORM get_form_03.

*  CLEAR gs_exl_header.
*  gs_exl_header-col_01 = 'Customer'.
*  gs_exl_header-col_02 = 'Credit control area'.
*  gs_exl_header-col_03 = 'Credit limit amount'.
*
*  DATA: ls_application TYPE ole2_object,
*        ls_workbook    TYPE ole2_object,
*        ls_sheet       TYPE ole2_object,
*        ls_cells       TYPE ole2_object.
*
*  DATA: lv_index(2)  TYPE n,
*        lv_field(20) TYPE c.
*
*  FIELD-SYMBOLS: <value> TYPE any.
*
*  CREATE OBJECT ls_application 'excel.application'.
*
*  SET PROPERTY OF ls_application 'visible' = 1.
*
*  CALL METHOD OF
*      ls_application
*      'Workbooks'    = ls_workbook.
*
*  CALL METHOD OF
*      ls_workbook
*      'Add'.
*
** Create first Excel Sheet
*  CALL METHOD OF
*      ls_application
*      'Worksheets'   = ls_sheet
*    EXPORTING
*      #1             = 1.
*
*  CALL METHOD OF
*      ls_sheet
*      'Activate'.
*
*  SET PROPERTY OF ls_sheet 'Name' = 'Sheet1'.
*
*  CLEAR lv_index.
*  DO 3 TIMES.
*    ADD 1 TO lv_index.
*
*    CALL METHOD OF
*        ls_sheet
*        'Cells'  = ls_cells
*      EXPORTING
*        #1       = lv_index.
*
*    CONCATENATE 'gs_exl_header-COL_' lv_index INTO lv_field.
*
*    ASSIGN (lv_field) TO <value>.
*
*    SET PROPERTY OF ls_cells 'Value' = <value>.
*  ENDDO.

ENDFORM.                    " GET_FORM
*&---------------------------------------------------------------------*
*&      Form  GET_EXCEL
*&---------------------------------------------------------------------*
FORM get_excel.

*  DEFINE get_amt_.
*
*    REPLACE ALL OCCURRENCES OF ',' IN &1 WITH ''.
*    &2 = &1.
*    PERFORM currency_conv_to_internal USING &3 CHANGING &2.
*
*  END-OF-DEFINITION.

*  DATA: lt_excel      TYPE TABLE OF alsmex_tabline,
*        lv_begin_row  TYPE i,
*        lv_end_row    TYPE i,
*        lv_range_rows TYPE i VALUE 500,
*        lo_cx         TYPE REF TO cx_root.
*  DATA: lv_msg TYPE string.
*
*  CLEAR: lv_begin_row,
*         lv_end_row.
*
*  lv_begin_row = 2.
*  lv_end_row = lv_begin_row + lv_range_rows - 1.
*
*  CLEAR gt_excel.
*  DO.
*    CLEAR lt_excel.
*    CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
*      EXPORTING
*        filename                = p_fname
*        i_begin_col             = 1
*        i_begin_row             = lv_begin_row
*        i_end_col               = 14
*        i_end_row               = lv_end_row
*      TABLES
*        intern                  = lt_excel
*      EXCEPTIONS
*        inconsistent_parameters = 1
*        upload_ole              = 2
*        OTHERS                  = 3.
*
*    IF lt_excel IS INITIAL.
*      EXIT.
*    ELSE.
*      APPEND LINES OF lt_excel TO gt_excel.
*    ENDIF.
*
*    lv_begin_row = lv_end_row + 1.
*    lv_end_row = lv_begin_row + lv_range_rows - 1.
*  ENDDO.
*
*  IF gt_excel IS INITIAL.
*    MESSAGE s000 WITH TEXT-m04 DISPLAY LIKE 'E'. "업로드된 데이터가 없습니다.
*    LEAVE LIST-PROCESSING.
*
*  ELSE.
*    CLEAR gt_outtab.
*    LOOP AT gt_excel INTO gs_excel.
*      AT NEW row.
*        CLEAR gs_outtab.
*      ENDAT.
*
*      CONDENSE gs_excel-value.
*
*      TRY.
*          CASE gs_excel-col.
*            WHEN 1.
*              get_amt_ gs_excel-value gs_outtab-nnnn gs_tka01-waers.
*
*            WHEN 2.
*              IF sy-subrc <> 0.
*                IF gs_outtab-icon IS INITIAL.
*                  gs_outtab-icon = icon_red_light.
*                  PERFORM get_dtel_txtmd USING 'KDGRP' CHANGING gv_txtmd.
*                  MESSAGE s021 WITH gv_txtmd INTO gs_outtab-msg. "유효하지 않은 XX 입니다.
*                ENDIF.
*              ENDIF.
*
*          ENDCASE.
*
*        CATCH cx_root INTO lo_cx.
*          lv_msg = lo_cx->get_text( ).
*
*      ENDTRY.
*
*      AT END OF row.
*        APPEND gs_outtab TO gt_outtab.
*      ENDAT.
*    ENDLOOP.
*  ENDIF.

ENDFORM.                    " GET_EXCEL
























**&---------------------------------------------------------------------*
**&      Form  SET_BDC_OPTION
**&---------------------------------------------------------------------*
*FORM set_bdc_option USING    pv_defsize
*                             pv_updmode
*                             pv_cattmode
*                             pv_dismode
*                             pv_raccommit
*                             pv_nobinpi
*                    CHANGING ps_ctu_params STRUCTURE ctu_params.
*  ps_ctu_params-defsize  = pv_defsize.
*  ps_ctu_params-updmode  = pv_updmode.
*  ps_ctu_params-cattmode = pv_cattmode.
*  ps_ctu_params-dismode  = pv_dismode.
*  ps_ctu_params-racommit = pv_raccommit.
*  ps_ctu_params-nobinpt  = pv_nobinpi.
*ENDFORM.                    " SET_BDC_OPTION
*&---------------------------------------------------------------------*
*&      Form  DYNPRO
*&---------------------------------------------------------------------*
*FORM dynpro USING pv_dynbegin pv_name pv_value.
*  PERFORM set_dynpro_tab TABLES gt_bdcdata
*                         USING  pv_dynbegin pv_name pv_value.
*ENDFORM.                    "DYNPRO
*&---------------------------------------------------------------------*
*&      Form  SET_DYNPRO_TAB
*&---------------------------------------------------------------------*
*FORM set_dynpro_tab  TABLES pt_bdctab STRUCTURE bdcdata
*                     USING  pv_dynbegin
*                            pv_name
*                            pv_value.
*
*  DATA: ls_bdctab TYPE bdcdata.
*
*  IF pv_dynbegin = 'X'.
*    MOVE: pv_name  TO ls_bdctab-program,
*          pv_value TO ls_bdctab-dynpro,
*               'X' TO ls_bdctab-dynbegin.
*    APPEND ls_bdctab TO pt_bdctab.
*
*  ELSE.
*    MOVE: pv_name  TO ls_bdctab-fnam,
*          pv_value TO ls_bdctab-fval.
*    APPEND ls_bdctab TO pt_bdctab.
*  ENDIF.
*
*ENDFORM.                    "SET_DYNPRO_TAB
*&---------------------------------------------------------------------*
*&      Form  DYNPRO
*&---------------------------------------------------------------------*
FORM dynpro
  USING pv_dynbegin
        pv_fnam
        pv_fval.

*  CLEAR gs_bdcdata.
*  IF pv_dynbegin = 'X'.
*    gs_bdcdata-dynbegin = 'X'.
*    gs_bdcdata-program = pv_fnam.
*    gs_bdcdata-dynpro = pv_fval.
*
*  ELSE.
*    gs_bdcdata-fnam = pv_fnam.
*    gs_bdcdata-fval = pv_fval.
*
*  ENDIF.
*
*  APPEND gs_bdcdata TO gt_bdcdata.

ENDFORM.                    "DYNPRO
*&---------------------------------------------------------------------*
*&      Form  RUN_BDC
*&---------------------------------------------------------------------*
FORM run_bdc.

*  LOOP AT gt_outtab ASSIGNING <fs_outtab> WHERE icon = icon_yellow_light.
*
*    CLEAR gt_bdcdata.
*    PERFORM dynpro USING :
*        'X'  'SAPMF02D'      '0105',
*        ''   'BDC_OKCODE'    '/00' ,
*        ''   'RF02D-KTOKD'   'CPD' ,
*        ''   'USE_ZAV'       'X'   .
*
*    PERFORM dynpro USING :
*        'X' 'SAPMF02D'             '0111'       ,
*        ''  'BDC_OKCODE'           '=UPDA'      ,
*        ''  'ADDR1_DATA-NAME1'     <fs_outtab>-name1,
*        ''  'ADDR1_DATA-COUNTRY'   <fs_outtab>-land1,
*        ''  'ADDR1_DATA-REGION'    <fs_outtab>-regio,
*        ''  'ADDR1_DATA-LANGU'     <fs_outtab>-spras,
*        ''  'SZA1_D0100-SMTP_ADDR' <fs_outtab>-smtp_addr.
*
*    CLEAR gt_bdcmsgcoll.
*    CALL TRANSACTION 'FD01' USING gt_bdcdata
*       MODE p_mode
*       MESSAGES INTO gt_bdcmsgcoll UPDATE 'S'.
*
*    <fs_outtab>-bdcmsg = gt_bdcmsgcoll.
*
*    CLEAR gs_bdcmsgcoll.
*    READ TABLE gt_bdcmsgcoll INTO gs_bdcmsgcoll WITH KEY msgtyp = 'S'
*                                                         msgnr  = '170'.
*
*    IF sy-subrc = 0.
*      <fs_outtab>-icon = icon_green_light.
*      <fs_outtab>-kunnr = gs_bdcmsgcoll-msgv1.
*      PERFORM build_message USING gs_bdcmsgcoll CHANGING <fs_outtab>-msg.
*    ELSE.
*      <fs_outtab>-icon = icon_red_light.
*      <fs_outtab>-msg = TEXT-mnn. "BDC 실행중 오류가 발생했습니다. 클릭하여 상세 메세지를 확인하세요.
*    ENDIF.
*
*  ENDLOOP.
*
*  IF sy-subrc = 0.
*    MESSAGE s000 WITH text-mnn. "BDC를 수행하였습니다. 수행 결과 Message를 확인하세요.
*  ELSE.
*    MESSAGE s000 WITH text-mnn DISPLAY LIKE 'W'. "반영할 데이터가 없습니다.
*  ENDIF.

ENDFORM.                    " RUN_BDC




















*&---------------------------------------------------------------------*
*&      Form  BUILD_MESSAGE
*&---------------------------------------------------------------------*
FORM build_message USING pv_msgid
                         pv_msgnr
                         pv_msgv1
                         pv_msgv2
                         pv_msgv3
                         pv_msgv4
                   CHANGING pv_text.

  CALL FUNCTION 'MESSAGE_TEXT_BUILD'
    EXPORTING
      msgid               = pv_msgid
      msgnr               = pv_msgnr
      msgv1               = pv_msgv1
      msgv2               = pv_msgv2
      msgv3               = pv_msgv3
      msgv4               = pv_msgv4
    IMPORTING
      message_text_output = pv_text.

ENDFORM.                    " BUILD_MESSAGE
*&---------------------------------------------------------------------*
*&      Form  BUILD_BDC_MESSAGE
*&---------------------------------------------------------------------*
FORM build_bdc_message USING    ps_message STRUCTURE bdcmsgcoll
                       CHANGING pv_text.

  CALL FUNCTION 'MESSAGE_TEXT_BUILD'
    EXPORTING
      msgid               = ps_message-msgid
      msgnr               = ps_message-msgnr
      msgv1               = ps_message-msgv1
      msgv2               = ps_message-msgv2
      msgv3               = ps_message-msgv3
      msgv4               = ps_message-msgv4
    IMPORTING
      message_text_output = pv_text.

ENDFORM.                    " BUILD_BDC_MESSAGE
*&---------------------------------------------------------------------*
*&      Form  BUILD_BAPI_MESSAGE
*&---------------------------------------------------------------------*
FORM build_bapi_message USING    ps_message STRUCTURE bapiret2
                        CHANGING pv_text.

  CALL FUNCTION 'MESSAGE_TEXT_BUILD'
    EXPORTING
      msgid               = ps_message-id
      msgnr               = ps_message-number
      msgv1               = ps_message-message_v1
      msgv2               = ps_message-message_v2
      msgv3               = ps_message-message_v3
      msgv4               = ps_message-message_v4
    IMPORTING
      message_text_output = pv_text.

ENDFORM.                    " BUILD_BAPI_MESSAGE
*&---------------------------------------------------------------------*
*&      Form  CONFIRM
*&---------------------------------------------------------------------*
FORM confirm
  USING pv_question
  CHANGING pv_answer.

*  CLEAR pv_answer.
*  CALL FUNCTION 'POPUP_TO_CONFIRM'
*    EXPORTING
*      titlebar              = 'Confirm'
**     DIAGNOSE_OBJECT       = ' '
*      text_question         = pv_question
*      text_button_1         = 'YES'
**     ICON_BUTTON_1         = ' '
*      text_button_2         = 'NO'
**     ICON_BUTTON_2         = ' '
*      default_button        = '1'
*      display_cancel_button = ''
**     USERDEFINED_F1_HELP   = ' '
**     START_COLUMN          = 25
**     START_ROW             = 6
**     POPUP_TYPE            =
**     IV_QUICKINFO_BUTTON_1 = ' '
**     IV_QUICKINFO_BUTTON_2 = ' '
*    IMPORTING
*      answer                = pv_answer. "예 1/ 아니오 2/ 취소 A

  CLEAR pv_answer.
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
*     DEFAULTOPTION  = 'Y'
      textline1      = pv_question
*     TEXTLINE2      = ' '
      titel          = 'Confirm'
*     START_COLUMN   = 25
*     START_ROW      = 6
      cancel_display = ''
    IMPORTING
      answer         = pv_answer. "예 J/ 아니오 N/ 취소 Y

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CONV
*&---------------------------------------------------------------------*
* PERFORM conv USING 'ALPHA' 'IN' 'Var1' CHANGING 'Var2'.
*&---------------------------------------------------------------------*
FORM conv
  USING pv_routine
        pv_inout
        pv_input
  CHANGING pv_output.

  DATA lv_fm_nm TYPE rs38l_fnam.

  lv_fm_nm = |CONVERSION_EXIT_{ pv_routine }_{ pv_inout }PUT|.

  CALL FUNCTION lv_fm_nm
    EXPORTING
      input  = pv_input
    IMPORTING
      output = pv_output.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DTEL_TXTMD
*&---------------------------------------------------------------------*
FORM get_dtel_txtmd USING pv_dtelnm
                    CHANGING pv_txtmd.

  DATA ls_dtel TYPE rsddtel.

*내역 : TXTLG
*짧은 : 없음
*중간 : TXTSH
*긴   : TXTMD
*헤딩 : TXTHD

  CALL FUNCTION 'RSD_DTEL_GET'
    EXPORTING
      i_dtelnm = pv_dtelnm
    IMPORTING
      e_s_dtel = ls_dtel.

  pv_txtmd = ls_dtel-txtmd.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DTEL_TXT
*&---------------------------------------------------------------------*
FORM get_dtel_txt
  USING pv_dtel
        pv_label
  CHANGING pv_txt.

  CLEAR pv_txt.

  SELECT SINGLE *
    FROM dd04t
    INTO @DATA(dd04t)
   WHERE rollname   = @pv_dtel
     AND ddlanguage = @sy-langu.

  CHECK sy-subrc = 0.

  CASE pv_label.
    WHEN 'M'.
      pv_txt = dd04t-scrtext_m.
    WHEN 'L'.
      pv_txt = dd04t-scrtext_l.
    WHEN 'S'.
      pv_txt = dd04t-scrtext_s.
  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DOMAIN_VALUES
*&---------------------------------------------------------------------*
FORM get_domain_values USING pv_domname CHANGING pt_tab TYPE t_dd07v.

  "DOMVALUE_L | ddtext

  CLEAR pt_tab.
  CALL FUNCTION 'GET_DOMAIN_VALUES'
    EXPORTING
      domname    = pv_domname
    TABLES
      values_tab = pt_tab.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DOMAIN_TEXT
*&---------------------------------------------------------------------*
FORM get_domain_text USING pv_domname pv_domvalue CHANGING pv_ddtext.

  CLEAR pv_ddtext.

  CALL FUNCTION 'DOMAIN_VALUE_GET'
    EXPORTING
      i_domname  = pv_domname
      i_domvalue = pv_domvalue
    IMPORTING
      e_ddtext   = pv_ddtext
    EXCEPTIONS
      not_exist  = 1
      OTHERS     = 2.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DOMVALUES
*&---------------------------------------------------------------------*
FORM get_domvalues
USING pv_domname
CHANGING pt_dd07v_tab TYPE swdtdd07v.

  "DOMVALUE_L | ddtext

  CLEAR pt_dd07v_tab.
  CALL FUNCTION 'DD_DOMVALUES_GET'
    EXPORTING
      domname        = pv_domname
      text           = 'X'
      langu          = sy-langu
    TABLES
      dd07v_tab      = pt_dd07v_tab
    EXCEPTIONS
      wrong_textflag = 1
      OTHERS         = 2.

ENDFORM.                    " GET_DOMVALUES
*&---------------------------------------------------------------------*
*& Form GET_MONTH_NAMES
*&---------------------------------------------------------------------*
FORM get_month_names TABLES pt_month_names.

  CALL FUNCTION 'MONTH_NAMES_GET'
*   EXPORTING
*     LANGUAGE              = SY-LANGU
*    IMPORTING
*      return_code           =
    TABLES
      month_names           = pt_month_names
    EXCEPTIONS
      month_names_not_found = 1
      OTHERS                = 2.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_LAST_DAY_OF_MONTH
*&---------------------------------------------------------------------*
FORM get_last_day_of_month
  USING    pv_gjahr
           pv_month
  CHANGING pv_last_day.

  pv_last_day = |{ pv_gjahr }{ pv_month }01|.

  CALL FUNCTION 'LAST_DAY_OF_MONTHS'
    EXPORTING
      day_in            = pv_last_day
    IMPORTING
      last_day_of_month = pv_last_day
    EXCEPTIONS
      day_in_no_date    = 1
      OTHERS            = 2.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_DAY_OF_MONTH
*&---------------------------------------------------------------------*
FORM get_day_of_month  USING    pv_gjahr
                                pv_poper
                       CHANGING pr_budat TYPE r_budat.

  DATA ls_budat TYPE s_budat.

  CLEAR pr_budat.

  ls_budat = 'IBT'.
  CONCATENATE pv_gjahr pv_poper+1(2) '01' INTO ls_budat-low.

  CALL FUNCTION 'LAST_DAY_OF_MONTHS'
    EXPORTING
      day_in            = ls_budat-low
    IMPORTING
      last_day_of_month = ls_budat-high
    EXCEPTIONS
      day_in_no_date    = 1
      OTHERS            = 2.

  APPEND ls_budat TO pr_budat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CURR_CONV_OUT
*&---------------------------------------------------------------------*
FORM curr_conv_out
  USING p_waers
        p_in
  CHANGING p_out.

  CLEAR p_out.

  DATA lv_currency TYPE tcurc-waers.
  DATA lv_amount_external TYPE bapicurr-bapicurr.

  CHECK p_waers IS NOT INITIAL.
  CHECK p_in IS NOT INITIAL.

  lv_currency = p_waers.
  CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_EXTERNAL'
    EXPORTING
      currency        = lv_currency
      amount_internal = p_in
    IMPORTING
      amount_external = lv_amount_external.

  p_out = lv_amount_external.

ENDFORM.                    "CURR_CONV_OUT
*&---------------------------------------------------------------------*
*&      Form  CURR_CONV_IN
*&---------------------------------------------------------------------*
FORM curr_conv_in
  USING p_waers
        p_out
  CHANGING p_in.

  CLEAR p_in.

  DATA lv_currency TYPE tcurc-waers.
  DATA lv_amount_external LIKE bapicurr-bapicurr.

  CHECK p_waers IS NOT INITIAL.
  CHECK p_out IS NOT INITIAL.

  lv_currency = p_waers.
  lv_amount_external = p_out.
  CALL FUNCTION 'BAPI_CURRENCY_CONV_TO_INTERNAL'
    EXPORTING
      currency             = lv_currency
      amount_external      = lv_amount_external
      max_number_of_digits = 23
    IMPORTING
      amount_internal      = p_in
*     RETURN               =
    .

ENDFORM.                    " CURR_CONV_IN
*&---------------------------------------------------------------------*
*&      Form  POPUP_GET_VALUES
*&---------------------------------------------------------------------*
FORM popup_get_values.

  DATA: lt_fields LIKE TABLE OF sval,
        ls_fields LIKE sval.

  ls_fields-tabname = 'SCUSTOM'.
  ls_fields-fieldname = 'ID'.
  APPEND ls_fields TO lt_fields.

  CALL FUNCTION 'POPUP_GET_VALUES'
    EXPORTING
*     NO_VALUE_CHECK  = ' '
      popup_title     = '고객정보'
*     START_COLUMN    = '5'
*     START_ROW       = '5'
*   IMPORTING
*     RETURNCODE      =
    TABLES
      fields          = lt_fields
    EXCEPTIONS
      error_in_fields = 1
      OTHERS          = 2.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
     WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  READ TABLE lt_fields INTO ls_fields INDEX 1.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  CONVERSION_DATE_DDMMYYYY
*&---------------------------------------------------------------------*
FORM conversion_date_ddmmyyyy_xxx
  USING    VALUE(pv_date)
  CHANGING VALUE(pv_ddmmyyyy).

  "사용자 날짜 포맷지정과 무관하게 항상 ddmmyyyy 타입의 날짜포맷을 리턴

  DATA: lo_descr_ref TYPE REF TO cl_abap_typedescr.
  DATA: lv_date(10).
  lo_descr_ref = cl_abap_typedescr=>describe_by_data( pv_date ).

  CHECK pv_date IS NOT INITIAL.
  CHECK lo_descr_ref->type_kind EQ 'D'.

  CLEAR lv_date.
  CALL FUNCTION 'CONVERT_DATE_TO_INTERN_FORMAT'
    EXPORTING
      datum = pv_date
      dtype = 'DATS'
    IMPORTING
*     ERROR =
      idate = lv_date
*     MESSG =
*     MSGLN =
    .
  CONCATENATE lv_date+6(2) lv_date+4(2) lv_date+0(4) INTO pv_ddmmyyyy.

ENDFORM.                    " CONVERSION_DATE_DDMMYYYY






















*&---------------------------------------------------------------------*
*&      Form  GET_TKA01
*&---------------------------------------------------------------------*
FORM get_tka01 USING pv_kokrs.

  CLEAR gs_tka01.
  SELECT SINGLE *
    FROM tka01 "관리회계영역
    INTO @gs_tka01
   WHERE kokrs = @pv_kokrs.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_TKA02
*&---------------------------------------------------------------------*
* 회사코드 : 관리회계영역 = 1 : 1
*&---------------------------------------------------------------------*
FORM get_tka02.

  CLEAR gs_tka02.
  SELECT SINGLE *
    FROM tka02 "관리회계영역
    INTO @gs_tka02
   WHERE kokrs = @p_kokrs.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_CSKS
*&---------------------------------------------------------------------*
FORM get_csks.

  CLEAR gs_csks.
  SELECT SINGLE *
    FROM csks
    INTO @gs_csks
   WHERE kokrs = @p_kokrs
     AND kostl = @p_kostl.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_CSKS
*&---------------------------------------------------------------------*
FORM get_cskt.

  CLEAR gs_cskt.
  SELECT SINGLE *
    FROM cskt
    INTO @gs_cskt
     WHERE kokrs = @p_kokrs
       AND kostl = @p_kostl
       AND datbi = '99991231'
       AND spras = @sy-langu.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_PRPS
*&---------------------------------------------------------------------*
FORM get_prps .

  CLEAR gs_prps.
  SELECT SINGLE *
    FROM prps
    INTO @gs_prps
   WHERE posid = @p_posid.

ENDFORM.



















*&---------------------------------------------------------------------*
*& Form INITIALIZATION
*&---------------------------------------------------------------------*
FORM initialization.

  PERFORM set_button.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form START-OF-SELECTION
*&---------------------------------------------------------------------*
FORM start-of-selection.

  gt_outtab = VALUE #(
    ( col1 = 1 )
    ( col1 = 1 )
    ( col1 = 1 )
    ( col1 = 1 )
    ( col1 = 1 )
    ( col1 = 1 )
    ( col1 = 1 )
    ( col1 = 1 )
    ( col1 = 1 )
    ( col1 = 1 )
    ( col1 = 1 )
    ( col1 = 1 )
    ( col1 = 1 )
    ( col1 = 1 )
    ( col1 = 1 )
    ( col1 = 1 )
    ( col1 = 2 )
    ( col1 = 3 )
    ( col1 = 4 )
  ).


*<<-- 엑셀업로드인 경우
*  PERFORM get_excl USING p_fname CHANGING gt_excl.
*
*  CLEAR gt_outtab.
*  LOOP AT gt_excl INTO gs_excl.
*
*    CLEAR gs_outtab.
*    MOVE-CORRESPONDING gs_excl TO gs_outtab.
*
**    gs_outtab-icon = icon_red_light.
**    gs_outtab-msg = ''.
**
**    IF gs_outtab-icon IS INITIAL.
**      gs_outtab-icon = icon_yellow_light.
**    ENDIF.
*
*    APPEND gs_outtab TO gt_outtab.
*
*  ENDLOOP.
*
*  PERFORM check_dup CHANGING gt_outtab.
*>>-- 엑셀업로드인 경우



ENDFORM.
*&---------------------------------------------------------------------*
*& Form END-OF-SELECTION
*&---------------------------------------------------------------------*
FORM end-of-selection .

  CALL SCREEN 1100.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECTION-SCREEN
*&---------------------------------------------------------------------*
FORM selection-screen .

  CASE sscrfields-ucomm.
    WHEN 'FC01'.
      PERFORM get_form USING 'Default_file_name' 'Obj_name'.

    WHEN 'ONLI'.
      PERFORM check_input.

  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form VALUE-REQUEST-FNAME
*&---------------------------------------------------------------------*
FORM value-request-fname .

  CALL FUNCTION 'WS_FILENAME_GET'
    EXPORTING
      def_path         = 'C:/'
      mask             = ',*.xls,*.xls,*.xlsx,*.xlsx.'
      mode             = 'O'
    IMPORTING
      filename         = p_fname
    EXCEPTIONS
      inv_winsys       = 1
      no_batch         = 2
      selection_cancel = 3
      selection_error  = 4
      OTHERS           = 5.

  IF sy-subrc <> 0.
    MESSAGE s022. "파일선택이 취소 되었습니다.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SELECTION-SCREEN-OUTPUT
*&---------------------------------------------------------------------*
FORM selection-screen-output .

*  LOOP AT SCREEN.
*
*    IF screen-group1 = 'G1'.
*      CASE 'X'.
*        WHEN p_r1.
*          screen-active = '1'.
*        WHEN p_r2.
*          screen-active = '0'.
*      ENDCASE.
*
*    IF screen-name = 'P_KOKRS'.
*      screen-required = '2'.
*    ENDIF.
*
*    MODIFY SCREEN.
*
*  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_INPUT
*&---------------------------------------------------------------------*
FORM check_input .

  IF p_kokrs IS INITIAL.
    SET CURSOR FIELD 'P_KOKRS'.
    MESSAGE e008 WITH %_p_kokrs_%_app_%-text.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_EXCL
*&---------------------------------------------------------------------*
FORM get_excl
  USING pv_fname
  CHANGING pt_excl TYPE t_excl.

  DATA lt_data TYPE truxs_t_text_data.

  CLEAR pt_excl.

  CALL FUNCTION 'TEXT_CONVERT_XLS_TO_SAP'
    EXPORTING
      i_line_header        = 'X'
      i_tab_raw_data       = lt_data
      i_filename           = pv_fname
    TABLES
      i_tab_converted_data = pt_excl
    EXCEPTIONS
      conversion_failed    = 1
      OTHERS               = 2.

  IF sy-subrc <> 0.
    MESSAGE
         ID sy-msgid
       TYPE 'S'
     NUMBER sy-msgno
       WITH sy-msgv1
            sy-msgv2
            sy-msgv3
            sy-msgv4 DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_DUP
*&---------------------------------------------------------------------*
FORM check_dup  CHANGING pt_outtab TYPE t_outtab.

  CHECK pt_outtab IS NOT INITIAL.

  DATA lt_dup TYPE t_outtab.

  lt_dup = pt_outtab.

*  SELECT
*    FROM @lt_dup AS lt_dup
*    FIELDS kostl,
*           kstar,
*           COUNT( * ) AS cnt
*    WHERE icon = @icon_yellow_light
*    GROUP BY kostl,
*             kstar
*    HAVING COUNT( * ) > 1
*    INTO TABLE @DATA(lt_duped).

*  LOOP AT lt_duped INTO DATA(ls_duped).
*    gs_outtab-icon = icon_led_red.
*    MESSAGE e009 INTO gs_outtab-msg.
*
*    MODIFY pt_outtab FROM gs_outtab
*    TRANSPORTING icon msg
*    WHERE kostl = ls_duped-kostl
*      AND kstar = ls_duped-kstar
*      AND icon = icon_yellow_light.
*  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SAVE
*&---------------------------------------------------------------------*
FORM save .

*  LOOP AT gt_outtab ASSIGNING <fs_outtab> WHERE icon = icon_yellow_light.
*
*    IF sy-subrc = 0.
*      <fs_outtab>-icon = icon_green_light.
*
*    ELSE.
*      <fs_outtab>-icon = icon_red_light.
*
*      CLEAR ls_sys_msg.
*      ls_sys_msg-msgid = sy-msgid.
*      ls_sys_msg-msgnr = sy-msgno.
*      ls_sys_msg-msgv1 = sy-msgv1.
*      ls_sys_msg-msgv2 = sy-msgv2.
*      ls_sys_msg-msgv3 = sy-msgv3.
*      ls_sys_msg-msgv4 = sy-msgv4.
*      PERFORM build_message USING ls_sys_msg CHANGING <fs_outtab>-msg.
*    ENDIF.
*
*  ENDLOOP.

  IF sy-subrc = 0.
    MESSAGE s018. "수행하였습니다.
  ENDIF.

ENDFORM.
