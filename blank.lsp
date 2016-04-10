;;;---------------------------------------------------------------------------;
;;;
;;;   BLANK.LSP   Version 1.0
;;;
;;;   Copyright (C) 1995 by Autodesk, Inc.
;;;
;;;   Permission to use, copy, modify, and distribute this software and its
;;;   documentation for any purpose and without fee is hereby granted.
;;;
;;;   THIS SOFTWARE IS PROVIDED "AS IS" WITHOUT EXPRESS OR IMPLIED WARRANTY.
;;;   ALL IMPLIED WARRANTIES OF FITNESS FOR ANY PARTICULAR PURPOSE AND OF
;;;   MERCHANTABILITY ARE HEREBY DISCLAIMED.
;;;
;;;---------------------------------------------------------------------------;
;;;   BLANK, UNBLANK, and UNBLANKALL
;;;
;;;   This module provides functions to manipulate the visibility field of
;;;   AutoCAD objects.  BLANK will make a selection set of objects invisible.
;;;   UNBLANK will make a specified object (given its handle) visible.
;;;   UNBLANKALL will make all blanked entities visible.
;;;
;;;---------------------------------------------------------------------------;


;;;---------------------------------------------------------------------------;
;;; Internal error handling.
;;;---------------------------------------------------------------------------;
(defun blank_error(s)
  ;; The strings in the following statements can be translated.
  (if (/= s ;|MSG1|;"Function cancelled")
    (princ (strcat ;|MSG2|;"\nBLANK Error: " s))
  )
  (setq *error* olderr)
  (princ)
)

(defun unblank_error(s)
  ;; The strings in the following statements can be translated.
  (if (/= s ;|MSG3|;"Function cancelled")
    (princ (strcat ;|MSG3|;"\nUNBLANK Error: " s))
  )
  (setq *error* olderr)
  (princ)
)

(defun blank60 (e / e2)
  (if (not (null (assoc '60 e)))
    (setq e2 (subst '(60 . 1) '(60 . 0) e))
    (setq e2 (append e '((60 . 1))))
  )
)   

(defun show60 (e / e2)
  (if (not (null (assoc '60 e)))
     (setq e2 (subst '(60 . 0) '(60 . 1) e))
     (setq e2 (append e '((60 . 0))))
  )
)

(defun setvis ( vis ename / e)
  (setq e (entget ename))
  (if (eq vis 0)
     (entmod (show60 e))
     (entmod (blank60 e))
  )
  (entupd ename)
  ;; Blank vertices of polyline, if necessary
  (if (eq (cdr (nth 1 e)) "POLYLINE")
    (progn
      (setq ename (entnext ename))
      (setq e (entget ename))
      (while (eq (cdr (nth 1 e)) "VERTEX")
        (if (eq vis 0)
           (entmod (show60 e))
           (entmod (blank60 e))
        )
        (entupd ename)
        (setq ename (entnext ename))
        (setq e (entget ename))
      ) ; while
    ) ; progn
  ) ; if polyline
  (if (and (eq (cdr (nth 1 e)) "INSERT")
           (assoc '66 e))
    (progn
      (setq ename (entnext ename))
      (setq e (entget ename))
      (while (eq (cdr (nth 1 e)) "ATTRIB")
        (if (eq vis 0)
           (entmod (show60 e))
           (entmod (blank60 e))
        )
        (entupd ename)
        (setq ename (entnext ename))
        (setq e (entget ename))
      ) ; while
    ) ; progn
  )
)

(defun c:blank ( ) ;;; / olderr echo ss i ename )
  (setq olderr *error*                ; Redefine error handler.
        echo (getvar ;|MSG0|;"cmdecho")
        *error* blank_error)
  (setvar ;|MSG0|;"cmdecho" 0)                ; Turn off cmdecho sysvar
  (command ;|MSG0|;"_.undo" ;|MSG0|;"_group")

  (setq ss (ssget))
  (setq i 0)
  (while (< i (sslength ss)) (progn
     (setq ename (ssname ss i))
     (setvis 1 ename)
     (setq i (1+ i))
  ))

  (setq *error* old_error)            ; restore error function
  (command ;|MSG0|;"_.undo" ;|MSG0|;"_end")
  (setvar ;|MSG0|;"cmdecho" echo)             ; restore cmdecho sysvar
  (princ)                             ; Quiet exit.
)

(defun c:unblankall ( ) ;;; / olderr echo ss i ename )
  (setq olderr *error*                ; Redefine error handler.
        echo (getvar ;|MSG0|;"cmdecho")
        *error* unblank_error)
  (setvar ;|MSG0|;"cmdecho" 0)                ; Turn off cmdecho sysvar
  (command ;|MSG0|;"_.undo" ;|MSG0|;"_group")

  ;; Select all blanked entities
  (setq ss (ssget ;|MSG0|;"_x" '((60 . 1))))
  (if (not (null ss))
    (progn
      (setq i 0)
      (princ (sslength ss))
      (princ " blanked entities found.\n");
      ;; Unblank each entity in the set
      (while (< i (sslength ss)) (progn
         (setq ename (ssname ss i))
         (setvis 0 ename)
         (setq i (1+ i))
      )) 
    )   
    (princ "\n0 blanked entities found.\n");
  )

  (setq *error* old_error)            ; restore error function
  (command ;|MSG0|;"_.undo" ;|MSG0|;"_end")
  (setvar ;|MSG0|;"cmdecho" echo)             ; restore cmdecho sysvar
  (princ)                             ; Quiet exit.
)

(defun c:unblank ( ) ;;; / olderr echo ss i ename hand )
  (setq olderr *error*                ; Redefine error handler.
        echo (getvar ;|MSG0|;"cmdecho")
        *error* unblank_error)
  (setvar ;|MSG0|;"cmdecho" 0)                ; Turn off cmdecho sysvar
  (command ;|MSG0|;"_.undo" ;|MSG0|;"_group")

  (setq hand (getstring ;|MSG5|;"\nEnter handle of entity to be unblanked: "))
  ;; Unblank the entity if handle is not an empty string
  (if (> (strlen hand) 0)
    (progn
      (setq ename (handent hand))
      (if (/= nil ename)
        (setvis 0 ename)
        (princ ;|MSG6|;"Invalid handle.")
      )
    )
  )

  (setq *error* old_error)            ; restore error function
  (command ;|MSG0|;"_.undo" ;|MSG0|;"_end")
  (setvar ;|MSG0|;"cmdecho" echo)             ; restore cmdecho sysvar
  (princ)                             ; Quiet exit.
)
(princ)
