TABLES: sscrfields.

*--alv
*--------------------------------------------------------------------*
TYPE-POOLS: slis,
            icon.

DATA: go_con_spt    TYPE REF TO cl_gui_splitter_container,
      go_con_top    TYPE REF TO cl_gui_container,
      go_con_alv    TYPE REF TO cl_gui_container,
      go_alv        TYPE REF TO cl_gui_alv_grid,

      gs_variant    TYPE disvariant,
      gs_layout     TYPE lvc_s_layo,

      gt_exclude    TYPE ui_functions,
      gs_exclude    TYPE ui_func,

      gt_fieldcat   TYPE lvc_t_fcat,
      gs_fieldcat   TYPE lvc_s_fcat,

      gt_sort       TYPE lvc_t_sort,
      gs_sort       TYPE lvc_s_sort,

      gt_roid_front TYPE lvc_t_roid,
      gs_roid_front TYPE lvc_s_roid,

      gv_lines      TYPE i,
      ok_1100       TYPE syst-ucomm,
      gv_ucomm      TYPE syst-ucomm.

FIELD-SYMBOLS <fs_fieldcat> TYPE lvc_s_fcat.

*--smw0 엑셀다운 기능 구현을 위한 전역변수 선언
*--------------------------------------------------------------------*
*TYPE-POOLS : truxs, soi.
*
*DATA : gt_doc_table      LIKE w3mime OCCURS 0,
*       gv_doc_size       TYPE i,
*       gv_doc_type(80)   VALUE soi_doctype_excel97_sheet,
*       gv_doc_format(80),
*       go_link_server    TYPE REF TO i_oi_link_server,
*       go_factory        TYPE REF TO i_oi_document_factory,
*       go_document       TYPE REF TO i_oi_document_proxy,
*       gv_retcode        TYPE t_oi_ret_string.

*--엑셀 로드
*--------------------------------------------------------------------*
DATA: gt_excel LIKE TABLE OF alsmex_tabline,
      gs_excel LIKE LINE OF gt_excel.

*--bdc
*--------------------------------------------------------------------*
DATA: gt_bdcdata    TYPE TABLE OF bdcdata,
      gs_bdcdata    TYPE bdcdata,
      gt_bdcmsgcoll TYPE TABLE OF bdcmsgcoll,
      gs_bdcmsgcoll TYPE bdcmsgcoll.

*--가공 변수
*--------------------------------------------------------------------*
DATA gv_txt TYPE string.
DATA gv_title TYPE syst-title.
DATA gv_answer.
DATA gv_stop.
DATA gv_msg TYPE string.

TYPES: t_dd07v TYPE TABLE OF dd07v,
       s_dd07v TYPE dd07v.

TYPES: s_outtab TYPE ZTEST,
       t_outtab TYPE TABLE OF s_outtab.
DATA: gs_outtab TYPE s_outtab,
      gt_outtab TYPE t_outtab.
FIELD-SYMBOLS <fs_outtab> TYPE s_outtab.

TYPES: s_excl TYPE bkpf,
       t_excl TYPE TABLE OF s_excl.
DATA: gs_excl TYPE s_excl,
      gt_excl TYPE t_excl.
FIELD-SYMBOLS <fs_excl> TYPE s_excl.

DATA gv_txtmd TYPE rsddtel-txtmd.

DATA gs_tka01 TYPE tka01.
DATA gs_tka02 TYPE tka02.

DATA gs_prps TYPE prps.
DATA gs_cskt TYPE cskt.
DATA gs_csks TYPE csks.

TYPES: r_budat TYPE RANGE OF budat,
       s_budat TYPE LINE OF r_budat.
DATA: gr_budat TYPE r_budat,
      gs_budat TYPE s_budat.

DATA: gt_month_names TYPE TABLE OF t247,
      gs_month_names TYPE t247.

*--local class (alv call-back)
*--------------------------------------------------------------------*
CLASS lcl_event_receiver DEFINITION DEFERRED.
DATA event_receiver TYPE REF TO lcl_event_receiver.
