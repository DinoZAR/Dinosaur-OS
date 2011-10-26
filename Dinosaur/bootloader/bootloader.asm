; This is the very beginning of Dinosaur OS! It goes into protected mode and
; jumps to the kernel loader

[BITS 16]		; In real mode, every instruction is 16 bits
[ORG 0x7C00]	; This is where our code will be loaded, so we calculate
				; addresses from here

%define CR 13
%define LF 10

start:
	
	; Set video mode for BIOS so it always shows a large, colorful display for drawing text
	mov ah, 0x00
	mov al, 3
	int 0x10
	
	; Set the cursor to the top left of the screen
	mov ah, 0x02
	mov bh, 0
	mov dl, 0
	mov dh, 0
	int 0x10
	
	; Write "Welcome to Dinosaur!" to the screen
	mov si, welcome_string		; Copy address of welcome_string to si
	call PrintString
	
	call PrintHorizRule
	
	mov si, mesg_hdd_contents
	call PrintString
	
	hlt
	
	
PrintString:
	mov ah, 0x0E		; Teletype function
	cld
	
	PrintString_begin:
		lodsb
		or al, al
		jz PrintString_end
		int 0x10
		jmp PrintString_begin
		
	PrintString_end:
		ret

PrintHorizRule:
	mov ah, 0x0E		; Teletype function
	mov al, "_"
	mov cx, 80
	
	PrintHorizRule_begin:
		dec cx
		jz PrintHorizRule_end
		int 0x10
		jmp PrintHorizRule_begin
		
	PrintHorizRule_end:
		mov al, CR			; Add trailing CR and LF
		int 0x10
		mov al, LF
		int 0x10
		ret
	
data:
	%define CR 13
	%define LF 10
	
	welcome_string db "Welcome to Dinosaur!",CR,LF,0
	
	mesg_hdd_contents db "Reading 2nd Stage image...",0
	
end_filler:
    times 510 - ($ - $$) db 0		; Fills rest of sector with 0's
    dw 0xAA55						; Boot signature
