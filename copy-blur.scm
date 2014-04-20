; An example script that blurs an image according to a blur radius.
; It illustrates how to hang a script in the image menu, and
; how a plug-in may be called.
(define (script-fu-copy-blur img
			     drawable
			     blur-radius)
  ; Create a new layer
  (set! new-layer (car (gimp-layer-copy drawable 0)))

  ; Give it a name
  (gimp-layer-set-name new-layer "Gauss-blurred")

  ; Add the new layer to the image
  (gimp-image-add-layer img new-layer 0)

  ; Call a plugin to blur the image
  (plug-in-gauss-rle 1 img new-layer blur-radius 1 1)

  ; Invert the new layer
  (gimp-invert new-layer)

  ; Flush the display 
  (gimp-displays-flush)   
)

(script-fu-register "script-fu-copy-blur"
		    "<Image>/Script-Fu/Tutorial/copy-blur"
		    "Copy and blur a layer"
		    "Dov Grobgeld"
		    "Dov Grobgeld"
		    "2002"
		    "RGB*, GRAY*"
		    SF-IMAGE "Image" 0
		    SF-DRAWABLE "Layer to blur" 0
		    SF-VALUE "Blur strength" "5")
