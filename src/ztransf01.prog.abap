*&---------------------------------------------------------------------*
*& Include          ZTRANSF01
*&---------------------------------------------------------------------*
DEFINE clear_.

  CLEAR &1.
  REFRESH &1.

END-OF-DEFINITION.
*&---------------------------------------------------------------------*
*&      Form  DOCK_GRID
*&---------------------------------------------------------------------*
FORM dock_grid
  USING pv_container_name
  CHANGING po_grid TYPE REF TO cl_gui_alv_grid.

  IF pv_container_name IS INITIAL.
    CREATE OBJECT go_splt
      EXPORTING
        parent  = cl_gui_container=>default_screen
        rows    = 2
        columns = 1.

  ELSE.
    CREATE OBJECT go_container
      EXPORTING
        container_name = pv_container_name.

    CREATE OBJECT go_splt
      EXPORTING
        parent  = go_container
        rows    = 2
        columns = 1.

  ENDIF.

  go_container_01 = go_splt->get_container( row = 1  column = 1 ).
  go_container_02 = go_splt->get_container( row = 2  column = 1 ).

  PERFORM top_of_scr CHANGING go_container_01.

  CREATE OBJECT po_grid
    EXPORTING
      i_parent = go_container_02.

ENDFORM.                    " DOCK_GRID
*&---------------------------------------------------------------------*
*&      Form  SET_VARIANT
*&---------------------------------------------------------------------*
FORM set_variant CHANGING ps_variant TYPE disvariant.

  CLEAR ps_variant.
  ps_variant-report = sy-repid.
  ps_variant-username = sy-uname.

*  CASE 'X'.
*    WHEN p_r1.
*      ps_variant-handle = 1.
*    WHEN p_r2.
*      ps_variant-handle = 2.
*  ENDCASE.

ENDFORM.                    " SET_VARIANT
*&---------------------------------------------------------------------*
*&      Form  SET_LAYOUT
*&---------------------------------------------------------------------*
FORM set_layout CHANGING ps_layout TYPE lvc_s_layo.

  ps_layout-sel_mode      = 'D'. "multiple selection
*  ps_layout-zebra         = 'X'.
  ps_layout-cwidth_opt    = 'X'.
  ps_layout-ctab_fname    = 'CELLCOLOR'.

*  ps_layout-grid_title    = ''.
*  ps_layout-info_fname    = 'LINECOLOR'. "필드명
*  ps_layout-stylefname    = 'CELLBTN'.

  "LAYOUT-EXCP_FNAME = 'LIGHT'. 1(Red)/ 2(Yellow)/ 3(Green)

ENDFORM.                    "set_layout
*&---------------------------------------------------------------------*
*&      Form  SET_TOOLBAR
*&---------------------------------------------------------------------*
FORM set_toolbar CHANGING pt_exclude TYPE ui_functions.

  DATA: ls_exclude TYPE ui_func.

  CLEAR pt_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_fc_detail.
*  APPEND ls_exclude TO pt_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_fc_sort_asc.
*  APPEND ls_exclude TO pt_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_fc_sort_dsc.
*  APPEND ls_exclude TO pt_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_fc_find.
*  APPEND ls_exclude TO pt_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_mb_filter.
*  APPEND ls_exclude TO pt_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_mb_sum.
*  APPEND ls_exclude TO pt_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_fc_print.
*  APPEND ls_exclude TO pt_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_mb_view.
*  APPEND ls_exclude TO pt_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_mb_export.
*  APPEND ls_exclude TO pt_exclude.
*  ls_exclude = cl_gui_alv_grid=>mc_fc_current_variant.
*  APPEND ls_exclude TO pt_exclude.

  ls_exclude = cl_gui_alv_grid=>mc_fc_graph.
  APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_info.
  APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_check.
  APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_refresh.
  APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_cut.
  APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_copy.
  APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_undo.
  APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_paste_new_row.
  APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_paste.
  APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_insert_row.
  APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_delete_row.
  APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_copy_row.
  APPEND ls_exclude TO pt_exclude.
  ls_exclude = cl_gui_alv_grid=>mc_fc_loc_append_row.
  APPEND ls_exclude TO pt_exclude.

ENDFORM.                    " SET_TOOLBAR
*&---------------------------------------------------------------------*
*&      Form  SET_FIELDCAT1
*&---------------------------------------------------------------------*
FORM set_fieldcat1
  USING pv_structure_name
  CHANGING pt_fieldcat TYPE lvc_t_fcat.

  DATA ls_fieldcat TYPE lvc_s_fcat.

  DEFINE set_field_nm_.

    &1-coltext   = &2.
    &1-reptext   = &2.
    &1-scrtext_l = &2.
    &1-scrtext_m = &2.
    &1-scrtext_s = &2.

  END-OF-DEFINITION.

  DEFINE set_field_nm_desc_.

    PERFORM get_dtel_txtmd USING 'BEZEI40' CHANGING gv_txtmd.
    READ TABLE pt_fieldcat INTO ls_fieldcat WITH KEY fieldname = &2.
    ls_fieldcat-scrtext_m = |{ ls_fieldcat-scrtext_m } { gv_txtmd }|.
    set_field_nm_ &1 ls_fieldcat-scrtext_m.

  END-OF-DEFINITION.

  CLEAR pt_fieldcat.
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
*     I_BUFFER_ACTIVE        =
      i_structure_name       = pv_structure_name
