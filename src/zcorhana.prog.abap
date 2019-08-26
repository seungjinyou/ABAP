*-----------------------------------------------------------------------
* Module/SubModule : CO
* Program ID       : ZCORHANA
* Program Title    : ABAP 신규 Syntax
* Description      : 신규 Syntax 활용을 위한 테스트/ 검증
*-----------------------------------------------------------------------
*                          MODIFICATION LOG
*
* DATE        AUTHORS           DESCRIPTION
* ----------- ----------------- ----------------------------------------
* 2018.12.17  PWC098            Initial Release
*-----------------------------------------------------------------------
REPORT zcorhana MESSAGE-ID zco01.

*1) SELECT
*----------------------------------------------------------------------*
*DATA prog_type.
*DATA clpo_flag.
*
*prog_type = 'R'.
*
*CLEAR clpo_flag. "★
*SELECT SINGLE @abap_true
*  FROM trdir
* WHERE name = @('ZCO' && prog_type && '0010') "또는 WHERE name = @( |ZCO{ prog_type }0010| )
*  INTO @clpo_flag.
*
*WRITE:/ clpo_flag.

*2) SELECT + RANGE 변수데이터
*----------------------------------------------------------------------*
*DATA lr_bukrs TYPE RANGE OF bkpf-bukrs.
*
*SELECT 'I' AS sign,
*       'EQ' AS option,
*       bukrs AS low
*  FROM bkpf
*  ORDER BY low
*  INTO CORRESPONDING FIELDS OF TABLE @lr_bukrs
*  UP TO 2 ROWS.

*3) DATA() 구문
*----------------------------------------------------------------------*
*SELECT *
*  FROM bkpf
*  INTO TABLE @DATA(lt_bkpf).
*
*cl_demo_output=>display( lt_bkpf ).

*4) DATA() 구문
*----------------------------------------------------------------------*
*DATA: lt_bkpf TYPE TABLE OF bkpf.
*
*lt_bkpf = VALUE #(
*                    ( bukrs = '1' belnr = 'a' gjahr = '4' )
*                    ( bukrs = '2' belnr = 'b' gjahr = '5' )
*                    ( bukrs = '3' gjahr = '6' )
*                 ).
*
*DATA lv_bukrs TYPE bukrs.
*
*DO 2 TIMES.
*  CASE sy-index.
*    WHEN 1. lv_bukrs = 1. CONDENSE lv_bukrs.
*    WHEN 2. lv_bukrs = 4. CONDENSE lv_bukrs.
*  ENDCASE.
*
*  SELECT SINGLE *
*    FROM @lt_bkpf AS lt_bkpf
*   WHERE bukrs = @lv_bukrs
*    INTO @DATA(ls_result_bkpf). "★ clear되지 않는다.
*
*  WRITE:/ |{ sy-subrc } { ls_result_bkpf-bukrs }|.
*ENDDO.

*5) INTERNAL TALBE 쿼리 + GROUPING SETS
*----------------------------------------------------------------------*
*TYPES:
*  BEGIN OF struct,
*    key1 TYPE c LENGTH 1,
*    key2 TYPE c LENGTH 1,
*    key3 TYPE c LENGTH 1,
*    num1 TYPE i,
*    num2 TYPE i,
*    num3 TYPE i,
*  END OF struct.
*DATA: itab TYPE TABLE OF struct.
*
*itab = VALUE #(
*                ( key1 = 'a' key2 = 'c' key3 = 'e' num1 = '1' num2 = '1' )
*                ( key1 = 'a' key2 = 'c' key3 = 'f' num1 = '2' num2 = '2' )
*                ( key1 = 'a' key2 = 'd' key3 = 'e' num1 = '3' num2 = '3' )
*                ( key1 = 'a' key2 = 'd' key3 = 'f' num1 = '4' num2 = '4' )
*              ).
*
*SELECT
*  FROM @itab AS itab "★
*  FIELDS key1,
*         key2,
*         key3,
*         SUM( num1 ) AS sum1,
*         SUM( num2 ) AS sum2,
*         SUM( num3 ) AS sum3,
*         SUM( num1 + num2 + num3 ) AS sum
*  GROUP BY GROUPING SETS ( ( key1, key2 ), ( key1, key3 ) ) "★
*  ORDER BY key1, key2, key3
*  INTO TABLE @DATA(result).


*6) UNION
*----------------------------------------------------------------------*
*SELECT a AS c1,
*       b AS c2,
*       ' ' AS c3,
*       ' ' AS c4
*  FROM demo_join1
**
***UNION    "① DISTINCT 처럼 동작
*UNION ALL "② APPENDING
*
**(
*  SELECT ' ' AS c1,
*         ' ' AS c2,
*         C AS c3,
*         D AS c4
*    FROM demo_join1
*
**  UNION DISTINCT
**
** SELECT i AS c1,
**        j AS c2,
**        k AS c3,
**        l AS c4
**   FROM demo_join3
**)
**  ORDER BY c1, c2, c3, c4
*  INTO TABLE @DATA(result_union)
*  .
*cl_demo_output=>display( result_union ).

