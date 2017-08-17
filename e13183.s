	.text

	.global main

main:

		@push lr to stack
			sub sp, sp, #4
			str lr, [sp, #0]
		

		@printf for enter the key
			ldr r0,=formatp1
			bl printf

			sub sp,sp,#8
		
		@scan the key1
			ldr r0,=formats
			mov r1,sp
			bl scanf
		
		
		@load 32bit wise to registers
			ldr r4,[sp,#4] @r4->b1
			ldr r5,[sp,#0] @r5->b2

			
		@scan the key2
			ldr r0,=formats
			mov r1,sp
			bl scanf
		
		@load 32bit wise to registers
			ldr r6,[sp,#4] @r6->a1
			ldr r7,[sp,#0] @r7->a2


		@printf for enter the plaintext
			ldr r0,=formatp2
			bl printf

		
		@scan the plaintext1
			ldr r0,=formats
			mov r1,sp
			bl scanf


		@load 32bit wise to registers
			ldr r8,[sp,#4] @r8->y1
			ldr r9,[sp,#0] @r9->y2


			
		@scan the plaintext2
			ldr r0,=formats
			mov r1,sp
			bl scanf
		
		
		@load 32bit wise to registers
			ldr r10,[sp,#4] @r10->x1
			ldr r11,[sp,#0] @r11->x2
			
			add sp,sp,#8
		

		@Calling the encrpt function 

			bl  encrypt


		@printf for Ciper text is:
			ldr r0,=formatp3
			bl printf

			ldr r0,=format3
			mov r1,r9
			mov r2,r8
			bl printf

			ldr r0,=format
			mov r1,r11
			mov r2,r10
			bl printf

		@ stack handling

			ldr	lr, [sp, #0]					  
			add	sp, sp, #4
			mov	pc, lr


roundRight:

	@x1->r0
	@x2->r1


		sub sp,sp,#28
		str lr,[sp,#0]
		str r4,[sp,#4]
		str r5,[sp,#8]
		str r6,[sp,#12]
		str r7,[sp,#16]
		str r8,[sp,#20]
		str r9,[sp,#24]
		
		
		lsr r4,r0,#8 @r4-> x1>>r
		lsl r5,r0,#24 @r5->x1<<32-r
		
		lsr r6,r1,#8 @r6-> x2>>r
		lsl r7,r1,#24 @r7->x2<<32-r
		
		orr r8,r4,r7 @r8->x1>>r | x2<<32-r
		orr r9,r5,r6 @r9->x2>>r | x1<<32-r
		
		
		mov r0,r8
		mov r1,r9
		
		ldr lr,[sp,#0]
		ldr r4,[sp,#4]
		ldr r5,[sp,#8]
		ldr r6,[sp,#12]
		ldr r7,[sp,#16]
		ldr r8,[sp,#20]
		ldr r9,[sp,#24]
		
		add sp,sp,#28
		mov pc,lr

roundLeft:

	@x1->r0
	@x2->r1
	

		sub sp,sp,#28
		str lr,[sp,#0]
		str r4,[sp,#4]
		str r5,[sp,#8]
		str r6,[sp,#12]
		str r7,[sp,#16]
		str r8,[sp,#20]
		str r9,[sp,#24]
		
		@mov r3,#32
		@sub r3,r3,r2  @r3->32-r
		
		lsl r4,r0,#3 @r4-> x1<<r
		lsr r5,r0,#29 @r5->x1>>32-r
		
		lsl r6,r1,#3 @r6-> x2<<r
		lsr r7,r1,#29 @r7->x2>>32-r
		
		orr r8,r4,r7 @r8->x1<<r | x2>>32-r
		orr r9,r5,r6 @r9->x2<<r | x1>>32-r
		
		
		mov r0,r8
		mov r1,r9
		
		ldr lr,[sp,#0]
		ldr r4,[sp,#4]
		ldr r5,[sp,#8]
		ldr r6,[sp,#12]
		ldr r7,[sp,#16]
		ldr r8,[sp,#20]
		ldr r9,[sp,#24]
		
		add sp,sp,#28
		mov pc,lr

@Encrypting function

encrypt:
		sub sp,sp,#4
		str lr,[sp,#0]

			
			@calling Round function-Round (x,y,b)
	@round right(x1,x2,8)
		mov r0,r8 
		mov r1,r9
		bl roundRight

		mov r8,r0 @r8->x1
		mov r9,r1 @r9->x2
		
				@x=x+y
		adds r9,r9,r11 @x2->x2+y2
		adc r8,r8,r10 @x1->x1+y1

				@x=x xor b
		eor r8,r8,r6  @x1->x1 xor b1
		eor r9,r9,r7 @x2=x2 xor b2



		@roundLeft(y1,y2,3)
		mov r0,r10 
		mov r1,r11
		bl roundLeft
		mov r10,r0
		mov r11,r1

		@y=y xor x
		eor r10,r10,r8  @y1->x1 xor y1
		eor r11,r11,r9 @y2=y2 xor x2 
		
		@i=0

		mov r12,#0

loop: 	cmp r12,#31
		beq exit  

		@round right(a1,a2,8)
		mov r0,r4 
		mov r1,r5
		bl roundRight

		mov r4,r0 @r4->a1
		mov r5,r1 @r5->a2
		
				@a=a+b
		adds r5,r5,r7 @a2->a2+b2
		adc r4,r4,r6 @a1->a1+b1

				@a=a xor i
		eor r5,r5,r12 @a2=a2 xor i 


		@roundLeft(b1,b2,3)
		mov r0,r6 
		mov r1,r7
		bl roundLeft

		mov r6,r0 @r6->b1
		mov r7,r1 @r7->b2
		
		@b=b xor a
		eor r6,r6,r4  @b1->b1 xor a1
		eor r7,r7,r5  @ b2=b2 xor a2 		
		

	@calling Round function-Round (x,y,b)
	@round right(x1,x2,8)
		mov r0,r8 
		mov r1,r9
		bl roundRight

		mov r8,r0 @r8->x1
		mov r9,r1 @r9->x2
		
				@x=x+y
		adds r9,r9,r11 @x2->x2+y2
		adc r8,r8,r10 @x1->x1+y1

				@x=x xor b
		eor r8,r8,r6  @x1->x1 xor b1
		eor r9,r9,r7 @x2=x2 xor b2 				

	@roundLeft(y1,y2,3)
		mov r0,r10 
		mov r1,r11
		bl roundLeft

		mov r10,r0 @r10->y1
		mov r11,r1 @r11->y2
		
		@y=y xor x
		eor r10,r10,r8  @y1->x1 xor y1
		eor r11,r11,r9 @y2=y2 xor x2 
		
		add r12,r12,#1
		b loop

	exit:
		
		
		ldr lr,[sp,#0]
		add sp,sp,#4	
		mov pc,lr 

		
	
	.data
	@ data memory

formatp1: .asciz "Enter the key:\n"
formatp2: .asciz "Enter the plain text:\n"
formats: .asciz "%llx"
formatp3: .asciz "Cipher text is:\n"
format3 : .asciz "%.16llx "											
format  : .asciz "%.16llx\n"

