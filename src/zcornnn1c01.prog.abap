*----------------------------------------------------------------------*
*       CLASS LCL_EVENT_RECEIVER DEFINITION
*----------------------------------------------------------------------*
CLASS lcl_event_receiver DEFINITION.

  PUBLIC SECTION.

    METHODS handle_data_changed
                FOR EVENT data_changed OF cl_gui_alv_grid
      IMPORTING er_data_changed.

    METHODS handle_data_changed_f
                FOR EVENT data_changed_finished OF cl_gui_alv_grid
      IMPORTING et_good_cells
                e_modified.

    METHODS handle_toolbar
                FOR EVENT toolbar OF cl_gui_alv_grid
      IMPORTING e_object
                e_interactive.

    METHODS handle_user_command
                FOR EVENT user_command OF cl_gui_alv_grid
      IMPORTING e_ucomm.

    METHODS handle_double_click
                FOR EVENT double_click OF cl_gui_alv_grid
      IMPORTING e_row
                e_column
                es_row_no.

    METHODS handle_hotspot_click
                FOR EVENT hotspot_click OF cl_gui_alv_grid
      IMPORTING e_row_id
                e_column_id
                es_row_no.

    METHODS handle_on_f4
                FOR EVENT onf4 OF cl_gui_alv_grid
      IMPORTING e_fieldname
                e_fieldvalue
                es_row_no
                er_event_data
                et_bad_cells
                e_display.

    METHODS handle_button_click
                FOR EVENT button_click OF cl_gui_alv_grid
      IMPORTING es_col_id
                es_row_no.

ENDCLASS.                    "lcl_event_receiver DEFINITION
*----------------------------------------------------------------------*
*       CLASS lcl_event_receiver IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS lcl_event_receiver IMPLEMENTATION.

  METHOD handle_data_changed.

    gt_roid_front = er_data_changed->mt_roid_front.

  ENDMETHOD.

  METHOD handle_data_changed_f.

    CHECK e_modified = 'X'.

    LOOP AT et_good_cells INTO DATA(ls_good_cells).

      DATA(ls_mod_cells) = ls_good_cells.

      AT NEW row_id. "ALV 라인단위
        READ TABLE gt_roid_front WITH KEY row_id = ls_mod_cells-row_id TRANSPORTING NO FIELDS.
        READ TABLE gt_outtab ASSIGNING <fs_outtab> INDEX sy-tabix.

        "DEFAULT 값
        "<fs_outtab>-column = ''.
      ENDAT.

      "ALV 셀단위
      CASE ls_mod_cells-fieldname.
        WHEN 'column'.

      ENDCASE.

    ENDLOOP.

    PERFORM alv_refresh.

*  CALL METHOD cl_gui_cfw=>set_new_ok_code
*    EXPORTING
*      new_code = 'DUMMY'.

  ENDMETHOD.

  METHOD handle_toolbar.

    PERFORM alv_toolbar USING e_object e_interactive.

  ENDMETHOD.

  METHOD handle_user_command.

    PERFORM alv_command USING e_ucomm.

  ENDMETHOD.

  METHOD handle_double_click.

*    DATA: ls_row    TYPE lvc_s_row,
*          ls_column TYPE lvc_s_col,
*          ls_row_no TYPE lvc_s_roid.

    CASE e_column-fieldname.
      WHEN 'KUNNR'.
        CLEAR gs_outtab.
        READ TABLE gt_outtab INTO gs_outtab INDEX e_row-index.

*        IF gs_outtab-kunnr IS NOT INITIAL.
*          SET PARAMETER ID 'KUN' FIELD gs_outtab-kunnr.
*          CALL TRANSACTION 'FD03' AND SKIP FIRST SCREEN.
*        ENDIF.

    ENDCASE.

  ENDMETHOD.

  METHOD handle_hotspot_click.

    CLEAR gs_outtab.
    READ TABLE gt_outtab INTO gs_outtab INDEX e_row_id-index.

    CASE e_column_id-fieldname.
      WHEN 'MSG'.
        "PERFORM show_result USING 'Itab BDCmsg'.

    ENDCASE.

  ENDMETHOD.

  METHOD handle_on_f4.

    DATA: ls_modi TYPE lvc_s_modi.

    DATA: lt_return TYPE TABLE OF ddshretval,
          ls_return TYPE ddshretval.

    FIELD-SYMBOLS <ft_modi> TYPE lvc_t_modi.

    ASSIGN er_event_data->m_data->* TO <ft_modi>.

    CASE e_fieldname.

      WHEN 'KSTAR'.
        SELECT kstar,
               ltext
          FROM csku
          INTO TABLE @DATA(lt_csku)
          WHERE spras = @sy-langu.

        CLEAR lt_return.
        CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
          EXPORTING
            retfield        = 'KSTAR'
            value_org       = 'S'
          TABLES
            value_tab       = lt_csku
            return_tab      = lt_return
          EXCEPTIONS
            parameter_error = 1
            no_values_found = 2
            OTHERS          = 3.

        IF e_display = ''. "활성
          CLEAR ls_return.
          READ TABLE lt_return INTO ls_return INDEX 1.

          IF sy-subrc = 0.
            ls_modi-row_id = es_row_no-row_id.
            ls_modi-fieldname = 'KSTAR'.
            ls_modi-value = ls_return-fieldval.
            APPEND ls_modi TO <ft_modi>.
          ENDIF.
        ENDIF.

    ENDCASE.

    "Avoid Standard Search help
    er_event_data->m_event_handled = 'X'.

  ENDMETHOD.                    "HANDLE_ON_F4

  METHOD handle_button_click.

    CLEAR gs_outtab.
    READ TABLE gt_outtab INTO gs_outtab INDEX es_row_no-row_id.

    IF sy-subrc = 0.
      "xxxx
    ENDIF.

  ENDMETHOD.

ENDCLASS.                    "lcl_event_receiver IMPLEMENTATION