*     I_CLIENT_NEVER_DISPLAY = 'X'
      i_bypassing_buffer     = 'X'
*     I_INTERNAL_TABNAME     =
    CHANGING
      ct_fieldcat            = pt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  LOOP AT pt_fieldcat ASSIGNING <fs_fieldcat>.
    CASE <fs_fieldcat>-fieldname.
      WHEN 'DEVCLASS'. <fs_fieldcat>-key = 'X'.
      WHEN 'OBJECT'. <fs_fieldcat>-key = 'X'.
      WHEN 'OBJ_NAME'. <fs_fieldcat>-key = 'X'.
      WHEN 'ID_SORT'. <fs_fieldcat>-no_out = 'X'.
      WHEN 'ID'. <fs_fieldcat>-key = 'X'.
      WHEN 'KEY'. <fs_fieldcat>-key = 'X'.

      WHEN 'ENTRY'. <fs_fieldcat>-no_out = 'X'.
      WHEN 'ENTRY_KO'. set_field_nm_ <fs_fieldcat> 'KO'.
      WHEN 'ENTRY_EN'. set_field_nm_ <fs_fieldcat> 'EN'.
      WHEN 'ENTRY_ZH'. set_field_nm_ <fs_fieldcat> 'ZH'.
    ENDCASE.

  ENDLOOP.

ENDFORM.                    " SET_FIELDCAT1
*&---------------------------------------------------------------------*
*&      Form  SET_FIELDCAT2
*&---------------------------------------------------------------------*
FORM set_fieldcat2
  USING pv_structure_name
  CHANGING pt_fieldcat TYPE lvc_t_fcat.

  DATA ls_fieldcat TYPE lvc_s_fcat.

  DEFINE set_field_nm_.

    &1-coltext   = &2.
    &1-reptext   = &2.
    &1-scrtext_l = &2.
    &1-scrtext_m = &2.
    &1-scrtext_s = &2.

  END-OF-DEFINITION.

  DEFINE set_field_nm_desc_.

    PERFORM get_dtel_txtmd USING 'BEZEI40' CHANGING gv_txtmd.
    READ TABLE pt_fieldcat INTO ls_fieldcat WITH KEY fieldname = &2.
    ls_fieldcat-scrtext_m = |{ ls_fieldcat-scrtext_m } { gv_txtmd }|.
    set_field_nm_ &1 ls_fieldcat-scrtext_m.

  END-OF-DEFINITION.

  CLEAR pt_fieldcat.
  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
*     I_BUFFER_ACTIVE        =
      i_structure_name       = pv_structure_name
*     I_CLIENT_NEVER_DISPLAY = 'X'
      i_bypassing_buffer     = 'X'
*     I_INTERNAL_TABNAME     =
    CHANGING
      ct_fieldcat            = pt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  LOOP AT pt_fieldcat ASSIGNING <fs_fieldcat>.
    CASE <fs_fieldcat>-fieldname.
      WHEN 'DEVCLASS'. <fs_fieldcat>-key = 'X'.
      WHEN 'OBJECT'. <fs_fieldcat>-key = 'X'.
      WHEN 'OBJ_NAME'. <fs_fieldcat>-key = 'X'.
      WHEN 'DDLANGUAGE'. <fs_fieldcat>-key = 'X'.
      WHEN 'SEQ'. <fs_fieldcat>-key = 'X'. <fs_fieldcat>-no_out = 'X'.
      WHEN 'DDTEXT'. <fs_fieldcat>-key = 'X'.
      WHEN 'DOMVALUE_L'. set_field_nm_ <fs_fieldcat> TEXT-w01.

    ENDCASE.

  ENDLOOP.

ENDFORM.                    " SET_FIELDCAT2
*&---------------------------------------------------------------------*
*&      Form  SET_EVENT
*&---------------------------------------------------------------------*
FORM set_event CHANGING po_grid TYPE REF TO cl_gui_alv_grid.

*"변경된 값이 존재할때, 엔터키에 trigger DATA_CHANGED event
*  CALL METHOD po_grid->register_edit_event
*    EXPORTING
*      i_event_id = cl_gui_alv_grid=>mc_evt_enter.

*"변경된 값이 존재할때, 커서아웃에 trigger DATA_CHANGED event
*  CALL METHOD po_grid->register_edit_event
*    EXPORTING
*      i_event_id = cl_gui_alv_grid=>mc_evt_modified.

