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
	percent				dword 100
;-------------------------------------------------------------------------------------------------;
;------------------------------------START Data for Login Module -------------------------------------;
;-------------------------------------------------------------------------------------------------;


	buffer			BYTE 21 DUP(0)
	loginBanner1	BYTE "=========================POS SYSTEM===========================",0dh,0ah
					byte "|                                                             |",0dh,0ah
					BYTE "|                         LOGIN                               |",0dh,0ah
					BYTE "|                        =======                              |",0dh,0ah
	blankBanner		byte "|                                                             |",0dh,0ah,0
	loginBanner2	BYTE "|            Enter Username :                                 |",0
	loginBanner3	BYTE "|            Enter Password :                                 |",0
	loginBannerEnd	BYTE "=========================POS SYSTEM===========================",0
	

	staffName		BYTE "Jonathan Lim",0
	staffID			DWORD 1209
	staffPassword	DWORD 1234

	loginInputStaffID	DWORD ?
	loginInputStaffPass	DWORD ?
	errorAdjust			dword 0
	loginErrorText	BYTE "Staff ID does not exist, Please try again",0
	loginErrorText2	BYTE "Password incorrect, Please try again",0
	logoutText BYTE "Successfully logged out.",0

	errorCount		DWORD 0

;-------------------------------------------------------------------------------------------------;
;------------------------------------END Data for Login Module ---------------------------------------;
;-------------------------------------------------------------------------------------------------;

;-------------------------------------------------------------------------------------------------;
;------------------------------------START Main Menu Module -------------------------------------;
;-------------------------------------------------------------------------------------------------;


	mmBanner1		BYTE "=========================-MAIN MENU-==============================",0dh,0ah
					BYTE "|                                                                |",0dh,0ah
					BYTE "|  1. Checkout                                                   |",0dh,0ah
					BYTE "|  2. Manage Stock                                               |",0dh,0ah
					BYTE "|  3. Logout                                                     |",0dh,0ah
					BYTE "|  Please select an option: ",0

	mmChoice		DWORD ?
	mminvalidInput	BYTE " ===========================================",0dh,0ah
					BYTE " =  INVALID INPUT. Please enter 1,2,3 only =",0dh,0ah
					BYTE " ===========================================",0
	mmSummary		byte " =========================================== ",0dh,0ah
					byte " |                                         |",0dh,0ah
					byte " |              SUMMARY REPORT             |",0dh,0ah
					byte " |                                         |",0dh,0ah
					byte " =========================================== ",0dh,0ah,0
	mmGT			byte " =========================================== ",0dh,0ah
					byte " Grand Total Sales : RM ",0
;-------------------------------------------------------------------------------------------------;
;------------------------------------END Main Menu Module ---------------------------------------;
;-------------------------------------------------------------------------------------------------;

;-------------------------------------------------------------------------------------------------;
;------------------------------------START Data for FoodMenu -------------------------------------;
;-------------------------------------------------------------------------------------------------;


	invalidVoucher	byte "Invalid voucher. Please try again", 0
	invalidPay		byte "ERROR. Payable Amount must be greater than GrandTotal",0
	checkoutBanner1 BYTE "==========================FOOD MENU===============================",0
	checkoutBanner2	BYTE "1. Nasi Lemak			- RM ",0
	checkoutBanner3	BYTE "2. Nasi Goreng			- RM ",0
	checkoutBanner4	BYTE "3. Mee Goreng			- RM ",0
	checkoutBanner5	BYTE "4. Chicken Rice			- RM ",0
	checkoutBanner6	BYTE "5. Wantan Mee			- RM ",0
	checkoutBanner7	BYTE "==========================FOOD MENU===============================",0dh,0ah,0
	checkoutChoice	BYTE "Please select which food | 0 to checkout | 99 to return to main menu: ", 0
	rChoice			byte ?
	txtVoucher		byte "Do you have a discount voucher? (y)es or (n)o : ",0
	txtInsertVoucher	byte "Please enter the voucher number (e.g. 4321): ",0
	txtFoodSelected byte "==============Food Selected=============",0dh,0ah,0
	txtReceipt		byte "========================================",0dh,0ah
					byte "                 RECEIPT				  ",0dh,0ah
					byte "========================================",0dh,0ah,0
	txtBack			byte "Transaction completed...",0dh,0ah
					byte "Press (q) to return back to main menu : ",0
	txtSubTotal		byte "Sub-total		:RM ",0
	txtNewSubTotal	byte "         		:RM ",0
	txtSST			byte "SST (6%)		:RM ",0
	txtDiscount		byte "Discount		:(RM5.90)",0
	txtGrandTotal	byte "Grand Total		:RM ",0
	txtPay			byte "Enter amount payable	:RM ",0
	txtBal			byte "Balance			:RM ",0
	

	selectedChoice DWORD ?
	selectedChoice2 DWORD ?
	voucherChoice	byte ?
	voucherNo		dword ?
	payAmount		dword ?

	sstTax			dword 600
	sst				dword ?

	divideSST		dword 1000000
	discountExist	dword 0
	foodPrices		dword 550,750,620,800,700				; Prices need to multiply by 100 in order to show decimals RM7 -> RM700 = RM7.00
	foodSelected	dword lengthof foodPrices DUP (0)
	foodTotal		dword lengthof foodPrices DUP (0)
	voucherRM		dword 590
		
	foodSubtotal	dword 0
	foodSum			dword 0

	foodx1			byte " x Nasi Lemak		- RM ",0
	foodx2			byte " x Nasi Goreng		- RM ",0
	foodx3			byte " x Mee Goreng		- RM ",0
	foodx4			byte " x Chicken Rice	- RM ",0
	foodx5			byte " x Wantan Mee		- RM ",0

	foodxx1			byte " x Nasi Lemak ",0
	foodxx2			byte " x Nasi Goreng ",0
	foodxx3			byte " x Mee Goreng",0
	foodxx4			byte " x Chicken Rice",0
	foodxx5			byte " x Wantan Mee",0

	arrfoodName	dword foodx1,foodx2,foodx3,foodx4,foodx5
	exitfoodName	dword foodxx1,foodxx2,foodxx3,foodxx4,foodxx5
	
	exitGrandtotal	dword 0
	exitFoodSelected dword lengthof foodSelected DUP (0)
