; This is the very beginning of Dinosaur OS! It simply loads the second-stage
; bootloader and executes it. It does not handle the transition from real-mode
; to protected mode to long mode, which is reserved for the second stage loader.
;
; After this bootloader has finished executing, here is what will result (if
; everything works OK):
;
; 1. SS and FS will be set up to use the maximum space possible
;
; 2. SS will be at 0x1000 and above (used for stack)
;
; 3. FS will be at 0x2000 and above (used as data buffer for reading disks)


[BITS 16]		; In real mode, every instruction is 16 bits
[ORG 0x7C00]	; My boot sector is loaded to this memory address, so my address
				; calculations at assembly time must take that into account
jmp start

%define CR 13
%define LF 10

start:
	
	; Set video mode for BIOS so it always shows a large, colorful display for 
	; drawing text
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
	
	; Print a horizontal rule, or just a line separating things
	call PrintHorizRule
	
	; Say we are getting next bootloader image
	mov si, mesg_status_2
	call PrintString
	call NextLine
	
check_LBP_extensions:
	
	; Check LBP extensions with BIOS disk services
	; When interrupt is finished executing, it will set the carry flag depending
	; on whether there are extensions or not. If carry is cleared, then it does
	; have them
	mov ah, 0x41
	mov bx, 0x55AA		; Magic number
	mov dl, 0x80		; Drive number (first one according to standards)
	int 0x13
	
	jnc read_disk
	
	mov si, no_LBP_extensions		; If test failed, then say it has and halt
	call PrintString
	call NextLine
	hlt

read_disk:

	mov si, success
	call PrintString
	call NextLine
	
	; Use the old fashioned CHS read style for better compatability
	; MAJOR NOTE OF CONFUSION: Sectors are counted 1-based, track and head are
	; 0-based
	mov ah, 0x02
	mov al, 3		; Num sectors to read
	mov cx, 1		; Track and sector address (Upper 10 track, lower 6 sector)
	mov dh, 0		; Head number
	mov dl, 0x80	; Drive number
	
	; Set ES:BX to point to our buffer, which is at the end of this thing
	mov bx, ds
	mov es, bx
	mov bx, buffer
	
	int 0x13
	
	; If carry flag is cleared, then read performed successfully
	jnc goto_secondstage
	
	; Say it failed to read if it did
	mov si, error_message
	call PrintString
	call NextLine
	
	; Get the drive status to check error
	mov ah, 0x01
	mov dl, 0x80
	int 0x13
	
	push ax
	call PrintRegister
	call NextLine
	
	hlt
	
	
SectorContents:
	mov cx, 20
	mov di, bx
	
	SectorContents_loop:
		mov ax, [di]
		
		push cx
		push ax
		call PrintRegister
		call NextLine
		pop cx
		
		dec cx
		jz SectorContents_done
		add di, 2
		jmp SectorContents_loop
		
	SectorContents_done:
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
	mov ah, 0x0E
	mov al, CR
	int 0x10
	mov al, LF
	int 0x10
	ret


;	DATA

data:
	%define CR 13
	%define LF 10
	
	welcome_string db "Welcome to Dinosaur!",0
	mesg_status_2 db "Reading 2nd Stage image...",0
	
	; Assorted error messages
	no_LBP_extensions db "No LBP Ext!",0
	error_message db "Error!",0
	success db "Success",0
	
	
; END FILLER STUFF
	
end_filler:
    times 510 - ($ - $$) db 0		; Fills rest of sector with 0's
    dw 0xAA55						; Boot signature

buffer:								; Location to put my buffer in