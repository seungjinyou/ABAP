*-----------------------------------------------------------------------
* Module/SubModule :
* Program ID       : ZTRANS
* Program Title    : 번역
* Description      :
*-----------------------------------------------------------------------
*                          MODIFICATION LOG
*
* DATE        AUTHORS   DESCRIPTION
* ----------- --------- ------------------------------------------------
* 2019.05.20  PWC098    Initial Release
*-----------------------------------------------------------------------
REPORT ztrans MESSAGE-ID zco01.

INCLUDE ztranstop.
INCLUDE ztransscr.
INCLUDE ztransc01.
INCLUDE ztransf01.
INCLUDE ztranso01.
INCLUDE ztransi01.

*INITIALIZATION.
*  PERFORM initialization.
*
*AT SELECTION-SCREEN.
*  PERFORM selection-screen.
*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_fname.
*  PERFORM value-request-fname.
*
*AT SELECTION-SCREEN OUTPUT.
*  PERFORM selection-screen-output.

START-OF-SELECTION.
  PERFORM start-of-selection.

END-OF-SELECTION.
  PERFORM end-of-selection.