*  "EVENT HANDLER 등록
*  CREATE OBJECT event_receiver.
*  SET HANDLER event_receiver->handle_data_changed FOR po_grid.
*  SET HANDLER event_receiver->handle_data_changed_f FOR po_grid.
*  SET HANDLER event_receiver->handle_toolbar FOR po_grid.
*  SET HANDLER event_receiver->handle_user_command FOR po_grid.
*  SET HANDLER event_receiver->handle_double_click FOR po_grid.
*  SET HANDLER event_receiver->handle_hotspot_click FOR po_grid.
*  SET HANDLER event_receiver->handle_on_f4 FOR po_grid.
*  SET HANDLER event_receiver->handle_button_click FOR po_grid.

ENDFORM.                    "SET_EVENT
*&---------------------------------------------------------------------*
*&      Form  SET_READY_FOR_INPUT
*&---------------------------------------------------------------------*
FORM set_input CHANGING po_grid TYPE REF TO cl_gui_alv_grid.

  CALL METHOD po_grid->set_ready_for_input
    EXPORTING
      i_ready_for_input = 1.

ENDFORM.                    "set_ready_for_input
*&---------------------------------------------------------------------*
*&      Form  DISPLAY
*&---------------------------------------------------------------------*
FORM display
  TABLES pt_outtab
  USING po_grid     TYPE REF TO cl_gui_alv_grid
        ps_variant  TYPE disvariant
        ps_layout   TYPE lvc_s_layo
        pt_exclude  TYPE ui_functions
        pt_fieldcat TYPE lvc_t_fcat
        pt_sort     TYPE lvc_t_sort.

  CALL METHOD po_grid->set_table_for_first_display
    EXPORTING
      i_bypassing_buffer   = 'X'
      is_variant           = ps_variant
      i_save               = 'A' "X : only Global, U : only Specific User, A : X & U
      i_default            = 'X' "Default Display Variant
      is_layout            = ps_layout
      it_toolbar_excluding = pt_exclude
    CHANGING
      it_outtab            = pt_outtab[]
      it_fieldcatalog      = pt_fieldcat
      it_sort              = pt_sort.

ENDFORM.                    "DISPLAY
*&---------------------------------------------------------------------*
*&      Form  REFRESH_TABLE_DISPLAY
*&---------------------------------------------------------------------*
FORM refresh_table_display USING po_grid TYPE REF TO cl_gui_alv_grid.

  CLEAR gs_stable.
  gs_stable-row = 'X'.
  gs_stable-col = 'X'.

  CALL METHOD po_grid->refresh_table_display
    EXPORTING
      is_stable      = gs_stable "keep position
      i_soft_refresh = 'X'. "keep sort/ filter/ sum...

ENDFORM.                    "REFRESH_TABLE_DISPLAY
*&---------------------------------------------------------------------*
*&      Form  ALV_CHECK_CHANGED_DATA
*&---------------------------------------------------------------------*
FORM alv_check_changed_data CHANGING po_grid TYPE REF TO cl_gui_alv_grid.

  CALL METHOD po_grid->check_changed_data
*    IMPORTING
*      e_valid   =
*    CHANGING
*      c_refresh = 'X'
    .

ENDFORM.                    " ALV_CHECK_CHANGED_DATA
*&---------------------------------------------------------------------*
*&      Form  TOP_OF_SCR
*&---------------------------------------------------------------------*
FORM top_of_scr CHANGING po_container TYPE REF TO cl_gui_container.

  DATA lv_line TYPE sdydo_text_element.

  CALL METHOD go_splt->set_row_height
    EXPORTING
      id     = 1
      height = 8.

  IF go_dd_document IS INITIAL.
    CREATE OBJECT go_dd_document.
  ENDIF.

  IF go_viewer IS INITIAL.
    CREATE OBJECT go_viewer "텍스트 뷰어 생성
      EXPORTING
        parent = po_container.
  ENDIF.

  DEFINE add_text_.
    CALL METHOD go_dd_document->add_text
      EXPORTING
        text         = &1
        sap_fontsize = '12'
        sap_emphasis = ''.
  END-OF-DEFINITION.

  DEFINE new_line_.
    CALL METHOD go_dd_document->new_line( repeat = 0 ).
  END-OF-DEFINITION.

  DEFINE get_text_range_.
    CONDENSE &2.
    CONDENSE &3.
    IF &3 IS NOT INITIAL.
      lv_line = |{ &1 } : { &2 } ~ { &3 }|.
    ELSEIF &2 IS NOT INITIAL.
      lv_line = |{ &1 } : { &2 }|.
    ELSE.
      lv_line = |{ &1 } : *|.
    ENDIF.
  END-OF-DEFINITION.

*  PERFORM get_dtel_txtmd USING 'KOKRS' CHANGING gv_txtmd.
*  lv_line = |{ gv_txtmd } : { p_kokrs } { gs_tka01-bezei }|.
*  add_text_ lv_line.

*  new_line_.
*  PERFORM get_dtel_txtmd USING 'KOSTL' CHANGING gv_txtmd.
*  lv_line = |{ gv_txtmd } : { p_kostl } { gs_cskt-ktext }|.
*  add_text_ lv_line.

  go_dd_document->html_control = go_viewer.

  CALL METHOD go_dd_document->display_document( reuse_control = 'X' parent = po_container ).

