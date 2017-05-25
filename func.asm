.data
buf_ptr QWORD 1
w QWORD 1
h QWORD 1
X QWORD 1
Y QWORD 1
S QWORD 1
curx QWORD 1
cury QWORD 1
curi QWORD 0
cztery QWORD 4
px QWORD 0
py QWORD 0
jWys QWORD 0
jSzer QWORD 0

.code
mandelbrot proc
init:
	push rax
	push rbx
	push rcx
	push rdx
	push r8
	push r9
	push r10
	push r11
	push rsp
	push rbp
	 
	mov buf_ptr, rcx		; rcx, buf_ptr <-> pointer
	mov w, rdx				; rdx, w <-> width
	mov h, r8				; r8, h <-> height
	
	xor rdx, rdx
	mov rax, w
	shr rax, 1
	mov X, rax
	mov jSzer, rax
	
	xor rdx, rdx
	mov rax, h
	shl rax, 1
	shr rax, 2
;	mov rbx, 4
;	div rbx
	mov Y, rax
	mov jWys, rax

	mov rax, w
	mov rbx, h
	mul rbx
	mov S, rax

	dec S ; numerowanie pixeli 0..n-1

	mov curi, 0
	shr jWys, 1
label1:
	mov rax, curi
	mov rbx, S
	cmp rax, rbx			; koniec tablicy pixeli
	je exit

	xor rdx, rdx
	mov rax, curi
	mov rbx, w
	div rbx
	mov cury, rax
	
	xor rdx, rdx
	mov rax, curi
	mov rbx, w
	div rbx
	mov curx, rdx

	CVTSI2SD xmm6, cztery ; czworka do porownanie

	CVTSI2SD xmm0, X
	CVTSI2SD xmm1, Y
	CVTSI2SD xmm2, curx
	CVTSI2SD xmm3, cury
	CVTSI2SD xmm4, jSzer
	CVTSI2SD xmm5, jWys
	
	subsd xmm2, xmm1	; znajdowanie aktualnego miejsca na plaszczyznie zespolonej	
	subsd xmm3, xmm0
	divsd xmm2, xmm5	; xmm0 <- rez
	divsd xmm3, xmm4	; xmm1 <- imz
	movsd xmm0, xmm2
	movsd xmm1, xmm3

	movsd px, xmm2
	movsd py, xmm3
	
	mov r8, 0

	label2:
		inc r8
	
		movsd xmm3, xmm0	; xmm3 <- 2 * rez * imz
		mulsd xmm3, xmm1
		addsd xmm3, xmm3

		mulsd xmm0, xmm0	; xmm0 <- rez^2
		mulsd xmm1, xmm1	; xmm1 <- imz^2
	
		movsd xmm5, xmm0	; xmm5 <- rez^2 + imz^2
		addsd xmm5, xmm1
	
		comisd xmm5, xmm6		; ? 4 < |z|^2 ?
		jnb nextpix				; jesli nie zgadza sie modul l. zesp. to idz do nastepnego pixela

		subsd xmm0, xmm1	; xmm0 <- rez^2 - imz^2
		movsd xmm1, xmm3	; xmm1 <- new imz

		movsd xmm2, px
		movsd xmm3, py

		addsd xmm0, xmm2
		addsd xmm1, xmm3


		cmp r8, 1000			; ile prob? 3
		jne label2

kolorowanie:
	mov rbx, curi
	mov rax, buf_ptr
	add rbx, rax
	mov al, 1
	mov byte ptr [rbx], al
nextpix:
	inc curi
	jmp label1

exit:
	pop rbp
	pop rsp
	pop r11
	pop r10
	pop r9
	pop r8
	pop rdx
	pop rcx
	pop rbx
	pop rax

	ret
mandelbrot endp
end