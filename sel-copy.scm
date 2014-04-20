; An example of how to create a floating layer and how to ancor it.
(define (script-fu-sel-copy img
    			drawable)

  (gimp-undo-push-group-start img)

  (gimp-edit-copy drawable)
  (set! sel-float (car (gimp-edit-paste drawable FALSE)))
  (gimp-layer-set-offsets sel-float 100 50)

  ; Anchor the selection
  (gimp-floating-sel-anchor sel-float)

  ; Complete the undo group
  (gimp-undo-push-group-end img)

  ; Flush output
  (gimp-displays-flush))


(script-fu-register "script-fu-sel-copy"
		    "<Image>/Script-Fu/Tutorial/Selection Copy"
		    "Copy the selection into the same layer"
		    "Dov Grobgeld"
		    "Dov Grobgeld"
		    "2002-02-12"
		    "RGB*, GRAY*"
		    SF-IMAGE "Image" 0
		    SF-DRAWABLE "Layer" 0)
