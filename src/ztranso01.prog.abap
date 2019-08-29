*&---------------------------------------------------------------------*
*& Include          ZTRANSO01
*&---------------------------------------------------------------------*
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

  IF go_grid IS INITIAL.
    PERFORM dock_grid USING ''
                      CHANGING go_grid.

    PERFORM set_variant  CHANGING gs_variant.
    PERFORM set_layout   CHANGING gs_layout.
    PERFORM set_toolbar  CHANGING gt_exclude.

    IF p_adic IS INITIAL.
      PERFORM set_fieldcat1 USING 'ZTRANS' CHANGING gt_fieldcat.
      PERFORM set_sort1 CHANGING gt_sort.
      PERFORM display
      TABLES gt_outtab1
      USING go_grid
            gs_variant
            gs_layout
            gt_exclude
            gt_fieldcat
            gt_sort.

      gv_line_cnt = lines( gt_outtab1 ).
    ELSE.
      PERFORM set_fieldcat2 USING 'ZTRANS1' CHANGING gt_fieldcat.
      PERFORM set_sort2 CHANGING gt_sort.
      PERFORM display
      TABLES gt_outtab2
      USING go_grid
            gs_variant
            gs_layout
            gt_exclude
            gt_fieldcat
            gt_sort.

      gv_line_cnt = lines( gt_outtab2 ).
    ENDIF.

*    PERFORM set_event CHANGING go_grid.
*    PERFORM set_input CHANGING go_grid.
*    PERFORM set_f4    CHANGING go_grid.


    IF gv_line_cnt = 0.
      "조회된 데이터가 없습니다.
      MESSAGE s001.
    ELSE.
      "건의 데이터가 조회되었습니다.
      MESSAGE s002 WITH gv_line_cnt.
    ENDIF.

  ELSE.
    PERFORM refresh_table_display USING go_grid.

  ENDIF.

ENDMODULE.                    "ALV_1100 OUTPUT