*7) SELECT 내장 함수 활용
*----------------------------------------------------------------------*
*SELECT id, char1, char2,
*       CASE char1
*         WHEN 'aaaaa' THEN ( char1 && char2 )
*         WHEN 'xxxxx' THEN ( char2 && char1 )
*         ELSE '99999'
*       END AS text
*  FROM demo_expressions
*  INTO TABLE @DATA(results).
*
*cl_demo_output=>display( results ).


*8) SELECT 내장 함수 활용
*----------------------------------------------------------------------*
*CHAR1 | CHAR2 | NUM1 | NUM2 | + | x |
*A       A       1      2      3   2
*A       A       2      2      4   4
*
*A       B       3      2      5   6
*A       B       4      2      6   8
*
*B       C       5      2      7   10 ←①
*B       C       6      2      8   12
*
*B       D       7      2      9   14 ←①
*
*RESULT
*B_C     7       8
*B_D     9       9

*SELECT
*       "②
*       char1 && '_' && char2 AS group,
*       MAX( num1 + num2 ) AS max,
*       MIN( num1 + num2 ) AS min
*  FROM demo_expressions
*  GROUP BY char1, char2
*  HAVING MIN( num1 * num2 ) > 7 "①
*  ORDER BY group
*  INTO TABLE @DATA(grouped_having).
*
*cl_demo_output=>display( grouped_having ).

*9 SELECT 내장 함수 활용
*----------------------------------------------------------------------*
*SELECT
*  carrid,
*  ltrim( carrid, 'A' ) AS lt, "왼쪽부터 'A'값을 지운다.
*  rtrim( carrid, 'A' ) AS rt, "오른쪽부터 A'값을 지운다.
*  lpad( carrid, 10, ' ' ) AS lp, "전체를 10자리로 하고, left 에 ' '을 채운다.
*  rpad( carrid, 10, ' ' ) AS rp, "전체를 10자리로 하고, right에 ' '을 채운다.
*  concat_with_space( carrid, carrid, 10 ) AS cs, "공백을 10자리 부여하면서, concat한다.
*  concat( carrid, carrid ) AS cc,
*  substring( carrid, 2, 1 ) AS sb
*  FROM scarr
*  INTO TABLE @DATA(result).
*
*cl_demo_output=>display( result ).

*10) READ TABLE
*----------------------------------------------------------------------*
*DATA: lt_bkpf TYPE TABLE OF bkpf.
*DATA: ls_bkpf TYPE bkpf.
*
*lt_bkpf = VALUE #(
*                    ( bukrs = '1' belnr = 'a' gjahr = '4' )
*                    ( bukrs = '2' belnr = 'b' gjahr = '5' )
*                    ( bukrs = '3' gjahr = '6' )
*                 ).
*
**ls_bkpf = lt_bkpf[ belnr = 'a' gjahr = '4' ]. "결과값이 있을 경우는 OK이나,
**ls_bkpf = lt_bkpf[ belnr = 'x' gjahr = '4' ]. "결과값이 없을 경우는 DUMP
*
*"→ 다음과 같이 사용해야함
*ASSIGN lt_bkpf[ belnr = 'x' gjahr = '4' ] TO FIELD-SYMBOL(<fs_bkpf>).

*11) APPEND
*----------------------------------------------------------------------*
*DATA itab TYPE RANGE OF i.
*
*itab = VALUE #( sign = 'I'  option = 'BT' ( low = 1  high = 10 )
*                                          ( low = 2  high = 20 )
*                                          ( low = 3  high = 30 )
*                            option = 'GE' ( low = 4 )
*              ).
*
*cl_demo_output=>display( itab ).

*12) CORRESPONDING
*----------------------------------------------------------------------*
*DATA: BEGIN OF ls_line1,
*        col1 VALUE 1,
*        col2 VALUE 2,
*        col3 VALUE 3,
*      END OF ls_line1,
*
*      BEGIN OF ls_line2,
*        col2,
*        col4 VALUE 4,
*      END OF ls_line2.
*
*ls_line2 = CORRESPONDING #( BASE ( ls_line2 ) ls_line1 ).
*WRITE:/ ls_line2.
*
*ls_line2 = CORRESPONDING #( BASE ( ls_line2 ) ls_line1 MAPPING col2 = col1 col4 = col2 ). "target = from
*WRITE:/ ls_line2.
*
*ls_line2 = CORRESPONDING #( BASE ( ls_line2 ) ls_line1 EXCEPT col2 ). "필드명이 같더라도, CORRESPONDING 하지 않음
*WRITE:/ ls_line2.



