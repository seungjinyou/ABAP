*&---------------------------------------------------------------------*
*& Include          ZTRANSI01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_1100  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_1100 INPUT.

  gv_ucomm = ok_1100.
  CLEAR ok_1100.

  CASE gv_ucomm.
    WHEN 'SAVE'.
*      PERFORM alv_check_changed_data CHANGING go_grid.
*      PERFORM confirm_before_save CHANGING gv_answer.
*      CHECK gv_answer = '1'.
*      PERFORM run_bdc.

  ENDCASE.

ENDMODULE.                 " USER_COMMAND_1100  INPUT
*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND_1100  INPUT
*&---------------------------------------------------------------------*
MODULE exit_command_1100 INPUT.

  LEAVE TO SCREEN 0.

ENDMODULE.                 " EXIT_COMMAND_1100  INPUT
