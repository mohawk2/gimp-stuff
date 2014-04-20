; An example script that writes a fixed string in the current
; image.
(define (script-fu-hello-world img drawable)

  ; Start an undo group. Everything between the start and the end will
  ; be carried out if an undo command is issued.
  (gimp-undo-push-group-start img)

  ; Create the text. See DBbrowser for parameters of gimp-text.
  (set! text-float (car (gimp-text-fontname
			 img
			 drawable
			 10 10
			 "Hello world"
			 0
			 1
			 50
			 0
			 "-*-utopia-*-r-*-*-*-*-*-*-*-*-*-*")))

  ; Anchor the selection
  (gimp-floating-sel-anchor text-float)

  ; Complete the undo group
  (gimp-undo-push-group-end img)

  ; Flush output
  (gimp-displays-flush))

(script-fu-register "script-fu-hello-world"
		    "<Image>/Script-Fu/Tutorial/Hello World"
		    "Write Hello World in the current image"
		    "Dov Grobgeld <dov.grobgeld@gmail.com>"
		    "Dov Grobgeld"
		    "2002-02-12"
		    "RGB*, GRAY*"
		    SF-IMAGE "Input Image" 0
		    SF-DRAWABLE "Input Drawable" 0)