*13) LOOP BY GROUP
*----------------------------------------------------------------------*
*TYPES: BEGIN OF ty_employee,
*         name TYPE char30,
*         role TYPE char30,
*         age  TYPE i,
*       END OF ty_employee,
*       ty_employee_t TYPE STANDARD TABLE OF ty_employee WITH KEY name.
*
*DATA(gt_employee) = VALUE ty_employee_t(
*                   ( name = 'alice'    role = 'fi'   age = 42 )
*                   ( name = 'john'     role = 'ab'   age = 10 )
*                   ( name = 'arthur'   role = 'ab'   age = 10 )
*                   ( name = 'mary'     role = 'fi'   age = 37 )
*                   ( name = 'sue'      role = 'mm'   age = 35 )
*                   ( name = 'barry'    role = 'ab'   age = 20 )
*                   ( name = 'mandy'    role = 'sd'   age = 64 ) ).
*
*"loop with grouping on role
*LOOP AT gt_employee INTO DATA(ls_employee)
*  GROUP BY ( role  = ls_employee-role "group key1
*             age   = ls_employee-age "group key2
*             size  = GROUP SIZE
*             index = GROUP INDEX )
*  ASCENDING "group key 에 대한 정렬
*  ASSIGNING FIELD-SYMBOL(<group>).
*
*  "output info at group level
*  WRITE: / |ㅁrole: { <group>-role }   ㅁnumber in this role: { <group>-size }   ㅁgroup: { <group>-index }|.
*
*  "loop at members of the group
*  LOOP AT GROUP <group> ASSIGNING FIELD-SYMBOL(<fs_member>).
*    WRITE:/ <fs_member>-name.
*  ENDLOOP.
*
*  SKIP.
*ENDLOOP.

*14) INTERNAL TABLE FILTER
*----------------------------------------------------------------------*
*TYPES: BEGIN OF s_filter,
*         bukrs TYPE bkpf-bukrs,
*         blart TYPE bkpf-blart,
*       END OF s_filter,
*       t_filter TYPE HASHED TABLE OF s_filter WITH UNIQUE KEY bukrs blart.
*
*SELECT *
*  FROM bkpf
*  INTO TABLE @DATA(lt_bkpf).
*
*DATA(lt_filter) = VALUE t_filter(
*                                  ( bukrs = '1100' blart = 'RV' ) "필터에 부여하는 컬럼은 모두 key이어야 함
*                                  ( bukrs = '1100' blart = 'SA' )
*                                ).
*
*DATA(lt_filtered) = FILTER #( lt_bkpf IN lt_filter
*                                   WHERE bukrs = bukrs
*                                     AND blart = blart ).
*
*cl_demo_output=>display( lt_filtered ).

*15) ALPHA
*----------------------------------------------------------------------*
*DATA(lv_vbeln) = '0000012345'.
*lv_vbeln = |{ lv_vbeln  ALPHA = OUT }|.
*
*WRITE:/ lv_vbeln.


*DATA gv_fm_nm TYPE rs38l_fnam.
*
*DEFINE conv_.
*
*  gv_fm_nm = |CONVERSION_EXIT_{ &2 }_{ &3 }PUT|.
*
*  CALL FUNCTION gv_fm_nm
*  EXPORTING
*  input  = &1
*  IMPORTING
*  output = &1.
*
*END-OF-DEFINITION.
*
*conv lv_vbeln 'ALPHA' 'OUT'.
*WRITE:/ lv_vbeln.
*
*conv lv_vbeln 'ALPHA' 'IN'.
*WRITE:/ lv_vbeln.



*16) Date Format
*----------------------------------------------------------------------*
*DATA pa_date TYPE d.
*pa_date = sy-datum.
*WRITE / |{ pa_date DATE = ISO }|.         "Date Format YYYY-MM-DD
*WRITE / |{ pa_date DATE = USER }|.        "As per user settings
*WRITE / |{ pa_date DATE = ENVIRONMENT }|. "Formatting setting of language


*17) ASSERT
*----------------------------------------------------------------------*
DATA: ls_sflight TYPE sflight,
      lt_sflight TYPE TABLE OF sflight.
DATA: lv_test VALUE 'y'.

SELECT *
  FROM sflight
  INTO TABLE @lt_sflight.

READ TABLE lt_sflight INTO ls_sflight INDEX 1.

ASSERT ID zassert_test SUBKEY 'Z_RFC_01' "T-CODE : SAAB
       FIELDS lt_sflight "복수 가능/ 타입무관
              ls_sflight
              SY-UZEIT
       CONDITION 1 <> 1. "CONDITION이 FALSE인 경우 ASSERT 수행
