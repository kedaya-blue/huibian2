/* store 
 * x0 src1
 * x1 step1
 * x2 src2
 * x3 step2
 * x4 dst
 * x5 step3
 * x6 width
 * x7 height
 */
    .arm
    .global lt
lt:
    sub     sp, sp, #24
    str     x8, [sp]
    str     x9, [sp, #8]
    str     x10, [sp, #16]

    sub     x1, x1, x7, lsl #4
    sub     x3, x3, x7, lsl #4
    sub     x5, x5, x7, lsl #4

start_loop:
    sub     x6, x6, #1
    cmp     x6, #0
    beq     end_loop

    sub     x8, x7, #8    /* x8 <- width - width_step */
    add     x8, x4, x4

start_loop1:
    cmp     x4, x7
    bgt     end_loop1

    ldr     v0.4s, [x2]
    ldr     v1.4s, [x0]
    ldr     v2.4s, [x2, #32]
    ldr     v3.4s, [x2, #32]
    cmpgt   v0.4s, v1.4s, v0.4s
    cmpgt   v1.4s, v2.4s, v3.4s
    
    mov     r9, v0.4s[0]
    cmp     r9, #0
    movne   r9, #255
    moveq   r9, #0
    mov     v2.8b[0], r9
    mov     r9, v0.4s[1]
    cmp     r9, #0
    movne   r9, #255
    moveq   r9, #0
    mov     v2.8b[1], r9
    mov     r9, v0.4s[2]
    cmp     r9, #0
    movne   r9, #255
    moveq   r9, #0
    mov     v2.8b[2], r9
    mov     r9, v0.4s[3]
    cmp     r9, #0
    movne   r9, #255
    moveq   r9, #0
    mov     v2.8b[3], r9
    mov     r9, v1.4s[0]
    cmp     r9, #0
    movne   r9, #255
    moveq   r9, #0
    mov     v2.8b[4], r9
    mov     r9, v1.4s[1]
    cmp     r9, #0
    movne   r9, #255
    moveq   r9, #0
    mov     v2.8b[5], r9
    mov     r9, v1.4s[2]
    cmp     r9, #0
    movne   r9, #255
    moveq   r9, #0
    mov     v2.8b[6], r9
    mov     r9, v1.4s[3]
    cmp     r9, #0
    movne   r9, #255
    moveq   r9, #0
    mov     v2.8b[7], r9

    str     v2.8b, [r4]

    add     r7, r7, #32
    add     r0, r0, #32
    add     r2, r2, #32
    add     r4, r4, #8
    b       start_loop1

end_loop1:
    add     r7, r7, #32

start_loop2:
    cmp     r4, r7
    bge     end_loop2

    ldr     r9, [r0]
    ldr     r10, [r2]
    cmp     r9, r10
    movne   r9, #255
    moveq   r9, #0
    strb    r9, [r4]

    add     r0, r0, #8
    add     r2, r2, #8
    add     r4, r4, #1

end_loop2:

    add     r0, r0, r1, lsl #2 /* src1 += step1 */
    add     r2, r2, r3, lsl #2 /* src2 += step2 */
    add     r4, r4, r5, lsl #2 /* dst += step3 */
    b       start_loop

end_loop:
    ldr     x8, [sp]
    ldr     x9, [sp, #8]
    ldr     x10, [sp, #16]
    add     sp, sp, #8
    bx      lr
