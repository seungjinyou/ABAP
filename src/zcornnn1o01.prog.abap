*&---------------------------------------------------------------------*
*&      Module  STATUS_1100  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_1100 OUTPUT.

  gv_title = sy-title.
  SET TITLEBAR '1100' WITH gv_title.
  SET PF-STATUS '1100'.

ENDMODULE.                 " STATUS_1100  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  ALV_1100  OUTPUT
*&---------------------------------------------------------------------*
MODULE alv_1100 OUTPUT.

  IF go_alv IS INITIAL.

    go_con_spt = NEW #(
        parent  = cl_gui_container=>default_screen
        rows    = 2
        columns = 1 ).

    go_con_spt->set_row_height(
      EXPORTING
        id     = 1
        height = 8 ).

    go_con_top = go_con_spt->get_container( row = 1  column = 1 ).
    PERFORM top_of_scr.

    go_con_alv = go_con_spt->get_container( row = 2  column = 1 ).
    go_alv = NEW #( i_parent = go_con_alv ).

    PERFORM alv_edit.
    PERFORM alv_event.
    PERFORM alv_f4.

    PERFORM alv_variant.
    PERFORM alv_layout.
    PERFORM alv_exclude.
    PERFORM alv_fieldcat.
    PERFORM alv_sort.

    go_alv->set_table_for_first_display(
      EXPORTING
        i_buffer_active      = 'X'
*       i_bypassing_buffer   = i_bypassing_buffer
*       i_consistency_check  = i_consistency_check
*       i_structure_name     = i_structure_name
        is_variant           = gs_variant
        i_save               = 'A' "X : Global, U : Specific User, A : All
        i_default            = 'X'
        is_layout            = gs_layout
*       is_print             = is_print
*       it_special_groups    = it_special_groups
        it_toolbar_excluding = gt_exclude
*       it_hyperlink         = it_hyperlink
*       it_alv_graphics      = it_alv_graphics
*       it_except_qinfo      = it_except_qinfo
*       ir_salv_adapter      = ir_salv_adapter
      CHANGING
        it_outtab            = gt_outtab
        it_fieldcatalog      = gt_fieldcat
        it_sort              = gt_sort
*       it_filter            = it_filter
        ).

    gv_lines = lines( gt_outtab ).

    IF gv_lines = 0.
      MESSAGE s001.
    ELSE.
      MESSAGE s002 WITH gv_lines.
    ENDIF.

  ELSE.
    PERFORM alv_refresh.

  ENDIF.

ENDMODULE.                    "ALV_1100 OUTPUT
