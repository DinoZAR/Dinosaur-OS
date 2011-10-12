; This is the very beginning of Dinosaur OS! It goes into protected mode and
; jumps to the kernel loader

[BITS 16]		; In real mode, every instruction is 16 bits
[ORG 0x7C00]	; This is where our code will be loaded, so we calculate
				; addresses from here
			
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
	
	
	; Write to the screen saying Dinosaur is starting
	mov ah, 0x13
	mov es, os_string
	mov bp, 0
	mov cx, os_string_len		; Number of characters to draw
	mov bl, 0x0C				; Green text color
	mov dh, 0					; Row
	mov dl, 0					; Column
	mov al, 3					; Write mode (character, with attribute, and update cursor)
	int 0x10
	
	
setup_protected_mode:

	; Create the Interrupt Descriptor Table (for real mode):
	; We do this by defining all of the table contents here, and then later loading the interrupt pointer
	; with the address of the first entry.
	
	; The format of each entry is the following:
	; 1 - Address of routine to service interrupt (2 bytes)		This is what we will concern ourselves with mostly.
	; 2 - Offset (2 bytes)										This is always 0.
	
	

data:

	os_string db "Welcome to Dinosaur!"
	os_string_len equ ($ - os_string)
	
	
end_filler:
    times 510 - ($ - $$) db 0		; Fills rest of sector with 0's
    dw 0xAA55						; Boot signature