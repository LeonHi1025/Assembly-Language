        .data

main_title:     .asciz "\nMain Function:\n"
function1:      .asciz "Function1: Name\n"
function2:      .asciz "Function2: ID\n"
print_header:   .asciz "*****Print All******\n"
id_sum_fmt:     .asciz "ID Summation = %d\n"
fmt_id_name_nl: .asciz "%d %s"
show_end:       .asciz "*****End Print*****\n"

        .text
        .global main
        .extern name
        .extern id
        .extern printf
        .extern id_store
        .extern id_sum_val
        .extern team
        .extern name_1
        .extern name_2
        .extern name_3

main:
    stmfd sp!, {lr}

    @Call Function Name
    ldr r0,=function1
	bl printf
    bl name
	
	@Call Function ID
	ldr r0,=function2
	bl printf
    bl id

    @ print MAIN header
    ldr r0, =main_title
    bl printf
    ldr r0, =print_header
    bl printf

    @ print Team
    ldr r0, =team
    bl printf

    ldr r4, =id_store

    mov r7, #1
    cmp r7, #0
    movgt r6, #1
    addne r6, r6, #0

    @ print member1
    ldr r0, =fmt_id_name_nl
    ldr r1, [r4]
    ldr r2, =name_1
    bl printf

    @ print member2
    ldr r0, =fmt_id_name_nl
    ldr r1, [r4, #4]
    ldr r2, =name_2
    bl printf

    @ print member3
    ldr r0, =fmt_id_name_nl
    ldr r1, [r4, #8]
    ldr r2, =name_3
    bl printf

    @ print ID sum
    ldr r0, =id_sum_fmt
    ldr r1, =id_sum_val
    ldr r1, [r1]
    bl printf

    ldr r0, =show_end
    bl printf

    mov r0, #0
    ldmfd sp!, {lr}
    mov pc, lr
