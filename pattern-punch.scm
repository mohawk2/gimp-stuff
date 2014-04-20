; The GIMP -- an image manipulation program
; Copyright (C) 1995 Spencer Kimball and Peter Mattis
; 
; This program is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
; 
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
; 
; You should have received a copy of the GNU General Public License
; along with this program; if not, write to the Free Software
; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
;
; Copyright (C) 1997 Dov Grobgeld dov.grobgeld@gmail.com
;
; Version 0.1 30 Nov 1997

; Description: 
;
;   To use this script the user should prepare a layer with black
;   background with some white paint on it. This script, which is
;   placed in the image/script-fu/stencils menu, takes this layer as
;   input and bumps all white areas with the desired pattern and make
;   all black areas transparent. E.g. with a white ellipse as input the
;   script creates a nice looking elliptic button suitable for being
;   saved as a transparent GIF.

(define (script-fu-pattern-punch
	 img
	 stencil
	 blur-strength
	 depth
	 pattern 
	 pressed)
  (let* ((old-bg-color (car (gimp-palette-get-background)))
	 (img-width (car (gimp-image-width img)))
	 (img-height (car (gimp-image-height img)))
	 (pattern-layer (car (gimp-layer-new img img-width img-height RGBA_IMAGE "Punch layer" 100 NORMAL))))

    ; standard startup
    (gimp-image-disable-undo img)

    ; Add a new pattern layer
    (gimp-image-add-layer img pattern-layer -1)

    ; We don't support selections so let's clear it.
    (gimp-selection-none img)

    ; blur the image
    (plug-in-gauss-rle 1 img stencil blur-strength TRUE TRUE)

    ; sharpen it
;    (gimp-levels img background VALUE 0 40 3.0 0 255)

    ; Fill the pattern layer with the pattern
    (gimp-palette-set-background '(100 500 200))
    (gimp-edit-fill img pattern-layer)
    (gimp-patterns-set-pattern pattern)
    (gimp-bucket-fill img pattern-layer PATTERN-BUCKET-FILL NORMAL 100 0 FALSE 0 0)

    ; Bump map
    (plug-in-bump-map 1 img pattern-layer stencil 135 45 depth 0 0 0 92 TRUE pressed 2)

    ; Add a layer mask to the button
    (set! mask (car (gimp-layer-create-mask pattern-layer WHITE-MASK)))
    (gimp-image-add-layer-mask img pattern-layer mask)

    ; Copy the mask to the layer mask
    (gimp-edit-copy img stencil)
    (gimp-floating-sel-anchor (car (gimp-edit-paste img mask 0)))
    (gimp-layer-set-visible stencil 0)

    ; Sharpen the mask
    (gimp-levels img mask 0 0 90 0.16 0 255)

    ; Clean up
    (gimp-image-set-active-layer img pattern-layer)

    (gimp-palette-set-background old-bg-color)
    (gimp-image-enable-undo img)
    (gimp-displays-flush)))

; Instructions: Draw something white on a black background. Then 
; call pattern punch. All white areas are filled with the requested 
; pattern and all black areas become transparent.
(script-fu-register "script-fu-pattern-punch"
		    "<Image>/Script-Fu/Stencil Ops/Pattern Punch"
		    "Punch a B/W image into a pattern. "
		    "Dov Grobgeld <dov.grobgeld@gmail.com>"
		    "Dov Grobgeld"
		    "29/11/1997"
		    ""
		    SF-IMAGE "Input Image" 0
		    SF-DRAWABLE "Input Drawable" 0
		    SF-VALUE "Blur amount" "5"
		    SF-VALUE "Depth" "7"
		    SF-VALUE  "Pattern"  "\"Blue Web\""
		    SF-TOGGLE "Pressed?"   FALSE)