;-------------------------------------------------------------------------------------------------;
;------------------------------------END Data for FoodMenu ---------------------------------------;
;-------------------------------------------------------------------------------------------------;

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


	mmBannerAdd		BYTE "===================ADD NEW ITEM===================", 0dh,0ah,0
				
	choiceName				BYTE "Please enter new product name | 0 to back | 99 to return to main menu: ",0

	MAX = 80                     ;max chars to read

	prodName		BYTE	" Nasi Lemak ", " Nasi Goreng ", " Mee Goreng ", " Chicken Rice ", " Wantan Mee ", 0
	

	addErrorText	BYTE "This product name is existed, Please try again ",0
	mmChoiceAdd			DWORD ?


;-------------------------------------------------------------------------------------------------;
;-----------------------------------------END Add Item -------------------------------------------;
;-------------------------------------------------------------------------------------------------;

;-------------------------------------------------------------------------------------------------;
;------------------------------------START Data for ProductList ------------------ ---------------;
;-------------------------------------------------------------------------------------------------;



	productBanner	BYTE "======================PRODUCT LIST======================", 0dh,0ah
					BYTE "1. Nasi Lemak			",0dh,0ah
					BYTE "2. Nasi Goreng	",0dh,0ah
					BYTE "3. Mee Goreng		",0dh,0ah
					BYTE "4. Chicken Rice	",0dh,0ah
					BYTE "5. Wantan Mee		",0dh,0ah
					BYTE "======================PRODUCT LIST======================", 0dh,0ah,0

	viewBanner		BYTE "-----------------------VIEW ITEM-----------------------",0
	updateBanner	BYTE "-----------------------UPDATE ITEM-----------------------",0
	addBanner	BYTE "-----------------------ADD ITEM-----------------------",0
	lineBanner		BYTE "---------------------------------------------------------",0

	viewChoicePL	BYTE "Please select which PRODUCT to proceed or 0 to stop: ", 0
	viewOption		BYTE	"Do you want to continue VIEW item?  (y)es or (n)o :  ", 0

	addOption		BYTE	"Do you want to continue ADD item?  (y)es or (n)o :  ", 0
	updateChoice	BYTE "1. Name ", 0dh, 0ah
					BYTE "2. Food Price ", 0dh, 0ah
					BYTE "3. Discount price ", 0dh, 0ah
					BYTE "4. Profit price ", 0dh, 0ah
					BYTE "5. Back ", 0dh, 0ah
					BYTE "-----------------------UPDATE ITEM-----------------------", 0dh, 0ah
					BYTE "Please select an option to update : ", 0
	
	updateName			BYTE	"Please enter new name : ", 0
	updateNewName		DWORD	?
	MAX = 80                     ;max chars to read
	updateNameSuccess	BYTE	"New name updated successfully", 0
	updateNameDisplay	BYTE	 "======================PRODUCT LIST======================", 0dh,0ah
						BYTE	"1. Nasi Lemak			",0dh,0ah
						BYTE	"2. Nasi Goreng	",0dh,0ah
						BYTE	"3. Mee Goreng		",0dh,0ah
						BYTE	"4. Chicken Rice	",0dh,0ah
						BYTE	"5. Wantan Mee		",0dh,0ah
						BYTE	"6. Ayam Goreng ",0

	updatePrice			BYTE	"Please enter new price : RM ", 0
	updateNewPrice		DWORD	?
	updatePriceSuccess	BYTE	"New price updated successfully", 0
	updatePriceDec		BYTE	"New price : RM ", 0
	updateOption		BYTE	"Do you want to continue UPDATE item?  (y)es or (n)o :  ", 0
	invalidOption		BYTE	"Invalid input. Please try again", 0
	noOption			BYTE	"This item is unavailable right now. Please add item in manage stock menu...",0

	pending		byte	"----------------------------------------------", 0dh, 0ah
				byte	"        This function is coming soon...." ,0dh,0ah
				byte	"----------------------------------------------", 0dh, 0ah, 0
	
	txtDelete		byte	"Please enter 0 to back | 99 to return to main menu: ", 0
	
	newVoucherBanner	byte	"Voucher Code : 5555", 0dh, 0ah
						byte	"Current discount price: RM 5.90" ,0
	newVoucherPrice		byte	"New discount price : RM ", 0
	newPriceValid		byte	"New price must be greater than RM 1.00. Please try again...", 0
	
	profit			dword ?
	stringNewPrice	byte "New price :          RM ",0
	stringProfit	byte "How much profit are you expecting? (e.g. 10)% > ",0



	string1		byte	"Nasi Lemak", 0
	string2		byte	"Nasi Goreng", 0
	string3		byte	"Mee Goreng", 0
	string4		byte	"Chicken Rice", 0
	string5		byte	"Wantan Mee", 0

	txtBanner			byte	"Food:           ",0
	priceBanner			byte	"Price:          RM ",0
	txtNasiLemak		byte	"Food :          Nasi Lemak",0
	txtNasiGoreng		byte	"Food :          Nasi Goreng",0
	txtMeeGoreng		byte	"Food :          Mee Goreng",0
	txtChickenRice		byte	"Food :          Chicken Rice",0
	txtWantanMee		byte	"Food :          Wantan Mee",0
	priceNasiLemak		byte	"Price :         RM 5.50",0
	priceNasiGoreng		byte	"Price :         RM 7.50",0
	priceMeeGoreng		byte	"Price :         RM 6.50",0
	priceChickenRice	byte	"Price :         RM 8.00",0
	priceWantanMee		byte	"Price :         RM 7.00",0
	txtProdSST			byte	"SST (6%) :	RM ",0

	selectedChoiceP1 DWORD ?
	selectedChoiceP2 DWORD ?
	uchoice		byte	?

	
	
;-------------------------------------------------------------------------------------------------;
;------------------------------------END Data for FoodMenu ---------------------------------------;
;-------------------------------------------------------------------------------------------------;
;**************************************************************************************************;


;------------------------------------Code Segment-------------------------------------;
.code			;defines the code segment(instructions, codes) 
	main PROC		; Main Driver
	;write assembly code here

;-------------------------------------------------------------------------------------------------;
;------------------------------------Start Login Module ------------------------------------------;
;-------------------------------------------------------------------------------------------------;


