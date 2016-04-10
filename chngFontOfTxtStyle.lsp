;;; Rename - Block/Dimstyle/LAyer/LType/Material/multileadeRstyle/Style/Tablestyle/Ucs/VIew/VPort
(defun chngFontOfTxtStyle (txtStyleName	     newFontnameWithExt
			   /		     theElist
			   eNameTxtSty	     fontChanged
			  )
			  ;|

  110903 Sanjay Kulkarni
  Changes the fontfile of a text style
  calling method (chngFontOfTxtStyle "ssk1" "txt.shx")

;;;

  If the font is not changed returns -1 otherwise returns 0

  If it is an acad default font or the font file is in the same folder of acad fonts, then path is not required
  Otherwise path is required.

  If the original font name and new font name is same, no error is returned.

  Font may not be changed because:

    1. Font name may not correct (including missing or wrong extension)
    2. Text style name is not correct
  
|;

  (setq fontChanged -1)
;;; Set the default retun value as failed.

  (setq eNameTxtSty (tblobjname "style" txtStyleName))
;;; Check if the text style exists

  (if (/= eNameTxtSty nil)
;;; If the text style exists

    (progn

      (setq theElist (entget eNameTxtSty))
;;; gets the entity list of the text style

      (setq theElist (subst (cons 3 newFontnameWithExt)
			    (assoc 3 theElist)
			    theElist
		     )
      )
;;; Creates a new list with new font name

      (entmod theElist)
;;; Modify the text style object

      (if (= (strcase (cdr (assoc 3 theElist)))
	     (strcase newFontnameWithExt)
	  )
;;; Return value: success=0
	(setq fontChanged 0)
      )
    )
  )
  (setq fontChanged fontChanged)
;;; ensures return value

)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(prompt
  "\nType 'cfot?' at command prompt for help about this function.\n"
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun c:cfot? (/ hlpStr)
	       ;|

  ;;; help display function for chngFontOfTxtStyle
  ;;; 110903 Sanjay Kulkarni
  
  |;

  (setq
    hlpStr
     "\n*** Help On Function chngFontOfTxtStyle ***\n\nThis function changes the font file of a text style.\n"
  )
  (setq	hlpStr
	 (strcat
	   hlpStr
	   "\nMethod of calling this function\n\t\t - (chngFontOfTxtStyle txtStyleName newFontnameWithExt)"
	 )
  )
  (setq	hlpStr
	 (strcat
	   hlpStr
	   "\n\t\t\twhere 'txtStyleName' is the name of the text style and"
	 )
  )

  (setq	hlpStr
	 (strcat
	   hlpStr
	   "\n\t      'newFontnameWithExt' is the name of the new font name\n\t\t\t\t\t\t and must include the extension"
	 )
  )

  (setq	hlpStr
	 (strcat
	   hlpStr
	   "\n\t      eg (chngFontOfTxtStyle \"ssk1\" \"txt.shx\")\n"
	 )
  )

  (setq	hlpStr
	 (strcat
	   hlpStr
	   "\nIf the font is not changed (text style or font file name is not correct or font file does not exist in "
	 )
  )
  (setq	hlpStr
	 (strcat
	   hlpStr
	   "the AutoCAD default font folder), the function returns an error value -1; otherwise "
	 )
  )
  (setq	hlpStr
	 (strcat
	   hlpStr
	   "it returns 0. You can add the full path in the font file name to be always safe.\n\n"
	 )
  )

  (prompt hlpStr)
  (textscr)
  (princ)
)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;