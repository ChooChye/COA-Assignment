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



	checkoutBanner1 BYTE "==========================FOOD MENU===============================",0dh,0ah
					BYTE "1. Nasi Lemak			- RM5",0dh,0ah
					BYTE "2. Nasi Goreng			- RM7",0dh,0ah
					BYTE "3. Mee Goreng			- RM6",0dh,0ah
					BYTE "4. Chicken Rice			- RM8",0dh,0ah
					BYTE "5. Wantan Mee			- RM7",0dh,0ah
					BYTE "==========================FOOD MENU===============================",0dh,0ah,0
	checkoutChoice	BYTE "Please select which food or 0 to stop: ", 0

	txtFoodSelected byte "==============Food Selected=============",0dh,0ah,0
	txtSubTotal		byte "The sub-total is : RM",0

	selectedChoice DWORD ?
	selectedChoice2 DWORD ?

	foodPrices		dword 5,7,6,8,7
	foodSelected	dword lengthof foodPrices DUP (0)

	foodPrice1		dword 5
	foodPrice2		dword 7
	foodPrice3		dword 6
	foodPrice4		dword 8
	foodPrice5		dword 7
	foodSum			dword 0

	foodx1			byte " x Nasi Lemak		- RM5",0
	foodx2			byte " x Nasi Goreng		- RM7",0
	foodx3			byte " x Mee Goreng		- RM6",0
	foodx4			byte " x Chicken Rice		RM8",0
	foodx5			byte " x Wantan Mee		- RM7",0

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
			;Increment quantity
			mov esi, 0
			add foodSelected[esi], 1
			mov eax, foodSelected[esi]

			call WriteDec
			mov edx, offset foodx1
			call WriteString
			call Crlf
			call Crlf
			loop _getChoice
		.elseif selectedChoice == 2
			mov esi, 4
			add foodSelected[esi], 1
			mov eax, foodSelected[esi]

			call WriteDec
			mov edx, offset foodx2
			call WriteString
			call Crlf
			call Crlf
			dec cx
			jne _getChoice
		.elseif selectedChoice == 3
			mov esi, 8
			add foodSelected[esi], 1
			mov eax, foodSelected[esi]

			call WriteDec
			mov edx, offset foodx3
			call WriteString
			call Crlf
			call Crlf
			dec cx
			jne _getChoice
		.elseif selectedChoice == 4
			mov esi, 12
			add foodSelected[esi], 1
			mov eax, foodSelected[esi]

			call WriteDec
			mov edx, offset foodx4
			call WriteString
			call Crlf
			call Crlf
			dec cx
			jne _getChoice
		.elseif selectedChoice == 5
			mov esi, 16
			add foodSelected[esi], 1
			mov eax, foodSelected[esi]

			call WriteDec
			mov edx, offset foodx5
			call WriteString
			call Crlf
			call Crlf
			dec cx
			jne _getChoice

		.elseif selectedChoice == 0
		call Clrscr
		mov edx, offset txtFoodSelected
		call WriteString
		call Crlf

		mov ecx, lengthof foodPrices
		mov esi, 0						; Point to element 0
		XOR EAX, EAX					; clear EAX value

		displayFoodSelected:

			mov eax, foodSelected[0]
			.if eax > 0
				call WriteDec
				mov edx, offset foodx1
				call WriteString
				call Crlf
			.endif

			mov eax, foodSelected[4]
			.if eax > 0
				call WriteDec
				mov edx, offset foodx2
				call WriteString
				call Crlf
			.endif

			mov eax, foodSelected[8]
			.if eax > 0
				call WriteDec
				mov edx, offset foodx3
				call WriteString
				call Crlf
			.endif

			mov eax, foodSelected[12]
			.if eax > 0
				call WriteDec
				mov edx, offset foodx4
				call WriteString
				call Crlf
			.endif

			mov eax, foodSelected[16]
			.if eax > 0
				call WriteDec
				mov edx, offset foodx5
				call WriteString
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
				loop sum

			mov edx, offset txtSubTotal
			call Crlf
			call WriteString
			mov eax, foodSum
			call WriteDec
			call Crlf
			
		.else
			call Crlf
			mov edx, offset invalidInput
			call WriteString
		.endif

	

;-------------------------------------------------------------------------------------------------;
;--------------------------------------------END FoodMenu ---------------------------------------;
;-------------------------------------------------------------------------------------------------;


	INVOKE ExitProcess,0		; INVOKE to call a function | Terminate the process

	main ENDP		;denotes the end of the procedure label
	END main		;denotes the end of the main driver