
.global _center
.global _check_button
.global _move_up
.global _move_down
.global _move_left
.global _move_right
.global _delay_loop  

addi x1, x0, 340         /* x1 = memory location;  center = 193 */
addi x2, x0, 7         /* x2 = bit select */
addi x3, x0, 383       /* max VGA location */
addi x4, x0, 384       /* x4 = UART location */

addi x5, x0, 2     /* Key code for 'up' button */
addi x7, x0, 6     /* Key code for 'down' button */
addi x8, x0, 4     /* Key code for 'left' button */
addi x9, x0, 8     /* Key code for 'right' button */

addi x13, x0, 3
addi x11, x0, 1
addi x12, x0, 7
li x14,  0x60000000
li x15,  0x40000000
li x16,  0x70000000

addi x17, x0, 2        /* Gun location */

addi x18, x0, 0


/* Enemies*/
li x28,   0x00014000
li x29,   0x0003E000
li x30,   0x0001C000
li x31,   0x00008000 


_center:
    sw x2, 0(x1) 
	sw x17, -4(x1)
    
    /* Enemies */
    sw x28, 4(x0) 
    sw x28, 5(x0) 
    sw x28, 6(x0) 
    sw x28, 7(x0) 
    sw x29, 8(x0) 
    sw x29, 9(x0) 
    sw x29, 10(x0) 
    sw x29, 11(x0) 
    sw x30, 12(x0) 
    sw x30, 13(x0)
    sw x30, 14(x0)
    sw x30, 15(x0)
    sw x31, 16(x0)
    sw x31, 17(x0)
    sw x31, 18(x0)
    sw x31, 19(x0)


_check_button:
    lw a0, 0(x4)

	beq a0, x5, _shoot
    beq a0, x8, _move_left
    beq a0, x9, _move_right
    
    j _delay_loop

_shoot:
	sw x0, -8(x18)
	addi x18, x1, 0
    addi x19, x17, 0
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
    slli x17, x17, 1
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
	sw x0, -4(x1)           /* clear current pixel */
    srli x17, x17, 1
    srli x2, x2, 1         /* shift pixel right */
    beq x2, x0, _wrap_right
    beq x2, x11, _two_bit_right /* BEQ = 0x1 */
    beq x2, x13, _one_bit_right /* BEQ = 0x3 */
    bnez x2, _no_wrap_right /* if not zero, continue */
    
_wrap_right:
	addi x1, x1, 1         /* move to next memory location */
    li x2, 0x70000000      /* set pixel to MSB */
    sw x2, 0(x1)
    sw x17, -4(x1)           /* set new gun */
    j _delay_loop
    
_no_wrap_right:
    sw x2, 0(x1)           /* set new pixel */
    sw x17, -4(x1)           /* set new gun */
    j _delay_loop
    
_one_bit_right:
	li x2, 0x40000000
    sw x2, 1(x1)
    li x2, 0x3
    sw x2, 0(x1)
    sw x17, -4(x1)           /* set new gun */
	j _delay_loop
    
_two_bit_right:
	li x2, 0x60000000      
    sw x2, 1(x1)
    li x2, 0x1     
    li x17, 0x40000000
    sw x2, 0(x1)
    sw x17, -3(x1)           /* set new gun */
    
    
	j _delay_loop

_delay_loop:
    li x6, 100000          /* Load the delay count */
delay_loop:
    addi x6, x6, -1        /* Decrement the counter */
    bnez x6, delay_loop    /* Loop until the counter reaches zero */
    addi x18, x18, -4      
    sw x19, -8(x18)          
    sw x0, -4(x18)
    blt x18, x0, _shoot_loop  
    j _check_button
    
_shoot_loop:
	addi x18, x0, 0
    j _check_button


///////////////////Trying to add bullet shooting through ship//////////////////////


.global _center
.global _check_button
.global _move_up
.global _move_down
.global _move_left
.global _move_right
.global _delay_loop  

addi x1, x0, 340         /* x1 = memory location;  center = 193 */
addi x2, x0, 7         /* x2 = bit select */
addi x3, x0, 383       /* max VGA location */
addi x4, x0, 384       /* x4 = UART location */

addi x5, x0, 2     /* Key code for 'up' button */
addi x7, x0, 6     /* Key code for 'down' button */
addi x8, x0, 4     /* Key code for 'left' button */
addi x9, x0, 8     /* Key code for 'right' button */

