*Initial Screen Button
SELECTION-SCREEN FUNCTION KEY 1.

SELECTION-SCREEN BEGIN OF BLOCK b0 WITH FRAME TITLE TEXT-b01.
PARAMETERS: p_kokrs LIKE cobk-kokrs MEMORY ID cac,
            p_kostl TYPE csks-kostl MEMORY ID kos,
            p_posid TYPE cnpb_w_add_obj_dyn-prps_ext,
            p_gjahr LIKE cobk-gjahr OBLIGATORY DEFAULT sy-datum(4),
            p_versn LIKE cobk-versn OBLIGATORY DEFAULT '000'.
PARAMETERS: p_fname LIKE rlgrap-filename MEMORY ID path.
SELECTION-SCREEN END OF BLOCK b0.

*sample
*SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-b01.
*PARAMETER: p_r1 RADIOBUTTON GROUP r1 DEFAULT 'X' USER-COMMAND dummy,
*           p_r2 RADIOBUTTON GROUP r1.
*
*PARAMETER: p_path LIKE rlgrap-filename MEMORY ID path MODIF ID g2.
*PARAMETER: p_mode TYPE ctu_params-dismode DEFAULT 'N' AS LISTBOX VISIBLE LENGTH 25 MODIF ID g2.
*SELECTION-SCREEN END OF BLOCK b2.
*
*selection-screen begin of line.
*selection-screen comment 40(25) text-w01 for field p_dis.
*selection-screen end of line.
