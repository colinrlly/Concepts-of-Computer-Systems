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

        addi    $s3, $s3, -1    # decrement length
        addi    $t2, $zero, -1  # stop loop when length == -1
        move    $t4, $zero      # initialize carry

addition_loop:
                                # branch when length is 0
        beq     $s3, $t2, done_adding

        add     $s4, $s0, $s3   # get effective first num digit pointer
        add     $s5, $s1, $s3   # get effective second num digit pointer
        add     $s6, $s2, $s3   # get effective result digit pointer

        lb      $s7, 0($s4)     # get digit of first number
        lb      $t1, 0($s5)     # get digit of second number
        
        add     $t3, $s7, $t1   # add the two numbers
        addi    $t3, $t3, -48   # get rid of extra 48
        add     $t3, $t3, $t4   # add carry

        addi    $t3, $t3, -58   # calculating the next carry
        slt     $t5, $t3, $zero # set t5 1 if t3 < 0
                                # branch if t3 < 0
        bne     $t5, $zero, no_carry
        addi    $t3, $t3, 48    # if there is a carry t3 is amt > #58
        addi    $t4, $zero, 1   # set carry to 1
        j       carry           # skip no_carry code
        
no_carry:
        addi    $t3, $t3, 58    # there is no carry so just add 57 back
        move    $t4, $zero      # carry is 0

carry:
        sb      $t3, 0($s6)     # store the first digit in result
        
        addi    $s3, $s3, -1    # decrement length num
        
        j addition_loop

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