_login:
	xor eax, eax
	mov edx, offset loginBanner1
	call WriteString
	mov edx, offset blankBanner
	call WriteString
	mov edx, offset loginBanner2
	call WriteString
	mov  dl,31  ;column
	mov eax, errorAdjust
	.if eax == 0
		mov  dh,6  ;row
		call Gotoxy
	.else
		mov  dh,7  ;row
		call Gotoxy
	.endif
	call ReadInt
	mov loginInputStaffID, eax
	
	.if loginInputStaffID == 1209
		mov edx, offset loginBanner3
		call WriteString
		mov  dl,31  ;column
		mov eax, errorAdjust
		.if eax == 0
			mov  dh,7  ;row
			call Gotoxy
		.else
			mov  dh,8  ;row
			call Gotoxy
		.endif
		mov eax, black + (black * 16)
		call settextcolor
		call ReadInt
		
		mov loginInputStaffPass, eax
		.if loginInputStaffPass == 1234
			call clrscr
			mov eax, white
			call settextcolor
			JMP _displayMainMenu			;Login successful
		.else
			call Clrscr
			mov eax, white+(red*16)
			call settextcolor

			mov edx, offset loginErrorText2
			call WriteString

			mov eax, white
			call settextcolor
			call Crlf
			mov errorAdjust, 1
			jmp _login
		.endif
	.else
		call clrscr
		mov eax, white+(red*16)
		call settextcolor

		mov edx, offset loginErrorText
		call WriteString

		mov eax, white
		call settextcolor
		call Crlf
		mov errorAdjust, 1
		jmp _login
	.endif
	

;-------------------------------------------------------------------------------------------------;
;------------------------------------End Login Module ------------------------------------------;
;-------------------------------------------------------------------------------------------------;


;-------------------------------------------------------------------------------------------------;
;------------------------------------------Start MainMenu ---------------------------------------;
;-------------------------------------------------------------------------------------------------;

_displayMainMenu:
	
	mov edx, offset mmBanner1
	call WriteString
	
	mov edx, offset selectedChoice						;Output Text and receive input from user
	call WriteString
	call ReadInt
	mov selectedChoice, eax

	.if selectedChoice == 1
		JMP _displayFoodMenu
	.elseif selectedChoice == 2
		JMP _displayManageStock
	.elseif selectedChoice == 3
	;---LOGOUT
	call clrscr
	mov edx, offset mmSummary
	call writestring
	call crlf

	mov ecx, lengthof exitFoodSelected
	mov esi, 0

	displaySummary:
		
		loopProd:
			.if exitFoodSelected[esi] > 0
				mov eax, exitFoodSelected[esi]
				call writedec
				mov edx, exitFoodName[esi]
				call writestring
				call crlf
				add esi, type exitFoodSelected
				loop loopProd
			.endif
			

		mov edx, offset mmGT
		call writestring
		mov eax, exitGrandTotal
		mov ebx, percent			; Divisor = 100
		xor edx, edx
		div ebx
		call writedec
		
		mov al, '.'             ; Decimal point
		call WriteChar 

		imul eax, edx, 10       
		xor edx, edx            
		div ebx                 
		call WriteDec   

		imul eax, edx, 10       
		xor edx, edx            
		div ebx                 
		call WriteDec
		
		call crlf
		call crlf
		mov eax, white+(green*16)
		call settextcolor
		mov edx, offset logoutText
		call writestring
		mov eax, white
		call settextcolor
		call crlf
		exit
	.else
		call clrscr
		mov eax, white+(red*16)
		call settextcolor

		mov edx, offset mminvalidInput
		call writestring
		
		mov eax, white
		call settextcolor
		call crlf

		jmp _displayMainMenu
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

		mov edx,OFFSET checkoutBanner2
		call WriteString
		
		mov eax, foodPrices[0]
		mov ebx, percent			; Divisor = 100
		xor edx, edx
		div ebx
		call writedec
		
		mov al, '.'             ; Decimal point
		call WriteChar 

		imul eax, edx, 10       
		xor edx, edx            
		div ebx                 
		call WriteDec   

		imul eax, edx, 10       
		xor edx, edx            
		div ebx                 
		call WriteDec 
		call crlf

		mov edx,OFFSET checkoutBanner3
		call WriteString

		mov eax, foodPrices[4]
		mov ebx, percent			; Divisor = 100
		xor edx, edx
		div ebx
		call writedec
		
		mov al, '.'             ; Decimal point
		call WriteChar 

		imul eax, edx, 10       
		xor edx, edx            
		div ebx                 
		call WriteDec   

		imul eax, edx, 10       
		xor edx, edx            
		div ebx                 
		call WriteDec 
		call crlf

		mov edx,OFFSET checkoutBanner4
		call WriteString

		mov eax, foodPrices[8]
		mov ebx, percent			; Divisor = 100
		xor edx, edx
		div ebx
		call writedec
		
		mov al, '.'             ; Decimal point
		call WriteChar 

		imul eax, edx, 10       
		xor edx, edx            
		div ebx                 
		call WriteDec   

		imul eax, edx, 10       
		xor edx, edx            
		div ebx                 
		call WriteDec 
		call crlf

		mov edx,OFFSET checkoutBanner5
		call WriteString

		mov eax, foodPrices[12]
		mov ebx, percent			; Divisor = 100
		xor edx, edx
		div ebx
		call writedec
		
		mov al, '.'             ; Decimal point
		call WriteChar 

		imul eax, edx, 10       
		xor edx, edx            
		div ebx                 
		call WriteDec   

		imul eax, edx, 10       
		xor edx, edx            
		div ebx                 
		call WriteDec 
		call crlf

		mov edx,OFFSET checkoutBanner6
		call WriteString

		mov eax, foodPrices[16]
		mov ebx, percent			; Divisor = 100
		xor edx, edx
		div ebx
		call writedec
		
		mov al, '.'             ; Decimal point
		call WriteChar 

		imul eax, edx, 10       
		xor edx, edx            
		div ebx                 
		call WriteDec   

		imul eax, edx, 10       
		xor edx, edx            
		div ebx                 
		call WriteDec 
		call crlf

		mov edx,OFFSET checkoutBanner7
		call WriteString
		call crlf

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

			imul eax, edx, 10       
			xor edx, edx            
			div ebx                 
			call WriteDec   

			imul eax, edx, 10       
			xor edx, edx            
			div ebx                 
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

			imul eax, edx, 10       
			xor edx, edx            
			div ebx                 
			call WriteDec   

			imul eax, edx, 10       
			xor edx, edx            
			div ebx                 
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

			imul eax, edx, 10       
			xor edx, edx            
			div ebx                 
			call WriteDec   

			imul eax, edx, 10       
			xor edx, edx            
			div ebx                 
			call WriteDec  
			call crlf			
			call crlf
			jmp _getChoice					; Jump to getChoice

		.elseif selectedChoice == 5
			inc foodSelected[16]				

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

			imul eax, edx, 10       
			xor edx, edx            
			div ebx                 
			call WriteDec   

			imul eax, edx, 10       
			xor edx, edx            
			div ebx                 
			call WriteDec  
			call crlf			
			call crlf
			jmp _getChoice					; Jump to getChoice

		.elseif selectedChoice == 99
			call Clrscr
			jmp _displayMainMenu

		.elseif selectedChoice == 0
			
			call Clrscr
			mov edx, offset txtFoodSelected
			call WriteString
			call Crlf

			mov ecx, lengthof foodSelected
			mov esi, 0
			call displayFS
			displayFS:
				.if foodSelected[esi] > 0
					mov eax, foodSelected[esi]
					call writedec
					
					mov edx, arrFoodName[esi]
					call writestring

					mov eax, foodTotal[esi]
					mov ebx, percent			; Divisor = 100
					xor edx, edx
					div ebx
					call writedec

					mov al, '.'             ; Decimal point
					call WriteChar 

					imul eax, edx, 10       
					xor edx, edx            
					div ebx                 
					call WriteDec   

					imul eax, edx, 10       
					xor edx, edx            
					div ebx                 
					call WriteDec
					call Crlf
					add esi, type foodSelected
					loop displayFS
				.endif

