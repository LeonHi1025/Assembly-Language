        .data
count_1: .word 0xffff

        .text
        .global drawJuliaSet
        .extern __aeabi_idiv

drawJuliaSet:

        stmfd   sp!, {r4-r11, lr}  
        mov     r10, r1             @ r10 = cY
        ldr     r11, [sp, #36]      @ form stack load frame pointer (4(byte) * 9(register) = 36)
		
		@!!
	mov     r0, lr
        adds    lr, sp, pc
	mov     lr, r0
		@!!
		
        mov     r5, #0              @ x = 0
		
for_loop_x:
        cmp     r5, #640            @ x < 640?
        beq     end_drawJuliaSet    
        movlt   r6, #0              @ y = 0                (Conditional Execution-1 less than)
		
for_loop_y:
        cmp     r6, #480            @ y < 480
        beq     next_x                

        @ --- zx = (1500 * x - 480000) / 320 ---
        ldr     r1, =1500
        mul     r0, r1, r5          @ 1500 * x
        ldr     r1, =480000       
        sub     r0, r0, r1          @ 1500 * x - 480000
	mov     r1, #1              @ r1 = 1             
	mov     r1, r1, LSL #13     @ r1 = 1 * 8192        (Operand2-1)
	mov     r1, r1, LSR #5      @ r1 = 8192 / 32 = 256 (Operand2-2)
	add     r1, r1, #64         @ r1 = 256 + 64 = 320  (Operand2-3)
        bl      __aeabi_idiv        @ / 320
        mov     r7, r0              @ r7 = zx              (Operand2-4)

        @ --- zy = (1000 * y - 240000) / 240 ---
        ldr     r1, =1000
        mul     r0, r1, r6          @ 1000 * y
        ldr     r1, =240000         
        sub     r0, r0, r1          @ 1000 * y - 240000
        mov     r1, #240             
        bl      __aeabi_idiv        @ / 240
        mov     r8, r0              @ r8 = zy
        mov     r9, #255            @ i = 255
		
while_loop:
        mul     r0, r7, r7          @ r0 = zx * zx
        mul     r1, r8, r8          @ r1 = zy * zy
        add     r12, r0, r1         @ zx * zx + zy * zy
        ldr     r3, =4000000
        cmp     r12, r3             @ zx * zx + zy * zy < 4000000 ?
        bge     after_while         @ draw
        cmpne   r9, #0              @ i > 0 ?              (Conditional Execution-2 not equal)
        ble     after_while         @ draw

        @ --- tmp = (zx * zx - zy * zy) / 1000 + cX(-700) ---
        mulgt     r0, r7, r7           @ r0 = zx * zx      (Conditional Execution-3 greater than)     
        mul     r1, r8, r8           @ r1 = zy * zy
        sub     r0, r0, r1           @ zx * zx - zy * zy
        mov     r1, #1000            
        bl      __aeabi_idiv         @ (zx * zx - zy * zy) / 1000
        sub     r4, r0, #700         @ + cX(-700)

        @ --- zy = (2 * zx * zy) / 1000 + cY ---
        mul     r0, r7, r8           @ r0 = zx * zy
        mov     r1, #2               
        mul     r0, r0, r1           @ 2 * zx * zy
        mov     r1, #1000
        bl      __aeabi_idiv         @ (2 * zx * zy) / 1000
        add     r8, r0, r10          @ zy = (2 * zx * zy) / 1000 + cY
        
        mov     r7, r4               @ zx = r4(tmp)
        sub     r9, r9, #1           @ i--
        b       while_loop

after_while:
        @ ---  r11 (frame) ---
        and     r0, r9, #0xff        @ r0 = i & 0xff
        mov     r1, r0, LSL #8       @ r1 = (i & 0xff) << 8
        orr     r0, r0, r1           @ r0 = (i & 0xff) << 8 |  i & 0xff
        mvn     r0, r0               @ color(r0) = ~color
        ldr     r3, =count_1         
        ldr     r1, [r3]             @ r1 = 0xffff
        and     r0, r0, r1           @ color = (~color) & 0xffff

        @ --- address count：r11 (frame) ---
        mov     r3, #640
        mul     r12, r6, r3          @ y * 640
        add     r12, r12, r5         @ + x
        mov     r1, #2
        mul     r12, r12, r1         @ (y * 640 + x) * 2
       
        strh    r0, [r11, r12]       @ load into frame[y][x]

        add     r6, r6, #1           @ y++
        b       for_loop_y 

next_x:
        add     r5, r5, #1           @ x++
        b       for_loop_x 

end_drawJuliaSet:
        mov     r0, #0
        ldmfd   sp!, {r4-r11, pc}
		