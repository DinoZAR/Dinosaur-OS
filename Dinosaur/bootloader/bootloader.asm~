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
	
	call PrintHorizRule
	
	mov si, mesg_status_2
	call PrintString
	
check_LBP_extensions:
	
	; Check LBP extensions with BIOS disk services
	; When interrupt is finished executing, it will set the CX register with features
	; We are interested in seeing if Bit 0 is set to 1, which if it is, then it
	; supports extensions
	mov ah, 0x41
	mov bx, 0x55AA		; Magic number
	mov dl, 0x01		; Drive number
	int 0x13
	
	push cx						; Print out contents of register for debug purposes
	call PrintRegister
	
	and cx, 0x0001				; Masks all except first bit
	cmp cx, 1
	je read_filesystem
	
	mov si, no_LBP_extensions		; If test failed, then say it has and halt
	call PrintString
	
	
read_filesystem:
	mov si, success
	call PrintString
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
	mov cx, 80
	
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
	mov ah, 0x0E				; AX -> Reserved for BIOS functions
	mov bx, 0x7FFF				; BX -> Used for mask to check each bit
	mov cl, 16					; CX -> Counter
	pop dx						; DX -> Actual register to print
	
	PrintRegister_begin:
		push dx
		and dx, bx				; Mask bit to check
		push cx
		sub cl, 1
		shr dx, cl				; Move single masked bit to first position
		pop cx
		
		cmp dx, 1
		pop dx
		
		je PrintRegister_1
		jmp PrintRegister_0
		
	PrintRegister_iterate:
		shl bx, 1				; Move my mask bit by 1
		dec cl
		cmp cl, 0
		je PrintRegister_end
		jmp PrintRegister_begin
		
	PrintRegister_1:
		mov al, 49				; ASCII code for character '1'
		int 0x10
		jmp PrintRegister_iterate
		
	PrintRegister_0:
		mov al, 48
		int 0x10
		jmp PrintRegister_iterate
		
	PrintRegister_end:
		mov si, success
		call PrintString
		ret
		
		
data:
	%define CR 13
	%define LF 10
	
	welcome_string db "Welcome to Dinosaur!",CR,LF,0
	mesg_status_2 db "Reading 2nd Stage image...",CR,LF,0
	
	; Assorted error messages
	no_LBP_extensions db "No LBP Ext!",CR,LF,0
	success db "Success",CR,LF,0
	
	
end_filler:
    times 510 - ($ - $$) db 0		; Fills rest of sector with 0's
    dw 0xAA55						; Boot signature