;--------------CALCULATE SUM
		calcSum:
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

;----------Subtotal				
			mov edx, offset txtSubTotal
			call Crlf
			call WriteString
			mov eax, foodSum
			mov ebx, percent			; Divisor = 100
			xor edx, edx
			div ebx
			call writedec

			mov al, '.'             ; Decimal point
			call WriteChar 

			imul eax, edx, 10       
			xor edx, edx            
			div ebx                 
			call WriteDec   

			imul eax, edx, 10       
			xor edx, edx            
			div ebx                 
			call WriteDec
			call Crlf

			readVoucher:
				mov edx, offset txtVoucher
				call writestring
				call readchar
				call writechar
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
				mov eax, white+(red*16)
				call settextcolor
				mov edx, offset invalidVoucher
				call writestring
				mov eax, white
				call settextcolor
				call Crlf
				call Crlf
				loop readVoucher
				
			inputVoucher:
				mov edx, offset txtInsertVoucher
				call writestring		
				call readint
				mov voucherNo, eax

				.if voucherNo == 5555
					inc discountExist
					call showGrandTotal
				.else
					jmp errorVoucher
				.endif

			showGrandTotal:
				call Clrscr
				xor eax, eax

				mov edx, offset txtReceipt
				call writestring
				call crlf

				mov ecx, lengthof foodSelected
				mov esi, 0

				displayFS2:
				.if foodSelected[esi] > 0
					mov eax, foodSelected[esi]
					call writedec
					
					mov edx, arrFoodName[esi]
					call writestring

					mov eax, foodTotal[esi]
					mov ebx, percent			; Divisor = 100
					xor edx, edx
					div ebx
					call writedec

					mov al, '.'             ; Decimal point
					call WriteChar 

					imul eax, edx, 10       
					xor edx, edx            
					div ebx                 
					call WriteDec   

					imul eax, edx, 10       
					xor edx, edx            
					div ebx                 
					call WriteDec
					call Crlf
					add esi, type foodSelected
					loop displayFS2
				.endif

				xor eax, eax
				xor ebx, ebx

				call Crlf
				mov edx, offset seperator
				call writestring
				call Crlf
				call Crlf

;---------------Subtotal

				mov edx, offset txtSubTotal
				call Crlf
				call WriteString
				mov eax, foodSum
				mov ebx, percent			; Divisor = 100
				xor edx, edx
				div ebx
				call writedec

				mov al, '.'             ; Decimal point
				call WriteChar 

				imul eax, edx, 10       
				xor edx, edx            
				div ebx                 
				call WriteDec   

				imul eax, edx, 10       
				xor edx, edx            
				div ebx                 
				call WriteDec
				call Crlf


;--------------Voucher
				mov eax, discountExist
				.if eax == 1
					mov edx, offset txtDiscount
					call writestring
					call crlf

					;------------------Subtract voucher amount from foodSum
					mov eax, foodSum
					mov foodSubtotal, eax
					mov ebx, voucherRM
					sub eax, ebx
					mov foodSum, eax

					;------------------Show new sub total
					mov edx, offset txtNewSubtotal
					call writestring
					mov eax, foodSum
					
					mov ebx, percent			; Divisor = 100
					xor edx, edx            
					div ebx					;; Divide the foodSum by 100 = foodSum/100
					call WriteDec

					mov al, '.'             ; Decimal point
					call WriteChar 

					imul eax, edx, 10       
					xor edx, edx            
					div ebx                 
					call WriteDec   

					imul eax, edx, 10       
					xor edx, edx            
					div ebx                 
					call WriteDec
					call Crlf

					
				.endif

				;;------ Move sum to exitGrandTotal, To display the total sales after logout
				mov eax, foodSum
				add exitGrandtotal, eax

;--------------SST 
				mov edx, offset txtSST
				call writestring
				
				mov eax, foodSum			; Formula = foodSum+[[(foodSum*sstTax)/100]/100]
				mov ebx, sstTax              
				mul ebx						; Multiply to get the amount of SST = foodSum*0.06
				mov sst, eax			; Initialise the value to sst
				mov ebx, 100				
				div ebx						; Divide operation = sst/100
				mov sst, eax			; initialise the new value to sstValue
				mov ebx, 100				
				div ebx						; Divide the operation again = sstValue/100	
				mov sst, eax			; initialise the new value to sst


				mov eax, sst		
				mov ebx, 100
				xor edx, edx            
				div ebx					;; Divide the foodSum by 100 = foodSum/100
				call WriteDec

				mov al, '.'             ; Decimal point
				call WriteChar 

				imul eax, edx, 10       
				xor edx, edx            
				div ebx                 
				call WriteDec   

				imul eax, edx, 10       
				xor edx, edx            
				div ebx                 
				call WriteDec
				call Crlf
				

