# File:		add_ascii_numbers.asm
# Author:	K. Reek
# Contributors:	P. White, W. Carithers
#		Colin Reilly
#
# Updates:
#		3/2004	M. Reek, named constants
#		10/2007 W. Carithers, alignment
#		09/2009 W. Carithers, separate assembly
#
# Description:	Add two ASCII numbers and store the result in ASCII.
#
# Arguments:	a0: address of parameter block.  The block consists of
#		four words that contain (in this order):
#
#			address of first input string
#			address of second input string
#			address where result should be stored
#			length of the strings and result buffer
#
#		(There is actually other data after this in the
#		parameter block, but it is not relevant to this routine.)
#
# Returns:	The result of the addition, in the buffer specified by
#		the parameter block.
#

	.globl	add_ascii_numbers

add_ascii_numbers:
A_FRAMESIZE = 40

#
# Save registers ra and s0 - s7 on the stack.
#
	addi 	$sp, $sp, -A_FRAMESIZE
	sw 	$ra, -4+A_FRAMESIZE($sp)
	sw 	$s7, 28($sp)
	sw 	$s6, 24($sp)
	sw 	$s5, 20($sp)
	sw 	$s4, 16($sp)
	sw 	$s3, 12($sp)
	sw 	$s2, 8($sp)
	sw 	$s1, 4($sp)
	sw 	$s0, 0($sp)
	
# ##### BEGIN STUDENT CODE BLOCK 1 #####

        lw      $s0, 0($a0)     # get address of first number
        lw      $s1, 4($a0)     # get address of second number
        lw      $s2, 8($a0)     # get address of result
        lw      $s3, 12($a0)    # get length of strings

        move    $s4, $zero      # initialize carry to 0

addition_loop:
                                # exit when there are no more digits
        beq     $s2, $zero, done_adding
        
        add     $s5, $s0, $s3   # use digit $s3 away from beg of first num
        add     $s6, $s1, $s3   # use digit $s3 away from beg of second num
        add     $s7, $s2, $s3   # use digit #s3 away from beg of result

        lb      $t1, 0($s5)     # get the value of the digit in first number
        lb      $t2, 0($s6)     # get the value of the digit in second number

        add     $t3, $t1, $t2   # add two digits together
        addi    $t3, $t3, -48   # subtract 48 to get correct ascii
        add     $t3, $t3, $s4   # add the carry

        sb      $t3, 0($s7)     # store the calulated digit in the result

        addi    $s3, $s3, -1    # decrement the digit pointer
        j       addition_loop   # go back to beginning of loop

done_adding:
                

# ###### END STUDENT CODE BLOCK 1 ######

#
# Restore registers ra and s0 - s7 from the stack.
#
	lw 	$ra, -4+A_FRAMESIZE($sp)
	lw 	$s7, 28($sp)
	lw 	$s6, 24($sp)
	lw 	$s5, 20($sp)
	lw 	$s4, 16($sp)
	lw 	$s3, 12($sp)
	lw 	$s2, 8($sp)
	lw 	$s1, 4($sp)
	lw 	$s0, 0($sp)
	addi 	$sp, $sp, A_FRAMESIZE

	jr	$ra			# Return to the caller.
