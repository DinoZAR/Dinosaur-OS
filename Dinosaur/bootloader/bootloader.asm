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
	mov si, welcome_string
	call PrintString
	call NextLine
	
	call PrintHorizRule
	
	; Say we are getting next image
	mov si, mesg_status_2
	call PrintString
	call NextLine
	
check_LBP_extensions:
	
	; Check LBP extensions with BIOS disk services
	; When interrupt is finished executing, it will set the CX register with features
	; We are interested in seeing if Bit 0 is set to 1, which if it is, then it
	; supports extensions
	mov ah, 0x41
	mov bx, 0x55AA		; Magic number
	mov dl, 0x80		; Drive number 1000 0000B is first one according to standards
	int 0x13
	
	and cx, 0x0001		; Masks all except first bit
	or cx, 0
	jnz read_filesystem
	
	mov si, no_LBP_extensions		; If test failed, then say it has and halt
	call PrintString
	call NextLine
	hlt
	
read_filesystem:
	
	; Get the contents of a sector and print out its crap
	
	
	hlt


; FUNCTIONS	
	
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
	mov cx, 81
	
	PrintHorizRule_begin:
		dec cx
		jz PrintHorizRule_end
		int 0x10
		jmp PrintHorizRule_begin
		
	PrintHorizRule_end:
		mov al, CR				; Add trailing CR and LF
		int 0x10
		mov al, LF
		int 0x10
		ret

PrintRegister:
	; Manage my stack properly
	push bp
	mov bp, sp
	
	mov ah, 0x0E				; AX -> Reserved for BIOS functions
	mov bx, 0x8000				; BX -> Used for mask to check each bit
	mov cl, 16					; CX -> Counter
								; DX -> Actual register to print
								
	PrintRegister_begin:
		mov dx, [bp+4]
		and dx, bx				; Mask bit to check
		
		or dx, 0
		jz PrintRegister_0
		jmp PrintRegister_1
		
	PrintRegister_iterate:
		shr bx, 1				; Move my mask over by 1
		dec cl
		cmp cl, 0
		je PrintRegister_end
		jmp PrintRegister_begin
		
	PrintRegister_1:
		mov al, 49				; ASCII code for character '1'
		int 0x10
		jmp PrintRegister_iterate
		
	PrintRegister_0:
		mov al, 48				; ASCII code for character '0'
		int 0x10
		jmp PrintRegister_iterate
		
	PrintRegister_end:
		pop bp
		ret 2
		
NextLine:
	mov si, next_line
	call PrintString
	ret


;	DATA

data:
	%define CR 13
	%define LF 10
	
	welcome_string db "Welcome to Dinosaur!",0
	mesg_status_2 db "Reading 2nd Stage image...",0
	next_line db CR,LF,0
	
	; Assorted error messages
	no_LBP_extensions db "No LBP Ext!",0
	success db "Success",0
	
; END FILLER STUFF
	
end_filler:
    times 510 - ($ - $$) db 0		; Fills rest of sector with 0's
    dw 0xAA55						; Boot signature