;---------------Grandtotal
				mov edx, offset txtGrandTotal
				call writestring
				mov eax, foodSum			; Formula = foodSum+[[(foodSum*sstTax)/100]/100]
				mov ebx, sstTax              
				mul ebx						; Multiply to get the amount of SST = foodSum*0.06
				mov sst, eax			; Initialise the value to sst
				mov ebx, 100				
				div ebx						; Divide operation = sst/100
				mov sst, eax			; initialise the new value to sstValue
				mov ebx, 100				
				div ebx						; Divide the operation again = sstValue/100	
				mov sst, eax			; initialise the new value to sst


				mov eax, foodSum			;; Add the sstValue to foodSum = foodSum + sst
				mov ebx, sst
				add eax, ebx
				mov foodSum, eax

				mov eax, foodSum			
				mov ebx, 100
				xor edx, edx            
				div ebx					;; Divide the foodSum by 100 = foodSum/100
				call WriteDec

				mov al, '.'             ; Decimal point
				call WriteChar 

				imul eax, edx, 10       
				xor edx, edx            
				div ebx                 
				call WriteDec   

				imul eax, edx, 10       
				xor edx, edx            
				div ebx                 
				call WriteDec
				call Crlf

				;--------------------------------------Copy value
				
				mov ecx, lengthof foodSelected
				mov esi, 0

				copyArr:
					mov eax, foodSelected[esi]
					add exitFoodSelected[esi], eax
					add esi, type foodSelected
					loop copyArr

				payBill:
					;----------------------Enter given amount
					mov eax, white+(cyan*16)
					call settextcolor
					mov edx, offset txtPay
					call writestring
					mov eax, white
					call settextcolor
					
					call readint
					mov payAmount, eax
				
					mov eax, payAmount
					mov ebx, foodSum
					.if eax < ebx
						;;Error Message
						call crlf
						mov eax, white+(red*16)
						call settextcolor
						mov edx, offset invalidPay
						call writestring
						mov eax, white
						call settextcolor
						call crlf
						call crlf
						loop payBill
					.else	
						;-----------Show balance
						mov edx, offset txtBal
						call writestring

						mov eax, payAmount			
						mov ebx, foodSum			
						sub eax, ebx
						mov foodSum, eax
						mov ebx, percent			; Divisor = 100
						xor edx, edx
						div ebx
						call writedec

						mov al, '.'             ; Decimal point
						call WriteChar 

						imul eax, edx, 10       
						xor edx, edx            
						div ebx                 
						call WriteDec   

						imul eax, edx, 10       
						xor edx, edx            
						div ebx                 
						call WriteDec
						call Crlf
						jmp backToMenu
					.endif

				backToMenu:
			;---------RESET VALUES
					mov ecx, lengthof foodSelected
					mov esi, 0

					resetFoodSelected:
						mov foodSelected[esi], 0
						add esi, type foodSelected
						loop resetFoodSelected			; loop sum
					
					xor eax, eax
					xor ecx, ecx

					mov ecx, lengthof foodTotal
					mov esi, 0

					resetFoodTotal:
						mov foodTotal[esi], 0
						loop resetFoodTotal			; loop sum

					mov sst, 0
					mov discountExist, 0
					mov foodSubtotal, 0
					mov	foodSum, 0
 
					call Crlf
					call Crlf
					mov eax, white+(green*16)
					call settextcolor
					mov edx, offset txtBack
					call writestring
					mov eax, white
					call settextcolor
					
					call readchar
					call writechar
					mov rChoice, al
					call Crlf
					call Crlf
					call clrscr

					xor eax, eax
					xor ebx, ebx
					xor edx, edx
				compareQ:
					cmp		rchoice, 'q'
					je		_displayMainMenu		; input == 'q'
					jne		invalidInput2			; input != 'q'
					
				invalidInput2:
					call Crlf
					mov eax, white+(red*16)
					call settextcolor
					mov edx, offset invalidInput
					mov eax, white
					call settextcolor
					call WriteString
					jmp backToMenu
		.else
			call Crlf
			mov eax, red+(white+16)
			call settextcolor
			mov edx, offset invalidInput
			
			call WriteString
			call crlf 
			call crlf
		.endif

	

;-------------------------------------------------------------------------------------------------;
;--------------------------------------------END FoodMenu ---------------------------------------;
;-------------------------------------------------------------------------------------------------;

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
		mov mmChoiceMenu,eax


		.if mmChoiceMenu == 1		; add item
			JMP _displayAddItem
		.elseif mmChoiceMenu == 2	; update item
			JMP _displayUpdateItem
		.elseif	mmChoiceMenu == 3	; delete item
			JMP _displayDeleteItem
		.elseif mmChoiceMenu == 4	; view item
			JMP _displayViewItem
		.elseif mmChoiceMenu == 5	; back
			call clrscr
			JMP _displayMainMenu
		.else			; invalid input
			mov eax, white+(red*16)
			call settextcolor
	
			mov edx, offset invalidOption
			call WriteString
			mov eax, white
			call settextcolor
			call Crlf
			jmp _displayManageStock
		.endif


_displayAddItem :
		
		call Clrscr
		mov edx,OFFSET mmBannerAdd
		call WriteString
		call Crlf
		jmp	_getAddChoice


_displayViewItem :
		call Clrscr
		mov edx,OFFSET productBanner
		call WriteString
		call Crlf
		jmp _getViewChoice

_displayDeleteItem:
	call clrscr
	mov eax, white+(cyan*16)
	call settextcolor
	mov edx, offset pending
	call writestring
	mov eax, white
	call settextcolor
	call crlf
	mov edx, offset txtDelete
	call writestring
	call readint
	mov selectedChoiceP1, eax

	.if selectedChoiceP1 == 0
		jmp _displayManageStock
	.elseif selectedChoiceP1 == 99
		call clrscr
		jmp	_displayMainMenu
	.else
		mov eax, white+(red*16)
		call settextcolor
		mov edx, offset invalidOption
		call WriteString
		mov eax, white
		call settextcolor
		call Crlf
		jmp _displayDeleteItem
	.endif

