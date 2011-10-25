; This is the very beginning of Dinosaur OS! It goes into protected mode and
; jumps to the kernel loader

[BITS 16]		; In real mode, every instruction is 16 bits
[ORG 0x7C00]	; This is where our code will be loaded, so we calculate
				; addresses from here

%define CR 13
%define LF 10

start:
	
	; Setup my stack segment first
	; Give it enough room for 4K of memory
	cli					; Don't allow interrupts while we do this. Interrupts require the stack to work
						; anyway, so don't let them work.
	mov ax, 0x00
	mov ss, ax			; Store number from ax into stack segment as an address from which to start
	mov sp, 4096		; 4K space
	sti					; After setting up stack, start interrupts again.
	
	
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
	
	; Write to the screen saying Dinosaur is starting
	mov si, [os_string]
	mov bl, 0x0C			; Sets text color to bright green
	call PrintString
	
	
	
	hlt
	
setup_protected_mode:

	; Create the Interrupt Descriptor Table (for real mode):
	; We do this by storing the Interrupt Desciptor Table Register value into a register,
	; multiply it by (4 * Vector#) to get the address of the table entry, then change the
	; table entry to the address of the routine that supports it.
	
	; The format of each entry is the following:
	; 1 - Address of routine to service interrupt (2 bytes)		This is what we will concern ourselves with mostly.
	; 2 - Offset (2 bytes)										This is always 0.
	
	

PrintString:
	mov ah, 0x0E		; Use BIOS Teletype function, which updates cursor for us
	mov cx, 1			; Set number of characters read to 0
	
	begin:
	lodsb		; Load next character
	cmp al,0
	jz done
	
	int 0x10
	jmp begin
	
	done:
	ret
	
	
data:
	os_string db "Welcome to Dinosaur!",CR,LF,0
	
	
end_filler:
    times 510 - ($ - $$) db 0		; Fills rest of sector with 0's
    dw 0xAA55						; Boot signature
