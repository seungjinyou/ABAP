*&---------------------------------------------------------------------*
*& Include          ZTRANSTOP
*&---------------------------------------------------------------------*
TABLES: sscrfields.

*--alv
*--------------------------------------------------------------------*
TYPE-POOLS: slis,
            icon.

DATA: go_container    TYPE REF TO cl_gui_custom_container,
      go_container_01 TYPE REF TO cl_gui_container,
      go_container_02 TYPE REF TO cl_gui_container,
      go_grid         TYPE REF TO cl_gui_alv_grid,

      go_splt         TYPE REF TO cl_gui_splitter_container,
      go_dd_document  TYPE REF TO cl_dd_document,
      go_viewer       TYPE REF TO cl_gui_html_viewer,

      gs_variant      TYPE disvariant,
      gs_layout       TYPE lvc_s_layo,

      gt_exclude      TYPE ui_functions,
      gs_exclude      TYPE ui_func,

      gt_fieldcat     TYPE lvc_t_fcat,
      gs_fieldcat     TYPE lvc_s_fcat,

      gt_sort         TYPE lvc_t_sort,
      gs_sort         TYPE lvc_s_sort,

      gv_line_cnt     TYPE i,
      ok_1100         TYPE syst-ucomm,
      gv_ucomm        TYPE syst-ucomm,
      gs_stable       TYPE lvc_s_stbl.

FIELD-SYMBOLS <fs_fieldcat> TYPE lvc_s_fcat.


*--가공 변수
*--------------------------------------------------------------------*
TYPES: s_outtab1 TYPE ztrans,
       t_outtab1 TYPE TABLE OF s_outtab1.
DATA: gs_outtab1 TYPE s_outtab1,
      gt_outtab1 TYPE t_outtab1.

TYPES: s_outtab2 TYPE ztrans1,
       t_outtab2 TYPE TABLE OF s_outtab2.
DATA: gs_outtab2 TYPE s_outtab2,
      gt_outtab2 TYPE t_outtab2.
FIELD-SYMBOLS <fs_outtab2> TYPE s_outtab2.

DATA: gs_textpool_merge TYPE s_outtab1,
      gt_textpool_merge TYPE t_outtab1.
DATA: gs_textpool_ko TYPE s_outtab1,
      gt_textpool_ko TYPE t_outtab1.
DATA: gs_textpool_en TYPE s_outtab1,
      gt_textpool_en TYPE t_outtab1.
DATA: gs_textpool_zh TYPE s_outtab1,
      gt_textpool_zh TYPE t_outtab1.

FIELD-SYMBOLS <fs_outtab1> TYPE s_outtab1.

TYPES: t_dd07v TYPE TABLE OF dd07v,
       s_dd07v TYPE dd07v.

DATA: gs_tadir TYPE tadir,
      gt_tadir TYPE TABLE OF tadir.
FIELD-SYMBOLS <fs_tadir> TYPE tadir.

TYPES: s_textpool TYPE textpool,
       t_textpool TYPE TABLE OF s_textpool.

DATA: gs_textpool TYPE textpool,
      gt_textpool TYPE TABLE OF textpool.
FIELD-SYMBOLS <fs_textpool> TYPE textpool.


DATA gv_title TYPE syst-title.

TABLES: rs38m,
        tadir.

TYPES: s_rsmptexts TYPE rsmptexts,
       t_rsmptexts TYPE TABLE OF s_rsmptexts.
DATA: gs_rsmptexts_merge TYPE s_rsmptexts,
      gt_rsmptexts_merge TYPE t_rsmptexts.
DATA: gs_rsmptexts_ko TYPE s_rsmptexts,
      gt_rsmptexts_ko TYPE t_rsmptexts.
DATA: gs_rsmptexts_en TYPE s_rsmptexts,
      gt_rsmptexts_en TYPE t_rsmptexts.
DATA: gs_rsmptexts_zh TYPE s_rsmptexts,
      gt_rsmptexts_zh TYPE t_rsmptexts.
FIELD-SYMBOLS <fs_rsmptexts> TYPE s_rsmptexts.

TYPES: s_dd04t TYPE dd04t,
       t_dd04t TYPE TABLE OF s_dd04t.
DATA: gs_dd04t_merge TYPE s_dd04t,
      gt_dd04t_merge TYPE t_dd04t.
DATA: gs_dd04t_ko TYPE s_dd04t,
      gt_dd04t_ko TYPE t_dd04t.
DATA: gs_dd04t_en TYPE s_dd04t,
      gt_dd04t_en TYPE t_dd04t.
DATA: gs_dd04t_zh TYPE s_dd04t,
      gt_dd04t_zh TYPE t_dd04t.
FIELD-SYMBOLS <fs_dd04t> TYPE s_dd04t.


TYPES: s_dd07t TYPE dd07t,
       t_dd07t TYPE TABLE OF s_dd07t.
DATA: gs_dd07t_merge TYPE s_dd07t,
      gt_dd07t_merge TYPE t_dd07t.
DATA: gs_dd07t_ko TYPE s_dd07t,
      gt_dd07t_ko TYPE t_dd07t.
DATA: gs_dd07t_en TYPE s_dd07t,
      gt_dd07t_en TYPE t_dd07t.
DATA: gs_dd07t_zh TYPE s_dd07t,
      gt_dd07t_zh TYPE t_dd07t.
FIELD-SYMBOLS <fs_dd07t> TYPE s_dd07t.

CONSTANTS c_progp TYPE tadir-object VALUE 'PROM'.

*--local class (alv call-back)
*--------------------------------------------------------------------*
CLASS lcl_event_receiver DEFINITION DEFERRED.
DATA: event_receiver TYPE REF TO lcl_event_receiver.
