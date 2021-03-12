.386		; define intel 80386 (i386) instruction set

.model flat, stdcall	; model		=> define memory size of the program
						;			=> FLAT - windows default model
						; stdcall	=> language type that can be integrated with (high level language)
						;			=> windows 32-bit default

.stack 4096			; define stack segment & it tell about the size (4096 = 4kb)

ExitProcess PROTO, dwExitCode: DWORD		; Standard exit procedure

INCLUDE Irvine32.inc

;------------------------------------Data Segment-------------------------------------;
.data		;defines the start of the data segment
	;define variables here

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

	errorCount		DWORD 0

;-------------------------------------------------------------------------------------------------;
;------------------------------------END Data for Login Module ---------------------------------------;
;-------------------------------------------------------------------------------------------------;

;-------------------------------------------------------------------------------------------------;
;------------------------------------START Main Menu Module -------------------------------------;
;-------------------------------------------------------------------------------------------------;


	mmBanner1		BYTE "==========================MAIN MENU===============================",0
	mmBanner2		BYTE "1. Checkout",0
	mmBanner3		BYTE "2. Manage Stock",0
	mmBanner4		BYTE "3. Logout",0

	mmChoice		DWORD ?


;-------------------------------------------------------------------------------------------------;
;------------------------------------END Main Menu Module ---------------------------------------;
;-------------------------------------------------------------------------------------------------;

;-------------------------------------------------------------------------------------------------;
;------------------------------------START Data for FoodMenu -------------------------------------;
;-------------------------------------------------------------------------------------------------;



	checkoutBanner1 BYTE "==========================FOOD MENU===============================",0
	checkoutBanner2 BYTE "1. Food 1",0
	checkoutBanner3 BYTE "2. Food 2",0
	checkoutBanner4 BYTE "3. Food 3",0
	checkoutBanner5 BYTE "4. Food 4",0
	checkoutBanner6 BYTE "5. Food 5",0
	checkoutBanner7 BYTE "==========================FOOD MENU===============================",0
	checkoutChoice	BYTE "Please select which food : ", 0

	selectedChoice DWORD ?

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
	mov edx, offset loginBanner
	call WriteString
	call Crlf

	mov edx, offset loginBanner1
	call WriteString
	call ReadInt
	mov staffID, eax

	.if staffID == 1
		mov edx, offset staffName
		call WriteString
		call Crlf
	.endif

_mainMenu:



;-------------------------------------------------------------------------------------------------;
;------------------------------------End Login Module ------------------------------------------;
;-------------------------------------------------------------------------------------------------;


	INVOKE ExitProcess,0		; INVOKE to call a function | Terminate the process

	main ENDP		;denotes the end of the procedure label
	END main		;denotes the end of the main driver