ENDFORM.                    "TOP_OF_SCR
*&---------------------------------------------------------------------*
*&      Form  GET_SELECTED_ROW
*&---------------------------------------------------------------------*
FORM get_selected_row .

  DATA: lt_rows TYPE lvc_t_row,
        ls_row  TYPE lvc_s_row.

  CLEAR: lt_rows,
         lt_rows[],
         gs_outtab1.

  CALL METHOD go_grid->get_selected_rows
    IMPORTING
      et_index_rows = lt_rows.

  CHECK NOT lt_rows[] IS INITIAL.

  LOOP AT lt_rows INTO ls_row.
    CHECK ( ls_row-rowtype IS INITIAL ) AND ( ls_row-index GT 0 ).

    CLEAR gs_outtab1.
    READ TABLE gt_outtab1 INTO gs_outtab1 INDEX ls_row-index.
  ENDLOOP.

ENDFORM.                    "GET_SELECTED_ROW
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

  DATA ls_cellcolor TYPE lvc_s_scol.

  ls_cellcolor-fname = pv_fnm.
  ls_cellcolor-color-col = pv_color+0(1).
  ls_cellcolor-color-int = pv_color+1(1).
  ls_cellcolor-color-inv = pv_color+2(1).
  DELETE pt_cellcolor WHERE fname = pv_fnm.
  INSERT ls_cellcolor INTO TABLE pt_cellcolor.

ENDFORM.                    "SET_COLOR
*&---------------------------------------------------------------------*
*&      Form  ALV_TOOLBAR
*&---------------------------------------------------------------------*
FORM alv_toolbar
  USING po_object TYPE REF TO cl_alv_event_toolbar_set
        pv_interactive.

*  DATA: ls_toolbar TYPE stb_button.
*
*  CLEAR ls_toolbar.
*  MOVE 'BTN01'            TO ls_toolbar-function.
*  MOVE  icon_select_block TO ls_toolbar-icon.
*  MOVE '버튼 테스트'      TO ls_toolbar-quickinfo.
*  MOVE '버튼 테스트'      TO ls_toolbar-text.
*  APPEND ls_toolbar       TO po_object->mt_toolbar.
*
*  CLEAR ls_toolbar.
*  MOVE '&ALL'              TO ls_toolbar-function.
*  MOVE  icon_select_all    TO ls_toolbar-icon.
*  MOVE '전체선택'          TO ls_toolbar-quickinfo.
*  MOVE '전체선택'          TO ls_toolbar-text.
*  APPEND ls_toolbar        TO po_object->mt_toolbar.
*
*  CLEAR ls_toolbar.
*  MOVE '&SAL'              TO ls_toolbar-function.
*  MOVE  icon_deselect_all  TO ls_toolbar-icon.
*  MOVE '전체해제'          TO ls_toolbar-quickinfo.
*  MOVE '전체해제'          TO ls_toolbar-text.
*  APPEND ls_toolbar        TO po_object->mt_toolbar.

ENDFORM.                    "alv_toolbar
*&---------------------------------------------------------------------*
*&      Form  ALV_COMMAND
*&---------------------------------------------------------------------*
FORM alv_command USING e_ucomm.

*  CASE e_ucomm.
*    WHEN 'BTN01'.
*      PERFORM btn01.
*
*  ENDCASE.
*
*  CALL METHOD cl_gui_cfw=>set_new_ok_code
*    EXPORTING
*      new_code = 'DUMMY'.

ENDFORM.                    "alv_command
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
*& Form INITIALIZATION
*&---------------------------------------------------------------------*
FORM initialization.

  PERFORM set_button.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form START-OF-SELECTION
