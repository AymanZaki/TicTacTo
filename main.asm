INCLUDE Irvine32.inc

.data
	XO_Grid byte '1', '2', '3', '4', '5', '6', '7', '8', '9'
	player1_msg byte "Player 1, please enter the number of the square where you want to palce your X: ", 0
	player2_msg byte "Player 2, please enter the number of the square where you want to palce your O: ", 0
	X_wins_msg BYTE "Player1 WINS!", 10, 0
	O_wins_msg BYTE "Player2 WINS!", 10, 0
	Draw_msg BYTE "Draw!", 10, 0
	grid_shape1 byte "---+---+---", 0
	grid_shape2 byte " | ", 0
	Continue_msg byte 10, "Do you want to play again ? (y/n) ", 0
	Resutl1_msg byte 10, "Player 1  ", 0
	Resutl2_msg byte "  Player 2", 10, 0
	Result3_msg byte " : ", 0
	User_Input byte 50 dup(?), 0
	Player_Flag byte 1
	Input_Counter byte 0
	XO_Flag byte 1
	Player1Counter dword 0
	Player2Counter dword 0
.code

Print PROC uses edx ecx
	
	mov esi, offset XO_Grid
	mov ecx, 3
	call crlf
	L:
		mov al, ' '
		call writechar
		mov al, byte ptr [esi]
		add esi, byte
		call writechar
		mov edx, offset grid_shape2
		call writestring 
		mov al, byte ptr[esi]	
		add esi, byte
		call writechar
		mov edx, offset grid_shape2
		call writestring
		mov al, byte ptr[esi]
		add esi, byte
		call writechar		
		call crlf
		mov edx, offset grid_shape1
		call writestring
		call crlf
	loop L 
	call crlf
ret
Print ENDP
	
Input PROC uses esi 
	call Print
	call CheckRows
	cmp XO_Flag, 0
	je ENDD
	call CheckColumns
	cmp XO_Flag, 0
	je ENDD
	call CheckRightDiagonal
	cmp XO_Flag, 0
	je ENDD
	call CheckLeftDiagonal
	cmp XO_Flag, 0
	je ENDD
	cmp Player_Flag, 1
	je  Player1
	Player2:
		mov edx, offset player2_msg
		call writestring
		mov edx, offset User_input
		mov ecx, lengthof User_input
		call readstring
		cmp eax, 1
		jne Player2
		call ParseDecimal32
		cmp eax, 0
		je Player2
		mov bl, XO_Grid[eax - 1]
		cmp bl, byte ptr[edx]
		jne Player2
		mov XO_Grid[eax - 1], 'O'
		jmp ENDD
	Player1:
		mov edx, offset player1_msg
		call writestring
		mov edx, offset User_input
		mov ecx, lengthof User_input
		call readstring
		cmp eax, 1
		jne Player1
		mov edx, offset User_input
		call ParseDecimal32
		cmp eax, 0
		je Player1
		mov bl, XO_Grid[eax - 1]
		cmp bl, byte ptr[edx]
		jne Player1
		mov XO_Grid[eax - 1], 'X'
	ENDD:
		inc Input_Counter
		xor Player_Flag, 1
ret
Input ENDP

CheckRows PROC uses esi eax ebx ecx
	mov ecx, 3
	mov esi, offset XO_Grid
	L:
		mov eax, 0
		mov dx, 3 * 'X' - 3
		movzx bx, BYTE PTR[esi]
		add ax, bx
		movzx bx, BYTE PTR[esi + 1]
		add ax, bx
		movzx bx, BYTE PTR[esi + 2]
		add ax, bx
		sub ax, dx
		cmp ax, 3
		je XWIN
		mov eax, 0
		mov dx, 3 * 'O' - 3
		movzx bx, BYTE PTR[esi]
		add ax, bx
		movzx bx, BYTE PTR[esi + 1]
		add ax, bx
		movzx bx, BYTE PTR[esi + 2]
		add ax, bx
		sub ax, dx
		cmp ax, 3
		je OWIN
		add esi, 3
	LOOP L
	cmp XO_Flag, 0
	jne quit
	XWIN:
		call X_WINS
		jmp quit
	OWIN:
		call O_WINS
	quit:
ret
CheckRows ENDP

