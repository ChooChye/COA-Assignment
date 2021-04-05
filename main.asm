.386		; define intel 80386 (i386) instruction set

.model flat, stdcall	; model		=> define memory size of the program
						;			=> FLAT - windows default model
						; stdcall	=> language type that can be integrated with (high level language)
						;			=> windows 32-bit default

.stack 4096			; define stack segment & it tell about the size (4096 = 4kb)

ExitProcess PROTO, dwExitCode: DWORD		; Standard exit procedure

INCLUDE Irvine32.inc
INCLUDE Macros.inc

;------------------------------------Data Segment-------------------------------------;
.data		;defines the start of the data segment
	;define variables here
	 
	invalidInput		BYTE " =====  INVALID INPUT =====",0
	seperator			byte "=======================================",0
	fullStop			byte ".", 0
	percent				dword 100
	thousand			dword 1000
	quotient			dword ?
	remainder			dword ?
;-------------------------------------------------------------------------------------------------;
;------------------------------------START Data for Login Module -------------------------------------;
;-------------------------------------------------------------------------------------------------;


	buffer			BYTE 21 DUP(0)
	loginBanner		BYTE "==========================LOGIN===============================",0
	loginBanner1	BYTE "Enter username: ",0
	loginBanner2	BYTE "Enter password : ", 0

	staffName		BYTE "Jonathan Lim",0
	staffID			DWORD 1209
	staffPassword	DWORD 12341234

	loginInputStaffID	DWORD ?
	loginInputStaffPass	DWORD ?

	loginErrorText	BYTE "Staff ID does not exist, Please try again",0
	loginErrorText2	BYTE "Password incorrect, Please try again",0
	

	errorCount		DWORD 0

;-------------------------------------------------------------------------------------------------;
;------------------------------------END Data for Login Module ---------------------------------------;
;-------------------------------------------------------------------------------------------------;

;-------------------------------------------------------------------------------------------------;
;------------------------------------START Main Menu Module -------------------------------------;
;-------------------------------------------------------------------------------------------------;


	mmBanner1		BYTE "==========================MAIN MENU===============================",0dh,0ah
					BYTE "1. Checkout",0dh,0ah
					BYTE "2. Manage Stock",0dh,0ah
					BYTE "3. Logout",0dh,0ah
					BYTE "Please select an option: ",0

	mmChoice		DWORD ?


;-------------------------------------------------------------------------------------------------;
;------------------------------------END Main Menu Module ---------------------------------------;
;-------------------------------------------------------------------------------------------------;

;-------------------------------------------------------------------------------------------------;
;------------------------------------START Data for FoodMenu -------------------------------------;
;-------------------------------------------------------------------------------------------------;


	invalidVoucher	byte "Invalid voucher. Please try again", 0
	checkoutBanner1 BYTE "==========================FOOD MENU===============================",0dh,0ah
					BYTE "1. Nasi Lemak			- RM5.50",0dh,0ah
					BYTE "2. Nasi Goreng			- RM7.50",0dh,0ah
					BYTE "3. Mee Goreng			- RM6.20",0dh,0ah
					BYTE "4. Chicken Rice			- RM8.00",0dh,0ah
					BYTE "5. Wantan Mee			- RM7.00",0dh,0ah
					BYTE "==========================FOOD MENU===============================",0dh,0ah,0
	checkoutChoice	BYTE "Please select which food or 0 to stop: ", 0

	txtVoucher		byte "Do you have a discount voucher? (y)es or (n)o : ",0
	txtInsertVoucher	byte "Please enter the voucher number (e.g. 4321): ",0
	txtFoodSelected byte "==============Food Selected=============",0dh,0ah,0
	txtReceipt		byte "========================================",0dh,0ah
					byte "                 RECEIPT				  ",0dh,0ah
					byte "========================================",0dh,0ah,0
	txtSubTotal		byte "Sub-total		:RM",0
	txtSST			byte "SST (6%)		:	RM",0
	txtDiscount		byte "Discount		:(RM5)",0
	txtGrandTotal	byte "Grand Total		:RM",0

	selectedChoice DWORD ?
	selectedChoice2 DWORD ?
	voucherChoice byte ?
	voucherNo		dword ?

	foodPrices		dword 550,750,620,800,700				; Prices need to multiply by 100 in order to show decimals RM7 -> RM700 = RM7.00
	foodSelected	dword lengthof foodPrices DUP (0)
	foodTotal		dword lengthof foodPrices DUP (0)
	voucherRM		dword 5
		
	foodSubtotal	dword 0
	foodSum			dword 0

	foodx1			byte " x Nasi Lemak		- RM",0
	foodx2			byte " x Nasi Goreng		- RM",0
	foodx3			byte " x Mee Goreng		- RM",0
	foodx4			byte " x Chicken Rice	- RM",0
	foodx5			byte " x Wantan Mee		- RM",0
	