*&---------------------------------------------------------------------*
FORM start-of-selection .

  CLEAR gt_tadir.
  SELECT *
    FROM tadir
    INTO TABLE @gt_tadir
   WHERE devclass IN @s_dev
     AND object IN @s_obt
     AND obj_name IN @s_obj.

  "---------------------------------------------------------------------
  "TEXT-POOL (PROG, FUGR)
  "---------------------------------------------------------------------
  IF p_adic IS INITIAL.
    PERFORM get_textpool_langu USING '3' CHANGING gt_textpool_ko.
    PERFORM get_textpool_langu USING 'E' CHANGING gt_textpool_en.
    PERFORM get_textpool_langu USING '1' CHANGING gt_textpool_zh.

    CLEAR gt_textpool_merge.
    APPEND LINES OF gt_textpool_ko TO gt_textpool_merge.
    APPEND LINES OF gt_textpool_en TO gt_textpool_merge.
    APPEND LINES OF gt_textpool_zh TO gt_textpool_merge.

    SORT gt_textpool_merge BY devclass
                              object
                              obj_name
                              id
                              key.
    DELETE ADJACENT DUPLICATES FROM gt_textpool_merge COMPARING devclass
                                                                object
                                                                obj_name
                                                                id
                                                                key.

    SORT: gt_textpool_ko BY devclass
                            object
                            obj_name
                            id
                            key,
          gt_textpool_en BY devclass
                            object
                            obj_name
                            id
                            key,
          gt_textpool_zh BY devclass
                            object
                            obj_name
                            id
                            key.
  ENDIF.

  "---------------------------------------------------------------------
  "메뉴페인터 Tab. RSMPTEXTS (PROG)
  "---------------------------------------------------------------------
  IF p_adic IS INITIAL.
    PERFORM get_rsmptexts USING '3' CHANGING gt_rsmptexts_ko.
    PERFORM get_rsmptexts USING 'E' CHANGING gt_rsmptexts_en.
    PERFORM get_rsmptexts USING '1' CHANGING gt_rsmptexts_zh.

    CLEAR gt_rsmptexts_merge.
    APPEND LINES OF gt_rsmptexts_ko TO gt_rsmptexts_merge.
    APPEND LINES OF gt_rsmptexts_en TO gt_rsmptexts_merge.
    APPEND LINES OF gt_rsmptexts_zh TO gt_rsmptexts_merge.

    SORT gt_rsmptexts_merge BY progname
                               obj_type
                               obj_code
                               texttype.
    DELETE ADJACENT DUPLICATES FROM gt_rsmptexts_merge COMPARING progname
                                                                 obj_type
                                                                 obj_code
                                                                 texttype.

    SORT: gt_rsmptexts_ko BY progname
                             obj_type
                             obj_code
                             texttype,
          gt_rsmptexts_en BY progname
                             obj_type
                             obj_code
                             texttype,
          gt_rsmptexts_zh BY progname
                             obj_type
                             obj_code
                             texttype.
  ENDIF.

  "---------------------------------------------------------------------
  "Tab. DD04T (DTEL)
  "---------------------------------------------------------------------
  IF p_adic IS NOT INITIAL.
    PERFORM get_dd04t USING '3' CHANGING gt_dd04t_ko.
    PERFORM get_dd04t USING 'E' CHANGING gt_dd04t_en.
    PERFORM get_dd04t USING '1' CHANGING gt_dd04t_zh.

    CLEAR gt_dd04t_merge.
    APPEND LINES OF gt_dd04t_ko TO gt_dd04t_merge.
    APPEND LINES OF gt_dd04t_en TO gt_dd04t_merge.
    APPEND LINES OF gt_dd04t_zh TO gt_dd04t_merge.

    SORT gt_dd04t_merge BY rollname.
    DELETE ADJACENT DUPLICATES FROM gt_dd04t_merge COMPARING rollname.

    SORT: gt_dd04t_ko BY rollname,
          gt_dd04t_en BY rollname,
          gt_dd04t_zh BY rollname.
  ENDIF.

  "---------------------------------------------------------------------
  "Tab. DD07T (DOMA)
  "---------------------------------------------------------------------
  IF p_adic IS NOT INITIAL.
    PERFORM get_dd07t USING '3' CHANGING gt_dd07t_ko.
    PERFORM get_dd07t USING 'E' CHANGING gt_dd07t_en.
    PERFORM get_dd07t USING '1' CHANGING gt_dd07t_zh.

    CLEAR gt_dd07t_merge.
    APPEND LINES OF gt_dd07t_ko TO gt_dd07t_merge.
    APPEND LINES OF gt_dd07t_en TO gt_dd07t_merge.
    APPEND LINES OF gt_dd07t_zh TO gt_dd07t_merge.

    SORT gt_dd07t_merge BY domname
                           domval_ld
                           domval_hd
                           domvalue_l.
    DELETE ADJACENT DUPLICATES FROM gt_dd07t_merge COMPARING domname
                                                             domval_ld
                                                             domval_hd
                                                             domvalue_l.

    SORT: gt_dd07t_ko BY domname
                         domval_ld
                         domval_hd
                         domvalue_l,
          gt_dd07t_en BY domname
                         domval_ld
                         domval_hd
                         domvalue_l,
          gt_dd07t_zh BY domname
                         domval_ld
                         domval_hd
                         domvalue_l.
  ENDIF.

  "---------------------------------------------------------------------
  "ASSEMBLE
  "---------------------------------------------------------------------
  CLEAR gt_outtab1.
  CLEAR gt_outtab2.

  LOOP AT gt_tadir ASSIGNING <fs_tadir>.

    CASE <fs_tadir>-object.
      WHEN 'PROG'
        OR 'FUGR'
        OR 'CLAS'.
        "TEXT-POOL......................................................
        CHECK p_adic IS INITIAL.

        READ TABLE gt_textpool_merge
          WITH KEY devclass = <fs_tadir>-devclass
                   object   = <fs_tadir>-object
                   obj_name = <fs_tadir>-obj_name
          BINARY SEARCH
          TRANSPORTING NO FIELDS.

        LOOP AT gt_textpool_merge INTO gs_textpool_merge FROM sy-tabix.
          IF <fs_tadir>-devclass NE gs_textpool_merge-devclass
          OR <fs_tadir>-object   NE gs_textpool_merge-object
          OR <fs_tadir>-obj_name NE gs_textpool_merge-obj_name.
            EXIT.
          ENDIF.

          CLEAR gs_outtab1.
          MOVE-CORRESPONDING gs_textpool_merge TO gs_outtab1.

          CASE gs_textpool_merge-id.
            WHEN 'R'. gs_outtab1-id_sort = 1. "Program Title
            WHEN 'S'. gs_outtab1-id_sort = 2. "Selection Text
            WHEN 'I'. gs_outtab1-id_sort = 3. "Text Symbol
            WHEN 'H'. gs_outtab1-id_sort = 4. "List header > Column Header
            WHEN 'T'. gs_outtab1-id_sort = 5. "List header > Title Bar
            WHEN OTHERS.
              gs_outtab1-id_sort = 6.
          ENDCASE.

          DEFINE read_textpool_langu.
            CLEAR &2.
            READ TABLE &1 INTO &2
              WITH KEY devclass = gs_textpool_merge-devclass
                       object   = gs_textpool_merge-object
                       obj_name = gs_textpool_merge-obj_name
                       id       = gs_textpool_merge-id
                       key      = gs_textpool_merge-key BINARY SEARCH.

            gs_outtab1-&3 = &2-entry.
          END-OF-DEFINITION.

          read_textpool_langu gt_textpool_ko gs_textpool_ko entry_ko.
          read_textpool_langu gt_textpool_en gs_textpool_en entry_en.
          read_textpool_langu gt_textpool_zh gs_textpool_zh entry_zh.
          APPEND gs_outtab1 TO gt_outtab1.
        ENDLOOP.

        "메뉴페인터.....................................................
        IF <fs_tadir>-object EQ 'PROG'.
          READ TABLE gt_rsmptexts_merge
            WITH KEY progname = <fs_tadir>-obj_name
            BINARY SEARCH
            TRANSPORTING NO FIELDS.

          LOOP AT gt_rsmptexts_merge INTO gs_rsmptexts_merge FROM sy-tabix.
            IF <fs_tadir>-obj_name NE gs_rsmptexts_merge-progname.
              EXIT.
            ENDIF.

            CLEAR gs_outtab1.
            gs_outtab1-devclass = <fs_tadir>-devclass.
            gs_outtab1-object   = c_progp.
            gs_outtab1-obj_name = <fs_tadir>-obj_name.

            CASE gs_rsmptexts_merge-obj_type.
              WHEN 'T'. gs_outtab1-id_sort  = 1. "제목
              WHEN 'F'. gs_outtab1-id_sort  = 2. "Function
              WHEN OTHERS.
                gs_outtab1-id_sort  = 3.
            ENDCASE.

            gs_outtab1-id       = gs_rsmptexts_merge-obj_type.
            gs_outtab1-key      = gs_rsmptexts_merge-obj_code.
            gs_outtab1-texttype = gs_rsmptexts_merge-texttype.

            DEFINE read_rsmptexts_langu.
              CLEAR &2.
              READ TABLE &1 INTO &2
                WITH KEY progname = gs_rsmptexts_merge-progname
                         obj_type = gs_rsmptexts_merge-obj_type
                         obj_code = gs_rsmptexts_merge-obj_code
                         texttype = gs_rsmptexts_merge-texttype BINARY SEARCH.

              gs_outtab1-&3 = &2-text.
            END-OF-DEFINITION.

            read_rsmptexts_langu gt_rsmptexts_ko gs_rsmptexts_ko entry_ko.
            read_rsmptexts_langu gt_rsmptexts_en gs_rsmptexts_en entry_en.
            read_rsmptexts_langu gt_rsmptexts_zh gs_rsmptexts_zh entry_zh.
            APPEND gs_outtab1 TO gt_outtab1.
          ENDLOOP.
        ENDIF.

      WHEN 'DTEL'.
        CHECK p_adic IS NOT INITIAL.

        DEFINE append_dd04t_langu.

          CLEAR &2.
          READ TABLE &1 INTO &2 WITH KEY rollname = gs_dd04t_merge-rollname
          BINARY SEARCH.

          CLEAR gs_outtab2.
          MOVE-CORRESPONDING &2 TO gs_outtab2.
          gs_outtab2-devclass = <fs_tadir>-devclass.
          gs_outtab2-object = <fs_tadir>-object.
          gs_outtab2-obj_name = <fs_tadir>-obj_name.
          gs_outtab2-ddlanguage = &3.
          gs_outtab2-seq = &4.
          APPEND gs_outtab2 TO gt_outtab2.

        END-OF-DEFINITION.

        READ TABLE gt_dd04t_merge
          WITH KEY rollname = <fs_tadir>-obj_name
          BINARY SEARCH
          TRANSPORTING NO FIELDS.

        LOOP AT gt_dd04t_merge INTO gs_dd04t_merge FROM sy-tabix.
          IF <fs_tadir>-obj_name NE gs_dd04t_merge-rollname.
            EXIT.
          ENDIF.

          append_dd04t_langu gt_dd04t_ko gs_dd04t_ko '3' 1.
          append_dd04t_langu gt_dd04t_en gs_dd04t_en 'E' 2.
          append_dd04t_langu gt_dd04t_zh gs_dd04t_zh '1' 3.
        ENDLOOP.

      WHEN 'DOMA'.
        CHECK p_adic IS NOT INITIAL.

        DEFINE append_dd07t_langu.

          CLEAR &2.
          READ TABLE &1 INTO &2
          WITH KEY domname    = gs_dd07t_merge-domname
                   domval_ld  = gs_dd07t_merge-domval_ld
                   domval_hd  = gs_dd07t_merge-domval_hd
                   domvalue_l = gs_dd07t_merge-domvalue_l
          BINARY SEARCH.

          CLEAR gs_outtab2.
          MOVE-CORRESPONDING &2 TO gs_outtab2.
          gs_outtab2-devclass = <fs_tadir>-devclass.
          gs_outtab2-object = <fs_tadir>-object.
          gs_outtab2-obj_name = <fs_tadir>-obj_name.
          gs_outtab2-ddlanguage = &3.
          gs_outtab2-seq = &4.
          APPEND gs_outtab2 TO gt_outtab2.

        END-OF-DEFINITION.

        READ TABLE gt_dd07t_merge
          WITH KEY domname = <fs_tadir>-obj_name
          BINARY SEARCH
          TRANSPORTING NO FIELDS.

        DATA lv_seq(3) TYPE n.

        LOOP AT gt_dd07t_merge INTO gs_dd07t_merge FROM sy-tabix.
          IF <fs_tadir>-obj_name NE gs_dd07t_merge-domname.
            EXIT.
          ENDIF.

          CLEAR lv_seq.
          ADD 1 TO lv_seq. append_dd07t_langu gt_dd07t_ko gs_dd07t_ko '3' lv_seq.
          ADD 1 TO lv_seq. append_dd07t_langu gt_dd07t_en gs_dd07t_en 'E' lv_seq.
          ADD 1 TO lv_seq. append_dd07t_langu gt_dd07t_zh gs_dd07t_zh '1' lv_seq.
        ENDLOOP.

    ENDCASE.

  ENDLOOP.

  "COLOR
  LOOP AT gt_outtab1 ASSIGNING <fs_outtab1>.
    DEFINE from_dictionary.
      IF <fs_outtab1>-&1 CP 'D       *'.
        REPLACE `D       ` IN <fs_outtab1>-&1 WITH ''.
        <fs_outtab1>-texttype = 'D'.
      ENDIF.
    END-OF-DEFINITION.

    from_dictionary entry_ko.
    from_dictionary entry_en.
    from_dictionary entry_zh.

    IF <fs_outtab1>-object NE c_progp.
      PERFORM set_color USING 'TEXTTYPE' '301' CHANGING <fs_outtab1>-cellcolor.
    ENDIF.
  ENDLOOP.

  LOOP AT gt_outtab2 ASSIGNING <fs_outtab2>.
    CASE <fs_outtab2>-object.
      WHEN 'DOMA'.
        PERFORM set_color USING 'REPTEXT' '301' CHANGING <fs_outtab2>-cellcolor.
        PERFORM set_color USING 'SCRTEXT_S' '301' CHANGING <fs_outtab2>-cellcolor.
        PERFORM set_color USING 'SCRTEXT_M' '301' CHANGING <fs_outtab2>-cellcolor.
        PERFORM set_color USING 'SCRTEXT_L' '301' CHANGING <fs_outtab2>-cellcolor.

      WHEN 'DTEL'.
        PERFORM set_color USING 'DOMVALUE_L' '301' CHANGING <fs_outtab2>-cellcolor.
        PERFORM set_color USING 'DOMVAL_LD' '301' CHANGING <fs_outtab2>-cellcolor.
        PERFORM set_color USING 'DOMVAL_HD' '301' CHANGING <fs_outtab2>-cellcolor.

    ENDCASE.
  ENDLOOP.

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
*      PERFORM get_form USING 'UPLOAD_FORMAT' 'ZEDUF02'.
*    WHEN 'FC02'.
*      CALL TRANSACTION 'TCODE'.
  ENDCASE.

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
**          screen-INPUT = '0'.
*        WHEN p_r2.
*          screen-active = '0'.
*      ENDCASE.
*
*    ELSEIF screen-group1 = 'G2'.
*      CASE 'X'.
*        WHEN p_r1.
*          screen-active = '0'.
*        WHEN p_r2.
*          screen-active = '1'.
*      ENDCASE.
*
*    ENDIF.
*
*    MODIFY SCREEN.
*  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_SORT1
*&---------------------------------------------------------------------*
FORM set_sort1  CHANGING pt_sort TYPE lvc_t_sort.

  DATA ls_sort TYPE lvc_s_sort.

  DEFINE sort_.
    ADD 1 TO ls_sort-spos.
    ls_sort-fieldname = &1.
    ls_sort-up = 'X'.
    ls_sort-comp = 'X'.
    APPEND ls_sort TO pt_sort.
  END-OF-DEFINITION.

  sort_ 'DEVCLASS'.
  sort_ 'OBJECT'.
  sort_ 'OBJ_NAME'.
  sort_ 'ID_SORT'.
  sort_ 'KEY'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_SORT2
