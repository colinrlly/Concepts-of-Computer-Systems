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
# set a current location at the front of each sub-array
        # t0 = location of the array to sort
        lb      $t0, 0($a0)     # get address of array to sort
      
        # multiply by 8 to get displacement of bytes
        addi    $t3, $zero, 8   # get the number 8 in a register
        mult    $a1, $t3        # multiply the index of first sub-array by 8
        mflo    $t1             
        
        # t1 = location of the front of the first sub-array
        add     $t1, $t0, $t1   # add index of first sub-array to front of array

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


        # t0 = address of the array
        # t1 = address of the front of the first sub-array
        # t2 = address of the front of the second sub-array
        # t3 = the number 8
        # t4 = address of the middle of the array
        # t5 = address of the end of the array (high)
        addi    $t0, $zero, 0
no_empty:
# as long as both sub-arrays are not empty
        slt     $t6, $t4, $t1   # set if front of first sub-array is greater than its end
        slt     $t7, $t5, $t2   # set if front of second array is greater than its end
        # check if either sub array is empty
        # if t6 is 1: first is empty, if t7 is 1: second is empty
        bne     $t6, $zero, first_empty
        bne     $t7, $zero, second_empty
 # call the compare function on the value at the current location of each sub-array
        # load first element from each sub-array
        lb      $t6, 0($t1)     # t6 = first element in first sub-array
        lb      $t7, 0($t2)     # t7 = first element in second sub-array
        
        # load arguments for compare function 
        move    $a0, $t6
        move    $a1, $t7

        # get address of compare function
        lb      $t3, 16($a0)

        # run compare function
        jalr    $t3
        
        # v0 = return of compare function
 # move the value that is suppose to come first into the scrap array
        # if the return value in v0=1, then the value of a0 should be first in the merged list
        # if the return value in v0=0, then the value of a1 should be first in the merged list
        beq     $v0, $zero, second_first
        # the element in the first sub-array should go first
        # perform a load and store from the location of the smaller element to the proper index of the scrap array
        **************************************************************
 # advance the current location for sub-array that had that element
        # perform an addi on the current location of the sub-array
second_first:
# once one of the sub-arrays is empty, move the remaining elements in the other sub-array into the scarap array
        # case for first sub-array being empty
first_empty:
        # case for second sub-array being empty
second_empty:
# once that is done, copy the scrap array back into the main array at the location that the two sub-arrays occupied
        # loop through the scrap array and copy everything back into the original location

# ********** END STUDENT CODE BLOCK 2 **********

#
# End of Merge routine.
#