CheckColumns PROC uses esi eax ebx ecx
	mov ecx, 3
	mov esi, offset XO_Grid
	L:
		mov eax, 0
		mov dx, 3 * 'X' - 3
		movzx bx, BYTE PTR[esi]
		add ax, bx
		movzx bx, BYTE PTR[esi + 3]
		add ax, bx
		movzx bx, BYTE PTR[esi + 6]
		add ax, bx
		sub ax, dx
		cmp ax, 3
		je XWIN
		mov eax, 0
		mov dx, 3 * 'O' - 3
		movzx bx, BYTE PTR[esi]
		add ax, bx
		movzx bx, BYTE PTR[esi + 3]
		add ax, bx
		movzx bx, BYTE PTR[esi + 6]
		add ax, bx
		sub ax, dx
		cmp ax, 3
		je OWIN
		add esi, byte
	LOOP L
	cmp XO_Flag, 0
	jne quit
	XWIN:
		call X_WINS
		jmp quit
	OWIN:
		call O_WINS
	quit:
ret
CheckColumns ENDP

CheckRightDiagonal PROC uses esi eax edx ebx
	mov esi, offset XO_Grid
	mov eax, 0
	mov dx, 3 * 'X' - 3
	movzx bx, BYTE PTR[esi]
	add ax, bx
	movzx bx, BYTE PTR[esi + 4]
	add ax, bx
	movzx bx, BYTE PTR[esi + 8]
	add ax, bx
	sub ax, dx
	cmp ax, 3
	je XWIN
	mov eax, 0
	mov dx, 3 * 'O' - 3
	movzx bx, BYTE PTR[esi]
	add ax, bx
	movzx bx, BYTE PTR[esi + 4]
	add ax, bx
	movzx bx, BYTE PTR[esi + 8]
	add ax, bx
	sub ax, dx
	cmp ax, 3
	je OWIN
	cmp XO_Flag, 0
	jne quit
	XWIN:
		call X_WINS
		jmp quit
	OWIN:
		call O_WINS
	quit:
ret
CheckRightDiagonal ENDP 

CheckLeftDiagonal PROC uses esi eax edx ebx
	mov esi, offset XO_Grid
	mov eax, 0
	mov dx, 3 * 'X' - 3
	movzx bx, BYTE PTR[esi + 2]
	add ax, bx
	movzx bx, BYTE PTR[esi + 4]
	add ax, bx
	movzx bx, BYTE PTR[esi + 6]
	add ax, bx
	sub ax, dx
	cmp ax, 3
	je XWIN
	mov eax, 0
	mov dx, 3 * 'O' - 3
	movzx bx, BYTE PTR[esi]
	add ax, bx
	movzx bx, BYTE PTR[esi + 4]
	add ax, bx
	movzx bx, BYTE PTR[esi + 6]
	add ax, bx
	sub ax, dx
	cmp ax, 3
	je OWIN
	cmp XO_Flag, 0
	jne quit
	XWIN:
		call X_WINS
		jmp quit
	OWIN:
		call O_WINS
	quit:
ret
CheckLeftDiagonal ENDP


X_WINS PROC
	inc Player1Counter
	mov Input_Counter, 8
	mov XO_Flag, 0
	mov edx, OFFSET X_wins_msg
	call writestring
ret
X_WINS ENDP

O_WINS PROC
	inc Player2Counter
	mov Input_Counter, 8
	mov XO_Flag, 0
	mov edx, OFFSET O_wins_msg
	call writestring
ret
O_WINS ENDP

Draw PROC
	mov edx, OFFSET Draw_msg
	call writestring
ret
Draw ENDP

Reset PROC uses esi eax ecx
	mov al, 1
	L:
		mov BYTE PTR[esi], al
		add BYTE PTR[esi], '0'
		add esi, byte
		inc al
	LOOP L
	mov Input_Counter, 0
	mov XO_Flag, 1
	mov Player_Flag, 1
ret
Reset ENDP

main PROC
	mov Input_Counter, 0
	Input_Loop:
	cmp Input_Counter, 9
	je END_LOOP
	call Input
	jmp Input_Loop
	END_LOOP:
	cmp XO_Flag, 0
	jne Draw_lable
	jmp next
	Draw_lable:
	call Draw

	next:
	mov edx, offset Resutl1_msg
	call writestring
	mov eax, Player1Counter
	call writedec
	mov edx, offset Result3_msg
	call writestring
	mov eax, Player2Counter
	call writedec
	mov edx, offset Resutl2_msg
	call writestring

	mov edx, offset Continue_msg
	call writestring
	call readchar
	call writechar
	call crlf
	call crlf
	mov ecx, lengthof XO_Grid
	mov esi, offset XO_Grid
	call Reset
	cmp al, 'y'
	je Input_Loop
	cmp al, 'Y'
	je Input_Loop
	exit
main ENDP

END main