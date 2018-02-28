# FILE:         $File$
# AUTHOR:       P. White
# CONTRIBUTORS: M. Reek, W. Carithers
# 		        Colin Reilly
#
# DESCRIPTION:
#	In this experiment, you will write some code in a pair of 
#	functions that are used to simplify a fraction.
#
# ARGUMENTS:
#       None
#
# INPUT:
#	The numerator and denominator of a fraction
#
# OUTPUT:
#	The fraction in simplified form (ie 210/50 would be simplified
#	to "4 and 1/5")
#
# REVISION HISTORY:
#       Dec  13, 04         - P. White, created program
#

#
# CONSTANT DECLARATIONS
#
PRINT_INT	= 1		# code for syscall to print integer
PRINT_STRING	= 4		# code for syscall to print a string
READ_INT	= 5		# code for syscall to read an int

#
# DATA DECLARATIONS
#
	.data
into_msg:
	.ascii  "\n*************************\n"
	.ascii	  "** Fraction Simplifier **\n"
	.asciiz   "*************************\n\n"
newline:
	.asciiz "\n"
input_error:
	.asciiz "\nError with previous input, try again.\n"
num_string:
	.asciiz "\nEnter the Numerator of the fraction: "
den_string:
	.asciiz "\nEnter the Denominator of the fraction: "
res_string:
	.asciiz "\nThe simplified fraction is: "
and_string:
	.asciiz " and "
div_string:
	.asciiz "/"
#
# MAIN PROGRAM
#
	.text
	.align	2
	.globl	main
main:
        addi    $sp, $sp, -16  	# space for return address/doubleword aligned
        sw      $ra, 12($sp)    # store the ra on the stack
        sw      $s2, 8($sp)
        sw      $s1, 4($sp)
        sw      $s0, 0($sp)

	la	$a0, into_msg
        jal	print_string

ask_for_num:
	la	$a0, num_string
        jal	print_string

	la	$v0, READ_INT
	syscall
	move	$s0, $v0	# s0 will be the numerator

	slti    $t0, $v0, 0
	beq	$t0, $zero, ask_for_den

        la      $a0, input_error
	jal     print_string

	j	ask_for_num

ask_for_den:
	la	$a0, den_string
	jal	print_string

	la	$v0, READ_INT
	syscall
	move	$a1, $v0	# a1 will be the denominator

	slti	$t0, $v0, 1
	beq	$t0, $zero, den_good

        la      $a0, input_error
	jal	print_string

	j	ask_for_den

den_good:
	move	$a0, $s0	# copy the numerator into a0
	jal	simplify

	move	$s0, $v0	# save the numerator
	move	$s1, $v1	# save the denominator
	move	$s2, $t9	# save the integer part
	
        la      $a0, res_string
	jal	print_string

	move	$a0, $s2
	li	$v0, PRINT_INT
	syscall

        la      $a0, and_string
	jal	print_string

        move    $a0, $s0
	li	$v0, PRINT_INT
	syscall

        la      $a0, div_string
	jal	print_string

        move    $a0, $s1
	li	$v0, PRINT_INT
	syscall

        la      $a0, newline
	jal	print_string

        #
        # Now exit the program.
	#
        lw      $ra, 12($sp)	# clean up stack
        lw      $s2, 8($sp)
        lw      $s1, 4($sp)
        lw      $s0, 0($sp)
        addi    $sp, $sp, 16
        jr      $ra

#
# Name:		simplify 
#
# Description:	Simplify a fraction.
#
# Arguments:	a0:	the original numerator
#		a1:	the original denominator
# Returns:	v0:	the simplified numerator
#		v1:	the simplified denominator
#		t9:	the simplified integer part
#
#######################################################################
# 		NOTE: 	this function uses a non-standard return register
#			t9 will contain the integer part of the
#			simplified fraction
#######################################################################
#
#

simplify:
        addi    $sp, $sp, -40	# allocate stack frame (on doubleword boundary)
        sw      $ra, 32($sp)    # store the ra & s reg's on the stack
        sw      $s7, 28($sp)
        sw      $s6, 24($sp)
        sw      $s5, 20($sp)
        sw      $s4, 16($sp)
        sw      $s3, 12($sp)
        sw      $s2, 8($sp)
        sw      $s1, 4($sp)
        sw      $s0, 0($sp)
	
# ######################################
# ##### BEGIN STUDENT CODE BLOCK 1 #####
        li $s2, 0

