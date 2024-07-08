
.global _center
.global _check_button
.global _move_up
.global _move_down
.global _move_left
.global _move_right
.global _delay_loop  

addi x1, x0, 193         /* x1 = memory location;  center = 193 */
addi x2, x0, 7         /* x2 = bit select */
addi x3, x0, 383       /* max VGA location */
addi x4, x0, 384       /* x4 = UART location */

addi x13, x0, 3
addi x11, x0, 1
addi x12, x0, 7
li x14,  0x60000000
li x15,  0x40000000
li x16,  0x70000000

addi x17, x0, 2        /* Gun location */

_center:
    sw x2, 0(x1) 
	sw x17, -4(x1)

_check_button:
    addi x5, x0, 2     /* Key code for 'up' button */
    addi x7, x0, 6     /* Key code for 'down' button */
    addi x8, x0, 4     /* Key code for 'left' button */
    addi x9, x0, 8     /* Key code for 'right' button */
    lw a0, 0(x4)
    beq a0, x5, _move_up
    beq a0, x7, _move_down
    beq a0, x8, _move_left
    beq a0, x9, _move_right
    
    j _check_button

_move_up:

    sw x0, -4(x1)           /* clear current pixel */

    sw x0, 0(x1)           /* clear current pixel */

    sw x0, 4(x1)           /* clear current pixel */

    
    addi x1, x1, -4        /* update memory location (move up)*/
    blt x1, x0, _move_up_wrap
    sw x2, 0(x1)           /* fill screen */
    j _delay_loop
    
_move_up_wrap:
	addi x1, x1, 384
    sw x2, 0(x1)           /* fill screen */
    j _delay_loop

_move_down:
    sw x0, 0(x1)           /* clear current pixel */

    addi x1, x1, 4         /* update memory location (move down) */
    bge x1, x3, _move_down_wrap
    sw x2, 0(x1)           /* fill screen */

    j _delay_loop
    
_move_down_wrap:
	addi x1, x1, -384
    sw x2, 0(x1)           /* fill screen */
    j _delay_loop

_move_left:
    sw x0, 0(x1)           /* clear current pixel */
    sw x0, 1(x1)           /* clear current pixel */
    sw x0, -4(x1)           /* clear current pixel */
    beq x2, x15, _wrap_left
    beq x2, x14, _two_bit_left /* BEQ = 0x60000000 */
    beq x2, x16, _one_bit_left /* BEQ = 0x70000000 */
    slli x2, x2, 1         /* shift pixel left */
    slli x17, x17, 1
    bnez x2, _no_wrap_left /* if not zero, continue */
    
_wrap_left:
    addi x1, x1, -1        /* move to previous memory location */
    li x2, 0x7         /* set pixel to LSB */
    slli x17, x17, 1
    sw x2, 0(x1)           /* set new pixel */
    sw x17, -4(x1)           /* set new gun */
    j _delay_loop
    
_no_wrap_left:
    sw x2, 0(x1)           /* set new pixel */
    sw x17, -4(x1)           /* set new gun */
    j _delay_loop
    
_one_bit_left:
	li x2, 0x1
    sw x2, -1(x1)
    li x2, 0x60000000
    sw x2, 0(x1)
    sw x17, -4(x1)           /* set new gun */
	j _delay_loop
    
_two_bit_left:
	li x2, 0x3
    sw x2, -1(x1)
    li x2, 0x40000000  
    li x17, 0x1
    sw x2, 0(x1)
    sw x17, -5(x1)           /* set new gun */
	j _delay_loop

_move_right:
    sw x0, 0(x1)           /* clear current pixel */
    sw x0, -1(x1)

    srli x2, x2, 1         /* shift pixel right */
    beq x2, x0, _wrap_right
    beq x2, x11, _two_bit_right /* BEQ = 0x1 */
    beq x2, x13, _one_bit_right /* BEQ = 0x3 */
    bnez x2, _no_wrap_right /* if not zero, continue */
    
_wrap_right:
	addi x1, x1, 1         /* move to next memory location */
    li x2, 0x70000000      /* set pixel to MSB */
    sw x2, 0(x1)
    
    j _delay_loop
    
_no_wrap_right:
    sw x2, 0(x1)           /* set new pixel */
    j _delay_loop
    
_one_bit_right:
	li x2, 0x40000000
    sw x2, 1(x1)
    li x2, 0x3
    sw x2, 0(x1)
    
	j _delay_loop
    
_two_bit_right:
	li x2, 0x60000000      
    sw x2, 1(x1)
    li x2, 0x1     
    sw x2, 0(x1)
    
    
	j _delay_loop

_delay_loop:
    li x6, 100000          /* Load the delay count */
delay_loop:
    addi x6, x6, -1        /* Decrement the counter */
    bnez x6, delay_loop    /* Loop until the counter reaches zero */
    j _check_button

