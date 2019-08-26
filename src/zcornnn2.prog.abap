*-----------------------------------------------------------------------
* Module/SubModule : CO
* Program ID       : ZCORNNN2
* Program Title    : Program title
* Description      : Program 설명
*-----------------------------------------------------------------------
*                          MODIFICATION LOG
*
* DATE        AUTHORS   DESCRIPTION
* ----------- --------- ------------------------------------------------
* 2018.12.17  PWC098    Initial Release
*-----------------------------------------------------------------------
REPORT zcornnn2 MESSAGE-ID zco01.

TYPE-POOLS slis.
DATA gs_layout TYPE slis_layout_alv.
DATA gt_fieldcat TYPE slis_t_fieldcat_alv.
DATA gt_sort TYPE slis_t_sortinfo_alv.
DATA gs_sort TYPE slis_sortinfo_alv.
DATA gs_variant TYPE disvariant.
DATA gt_excluding TYPE slis_t_extab.
DATA gt_events TYPE slis_t_event.
DATA gs_events TYPE slis_alv_event.

DATA gv_repid TYPE syst-repid.
DATA gv_lines TYPE i.

DATA: BEGIN OF gt_outtab OCCURS 0,
        box,
        light,
      END OF gt_outtab.
FIELD-SYMBOLS <fs_outtab> LIKE gt_outtab.
TYPES t_outtab LIKE TABLE OF gt_outtab.
TYPES s_outtab LIKE gt_outtab.

*-----------------------------------------------------------------------
* SELECTION-SCREEN
*-----------------------------------------------------------------------
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-b01.
PARAMETERS p_bukrs TYPE ce4ih00-bukrs MEMORY ID buk.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.
  PERFORM start-of-selection.

END-OF-SELECTION.
  PERFORM end-of-selection.


*&---------------------------------------------------------------------*
*& Form START-OF-SELECTION
*&---------------------------------------------------------------------*
FORM start-of-selection .

  gt_outtab[] =
  VALUE #( ( box = '' light = 1 )
           ( box = '' light = 2 )
           ( box = '' light = 3 )
         )
  .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form END-OF-SELECTION
*&---------------------------------------------------------------------*
FORM end-of-selection .

  PERFORM set_layout.
  PERFORM set_fieldcat.
  PERFORM set_sort.
  PERFORM set_variant.
  PERFORM set_excluding.
  PERFORM set_events.

  gv_repid = sy-repid.
  gv_lines = lines( gt_outtab ).

  IF gv_lines = 0.
    "조회된 데이터가 없습니다.
    MESSAGE s001.
  ELSE.
    "건의 데이터가 조회되었습니다.
    MESSAGE s002 WITH gv_lines.
  ENDIF.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
*     i_interface_check      =
      i_bypassing_buffer     = 'X'
*     i_buffer_active        =
      i_callback_program     = gv_repid
*     i_callback_pf_status_set = 'PF_STATUS_SET'
*     i_callback_user_command  = 'USER_COMMAND'
      i_callback_top_of_page = 'TOP_OF_PAGE'
*     i_callback_html_top_of_page =
*     i_callback_html_end_of_list =
*     i_structure_name       =
*     i_background_id        =
      is_layout              = gs_layout
      it_fieldcat            = gt_fieldcat
      it_excluding           = gt_excluding
*     it_special_groups      =
      it_sort                = gt_sort
*     it_filter              =
*     is_sel_hide            =
      i_default              = 'X'
      i_save                 = 'A'
      is_variant             = gs_variant
*     it_events              = gt_events
*     it_event_exit          =
*     is_print               =
*     is_reprep_id           =
*     i_screen_start_column  = 0
*     i_screen_start_line    = 0
*     i_screen_end_column    = 0
*     i_screen_end_line      = 0
*     i_html_height_top      = 0
*     i_html_height_end      = 0
*     it_alv_graphics        =
*     it_hyperlink           =
*     it_add_fieldcat        =
*     it_except_qinfo        =
*     ir_salv_fullscreen_adapter  =
*     o_previous_sral_handler  =
*   IMPORTING
*     e_exit_caused_by_caller  =
*     es_exit_caused_by_user =
    TABLES
      t_outtab               = gt_outtab[]
    EXCEPTIONS
      program_error          = 1
      OTHERS                 = 2.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_LAYOUT
*&---------------------------------------------------------------------*
FORM set_layout.

  CLEAR gs_layout.

