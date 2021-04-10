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


;**************************************************************************************************;
;---------------------------------------------------------------------------------------------------;
;------------------------------------START Manage Stock Module -------------------------------------;
;---------------------------------------------------------------------------------------------------;


	mmBannerMenu		BYTE "===================MANAGE STOCK MENU===================", 0dh,0ah
						BYTE "1. Add Item",0dh,0ah
						BYTE "2. Update Item",0dh,0ah
						BYTE "3. Delete Item",0dh,0ah
						BYTE "4. View Item",0dh,0ah
						BYTE "5. Back",0dh,0ah
						BYTE "Please select an option: ",0
	
	mmChoiceMenu		DWORD ?


;---------------------------------------------------------------------------------------------------;
;------------------------------------END Manage Stock Module ---------------------------------------;
;---------------------------------------------------------------------------------------------------;

;---------------------------------------------------------------------------------------------------;
;------------------------------------START Add Item ------------------------------------------------;
;---------------------------------------------------------------------------------------------------;


	mmBannerAdd		BYTE "===================MANAGE STOCK MENU===================", 0dh,0ah
				
					BYTE "Please enter new product name: ",0
	
	

	;prodName		QWORD	"NasiLemak", "NasiGoreng", "MeeGoreng", "ChickenRice", "WantanMee"

	addErrorText	BYTE "This product name is existed, Please try again",0
	mmChoiceAdd			DWORD ?

;-------------------------------------------------------------------------------------------------;
;-----------------------------------------END Add Item -------------------------------------------;
;-------------------------------------------------------------------------------------------------;
;**************************************************************************************************;


;-------------------------------------------------------------------------------------------------;
;------------------------------------START Data for ProductList ------------------ ---------------;
;-------------------------------------------------------------------------------------------------;



	checkoutBannerPL BYTE "======================PRODUCT LIST======================", 0dh,0ah
				BYTE "1. Nasi Lemak			- RM5.50",0dh,0ah
					BYTE "2. Nasi Goreng			- RM7.50",0dh,0ah
					BYTE "3. Mee Goreng			- RM6.20",0dh,0ah
					BYTE "4. Chicken Rice			- RM8.00",0dh,0ah
					BYTE "5. Wantan Mee			- RM7.00",0dh,0ah
					BYTE "======================PRODUCT LIST======================", 0dh,0ah,0
	checkoutChoicePL	BYTE "Please select which product to view or 0 to stop: ", 0

	txtProductSelected byte "==============Product Selected=============",0dh,0ah,0
	txtProdSubTotal		byte "Price:	RM",0
	txtProdSST			byte "SST (6%) :	RM",0

	selectedChoiceP1 DWORD ?
	selectedChoiceP2 DWORD ?

	foodPricesList		dword 550,750,620,800,700
	foodSelectedList	dword lengthof foodPricesList DUP (0)

		

	prodPrice1		dword 5
	prodPrice2		dword 7
	prodPrice3		dword 6
	prodPrice4		dword 8
	prodPrice5		dword 7
	prodSum			dword 0
	prodSubtotal	dword 0
	

	prodx1			byte " x Nasi Lemak		- RM",0
	prodx2			byte " x Nasi Goreng		- RM",0
	prodx3			byte " x Mee Goreng		- RM",0
	prodx4			byte " x Chicken Rice		RM",0
	prodx5			byte " x Wantan Mee		- RM",0
	
	prodPrices		dword 550,750,620,800,700				; Prices need to multiply by 100 in order to show decimals RM7 -> RM700 = RM7.00
	prodSelected	dword lengthof prodPrices DUP (0)
	prodTotal		dword lengthof prodPrices DUP (0)

;-------------------------------------------------------------------------------------------------;
;------------------------------------END Data for FoodMenu ---------------------------------------;
;-------------------------------------------------------------------------------------------------;


;------------------------------------Code Segment-------------------------------------;
.code			;defines the code segment(instructions, codes) 
	main PROC		; Main Driver
	;write assembly code here

;*******************************************************************************************************;
;-------------------------------------------------------------------------------------------------;
;------------------------------------------Start ManageStockMenu ---------------------------------------;
;-------------------------------------------------------------------------------------------------;

_displayManageStock :
		call Clrscr
		mov edx,OFFSET mmBannerMenu
		call WriteString
		call Crlf
		
	
		mov edx, offset mmChoiceMenu						;Output Text and receive input from user
		call WriteString
		call ReadInt

		.if mmChoiceMenu == 1
			JMP _displayAddItem
		.elseif mmChoiceMenu == 2
			JMP _displayUpdateItem


		.endif


_displayAddItem :
		
		call Clrscr
		mov edx,OFFSET mmBannerAdd
		call WriteString
		call Crlf
		jmp	_getAddChoice


_displayUpdateItem :
		call Clrscr
		mov edx,OFFSET checkoutBannerPL
		call WriteString
		call Crlf
		jmp _getViewChoice

_getAddChoice:
		
		mov		edx, offset mmBannerAdd
		call	WriteString
		call	ReadString
		call crlf
		mov		mmChoiceAdd, eax

	;	mov ecx, lengthof foodSelectedList	

;		.if mmChoiceAdd == "NasiLemak"
		.if mmChoiceAdd == "Nasi"
			mov edx, offset addErrorText
			call WriteString
			call Crlf
			loop _getAddChoice
		
		
		.endif

	


_getViewChoice:

		mov edx, offset checkoutChoicePL						;Output Text and receive input from user
		call WriteString
		call ReadInt
		mov selectedChoiceP1, eax

		mov ecx, lengthof foodSelectedList	

		.if selectedChoiceP1 == 1
			inc foodSelectedList[0]				;; Increment Nasi lemak quantity

			;; Display Quantity = 1 x Nasi Lemak	-RM
			mov eax, foodSelectedList[0]		
			call WriteDec
			mov edx, offset prodx1
			call WriteString

			;; Quantity * Price
			mov ebx,  foodPricesList[0]
			mul ebx
			mov prodTotal[0], eax

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
			jmp _getViewChoice					; Jump to getChoice

		.elseif selectedChoiceP1 == 2
			inc foodSelectedList[4]				;; Increment Nasi lemak quantity

			;; Display Quantity
			mov eax, foodSelectedList[4]		
			call WriteDec
			mov edx, offset prodx2
			call WriteString

			;; Quantity * Price
			mov ebx,  foodPricesList[4]
			mul ebx
			mov prodTotal[4], eax

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
			jmp _getViewChoice					; Jump to getChoice

		

	.endif
;-------------------------------------------------------------------------------------------------;
;--------------------------------------------END ManageStockMenu ---------------------------------------;
;-------------------------------------------------------------------------------------------------;
;*******************************************************************************************************;

	
		INVOKE ExitProcess,0		; INVOKE to call a function | Terminate the process

	main ENDP		;denotes the end of the procedure label
	END main		;denotes the end of the main driver