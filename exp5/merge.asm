#
# FILE:         $File$
# AUTHOR:       Phil White, RIT 2016
#               
# CONTRIBUTORS:
#		<<<YOUR NAME HERE>>>
#
# DESCRIPTION:
#	This file contains the merge function of mergesort
#

#-------------------------------

#
# Numeric Constants
#

PRINT_STRING = 4
PRINT_INT = 1


#***** BEGIN STUDENT CODE BLOCK 2 ***************************


#
# Make sure to add any .globl that you need here
#

    .globl  merge
    .globl  sort

#
# Name:         merge
# Description:  takes two individually sorted areas of an array and
#		merges them into a single sorted area
#
#		The two areas are defined between (inclusive)
#		area1:	low   - mid
#		area2:	mid+1 - high
#
#		Note that the area will be contiguous in the array
#
# Arguments:    a0:     a parameter block containing 3 values
#			- the address of the array to sort
#			- the address of the scrap array needed by merge
#			- the address of the compare function to use
#			  when ordering data
#               a1:     the index of the first element of the area
#               a2:     the index of the last element of the area
#               a3:     the index of the middle element of the area
# Returns:      none
# Destroys:     t0,t1
#

merge:
A_FRAMESIZE = 48

# 
# Save registers ra and s0 - s7 on the stack.
#

        addi    $sp, $sp, -A_FRAMESIZE
        sw      $ra, -4+A_FRAMESIZE($sp)
        sw      $s7, 28($sp)
        sw      $s6, 24($sp)
        sw      $s5, 20($sp)
        sw      $s4, 16($sp)
        sw      $s3, 12($sp)
        sw      $s2, 8($sp)
        sw      $s1, 4($sp)
        sw      $s0, 0($sp)

# set a current location at the front of each sub-array
        # t0 = location of the array to sort
        lw      $t0, 0($a0)     # get address of array to sort
      
        # multiply by 8 to get displacement of bytes
        addi    $t3, $zero, 4   # get the number 4 in a register
        mult    $a1, $t3        # multiply the index of first sub-array by 8
        mflo    $t1             
        
        # t1 = location of the front of the first sub-array
        add     $t1, $t0, $t1   # add index of first sub-array to front of array
        move    $s3, $t1        # copy for moving over data at the end

        # get index of second sub-array
        addi    $t2, $a3, 1     # add one to the middle index
        mult    $t2, $t3        # multiply the index of second sub-array by 8
        mflo    $t2             
         
        # t2 = location of the front of the second sub-array
        add     $t2, $t0, $t2   # add index of second sub-array to front of array

        # t4 = location of middle (end of first sub-array)
        mult    $a3, $t3        # multiply index of middle by 8
        mflo    $t4
        add     $t4, $t0, $t4   # add index of middle to front of array 
        
        # t5 = location of high   (end of second sub-array)
        mult    $a2, $t3        # multiply index of high by 8
        mflo    $t5
        add     $t5, $t0, $t5   # add index of high to front of array

        # s1 = location of front of scrap array
        lw      $s1, 4($a0)
        lw      $s2, 4($a0)     # second copy for moving over data at the end

        # t0 = address of the array
        # t1 = address of the front of the first sub-array
        # t2 = address of the front of the second sub-array
        # t3 = the number 4
        # t4 = address of the middle of the array
        # t5 = address of the end of the array (high)
        # s1 = address of the front of the scrap array
        # s2 = address of the front of the scrap array
        lw      $t3, 8($a0)     # get address of compare function

while_no_empty:
        slt     $t6, $t4, $t1   # set if front of first sub-array is greater than its end
        slt     $t7, $t5, $t2   # set if front of second array is greater than its end
        
        bne     $t6, $zero, first_empty         # check if first is empty
        bne     $t7, $zero, second_empty        # check if second is empty
  
        lw      $t6, 0($t1)     # t6 = first element in first sub-array
        lw      $t7, 0($t2)     # t7 = first element in second sub-array
        
        sw      $a0, 32($sp)    # store arguments
        sw      $a1, 36($sp)
 
        add     $a0, $zero, $t6 # load t6 into a0
        add     $a1, $zero, $t7 # load t7 into a1

        jalr    $t3             # run compare function

        lw      $a0, 32($sp)    # load back arguments
        lw      $a1, 36($sp)
        
        # v0 = return of compare function
        beq     $v0, $zero, second_first
      
        lw      $s0, 0($t1)     # move first element of sub-array into scrap array
        sw      $s0, 0($s1)
        addi    $t1, $t1, 4     # advance current sub-array

        j       bottom_of_loop
second_first:
        lw      $s0, 0($t2)     # move first element of sub-array into scrap array
        sw      $s0, 0($s1)
        addi    $t2, $t2, 4     # advance current sub-array

bottom_of_loop:
        addi    $s1, $s1, 4     # advance scrap array pointer

        j       while_no_empty

first_empty:
        lw      $s4, 0($t2)     # move first element of second array to scrap
        sw      $s4, 0($s1)

        addi    $t2, $t2, 4     # increment second sub-array and scrap
        addi    $s1, $s1, 4

        slt     $s5, $t5, $t2   # loop if second sub-array isn't empty
        beq     $s5, $zero, first_empty

        j       done

second_empty:
        lw      $s4, 0($t1)     # move first element of first array to scrap
        sw      $s4, 0($s1)

        addi    $t1, $t1, 4     # increment first sub-array and scrap
        addi    $s1, $s1, 4

        slt     $s5, $t4, $t1   # loop if first sub-array isn't empty
        beq     $s5, $zero, second_empty

done:
        # get front of scrap array (s2)
        # front of original array (s3)
        lw      $s4, 0($s2)     # copy first element from scrap array to original
        sw      $s4, 0($s3)
        # iterate both
        addi    $s2, $s2, 4     # increment both pointers
        addi    $s3, $s3, 4
        # until low > high
        slt     $s5, $t5, $s3   # set if end is less than front
        beq     $s5, $zero, done
        
#
# Restore registrs ra and s0 - s7 from the stack.
#

        lw      $ra, -4+A_FRAMESIZE($sp)
        lw      $s7, 28($sp)
        lw      $s6, 24($sp)
        lw      $s5, 20($sp)
        lw      $s4, 16($sp)
        lw      $s3, 12($sp)
        lw      $s2, 8($sp)
        lw      $s1, 4($sp)
        lw      $s0, 0($sp)
        addi    $sp, $sp, A_FRAMESIZE

        jr      $ra
# ********** END STUDENT CODE BLOCK 2 **********

#
# End of Merge routine.
#