;-------------------------------------------------------------------------------------------------;
;------------------------------------END Data for FoodMenu ---------------------------------------;
;-------------------------------------------------------------------------------------------------;


;------------------------------------Code Segment-------------------------------------;
.code			;defines the code segment(instructions, codes) 
	main PROC		; Main Driver
	;write assembly code here

;-------------------------------------------------------------------------------------------------;
;------------------------------------Start Login Module ------------------------------------------;
;-------------------------------------------------------------------------------------------------;


_login:
	xor eax, eax
	mov edx, offset loginBanner
	call WriteString
	call Crlf

	mov edx, offset loginBanner1
	call WriteString
	call ReadInt
	mov loginInputStaffID, eax
	
	.if loginInputStaffID == 1209
		mov edx, offset loginBanner2
		call WriteString
		call ReadInt
		mov loginInputStaffPass, eax
		.if loginInputStaffPass == 1234
			JMP _displayMainMenu			;Login successful
		.else
			call Clrscr
			mov edx, offset loginErrorText2
			call WriteString
			call Crlf
			loop _login
	.endif
	.else
		mov edx, offset loginErrorText
		call WriteString
		call Crlf
		loop _login
	.endif
	

;-------------------------------------------------------------------------------------------------;
;------------------------------------End Login Module ------------------------------------------;
;-------------------------------------------------------------------------------------------------;


;-------------------------------------------------------------------------------------------------;
;------------------------------------------Start MainMenu ---------------------------------------;
;-------------------------------------------------------------------------------------------------;

_displayMainMenu:
	call Clrscr
	mov edx, offset mmBanner1
	call WriteString
	call Crlf
	
	mov edx, offset selectedChoice						;Output Text and receive input from user
	call WriteString
	call ReadInt

	.if selectedChoice == 1
		JMP _displayFoodMenu


	.endif


;-------------------------------------------------------------------------------------------------;
;------------------------------------------END MainMenu ---------------------------------------;
;-------------------------------------------------------------------------------------------------;


;-------------------------------------------------------------------------------------------------;
;------------------------------------------Start FoodMenu ---------------------------------------;
;-------------------------------------------------------------------------------------------------;

_displayFoodMenu :
		call Clrscr
		mov edx,OFFSET checkoutBanner1
		call WriteString
		call Crlf
		

