#x24 is for wait counter
li x25, 2000000 #wait limit

#x26 is for move counter
addi x27, x0, 16 #x26 is for move limit

addi x1, x0, 60
addi x2, x0, 36
addi x3, x0, 24
addi x4, x0, 255

start:

    addi x26, x0, 0

left:
    sw x1, 0(x0)
    sw x2, 4(x0)
    sw x1, 8(x0)
    sw x3, 12(x0)
    sw x4, 16(x0)
    sw x3, 20(x0)
    sw x3, 24(x0)
    sw x2, 28(x0)
    sw x2, 32(x0)
    sw x2, 36(x0)

    addi x24, x0, 0; # x24 = x0 + 0

        wait_loop:

            #add to time counter
            addi x24, x24, 1; # x24 = x24 + 1    

            #repeat until finish time step
            blt x24, x25, wait_loop # if x24 < x25 then wait
    
    slli x1, x1, 1
    slli x2, x2, 1
    slli x3, x3, 1
    slli x4, x4, 1
    
    addi x26, x26, 1
    blt x26, x27, left


    addi x26, x0, 0

right:
    sw x1, 0(x0)
    sw x2, 4(x0)
    sw x1, 8(x0)
    sw x3, 12(x0)
    sw x4, 16(x0)
    sw x3, 20(x0)
    sw x3, 24(x0)
    sw x2, 28(x0)
    sw x2, 32(x0)
    sw x2, 36(x0)

    addi x24, x0, 0; # x24 = x0 + 0

        wait_loop2:

            #add to time counter
            addi x24, x24, 1; # x24 = x24 + 1    

            #repeat until finish time step
            blt x24, x25, wait_loop2 # if x24 < x25 then wait
    
    srli x1, x1, 1
    srli x2, x2, 1
    srli x3, x3, 1
    srli x4, x4, 1
    
    addi x26, x26, 1
    blt x26, x27, right

jal x0, start


    
    
