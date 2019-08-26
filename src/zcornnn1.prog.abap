*-----------------------------------------------------------------------
* Module/SubModule : CO
* Program ID       : ZCORNNN1
* Program Title    : Program title
* Description      : Program 설명
*-----------------------------------------------------------------------
*                          MODIFICATION LOG
*
* DATE        AUTHORS   DESCRIPTION
* ----------- --------- ------------------------------------------------
* 2019.02.15  PWC098    Initial Release
*-----------------------------------------------------------------------
REPORT zcornnn1 MESSAGE-ID zco01.

*INCLUDE officeintegrationinclude.
INCLUDE zcornnn1top.
INCLUDE zcornnn1scr.
INCLUDE zcornnn1c01.
INCLUDE zcornnn1f01.
INCLUDE zcornnn1o01.
INCLUDE zcornnn1i01.

INITIALIZATION.
  PERFORM initialization.

AT SELECTION-SCREEN OUTPUT.
  PERFORM selection-screen-output.

AT SELECTION-SCREEN.
  PERFORM selection-screen.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_fname.
  PERFORM value-request-fname.

START-OF-SELECTION.
  PERFORM start-of-selection.

END-OF-SELECTION.
  PERFORM end-of-selection.
