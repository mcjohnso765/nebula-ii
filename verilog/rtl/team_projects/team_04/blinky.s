#list of registers and their purpose in this program

# x1 - all ones
li x1, 0xffffffff
# x5 - link (jal, jalr)

# x2 - color to paint with

# x9 - loop counter
# x10 - VGA screen size
addi x10, x0, 384

# x24 - time counter
# x25 - time step size
li x25, 12000000
#addi x25, x0, 120000; # x25 = x0 + 100
# consider X26 for longer waits


start:

    xor x2, x2, x1
    
    # jal x5, paint_screen  # jump to paint_screen and save position to x5
    
    # jal x5, wait


#paints screen with the value in x2
# paint_screen:

    #reset loop
    addi x9, x0, 0; # x2 = x0 + 0 //set r9 to 0

    fill_pixel:

        sw x2, 0(x9) #store ffff to memory

        addi x9, x9, 1 # x2 = x2 + 4

        blt x9, x10, fill_pixel # if x2 < t1 then target

    #exit function
    #jal x0, wait
    




#waits for some interval of time (provided by x25)
# wait:
    #reset time counter
    addi x24, x0, 0; # x24 = x0 + 0

    wait_loop:

        #add to time counter
        addi x24, x24, 1; # x24 = x24 + 1    

        #repeat until finish time step
        blt x24, x25, wait_loop # if x24 < x25 then wait
        
    #jump to where wait was called
    jal x0, start
    

#end program
# end:
#     jal end  # jump to end and save position to ra
    
