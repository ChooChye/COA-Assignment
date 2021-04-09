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
	loginBanner		BYTE "==========================LOGIN===============================",0
	loginBanner1	BYTE "Enter username: ",0
	loginBanner2	BYTE "Enter password : ", 0

	staffName		BYTE "Jonathan Lim",0
	staffID			DWORD 1209
	staffPassword	DWORD 1234

	loginInputStaffID	DWORD ?
	loginInputStaffPass	DWORD ?

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


	mmBanner1		BYTE "==========================MAIN MENU===============================",0dh,0ah
					BYTE "1. Checkout",0dh,0ah
					BYTE "2. Manage Stock",0dh,0ah
					BYTE "3. Logout",0dh,0ah
					BYTE "Please select an option: ",0

	mmChoice		DWORD ?
	mminvalidInput	BYTE " ===========================================",0dh,0ah
					BYTE " =  INVALID INPUT. Please enter 1,2,3 only =",0dh,0ah
					BYTE " ===========================================",0
	mmSummary		byte " =========================================== ",0dh,0ah
					byte " ",0dh,0ah
					byte "                SUMMARY REPORT               ",0dh,0ah
					byte " ",0dh,0ah
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
	checkoutBanner1 BYTE "==========================FOOD MENU===============================",0dh,0ah
					BYTE "1. Nasi Lemak			- RM5.50",0dh,0ah
					BYTE "2. Nasi Goreng			- RM7.50",0dh,0ah
					BYTE "3. Mee Goreng			- RM6.20",0dh,0ah
					BYTE "4. Chicken Rice			- RM8.00",0dh,0ah
					BYTE "5. Wantan Mee			- RM7.00",0dh,0ah
					BYTE "==========================FOOD MENU===============================",0dh,0ah,0
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
	
	inputName		db	"Name: $"
	outputName		db	"New Name: $"
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
	deleteBanner	BYTE "-----------------------DELETE ITEM-----------------------",0
	lineBanner		BYTE "---------------------------------------------------------",0

	viewChoicePL	BYTE "Please select which product to proceed or 0 to stop: ", 0

	updateChoice	BYTE "1. Name ", 0dh, 0ah
					BYTE "2. Food Price ", 0dh, 0ah
					BYTE "3. Discount price ", 0dh, 0ah
					BYTE "4. Back ", 0dh, 0ah
					BYTE "-----------------------UPDATE ITEM-----------------------", 0dh, 0ah
					BYTE "Please select an option to update : ", 0
	
	updatePrice			BYTE	"Please enter new price : RM ", 0
	updateNewPrice		DWORD	?
	updatePriceSuccess	BYTE	"New price updated successfully", 0
	updatePriceDec		BYTE	"New price : RM ", 0
	updateOption		BYTE	"Do you want to continue update item?  (y)es or (n)o :  ", 0
	invalidOption		BYTE	"Invalid input. Please try again", 0
	
	pending		byte	"----------------------------------------------", 0dh, 0ah
				byte	"        This function is coming soon...." ,0dh,0ah
				byte	"----------------------------------------------", 0dh, 0ah, 0
	
	newVoucherBanner	byte	"Voucher Code : 5555", 0dh, 0ah
						byte	"Current discount price: RM 5.90" ,0
	newVoucherPrice		byte	"New discount price : RM ", 0
	newPriceValid		byte	"New price must be greater than RM 1.00. Please try again...", 0
	

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
			call clrscr
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

				call displayFS

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


		.if mmChoiceMenu == 1
			JMP _displayAddItem
		.elseif mmChoiceMenu == 2
			JMP _displayUpdateItem
		.elseif mmChoiceMenu == 4
			JMP _displayViewItem
		.elseif mmChoiceMenu == 5
			JMP _displayMainMenu
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
		.elseif mmChoiceAdd == 2
		

		.elseif mmChoiceAdd == 0
			jmp	_displayManageStock
		.elseif mmChoiceAdd == 99
			jmp	_displayMainMenu
		.endif
	


_getViewChoice:

		call Crlf
		mov edx,OFFSET viewBanner
		call WriteString
		call Crlf
		mov edx,OFFSET prodName	; display all list
		call WriteString
		call Crlf
		call Crlf
		mov edx, offset viewChoicePL						;Output Text and receive input from user
		call WriteString
		call ReadInt
		mov selectedChoiceP1, eax


		.if selectedChoiceP1 == 1	
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
				jmp _getViewChoice			

		.elseif selectedChoiceP1 == 2
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
				jmp _getViewChoice			
		.elseif selectedChoiceP1 == 3
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
				jmp _getViewChoice			
		.elseif selectedChoiceP1 == 4
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
				jmp _getViewChoice			
		.elseif selectedChoiceP1 == 5
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
				jmp _getViewChoice		
			.elseif selectedChoiceP1 == 0
				jmp _displayManageStock

	.endif

	
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
		mov	edx, offset pending
		call writestring
		call crlf
	.elseif selectedChoiceP1 == 2		; update choice = price
			call Crlf
			mov edx, offset viewChoicePL						;Output Text and receive input from user
			call WriteString
			call ReadInt
			mov selectedChoiceP2, eax
			
			call Clrscr
			mov edx, offset lineBanner
			call WriteString
			;call Crlf

		_displayUpdatePrice:
			.if selectedChoiceP2 == 1		; product = nasi lemak
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
				jmp _chkUpdatePrice

			.elseif selectedChoiceP2 == 2		; product = nasi goreng
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
				jmp _chkUpdatePrice
			.elseif selectedChoiceP2 == 3		; product = mee goreng
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
				jmp _chkUpdatePrice
			.elseif selectedChoiceP2 == 4		; product = Chicken rice
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
				jmp _chkUpdatePrice
			.elseif selectedChoiceP2 == 5		; product = wantan mee
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
					call writeDec
					mov eax, white
					call settextcolor
					call Crlf
					call Crlf

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

				.else		; if new price not more than 100
					call clrscr

					mov eax, white+(red*16)
					call settextcolor

					mov edx, offset newPriceValid
					call WriteString

					mov eax, white
					call settextcolor
					call Crlf
					jmp _displayUpdatePrice
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

		.if updateNewPrice >= 100
			mov	edx, offset newVoucherBanner
			call writestring
			call crlf
			mov	eax, updateNewPrice
			call writestring
			call crlf
			mov	edx, offset updatePriceSuccess
			call writestring
			call crlf
		.else		; if new price not more than 100
			
			mov eax, white+(red*16)
			call settextcolor
	
			mov edx, offset newPriceValid
			call WriteString
			mov eax, white
			call settextcolor
			call Crlf
			
		.endif

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