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

	#Read Number
	li $v0, 5
	syscall

#-----------------------------------------------------------------------------------------------------#



#-----------------------------------------------------------------------------------------------------#



#-----------------------------------------------------------------------------------------------------#