_getChoice:
		mov edx, offset checkoutChoice						;Output Text and receive input from user
		call WriteString
		call ReadInt
		mov selectedChoice, eax

		mov ecx, lengthof foodSelected	

		.if selectedChoice == 1
			inc foodSelected[0]				;; Increment Nasi lemak quantity

			;; Display Quantity = 1 x Nasi Lemak	-RM
			mov eax, foodSelected[0]		
			call WriteDec
			mov edx, offset foodx1
			call WriteString

			;; Quantity * Price
			mov ebx,  foodPrices[0]
			mul ebx
			mov foodTotal[0], eax

			mov ebx, percent			; Divisor = 100
			xor edx, edx
			div ebx
			call writedec

			mov al, '.'             ; Decimal point
			call WriteChar 

			imul eax, edx, 10       ; EAX = EDX * 10 i.e. New dividend = Old remainder * 10
			xor edx, edx            ; Clear the high part of dividend
			div ebx                 ; EAX rem. EDX = EDX:EAX / EBX
			call WriteDec   

			imul eax, edx, 10       ; EAX = EDX * 10 i.e. New dividend = Old remainder * 10
			xor edx, edx            ; Clear the high part of dividend
			div ebx                 ; EAX rem. EDX = EDX:EAX / EBX
			call WriteDec  
			call crlf	
			call crlf
			jmp _getChoice					; Jump to getChoice

		.elseif selectedChoice == 2
			inc foodSelected[4]				;; Increment Nasi lemak quantity

			;; Display Quantity
			mov eax, foodSelected[4]		
			call WriteDec
			mov edx, offset foodx2
			call WriteString

			;; Quantity * Price
			mov ebx,  foodPrices[4]
			mul ebx
			mov foodTotal[4], eax

			mov ebx, percent			; Divisor = 100
			xor edx, edx
			div ebx
			call writedec

			mov al, '.'             ; Decimal point
			call WriteChar 

			imul eax, edx, 10       ; EAX = EDX * 10 i.e. New dividend = Old remainder * 10
			xor edx, edx            ; Clear the high part of dividend
			div ebx                 ; EAX rem. EDX = EDX:EAX / EBX
			call WriteDec   

			imul eax, edx, 10       ; EAX = EDX * 10 i.e. New dividend = Old remainder * 10
			xor edx, edx            ; Clear the high part of dividend
			div ebx                 ; EAX rem. EDX = EDX:EAX / EBX
			call WriteDec  
			call crlf			
			call crlf
			jmp _getChoice					; Jump to getChoice

		.elseif selectedChoice == 3
			inc foodSelected[8]				;; Increment Nasi lemak quantity

			;; Display Quantity = 1 x Nasi Lemak	-RM
			mov eax, foodSelected[8]		
			call WriteDec
			mov edx, offset foodx3
			call WriteString

			;; Quantity * Price
			mov ebx,  foodPrices[8]
			mul ebx
			mov foodTotal[8], eax

			mov ebx, percent			; Divisor = 100
			xor edx, edx
			div ebx
			call writedec

			mov al, '.'             ; Decimal point
			call WriteChar 

			imul eax, edx, 10       ; EAX = EDX * 10 i.e. New dividend = Old remainder * 10
			xor edx, edx            ; Clear the high part of dividend
			div ebx                 ; EAX rem. EDX = EDX:EAX / EBX
			call WriteDec   

			imul eax, edx, 10       ; EAX = EDX * 10 i.e. New dividend = Old remainder * 10
			xor edx, edx            ; Clear the high part of dividend
			div ebx                 ; EAX rem. EDX = EDX:EAX / EBX
			call WriteDec  
			call crlf			
			call crlf
			jmp _getChoice					; Jump to getChoice
		.elseif selectedChoice == 4
			inc foodSelected[12]				;; Increment Nasi lemak quantity

			;; Display Quantity = 1 x Nasi Lemak	-RM
			mov eax, foodSelected[12]		
			call WriteDec
			mov edx, offset foodx4
			call WriteString

			;; Quantity * Price
			mov ebx,  foodPrices[12]
			mul ebx
			mov foodTotal[12], eax

			mov ebx, percent			; Divisor = 100
			xor edx, edx
			div ebx
			call writedec

			mov al, '.'             ; Decimal point
			call WriteChar 

			imul eax, edx, 10       ; EAX = EDX * 10 i.e. New dividend = Old remainder * 10
			xor edx, edx            ; Clear the high part of dividend
			div ebx                 ; EAX rem. EDX = EDX:EAX / EBX
			call WriteDec   

			imul eax, edx, 10       ; EAX = EDX * 10 i.e. New dividend = Old remainder * 10
			xor edx, edx            ; Clear the high part of dividend
			div ebx                 ; EAX rem. EDX = EDX:EAX / EBX
			call WriteDec  
			call crlf			
			call crlf
			jmp _getChoice					; Jump to getChoice

		.elseif selectedChoice == 5
			inc foodSelected[16]				;; Increment Nasi lemak quantity

			;; Display Quantity = 1 x Nasi Lemak	-RM
			mov eax, foodSelected[16]		
			call WriteDec
			mov edx, offset foodx5
			call WriteString

			;; Quantity * Price
			mov ebx,  foodPrices[16]
			mul ebx
			mov foodTotal[16], eax

			mov ebx, percent			; Divisor = 100
			xor edx, edx
			div ebx
			call writedec

			mov al, '.'             ; Decimal point
			call WriteChar 

			imul eax, edx, 10       ; EAX = EDX * 10 i.e. New dividend = Old remainder * 10
			xor edx, edx            ; Clear the high part of dividend
			div ebx                 ; EAX rem. EDX = EDX:EAX / EBX
			call WriteDec   

			imul eax, edx, 10       ; EAX = EDX * 10 i.e. New dividend = Old remainder * 10
			xor edx, edx            ; Clear the high part of dividend
			div ebx                 ; EAX rem. EDX = EDX:EAX / EBX
			call WriteDec  
			call crlf			
			call crlf
			jmp _getChoice					; Jump to getChoice

		.elseif selectedChoice == 0
			
			call Clrscr
			mov edx, offset txtFoodSelected
			call WriteString
			call Crlf

			displayFoodSelected:
				mov eax, foodSelected[0]
				.if eax > 0
					mov ecx, lengthof foodPrices
					call WriteDec
					mov edx, offset foodx1
					call WriteString

					mov eax, foodTotal[0]
					mov ebx, percent			; Divisor = 100
					xor edx, edx
					div ebx
					call writedec

					mov al, '.'             ; Decimal point
					call WriteChar 

					imul eax, edx, 10       ; EAX = EDX * 10 i.e. New dividend = Old remainder * 10
					xor edx, edx            ; Clear the high part of dividend
					div ebx                 ; EAX rem. EDX = EDX:EAX / EBX
					call WriteDec   

					imul eax, edx, 10       ; EAX = EDX * 10 i.e. New dividend = Old remainder * 10
					xor edx, edx            ; Clear the high part of dividend
					div ebx                 ; EAX rem. EDX = EDX:EAX / EBX
					call WriteDec
					call Crlf
				.endif

				mov eax, foodSelected[4]
				.if eax > 0
					call WriteDec
					mov edx, offset foodx2
					call WriteString
					mov eax, foodTotal[4]
					mov ebx, percent			; Divisor = 100
					xor edx, edx
					div ebx
					call writedec

					mov al, '.'             ; Decimal point
					call WriteChar 

					imul eax, edx, 10       ; EAX = EDX * 10 i.e. New dividend = Old remainder * 10
					xor edx, edx            ; Clear the high part of dividend
					div ebx                 ; EAX rem. EDX = EDX:EAX / EBX
					call WriteDec   

					imul eax, edx, 10       ; EAX = EDX * 10 i.e. New dividend = Old remainder * 10
					xor edx, edx            ; Clear the high part of dividend
					div ebx                 ; EAX rem. EDX = EDX:EAX / EBX
					call WriteDec
					call Crlf
				.endif

				mov eax, foodSelected[8]
				.if eax > 0
					call WriteDec
					mov edx, offset foodx3
					call WriteString
					mov eax, foodTotal[8]
					mov ebx, percent			; Divisor = 100
					xor edx, edx
					div ebx
					call writedec

					mov al, '.'             ; Decimal point
					call WriteChar 

					imul eax, edx, 10       ; EAX = EDX * 10 i.e. New dividend = Old remainder * 10
					xor edx, edx            ; Clear the high part of dividend
					div ebx                 ; EAX rem. EDX = EDX:EAX / EBX
					call WriteDec   

					imul eax, edx, 10       ; EAX = EDX * 10 i.e. New dividend = Old remainder * 10
					xor edx, edx            ; Clear the high part of dividend
					div ebx                 ; EAX rem. EDX = EDX:EAX / EBX
					call WriteDec
					call Crlf
				.endif

				mov eax, foodSelected[12]
				.if eax > 0
					call WriteDec
					mov edx, offset foodx4
					call WriteString
					mov eax, foodTotal[12]
					mov ebx, percent			; Divisor = 100
					xor edx, edx
					div ebx
					call writedec

					mov al, '.'             ; Decimal point
					call WriteChar 

					imul eax, edx, 10       ; EAX = EDX * 10 i.e. New dividend = Old remainder * 10
					xor edx, edx            ; Clear the high part of dividend
					div ebx                 ; EAX rem. EDX = EDX:EAX / EBX
					call WriteDec   

					imul eax, edx, 10       ; EAX = EDX * 10 i.e. New dividend = Old remainder * 10
					xor edx, edx            ; Clear the high part of dividend
					div ebx                 ; EAX rem. EDX = EDX:EAX / EBX
					call WriteDec
					call Crlf
				.endif

				mov eax, foodSelected[16]
				.if eax > 0
					call WriteDec
					mov edx, offset foodx5
					call WriteString
					mov eax, foodTotal[16]
					mov ebx, percent			; Divisor = 100
					xor edx, edx
					div ebx
					call writedec

					mov al, '.'             ; Decimal point
					call WriteChar 

					imul eax, edx, 10       ; EAX = EDX * 10 i.e. New dividend = Old remainder * 10
					xor edx, edx            ; Clear the high part of dividend
					div ebx                 ; EAX rem. EDX = EDX:EAX / EBX
					call WriteDec   

					imul eax, edx, 10       ; EAX = EDX * 10 i.e. New dividend = Old remainder * 10
					xor edx, edx            ; Clear the high part of dividend
					div ebx                 ; EAX rem. EDX = EDX:EAX / EBX
					call WriteDec
					call Crlf
				.endif

			mov ecx, lengthof foodPrices
			mov esi, 0						; Point to element 0
			XOR EAX, EAX					; clear EAX value

			sum:
				mov eax, foodSelected[esi]		; Move quantity from index 0
				mov ebx, foodPrices[esi]		; Move price from element 0 => 5
				mul ebx							; Multiply
				add foodSum, eax				; add the sum value to variable foodSum
				add esi, type foodSelected		; increase esi
				loop sum						; loop sum
				
			mov edx, offset txtSubTotal
			call Crlf
			call WriteString
			mov eax, foodSum
			call WriteDec
			call Crlf

			readVoucher:
				mov edx, offset txtVoucher
				call writestring
				call readchar
				mov voucherChoice, al
				call Crlf
				call Crlf

			compareY:
				cmp		voucherChoice, 'y'
				je		inputVoucher		; input == 'y'
				jne		compareN	; input != 'y'

			compareN:
				cmp voucherChoice, 'n'
				je   showGrandTotal
				jne	 errorVoucher

			errorVoucher:
				mov edx, offset invalidVoucher
				call writestring
				call Crlf
				loop readVoucher
			
			

			inputVoucher:
				mov edx, offset txtInsertVoucher
				call writestring
				call readint
				mov voucherNo, eax

				.if voucherNo == 0000
					
