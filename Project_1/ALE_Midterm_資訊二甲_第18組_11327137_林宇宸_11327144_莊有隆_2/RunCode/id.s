               .data
data_type:     .asciz "%d"
data_type_n:   .asciz "%d\n"
data_type_char:.asciz " %c"
change_line:   .asciz "\n"
number:        .word 0
id_store:      .word 0, 0, 0
id_sum_val:    .word 0 
char:          .byte 0
title:         .asciz "** Please Enter Member %d ID:**\n"
enter_command: .asciz "** Please Enter Command **\n"
print_number:  .asciz "*****Print Team Member ID and ID Summation*****\n"
total:         .asciz "ID Summation = %d\n"
show_begin:    .asciz "*****Input ID*****\n"
show_end:      .asciz "*****End Print*****\n"

        .text
		.global id_sum_val 
        .global id_store
        .global id

id:     stmfd sp!, {lr}
        ldr r7, =id_store  @ r7 store 3 int data
		ldr r0, =show_begin
		bl  printf
		mov r11, #0        @ r11 = int 0
		
		@ Teacher Require
		mov   r12, sp
		rsbs  sp, lr, pc
		mov   sp, r12
		@ Teacher Require
		
	    b     load_number  @ jump to label load_number

@enter_student_number
load_number:
        add   r11, r11, #1 @ r11++
        ldr   r0, =title
		
        cmp   r11, #3      @ r11 < 3?
		bgt   input_p      @ if > 3 jump to label input_p
		mov   r1, r11      @ else r11(number) load to r1

		bl    printf
		ldr   r0, =data_type
		ldr   r1, =number
		bl    scanf
		ldr   r10,=number
		ldr   r4, [r10]
		cmp   r11, #3
		strle r4, [r7], #4  @ 1 int = 4 byte
		b     load_number

@Enter_command
input_p:

        ldr   r0,  =enter_command
		bl    printf
        ldr   r0, =data_type_char
		ldr   r1, =char  @load adress
		bl    scanf
		ldr   r9, =char  @load adress
		ldrb  r4, [r9]  @load data
		cmp   r4, #'p'
		beq   print
		b     input_p

@Print All Student Number
print:	
		ldr   r0, =print_number
		bl    printf

		ldr   r7, =id_store
        ldr   r4, [r7]
        ldr   r5, [r7, #4]
        ldr   r6, [r7, #8]

		ldr   r0, =data_type_n
		mov   r1, r4
		bl    printf

		ldr   r0, =data_type_n
		mov   r1, r5
		bl    printf

		ldr   r0, =data_type_n
		mov   r1, r6
		bl    printf

		ldr   r0, =change_line
		bl printf

		@ID_Sum
		ldr   r0, =total
		mov   r9, #0
		Add   r9, r9, r4
		Add   r9, r9, r5
		Add   r9, r9, r6
		ldr r8, =id_sum_val 
		str r9, [r8] 

		mov   r1, r9
		bl    printf
		ldr r0, =show_end
		bl  printf

		mov   r0, #0
        ldmfd sp!, {lr}
        mov   pc,  lr

