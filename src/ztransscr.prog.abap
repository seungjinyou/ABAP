*&---------------------------------------------------------------------*
*& Include          ZTRANSSCR
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b0 WITH FRAME TITLE TEXT-b01.

SELECT-OPTIONS s_dev FOR tadir-devclass MEMORY ID dev.
SELECT-OPTIONS s_obt FOR tadir-object MEMORY ID obt.
SELECT-OPTIONS s_obj FOR tadir-obj_name MEMORY ID obj.

PARAMETERS p_adic AS CHECKBOX.

SELECTION-SCREEN END OF BLOCK b0.
