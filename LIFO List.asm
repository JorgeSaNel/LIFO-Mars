	.data
strIntroduce: .asciiz "Introduce a few numbers. Insert 0 to stop => "
strRemove: .asciiz "What number do you want to remove?: "
strList: .asciiz "The list is: "
strNotFound: .asciiz "The number was not found. The list is => "
strDashLine: .asciiz " - "
	.text
#Structure of the node	
#typedef struct _node_t {
	#int val; 
	#struct _node_t *next;
#} node_t;

main:
	#Print Introduce Number
	la $a0, strIntroduce
	li $v0, 4
	syscall

	li $s0, 0	#$s0 will have always the first node of the list
	li $s7, 0	#$s7 is how many numbers did you introduce
	
readNumber:
	#Read Number
	li $v0, 5
	syscall
	move $s1, $v0

	beqz $s1, endRead	#In case it is 0
	add $s7, $s7, 1
	
	move $a0, $s0
	move $a1, $s1
	jal push
	move $s0, $v0
	b readNumber
	
endRead:
	#Remove
	la $a0, strRemove
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	move $s1, $v0
	
	move $a0, $s0
	move $a1, $s1
	jal remove
	
	#Sort numbers in ascending order
	move $a0, $s0
	move $a1, $s7
	jal sortNumbers
	
	#Print
	move $a0, $s0
	jal print
	
	#End Program
	li $v0, 10
	syscall
#-----------------------------------------------------------------------------------------------------#
#node_t *push(node_t *top, int val):
push:
	subu $sp, $sp, 32
	sw $fp, 28($sp)
	sw $ra, 24($sp)
	addu $fp, $sp, 32
	sw $s0, 0($fp)
	sw $s1, 4($fp)
	sw $s2, 8($fp)

	
	#Move values
	move $s0, $a0	#s0 is the top
	move $s1, $a1	#s1 is the value
	
	li $a0, 8
	li $v0, 9
	syscall
	move $s2, $v0	#s2 has the address of the new node
	#Save values 
	sw $s1, 0($s2)
	sw $s0, 4($s2)

	move $v0, $s2
	
	lw $s0, 0($fp)
	lw $s1, 4($fp)
	lw $s2, 8($fp)
	lw $fp, 28($sp)
	lw $ra, 24($sp)
	addu $sp, $sp, 32
	jr $ra
#endPush
#-----------------------------------------------------------------------------------------------------#
#To sort the numbers correctly, we always asume that we found the number we want to remove
sortNumbers:
	subu $sp, $sp, 32
	sw $fp, 28($sp)
	sw $ra, 24($sp)
	addiu $fp, $sp, 32
	sw $s0, 0($fp)
	sw $s1, 4($fp)
	sw $s2, 8($fp)
	
	move $s0, $a0
	move $s7, $a1
	
	li $t7, 1
repeatProcess:
	beq $t7, $s7, free
	add $t7, $t7, 1
	
	li $t0, 2
	
	continueSort:
	beq $t0, $s7, finishSortNumbers
		add $t0, $t0, 1
		
		lw $s2, 4($s0)		
		lw $s3, 0($s2)	#s2 = list[a+1]
		lw $s1, 0($s0)	#s3 = list[a]
		
		bgt $s1, $s3, changeNumbers
			move $s0, $s2
			b continueSort
		
	changeNumbers:
		move $t1, $s1	#aux = list[a]
		move $t2, $s3
		sw $t2, 0($s0)	#list[a] = list[a+1]
		sw $t1, 0($s2)	#list[a+1] = aux
		
		move $s0, $s2
			
		b continueSort
	
	finishSortNumbers:
		move $s0, $a0
		b repeatProcess
		
	free:
	lw $s0, 0($fp)
	lw $s1, 4($fp)
	lw $s2, 8($fp)
	lw $fp, 28($sp)
	lw $ra, 24($sp)
	addu $sp, $sp, 32
	jr $ra

#endSortNumbers:
#-----------------------------------------------------------------------------------------------------#
#node_t *remove(node_t *top, int val)
remove:
	subu $sp, $sp, 32
	sw $fp, 28($sp)
	sw $ra, 24($sp)
	addiu $fp, $sp, 32
	sw $s0, 16($fp)
	sw $s1, 12($fp)
	sw $s2, 8($fp)
	sw $s3, 4($fp)
	sw $s4, 0($fp)
	
	#Save Values
	move $s0, $a0	#s0 has top value
	move $s1, $a1	#s1 is the number we want to remove
	
loop:
	lw $s2, 4($s0)		#4($s0) has the address
	beqz $s2, notFound
		lw $s3, 0($s2)	#0($s0) has the number
	beq $s1, $s3, found
		move $s0, $s2
	b loop
	
found:
	#We found the value and we have to remove it
	lw $s4, 4($s2)
	sw $s4, 4($s0)
	
	move $v0, $s2
	b endRemove
	
notFound:
	#The number is not in the list
	la $a0, strNotFound
	li $v0, 4
	syscall
	
endRemove:		
	lw $s0, 16($fp)
	lw $s1, 12($fp)
	lw $s2, 8($fp)
	lw $s3, 4($fp)
	lw $s4, 0($fp)	
	lw $fp, 28($sp)
	lw $ra, 24($sp)
	addiu $sp, $sp, 32
	jr $ra
#endRemove
#-----------------------------------------------------------------------------------------------------#
#if (top->next =! null) {
#	print(top->next); 
#}	
#printf(“%d\n”, top->val);
#return;
print:
	subu $sp, $sp, 32
	sw $fp, 28($sp)
	sw $ra, 24($sp)
	addiu $fp, $sp, 32
	sw $s0, 16($fp)
	sw $s1, 12($fp)

	move $s0, $a0
	
	lw $s1, 4($s0)
	beqz $s1, endLookNumber	#If the value is 0, means the end of the list
	
	move $a0, $s1
	jal print
	
	endLookNumber:
		lw $a0, 0($s0)
		li $v0, 1
		syscall
		
		la $a0, strDashLine
		li $v0, 4
		syscall
		
	lw $s0, 16($fp)
	lw $s1, 12($fp)
	lw $fp, 28($sp)
	lw $ra, 24($sp)
	addiu $sp, $sp, 32
	jr $ra
#endPrint


	
	










