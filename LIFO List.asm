#This file has three procedures:
	#Insert.- Create a node and insert the number at the end of the list untill it receives a 0
	#Remove.- Remove a number from the list
	#Print.- Print list in the order the numbers were introduced

#EXAMPLE:  Insert 1-5-8-7-9-0
#          Remove 7
#          Final list: 1-5-8-9
#-----------------------------------------------------------------------------------------------------#
	.data
strIntroduce: .asciiz "Introduce a few numbers. Insert 0 to stop => "
strRemove: .asciiz "What number do you want to remove?: "
strList: .asciiz "The list is: "
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

	#$s0 will have always the first node of the list
	li $s0, 0
	
readNumber:
	#Read Number
	li $v0, 5
	syscall
	move $s1, $v0

	beqz $s1, endRead	#In case it is 0
	
	move $a0, $s0
	move $a1, $s1
	jal push
	move $s0, $v0
	b readNumber
	
endRead:
	move $a0, $s0
	jal print
	
	#End Program
	li $v0, 10
	syscall
#-----------------------------------------------------------------------------------------------------#
push:
#¿Como crear pila correctamente?
#¿Hay que pila por cada valor que se vaya a utilizar aunque no salga de este procedimiento?
	subu $sp, $sp, 32
	sw $fp, 28($sp)
	sw $ra, 24($sp)
	sw $s0, 16($sp)
	sw $s1, 12($sp)
	sw $s2, 8($sp)
	addiu $fp, $sp, 28
	
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
	
	lw $fp, 28($sp)
	lw $ra, 24($sp)
	lw $s0, 16($sp)
	lw $s1, 12($sp)
	lw $s2, 8($sp)
	addiu $sp, $sp, 32
	jr $ra

#-----------------------------------------------------------------------------------------------------#
remove:


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
	sw $s0, 16($sp)
	sw $s1, 12($sp)
	sw $s2, 8($sp)
	sw $s3, 4($sp)
	sw $s4, 0($sp)
	addiu $fp, $sp, 28











