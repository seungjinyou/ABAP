*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_1100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_1100 INPUT.

  gv_ucomm = ok_1100.
  CLEAR ok_1100.

  CASE gv_ucomm.
    WHEN 'SAVE'.
      PERFORM alv_check_changed_data.

*      READ TABLE gt_outtab WITH KEY icon = icon_yellow_light
*      TRANSPORTING NO FIELDS.

      IF sy-subrc <> 0.
        "반영할 데이터가 없습니다.
        MESSAGE s019 DISPLAY LIKE 'W'.
        EXIT.
      ENDIF.

      MESSAGE s004 INTO gv_msg. "저장하시겠습니까?
      PERFORM confirm USING gv_msg CHANGING gv_answer.

      IF gv_answer <> 'J'.
        MESSAGE s006. "취소하였습니다.
        EXIT.
      ENDIF.

      PERFORM save.

*      PERFORM run_bdc.

  ENDCASE.

ENDMODULE.                 " USER_COMMAND_1100  INPUT
*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND_1100  INPUT
*&---------------------------------------------------------------------*
MODULE exit_command_1100 INPUT.

  LEAVE TO SCREEN 0.

ENDMODULE.                 " EXIT_COMMAND_1100  INPUT