_getAddChoice:
		
	
		mov edx, offset choiceName					;Output Text and receive input from user
	;	mov  ecx,MAX								;buffer size - 1
		call WriteString
		call ReadInt
		mov mmChoiceAdd, eax

		.if mmChoiceAdd == 1
			call Clrscr
			mov eax, white+(red*16)
			call settextcolor
	
			mov edx, offset addErrorText
			call WriteString
			mov eax, white
			call settextcolor
			call Crlf

			call Crlf
			mov edx, offset mmBannerAdd
			call WriteString
			call Crlf
			loop _getAddChoice
		
		.elseif mmChoiceAdd == 0
			jmp	_displayManageStock
		.elseif mmChoiceAdd == 99
			jmp	_displayMainMenu
		.else

			call clrscr
			mov edx, offset addBanner
			call writestring
			call crlf
			mov	edx, offset updateName
			mov	ecx,MAX            ;buffer size - 1
			call writeString
			call ReadString
	
			call Crlf
			mov eax, white+(green*16)
			call settextcolor
			mov edx, offset updateNameSuccess
			call writestring
			mov eax, white
			call settextcolor
		
			call crlf
			call crlf
			mov edx, offset updateNameDisplay
			call writestring
			mov edx, offset uchoice
			call writestring
			call crlf
			call crlf
			
			xor al,al					
			mov edx, offset addOption
			call WriteString
			call readchar
			call writechar
			mov uchoice, al
			call Crlf
			call Crlf
			jmp compareAddYes
	
	;---------------compare yes / no---------------
			compareAddYes:
				cmp		uchoice, 'y'
				je		_displayAddItem		; input == 'y'
				jne		compareAddNo	; input != 'y'

			compareAddNo:
				cmp uchoice, 'n'
				je   _displayManageStock
				jne	 errorInput2
					
			errorInput2:
				mov edx, offset invalidOption
				mov eax, white+(red*16)
				call settextcolor
	
				mov edx, offset invalidOption
				call WriteString
				mov eax, white
				call settextcolor
				call Crlf
				jmp _displayAddItem

		.endif
	


_getViewChoice:

		call Crlf
		mov edx,OFFSET viewBanner
		call WriteString
		call Crlf
	
		call Crlf
		mov edx, offset viewChoicePL						;Output Text and receive input from user
		call WriteString
		call ReadInt
		mov selectedChoiceP1, eax


		.if selectedChoiceP1 == 1		; view nasi lemak
			;-------VIEW SST
				call Crlf
				mov edx,OFFSET txtNasiLemak
				call WriteString
				call Crlf
				mov edx, offset priceNasiLemak
				call writestring
				call Crlf
				mov edx, offset txtProdSST
				call writestring
				
				mov eax, 550			; Formula = 550+[[(550*sstTax)/100]/100]
				jmp _calculateSST
				
		.elseif selectedChoiceP1 == 2		; view nasi goreng
				;-------VIEW SST
				call Crlf
				mov edx,OFFSET txtNasiGoreng
				call WriteString
				call Crlf
				mov edx, offset priceNasiGoreng
				call writestring
				call Crlf
				mov edx, offset txtProdSST
				call writestring
				
				mov eax, 750			; Formula = 750+[[(750*sstTax)/100]/100]
				jmp _calculateSST

		.elseif selectedChoiceP1 == 3		; view mee goreng
			;-------VIEW SST
				call Crlf
				mov edx,OFFSET txtMeeGoreng
				call WriteString
				call Crlf
				mov edx, offset priceMeeGoreng
				call writestring
				call Crlf
				mov edx, offset txtProdSST
				call writestring
				
				mov eax, 620			; Formula = 620+[[(620*sstTax)/100]/100]
			jmp _calculateSST

		.elseif selectedChoiceP1 == 4		; view chicken rice
			;-------VIEW SST
				call Crlf
				mov edx,OFFSET txtChickenRice
				call WriteString
				call Crlf
				mov edx, offset priceChickenRice
				call writestring
				call Crlf
				mov edx, offset txtProdSST
				call writestring
				
				mov eax, 800			; Formula = 800+[[(800*sstTax)/100]/100]
				jmp _calculateSST		
		.elseif selectedChoiceP1 == 5		; view wantan mee
			;-------VIEW SST
				call Crlf
				mov edx,OFFSET txtWantanMee
				call WriteString
				call Crlf
				mov edx, offset priceWantanMee
				call writestring
				call Crlf
				mov edx, offset txtProdSST
				call writestring
				
				mov eax, 700			; Formula = 700+[[(700*sstTax)/100]/100]
				jmp _calculateSST
		.elseif selectedChoiceP1 > 5	; view no item
			call crlf
			mov eax, white+(red*16)
			call settextcolor

			mov edx, offset noOption
			call WriteString

			mov eax, white
			call settextcolor
			call Crlf
			
			call crlf
			jmp compareOption
		.elseif selectedChoiceP1 == 0		; view manage stock menu
				jmp _displayManageStock

	.endif

	

	_calculateSST:
		mov ebx, sstTax              
		mul ebx						; Multiply to get the amount of SST = foodSum*0.06
		mov sst, eax			; Initialise the value to sst
		mov ebx, 100				
		div ebx						; Divide operation = sst/100
		mov sst, eax			; initialise the new value to sstValue
		mov ebx, 100				
		div ebx						; Divide the operation again = sstValue/100	
		mov sst, eax			; initialise the new value to sst

		mov eax, sst		
		mov ebx, 100
		xor edx, edx            
		div ebx					;; Divide the foodSum by 100 = foodSum/100
		call WriteDec

		mov al, '.'             ; Decimal point
		call WriteChar 

		imul eax, edx, 10       
		xor edx, edx            
		div ebx                 
		call WriteDec   

		imul eax, edx, 10       
		xor edx, edx            
		div ebx                 
		call WriteDec
		call Crlf
		call Crlf
				
		xor al,al					
		mov edx, offset viewOption
		call WriteString
		call readchar
		call writechar
		mov uchoice, al
		call Crlf
		call Crlf
		jmp cmpYes
	
	;---------------compare yes / no---------------
		cmpYes:
			cmp		uchoice, 'y'
			je		_displayViewItem 		; input == 'y'
			jne		compNo	; input != 'y'

		compNo:
			cmp uchoice, 'n'
			je   _displayUpdateItem
			jne	 errorInput1
					
		errorInput1:
			mov edx, offset invalidOption
			mov eax, white+(red*16)
			call settextcolor
	
			mov edx, offset invalidOption
			call WriteString
			mov eax, white
			call settextcolor
			call Crlf
			jmp _displayViewItem


	