*&---------------------------------------------------------------------*
FORM set_sort2  CHANGING pt_sort TYPE lvc_t_sort.

  DATA ls_sort TYPE lvc_s_sort.

  DEFINE sort_.
    ADD 1 TO ls_sort-spos.
    ls_sort-fieldname = &1.
    ls_sort-up = 'X'.
    ls_sort-comp = 'X'.
    APPEND ls_sort TO pt_sort.
  END-OF-DEFINITION.

  sort_ 'DEVCLASS'.
  sort_ 'OBJECT'.
  sort_ 'OBJ_NAME'.
  sort_ 'SEQ'.
  sort_ 'DDLANGUAGE'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_TEXTPOOL
*&---------------------------------------------------------------------*
*ID
* H : Column Header
* I : Text Symbol
* R : Program Title
* S : Selection Text
* T : Title Bar
*&---------------------------------------------------------------------*
FORM get_textpool  USING    pv_name
                            pv_langu
                   CHANGING pt_textpool TYPE t_textpool.

  CLEAR pt_textpool.
  CALL FUNCTION 'RS_TEXTPOOL_READ'
    EXPORTING
      objectname           = pv_name
      action               = 'DISPLAY'
*     AUTHORITY_CHECK      = ' '
      language             = pv_langu
    TABLES
      tpool                = pt_textpool
    EXCEPTIONS
      object_not_found     = 1
      permission_failure   = 2
      invalid_program_type = 3
      error_occured        = 4
      action_cancelled     = 5
      OTHERS               = 6.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_TEXTPOOL
