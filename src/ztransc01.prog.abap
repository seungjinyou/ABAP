*&---------------------------------------------------------------------*
*& Include          ZTRANSC01
*&---------------------------------------------------------------------*
*----------------------------------------------------------------------*
*       CLASS LCL_EVENT_RECEIVER DEFINITION
*----------------------------------------------------------------------*
CLASS lcl_event_receiver DEFINITION.

  PUBLIC SECTION.

*    METHODS handle_data_changed
*                  FOR EVENT data_changed OF cl_gui_alv_grid
*      IMPORTING er_data_changed.
*
*    METHODS handle_data_changed_f
*                  FOR EVENT data_changed_finished OF cl_gui_alv_grid
*      IMPORTING et_good_cells
*                  e_modified.
*
*    METHODS handle_toolbar
*                  FOR EVENT toolbar OF cl_gui_alv_grid
*      IMPORTING e_object
*                  e_interactive.
*
*    METHODS handle_user_command
*                  FOR EVENT user_command OF cl_gui_alv_grid
*      IMPORTING e_ucomm.
*
*    METHODS handle_double_click
*                  FOR EVENT double_click OF cl_gui_alv_grid
*      IMPORTING e_row
*                  e_column
*                  es_row_no.
*
*    METHODS handle_hotspot_click
*                  FOR EVENT hotspot_click OF cl_gui_alv_grid
*      IMPORTING e_row_id
*                  e_column_id
*                  es_row_no.
*
*    METHODS handle_on_f4
*                  FOR EVENT onf4 OF cl_gui_alv_grid
*      IMPORTING e_fieldname
*                  e_fieldvalue
*                  es_row_no
*                  er_event_data
*                  et_bad_cells
*                  e_display.
*
*    METHODS handle_button_click
*                  FOR EVENT button_click OF cl_gui_alv_grid
*      IMPORTING es_col_id
*                  es_row_no.

ENDCLASS.                    "lcl_event_receiver DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_event_receiver IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS lcl_event_receiver IMPLEMENTATION.

*  METHOD handle_data_changed.
*
*    DATA ls_mod_cells TYPE lvc_s_modi.
*
*    LOOP AT er_data_changed->mt_mod_cells INTO ls_mod_cells.
*
*      READ TABLE gt_outtab ASSIGNING <fs_outtab> INDEX ls_mod_cells-row_id.
*
*      CASE ls_mod_cells-fieldname.
*        WHEN 'XXX'.
*
*      ENDCASE.
*
*      PERFORM display_data_check
*      USING er_data_changed
*          ls_mod_cells
*          'Error Msg'.
*
*    ENDLOOP.
*
*    CALL METHOD cl_gui_cfw=>set_new_ok_code
*      EXPORTING
*        new_code = 'DUMMY'.
*
*  ENDMETHOD.                    "HANDLE_DATA_CHANGED
*
*  METHOD handle_data_changed_f.
*
*  ENDMETHOD.                    "HANDLE_DATA_CHANGED_F
*
*
*  METHOD handle_toolbar.
*
*    PERFORM alv_toolbar USING e_object e_interactive.
*
*  ENDMETHOD.                    "HANDLE_TOOLBAR
*
*  METHOD handle_user_command.
*
*    PERFORM alv_command USING e_ucomm.
*
*  ENDMETHOD.                    "HANDLE_USER_COMMAND
*
*  METHOD handle_double_click.
*
*    DATA: ls_row    TYPE lvc_s_row,
*          ls_column TYPE lvc_s_col,
*          ls_row_no TYPE lvc_s_roid.
*
*    CASE e_column-fieldname.
*      WHEN 'KUNNR'.
*        CLEAR gs_outtab.
*        READ TABLE gt_outtab INTO gs_outtab INDEX e_row-index.
*
*        IF gs_outtab-kunnr IS NOT INITIAL.
*          SET PARAMETER ID 'KUN' FIELD gs_outtab-kunnr.
*          CALL TRANSACTION 'FD03' AND SKIP FIRST SCREEN.
*        ENDIF.
*
*    ENDCASE.
*
*  ENDMETHOD.                    "HANDLE_DOUBLE_CLICK
*
*  METHOD handle_hotspot_click.
*
*    DATA: ls_row_id    TYPE lvc_s_row,
*          ls_column_id TYPE lvc_s_col,
*          ls_row_no    TYPE lvc_s_roid.
*
*    DATA: lt_msg TYPE bapiret2_t.
*
*    CLEAR gs_outtab.
*    READ TABLE gt_outtab INTO gs_outtab INDEX e_row_id-index.
*
*    CASE e_column_id-fieldname.
*      WHEN 'MSG'.
*        CHECK gs_outtab-bdcmsg IS NOT INITIAL.
*        PERFORM show_result USING gs_outtab-bdcmsg.
*
*    ENDCASE.
*
*  ENDMETHOD.                    "HANDLE_HOTSPOT_CLICK
*
*  METHOD handle_on_f4.
*
*    DATA: lt_map    TYPE TABLE OF dselc,
*          ls_map    TYPE dselc,
*          lt_return TYPE TABLE OF ddshretval,
*          ls_return TYPE ddshretval.
*
*    DATA: ls_modi TYPE lvc_s_modi.
*    FIELD-SYMBOLS <ft_modi> TYPE lvc_t_modi.
*
*    ASSIGN er_event_data->m_data->* TO <ft_modi>.
*
*    CASE e_fieldname.
*
*      WHEN 'KSTAR'.
*        IF gt_csku IS INITIAL.
*          SELECT kstar,
*                 ltext
*            FROM csku
*            INTO TABLE @gt_csku
*            WHERE spras = @sy-langu
*              AND ktopl = @gs_tka01-ktopl.
*        ENDIF.
*
*        CLEAR lt_return.
*        CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
*          EXPORTING
*            retfield        = 'KSTAR'
*            value_org       = 'S'
*          TABLES
*            value_tab       = gt_csku
*            return_tab      = lt_return
*          EXCEPTIONS
*            parameter_error = 1
*            no_values_found = 2
*            OTHERS          = 3.
*
*        IF e_display = ''. "활성
*          CLEAR ls_return.
*          READ TABLE lt_return INTO ls_return INDEX 1.
*
*          IF sy-subrc = 0.
*            ls_modi-row_id = es_row_no-row_id.
*            ls_modi-fieldname = 'KSTAR'.
*            ls_modi-value = ls_return-fieldval.
*            APPEND ls_modi TO <ft_modi>.
*          ENDIF.
*        ENDIF.
*
*    ENDCASE.
*
*    "avoid possible standard search help
*    er_event_data->m_event_handled = 'X'.
*
*  ENDMETHOD.                    "HANDLE_ON_F4
*
*  METHOD handle_button_click.
*
*    CLEAR gs_outtab.
*    READ TABLE gt_outtab INTO gs_outtab INDEX es_row_no-row_id.
*
*    IF sy-subrc = 0.
*      "xxxx
*    ENDIF.
**
*  ENDMETHOD.                    "HANDLE_BUTTON_CLICK


ENDCLASS.                    "lcl_event_receiver IMPLEMENTATION