;------ UPDATE ITEM

_displayUpdateItem:

		call Clrscr
		mov edx,OFFSET productBanner
		call WriteString
		call Crlf

		mov edx,OFFSET updateBanner
		call WriteString
		call Crlf
		mov edx, offset updateChoice						;Output Text and receive input from user
		call WriteString
		call ReadInt					; read update choice
		mov selectedChoiceP1, eax
		jmp _getUpdateChoice

_getUpdateChoice:

	.if selectedChoiceP1 == 1		; update choice = name
		call clrscr
		mov edx, offset updateBanner
		call writestring
		call crlf
		call crlf
		mov	edx, offset updateName
		mov	ecx,MAX            ;buffer size - 1
		call writeString
		call ReadString
	
		call Crlf
		mov eax, white+(green*16)
		call settextcolor
		mov edx, offset updateNameSuccess
		call writestring
		mov eax, white
		call settextcolor
		
		call crlf
		call crlf
		mov edx, offset updateNameDisplay
		call writestring
		mov edx, offset uchoice
		call writestring
		call crlf
		call crlf
		jmp compareOption

	.elseif selectedChoiceP1 == 2		; update choice = price
			
			call Crlf
			mov edx, offset viewChoicePL						;Output Text and receive input from user
			call WriteString
			call ReadInt
			mov selectedChoiceP2, eax
			
			
			;call Crlf

		_displayUpdatePrice:
			.if selectedChoiceP2 == 1		; product = nasi lemak
				call Clrscr
				mov edx, offset lineBanner
				call WriteString
				call Crlf
				mov edx, OFFSET txtNasiLemak
				call WriteString
				call Crlf
				mov edx, offset priceNasiLemak
				call WriteString
				call Crlf
				mov edx, offset lineBanner
				call WriteString
				call Crlf
				mov esi, 0
				jmp _chkUpdatePrice

			.elseif selectedChoiceP2 == 2		; product = nasi goreng
				call Clrscr
				mov edx, offset lineBanner
				call WriteString
				call Crlf
				mov edx, OFFSET txtNasiGoreng
				call WriteString
				call Crlf
				mov edx, offset priceNasiGoreng
				call WriteString
				call Crlf
				mov edx, offset lineBanner
				call WriteString
				call Crlf
				mov esi, 4
				jmp _chkUpdatePrice
			.elseif selectedChoiceP2 == 3		; product = mee goreng
				call Clrscr
				mov edx, offset lineBanner
				call WriteString
				call Crlf
				mov edx, OFFSET txtMeeGoreng
				call WriteString
				call Crlf
				mov edx, offset priceMeeGoreng
				call WriteString
				call Crlf
				mov edx, offset lineBanner
				call WriteString
				call Crlf
				mov esi, 8
				jmp _chkUpdatePrice
			.elseif selectedChoiceP2 == 4		; product = Chicken rice
				call Clrscr
				mov edx, offset lineBanner
				call WriteString
				call Crlf
				mov edx, OFFSET txtChickenRice
				call WriteString
				call Crlf
				mov edx, offset priceChickenRice
				call WriteString
				call Crlf
				mov edx, offset lineBanner
				call WriteString
				call Crlf
				mov esi, 12
				jmp _chkUpdatePrice
			.elseif selectedChoiceP2 == 5		; product = wantan mee
				call Clrscr
				mov edx, offset lineBanner
				call WriteString
				call Crlf
				mov edx, OFFSET txtWantanMee
				call WriteString
				call Crlf
				mov edx, offset priceWantanMee
				call WriteString
				call Crlf
				mov edx, offset lineBanner
				call WriteString
				call Crlf
				mov esi, 16
				jmp _chkUpdatePrice
			.else			; invalid input

				mov eax, white+(red*16)
				call settextcolor
	
				mov edx, offset invalidOption
				call WriteString
				mov eax, white
				call settextcolor
				call Crlf
				jmp _displayUpdatePrice
			.endif

		_chkUpdatePrice:
				xor eax, eax
				mov edx, offset updatePrice						;Output Text and receive input from user
				call WriteString
				call ReadInt
				mov updateNewPrice, eax

				.if updateNewPrice >= 100
					
					call Crlf
					mov eax, white+(green*16)
					call settextcolor
					mov edx, offset updatePriceSuccess
					call writestring
					mov eax, white
					call settextcolor
					call Crlf
					call Crlf
					mov eax, white+(cyan*16)
					call settextcolor
					mov edx, offset updatePriceDec
					call WriteString
					
					mov eax, updateNewPrice
					mov foodPrices[esi], eax
					mov ebx, percent			; Divisor = 100
					xor edx, edx
					div ebx
					call writedec
		
					mov al, '.'             ; Decimal point
					call WriteChar 

					imul eax, edx, 10       
					xor edx, edx            
					div ebx                 
					call WriteDec   

					imul eax, edx, 10       
					xor edx, edx            
					div ebx                 
					call WriteDec 
					call crlf

					mov eax, white
					call settextcolor
					call Crlf
					call Crlf
					jmp compareOption
				
				compareOption:
					xor al,al					
					mov edx, offset updateOption
					call WriteString
					call readchar
					call writechar
					mov uchoice, al
					call Crlf
					call Crlf
					jmp compareYes
	
	;---------------compare yes / no---------------
					compareYes:
						cmp		uchoice, 'y'
						je		_displayUpdateItem		; input == 'y'
						jne		compareNo	; input != 'y'

					compareNo:
						cmp uchoice, 'n'
						je   _displayManageStock
						jne	 errorInput
					
					errorInput:
						mov edx, offset invalidOption
						mov eax, white+(red*16)
						call settextcolor
	
						mov edx, offset invalidOption
						call WriteString
						mov eax, white
						call settextcolor
						call Crlf
						jmp _displayUpdatePrice

	
		
			.else			; if new price not more than 100
				call crlf
				mov eax, white+(red*16)
				call settextcolor
	
				mov edx, offset newPriceValid
				call WriteString
				mov eax, white
				call settextcolor
				call Crlf
				call Crlf
				jmp compareOption
			

			.endif

	.elseif selectedChoiceP1 == 3		; update choice = discount price
	
	
		call clrscr
		mov	edx, offset updateBanner
		call writestring
		call crlf
		mov	edx, offset newVoucherBanner
		call writestring
		call crlf
		mov	edx, offset newVoucherPrice
		call writestring
		call readInt
		mov updateNewPrice, eax
		call crlf

		