*&---------------------------------------------------------------------*
FORM get_textpool_langu
  USING pv_langu
  CHANGING pt_outtab1 TYPE t_outtab1.

  CLEAR pt_outtab1.

  DATA lv_obj_name TYPE tadir-obj_name.

  LOOP AT gt_tadir INTO gs_tadir
    WHERE object EQ 'PROG'
       OR object EQ 'FUGR'
       OR object EQ 'CLAS'.

    CASE gs_tadir-object.
      WHEN 'PROG'
        OR 'CLAS'.
        lv_obj_name = gs_tadir-obj_name.
      WHEN 'FUGR'.
        lv_obj_name = |SAPL{ gs_tadir-obj_name }|.
    ENDCASE.

    PERFORM get_textpool USING lv_obj_name pv_langu CHANGING gt_textpool.

    LOOP AT gt_textpool INTO gs_textpool.
      CLEAR gs_outtab1.
      gs_outtab1-devclass = gs_tadir-devclass.
      gs_outtab1-object = gs_tadir-object.
      gs_outtab1-obj_name = gs_tadir-obj_name.
      gs_outtab1-id = gs_textpool-id.
      gs_outtab1-key = gs_textpool-key.
      gs_outtab1-entry = gs_textpool-entry.
      APPEND gs_outtab1 TO pt_outtab1.
    ENDLOOP.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_RSMPTEXTS