*  gs_layout-zebra = 'X'.
  gs_layout-colwidth_optimize = 'X'.

  "※BOX 컬럼
  gs_layout-box_fieldname = 'BOX'.

  "※LIGHT(1) : 1 Red 2 Yellow 3 Green
  "gs_layout-lights_fieldname = 'LIGHT'.

  "※COLOR(4) : 열단위의 색상
  "gs_layout-info_fieldname = 'COLOR'.

  "※COLTAB TYPE LVC_T_SCOL : 셀단위의 색상
  "gs_layout-coltab_fieldname

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_SORT
*&---------------------------------------------------------------------*
FORM set_sort.

  CLEAR gt_sort.

  DEFINE sort_.
    CLEAR gs_sort.
    gs_sort-spos      = &1.
    gs_sort-fieldname = &2.
    gs_sort-up        = &3.
    gs_sort-down      = &4.
    gs_sort-subtot    = &5.
    APPEND gs_sort TO gt_sort.
  END-OF-DEFINITION.

*  sort_:
*  '1' 'BUKRS' 'X' '' '',
*  '2' 'MATNR' 'X' '' '',
*  '3' 'KAUFN' 'X' '' ''.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  SET_FIELDCAT
*&---------------------------------------------------------------------*
FORM set_fieldcat.

*  PROG. BALVBUFDEL : BUFFER RESET
  DATA(lv_datum) = CONV datum( sy-datum + 1 ).
  SET PARAMETER ID 'ALVBUFFER' FIELD lv_datum.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-repid
      i_internal_tabname     = 'GT_OUTTAB'
      i_inclname             = sy-repid
      i_bypassing_buffer     = 'X'
    CHANGING
      ct_fieldcat            = gt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  LOOP AT gt_fieldcat ASSIGNING FIELD-SYMBOL(<fs_fieldcat>).

    DEFINE set_ddictxt.
      "(S)hort (M)iddle (L)ong
      <fs_fieldcat>-ddictxt = &1.
    END-OF-DEFINITION.

    DEFINE set_fnm.
      <fs_fieldcat>-reptext_ddic = &1.
      <fs_fieldcat>-seltext_l    = &1.
      <fs_fieldcat>-seltext_m    = &1.
      <fs_fieldcat>-seltext_s    = &1.
    END-OF-DEFINITION.

    DEFINE set_key.
      <fs_fieldcat>-key = 'X'.
    END-OF-DEFINITION.

    DEFINE set_edit.
      <fs_fieldcat>-edit = 'X'.
    END-OF-DEFINITION.

    "<fs_fieldcat>-do_sum
    "<fs_fieldcat>-no_out
    "<fs_fieldcat>-tech
    "<fs_fieldcat>-outputlen
    "<fs_fieldcat>-icon
    "<fs_fieldcat>-col_pos
    "<fs_fieldcat>-emphasize
    "<fs_fieldcat>-cfieldname = 'WAERS'

    CASE <fs_fieldcat>-fieldname.
      WHEN 'BOX'.
        DELETE gt_fieldcat INDEX sy-tabix.

      WHEN 'LIGHT'.
        set_key.
        set_fnm 'LIGHT'.

    ENDCASE.


  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form TOP_OF_PAGE
*&---------------------------------------------------------------------*
FORM top_of_page.

  DATA: lt_top TYPE slis_t_listheader,
        ls_top TYPE slis_listheader.

  "TYP (H = Header, S = Selection, A = Action)

  CLEAR ls_top.
  ls_top-typ  = 'H'.
  ls_top-info = 'info'.
  APPEND ls_top TO lt_top.

  CLEAR ls_top.
  ls_top-typ  = 'S'.
  ls_top-key  = 'COL1 '.
  ls_top-info = 'COL1'.
  APPEND ls_top TO lt_top.

  CLEAR ls_top.
  ls_top-typ  = 'S'.
  ls_top-key  = 'COL2 '.
  ls_top-info = 'COL2'.
  APPEND ls_top TO lt_top.

  CLEAR ls_top.
  ls_top-typ  = 'A'.
  ls_top-info = 'info'.
  APPEND ls_top TO lt_top.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = lt_top.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_VARIANT
*&---------------------------------------------------------------------*
FORM set_variant .

  CLEAR gs_variant.
  gs_variant-report = sy-repid.
  gs_variant-username = sy-uname.
  "gs_variant-handle = .

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_PF_STATUS
*&---------------------------------------------------------------------*
FORM set_pf_status USING rt_extab TYPE slis_t_extab.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form USER_COMMAND
*&---------------------------------------------------------------------*
FORM user_command
  USING r_ucomm LIKE sy-ucomm
        rs_selfield TYPE slis_selfield.



ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_EXCLUDING
*&---------------------------------------------------------------------*
FORM set_excluding .

  APPEND '&INFO' TO gt_excluding.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_EVENTS
*&---------------------------------------------------------------------*
FORM set_events .

  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    EXPORTING
      i_list_type     = 0
    IMPORTING
      et_events       = gt_events
    EXCEPTIONS
      list_type_wrong = 1
      OTHERS          = 2.

*  READ TABLE gt_events ASSIGNING FIELD-SYMBOL(<fs_events>)
*  WITH KEY name = slis_ev_top_of_page.
*
*  IF sy-subrc = 0.
*    <fs_events>-form = slis_ev_top_of_page.
*  ENDIF.

ENDFORM.
