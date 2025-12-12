            .data
.global team
.global name_1
.global name_2
.global name_3

team:       .asciz "Team 18\n"
name_1:     .asciz "Zhang Youlong\n"
name_2:     .asciz "Lin YuChen\n"
name_3:     .asciz "Lin YuChen\n"
show_begin: .asciz "*****Print Name*****\n"
show_end:   .asciz "*****End Print*****\n"


        .text
        .global name

name:
    stmfd sp!, {lr}
    ldr   r0, =show_begin
	bl    printf
    ldr   r0, =team
	bl    printf
    ldr   r0, =name_1
	bl    printf
	ldr   r0, =name_2
	bl    printf
	ldr   r0, =name_3
	bl    printf
	ldr   r0, =show_end
	bl    printf
	mov   r0, #0
	ldmfd sp!, {lr}
	mov   pc,  lr