*&---------------------------------------------------------------------*
*  M : 메뉴
*  F : Function
*  T : 제목
*  A : 메뉴바
*  P : 기능키세팅
*  B : 푸시버튼세팅
*  C : 상태
*&---------------------------------------------------------------------*
FORM get_rsmptexts
  USING pv_langu
  CHANGING pt_rsmptexts TYPE t_rsmptexts.

  CLEAR pt_rsmptexts.
  SELECT b~*
    FROM @gt_tadir AS a
    JOIN rsmptexts AS b
      ON a~obj_name = b~progname
     AND a~object = 'PROG'
     AND b~sprsl = @pv_langu
     AND b~obj_type IN ('F', 'T')
    INTO CORRESPONDING FIELDS OF TABLE @pt_rsmptexts.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_DD04T
*&---------------------------------------------------------------------*
FORM get_dd04t  USING pv_langu
                CHANGING pt_dd04t TYPE t_dd04t.

  CLEAR pt_dd04t.

  SELECT b~rollname,
         b~ddlanguage,
         b~ddtext,
         b~reptext,
         b~scrtext_s,
         b~scrtext_m,
         b~scrtext_l
    FROM @gt_tadir AS a
    JOIN dd04t AS b
      ON a~obj_name = b~rollname
     AND b~ddlanguage = @pv_langu
    INTO CORRESPONDING FIELDS OF TABLE @pt_dd04t.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_DD07T
*&---------------------------------------------------------------------*
FORM get_dd07t  USING pv_langu
                CHANGING pt_dd07t TYPE t_dd07t.

  CLEAR pt_dd07t.

  SELECT b~domname,
         b~ddlanguage,
         b~valpos,
         b~ddtext,
         b~domval_ld,
         b~domval_hd,
         b~domvalue_l
    FROM @gt_tadir AS a
    JOIN dd07t AS b
      ON a~obj_name = b~domname
     AND b~ddlanguage = @pv_langu
    INTO CORRESPONDING FIELDS OF TABLE @pt_dd07t.

ENDFORM.
