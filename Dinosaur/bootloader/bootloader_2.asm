; This is my second stage loader. It is responsible for loading protected and
; long mode and starting the kernel
;
; Num sectors required: 1
;
; Compiled as flat binary

[BITS 16]
[ORG 0x7E00]		; The origin of this code is one sector above 0x7C00, which
					; is 0x7C00 + 0x200 = 0x7E00
					