addi x13, x0, 3
addi x11, x0, 1
addi x12, x0, 7
li x14,  0x60000000
li x15,  0x40000000
li x16,  0x70000000

addi x17, x0, 2        /* Gun location */

addi x18, x0, 0

addi x20, x0, 24 /* bottom of enemies */


/* Enemies*/
li x28,   0x06C00000
li x29,   0x7BBC0000
li x30,   0x07C00000
li x31,   0x02800000
li x27,   0x01000000


_center:
    sw x2, 0(x1) 
	sw x17, -4(x1)
    
    /* Enemies */
    sw x28, 4(x0) 
    sw x28, 5(x0) 
    sw x28, 6(x0) 
    sw x28, 7(x0) 
    sw x29, 8(x0) 
    sw x29, 9(x0) 
    sw x29, 10(x0) 
    sw x29, 11(x0) 
    sw x30, 12(x0) 
    sw x30, 13(x0)
    sw x30, 14(x0)
    sw x30, 15(x0)
    sw x31, 16(x0)
    sw x31, 17(x0)
    sw x31, 18(x0)
    sw x31, 19(x0)
    sw x27, 20(x0) 
    sw x27, 21(x0) 
    sw x27, 22(x0) 
    sw x27, 23(x0) 


_check_button:
    lw a0, 0(x4)
	
	beq a0, x5, _shoot
    beq a0, x8, _move_left
    beq a0, x9, _move_right
    
    
    
    j _delay_loop

_shoot:
	sb x0, -8(x18)
	addi x18, x1, 0 /* bullet register */
    addi x19, x17, 0 /* bullet bit */
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
    slli x17, x17, 1
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
	sw x0, -4(x1)           /* clear current pixel */
    srli x17, x17, 1
    srli x2, x2, 1         /* shift pixel right */
    beq x2, x0, _wrap_right
    beq x2, x11, _two_bit_right /* BEQ = 0x1 */
    beq x2, x13, _one_bit_right /* BEQ = 0x3 */
    bnez x2, _no_wrap_right /* if not zero, continue */
    
_wrap_right:
	addi x1, x1, 1         /* move to next memory location */
    li x2, 0x70000000      /* set pixel to MSB */
    sw x2, 0(x1)
    sw x17, -4(x1)           /* set new gun */
    j _delay_loop
    
_no_wrap_right:
    sw x2, 0(x1)           /* set new pixel */
    sw x17, -4(x1)           /* set new gun */
    j _delay_loop
    
_one_bit_right:
	li x2, 0x40000000
    sw x2, 1(x1)
    li x2, 0x3
    sw x2, 0(x1)
    sw x17, -4(x1)           /* set new gun */
	j _delay_loop
    
_two_bit_right:
	li x2, 0x60000000      
    sw x2, 1(x1)
    li x2, 0x1     
    li x17, 0x40000000
    sw x2, 0(x1)
    sw x17, -3(x1)           /* set new gun */
    
    
	j _delay_loop

_delay_loop:
    li x6, 100000          /* Load the delay count */
delay_loop:
    addi x6, x6, -1        /* Decrement the counter */
    bnez x6, delay_loop    /* Loop until the counter reaches zero */
    addi x18, x18, -4      
    blt x18, x0, _shoot_loopy
    blt x18, x20, _shoot_loop  
    sw x19, -8(x18)          
    sw x0, -4(x18)
    j _check_button
    
_shoot_loopy:
    addi x18, x0, 0
    j _check_button
    
_shoot_loop:  /* 26 is hold */
    and x26, x27, x19 
    bnez x26, _five
	and x26, x31, x19 
    bnez x26, _four
    and x26, x30, x19 
    bnez x26, _three
    and x26, x29, x19 
    bnez x26, _two
    and x26, x28, x19 
    bnez x26, _one
    j _check_button
    
    
_one:
	xor x28, x28, x19 
	sw x28, -16(x18)
    
    j _check_button
    
_two:
	xor x29, x29, x19 
    sw x29, -12(x18)
    j _one

_three:
	xor x30, x30, x19 
	sw x30, -8(x18)
    j _two

_four:
	xor x31, x31, x19 
	sw x31, -4(x18)
    j _three

_five:
	xor x27, x27, x19 
	sw x27, 0(x18)
    j _four
    