;		.if updateNewPrice >= 100
;			call clrscr
;			mov	edx, offset newVoucherBanner
;			call writestring
			call crlf
;		
;			mov updateNewPrice, eax
;			call writestring
;			call crlf
;			call crlf
;			mov	edx, offset updatePriceSuccess
;			call writestring
;			call crlf
;			jmp compareOption
;		.else			; if new price not more than 100
		
;			mov eax, white+(red*16)
;			call settextcolor
	
;			mov edx, offset newPriceValid
;			call WriteString
;			mov eax, white
;			call settextcolor
;			call Crlf
			
		.if updateNewPrice >= 100
					
					mov eax, white+(green*16)
					call settextcolor
					mov edx, offset updatePriceSuccess
					call writestring
					mov eax, white
					call settextcolor
					call Crlf
					call Crlf
					mov eax, white+(cyan*16)
					call settextcolor
					mov edx, offset newVoucherPrice
					call WriteString
					
					mov eax, updateNewPrice
					mov foodPrices[0], eax
					mov ebx, percent			; Divisor = 100
					xor edx, edx
					div ebx
					call writedec
		
					mov al, '.'             ; Decimal point
					call WriteChar 

					imul eax, edx, 10       
					xor edx, edx            
					div ebx                 
					call WriteDec   

					imul eax, edx, 10       
					xor edx, edx            
					div ebx                 
					call WriteDec 
					call crlf

					mov eax, white
					call settextcolor
					call Crlf
					call Crlf
					jmp compareOption
				
			.else			; if new price not more than 100
				
				mov eax, white+(red*16)
				call settextcolor
	
				mov edx, offset newPriceValid
				call WriteString
				mov eax, white
				call settextcolor
				call Crlf
				call Crlf
				jmp compareOption
			

			.endif
	



	.elseif selectedChoiceP1 == 4			; update choice = profit 

		call Crlf
		mov edx, offset viewChoicePL			; choose to proceed
		call WriteString
		call ReadInt
		mov selectedChoiceP1, eax
		call clrscr
		mov	edx, offset lineBanner
		call Writestring
		
		.if selectedChoiceP1 == 1		; view nasi lemak			
			call crlf
			mov edx,OFFSET txtNasiLemak
			call WriteString
			call Crlf
			mov edx, offset priceNasiLemak
			call writestring
			call Crlf
			mov	esi, 0
			jmp	_displayProfit

		.elseif selectedChoiceP1 == 2		; view nasi goreng				
			call Crlf
			mov edx,OFFSET txtNasiGoreng
			call WriteString
			call Crlf
			mov edx, offset priceNasiGoreng
			call writestring
			call Crlf
			mov	esi, 4
			jmp	_displayProfit
		.elseif selectedChoiceP1 == 3		; view mee goreng				
			call Crlf
			mov edx,OFFSET txtMeeGoreng
			call WriteString
			call Crlf
			mov edx, offset priceMeeGoreng
			call writestring
			call Crlf
			mov	esi, 8
			jmp	_displayProfit
		.elseif selectedChoiceP1 == 4		; view chicken rice				
			call Crlf
			mov edx,OFFSET txtChickenRice
			call WriteString
			call Crlf
			mov edx, offset priceChickenRice
			call writestring
			call Crlf
			mov	esi, 12
			jmp	_displayProfit
		.elseif selectedChoiceP1 == 5		; view wantan mee				
			call Crlf
			mov edx,OFFSET txtWantanMee
			call WriteString
			call Crlf
			mov edx, offset priceWantanMee
			call writestring
			call Crlf
			mov	esi, 16
			jmp	_displayProfit

		.else			; invalid input
			mov eax, white+(red*16)
			call settextcolor
	
			mov edx, offset invalidOption
			call WriteString
			mov eax, white
			call settextcolor
			call Crlf
			jmp _displayUpdateItem
		.endif


	;------update new price base on profit-----	
		_displayProfit:
			; call clrscr
;			mov edx, offset stringPrice
;			call writestring
;			mov eax, foodPrices[esi]
;			call writedec

			mov	edx, offset lineBanner
			call Writestring
			call crlf
			mov edx, offset stringProfit
			call writestring
			call readint
			mov ebx, percent
			mul ebx
			mov profit, eax				; percentage = profit*100 = profit | 5% = 5 * 100 = 500

			mov eax, foodPrices[esi]			; foodPrices * profit = profit | 500 * 500 = 250,000
			mov ebx, profit
			mul ebx
			mov profit, eax

			mov ebx, percent			; profit/100 = profit | 250,000 / 100 = 2500 => RM25.00
			div ebx
			mov profit, eax

			mov ebx, percent			; profit/100 = profit | 2500 / 100 = 25 => RM0.25
			div ebx
			mov profit, eax

			mov eax, foodPrices[esi]			; foodPrices + profit | 550+0.25 = 5.25
			mov ebx, profit
			add eax, ebx
			mov foodPrices[esi], eax

			call crlf
			mov edx, offset stringNewPrice						;------display new profit price
			call writestring
			mov eax, foodPrices[esi]
			mov ebx, 100
			xor edx, edx            
			div ebx					;; Divide the foodSum by 100 = foodSum/100
			call WriteDec

			mov al, '.'             ; Decimal point
			call WriteChar 

			imul eax, edx, 10       
			xor edx, edx            
			div ebx                 
			call WriteDec   
	
			imul eax, edx, 10       
			xor edx, edx            
			div ebx           
			call WriteDec 

			call crlf
			call crlf
			
			jmp compareOption
	
	
	.elseif selectedChoiceP1 == 5		; update choice = back
		jmp _displayManageStock

	.else			; invalid input
	
			mov eax, white+(red*16)
			call settextcolor
	
			mov edx, offset invalidOption
			call WriteString
			mov eax, white
			call settextcolor
			call Crlf


		jmp _displayUpdateItem
	.endif





;-------------------------------------------------------------------------------------------------;
;--------------------------------------------END ManageStockMenu ---------------------------------------;
;-------------------------------------------------------------------------------------------------;
;*******************************************************************************************************;

	

	TERMINATE:
		INVOKE ExitProcess,0		; INVOKE to call a function | Terminate the process

	main ENDP		;denotes the end of the procedure label
	END main		;denotes the end of the main driver