;------------------Subtract voucher amount from foodSum
					mov eax, foodSum
					mov foodSubtotal, eax
					mov ebx, voucherRM
					sub eax, ebx
					mov foodSum, eax
					call showGrandTotal
				.endif

			showGrandTotal:
				call Clrscr
				xor eax, eax

				mov edx, offset txtReceipt
				call writestring
				call crlf

				mov eax, foodSelected[0]
				.if eax > 0
					mov ecx, lengthof foodPrices
					call WriteDec
					mov edx, offset foodx1
					call WriteString

					mov eax, foodTotal[0]
					call writeDec
					call Crlf
				.endif

				mov eax, foodSelected[4]
				.if eax > 0
					call WriteDec
					mov edx, offset foodx2
					call WriteString
					mov eax, foodTotal[4]
					call writeDec
					call Crlf
				.endif

				mov eax, foodSelected[8]
				.if eax > 0
					call WriteDec
					mov edx, offset foodx3
					call WriteString
					mov eax, foodTotal[8]
					call writeDec
					call Crlf
				.endif

				mov eax, foodSelected[12]
				.if eax > 0
					call WriteDec
					mov edx, offset foodx4
					call WriteString
					mov eax, foodTotal[12]
					call writeDec
					call Crlf
				.endif

				mov eax, foodSelected[16]
				.if eax > 0
					call WriteDec
					mov edx, offset foodx5
					call WriteString
					mov eax, foodTotal[16]
					call writeDec
					call Crlf
				.endif

				call Crlf
				mov edx, offset seperator
				call writestring
				call Crlf
				call Crlf
;---------------Subtotal
				mov edx, offset txtSubTotal
				call writestring

				mov eax, foodSubtotal
				call writedec
				call crlf

				mov edx, offset txtDiscount
				call writestring
				call crlf

;---------------Grandtotal
				mov edx, offset txtGrandTotal
				call writestring
				mov eax, foodSum
				call writedec
				call crlf

				readChoice:
					mov edx, offset txtVoucher
					call writestring
					call readint
					mov selectedChoice, eax
					call Crlf
					call Crlf

				

				dec cx
				jne _displayMainMenu

		.else
			call Crlf
			mov edx, offset invalidInput
			call WriteString
		.endif

	

;-------------------------------------------------------------------------------------------------;
;--------------------------------------------END FoodMenu ---------------------------------------;
;-------------------------------------------------------------------------------------------------;

	TERMINATE:
		INVOKE ExitProcess,0		; INVOKE to call a function | Terminate the process

	main ENDP		;denotes the end of the procedure label
	END main		;denotes the end of the main driver