while_num_gt_den:
        slt     $s1, $a0, $a1     # set s1 to 1 if num is less than den
                                  # branch if num is less than den
        bne     $s1, $zero, num_is_less_than_den
        sub     $a0, $a0, $a1     # subtract the denominator from the numerator
        addi    $s2, $s2, 1       # add one to the count of times subtracted
        j       while_num_gt_den  # go back to the top of while loop


num_is_less_than_den:             # numerator is less than denominator
        move    $t9, $s2          # move the arg int into the final int reg
        move    $s4, $a0          # save the numerator
        move    $s5, $a1          # save the denominator
                                  # don't calculate gcd if num is 0
        beq     $s4, $zero, num_is_zero
        jal     find_gcd          # run find_gcd to find the gcd
        div     $s4, $v0          # divide num by gcd
        mflo    $s4               # put the result of the div in t1
        div     $s5, $v0          # divide den by gcd
        mflo    $s5               # put the result of the div in t2

num_is_zero:
        move    $v0, $s4          # put the final num in its return location
        move    $v1, $s5          # put the final den in its return location
        


# ###### END STUDENT CODE BLOCK 1 ######
# ######################################

simplify_done:
        lw      $ra, 32($sp)    # restore the ra & s reg's from the stack
        lw      $s7, 28($sp)
        lw      $s6, 24($sp)
        lw      $s5, 20($sp)
        lw      $s4, 16($sp)
        lw      $s3, 12($sp)
        lw      $s2, 8($sp)
        lw      $s1, 4($sp)
        lw      $s0, 0($sp)
        addi    $sp, $sp, 40      # clean up stack
	jr	$ra

#
# Name:		find_gcd 
#
# Description:	computes the GCD of the two inputed numbers
# Arguments:  	a0	The first number
#		a1	The second number
# Returns: 	v0	The GCD of a0 and a1.
#

find_gcd:
        addi	$sp, $sp, -40	# allocate stackframe (doubleword aligned)
        sw      $ra, 32($sp)    # store the ra & s reg's on the stack
        sw      $s7, 28($sp)
        sw      $s6, 24($sp)
        sw      $s5, 20($sp)
        sw      $s4, 16($sp)
        sw      $s3, 12($sp)
        sw      $s2, 8($sp)
        sw      $s1, 4($sp)
        sw      $s0, 0($sp)

# ######################################
# ##### BEGIN STUDENT CODE BLOCK 2 #####

while_gcd:
        beq     $a0, $a1, while_gcd_done     # if num1 == num2 branch
        slt     $t3, $a0, $a1                # if num1 < num2, t3 = 1
        beq     $t3, $zero, num1_gt_num2     # if num1 > num2 branch
        sub     $t1, $a1, $a0                # t1 = num2 - num1
        j       num1_lt_num2_done            # jump to end of if statement

num1_gt_num2:   
        sub     $t1, $a0, $a1                # t1 = num1 - num2

num1_lt_num2_done:
        slt     $t2, $a0, $a1                # set t2 0 if num1 > num2
        bne     $t2, $zero, while_gcd_else   # if t2 == 0 branch
        move    $a0, $t1                     # num1 = D
        j       while_gcd_if_done            # skip else condition

while_gcd_else:
        move    $a1, $t1                     # else num2 = D

while_gcd_if_done:
        j       while_gcd                    # go back to the top of the while

while_gcd_done:
        move    $v0, $a0                     # set return value to num1


# ###### END STUDENT CODE BLOCK 2 ######
# ######################################

find_gcd_done:
        lw      $ra, 32($sp)    # restore the ra & s reg's from the stack
        lw      $s7, 28($sp)
        lw      $s6, 24($sp)
        lw      $s5, 20($sp)
        lw      $s4, 16($sp)
        lw      $s3, 12($sp)
        lw      $s2, 8($sp)
        lw      $s1, 4($sp)
        lw      $s0, 0($sp)
        addi    $sp, $sp, 40      # clean up the stack
	jr	$ra

#
# Name;		print_number 
#
# Description:	This routine reads a number then a newline to stdout
# Arguments:	a0:  the number to print
# Returns:	nothing
#
print_number:

        li 	$v0, PRINT_INT
        syscall			#print a0

        la	$a0, newline
        li      $v0, PRINT_STRING
        syscall			#print a newline

        jr      $ra

#
# Name;		print_string 
#
# Description:	This routine prints out a string pointed to by a0
# Arguments:	a0:  a pointer to the string to print
# Returns:	nothing
#
print_string:

        li 	$v0, PRINT_STRING
        syscall			#print a0

        jr      $ra
