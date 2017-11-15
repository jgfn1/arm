/*Question description:
Imposes RO permissions on time.log. What happens when you re-run
the program from task 4?
*/

.bss	/*unitialized variables section*/
.data	
	file_name: .asciz "/your_desired_path/time_logs/time.log"
.text
		.global _start

_start:
	nop

change_permissions:
	mov r1, #256 	/*RO permission passed as an argument 
	through reg 1*/
	ldr r0, =file_name /*folder name passed*/
	/*the order of the arguments needs to be inverted*/
	mov r7, #15 /*chmod syscall*/
	svc 0 /*syscall*/
	
exit:
	mov r7, #1 	/*exit code*/
	mov r0, #0	/*returns 0 to the OS*/
	svc #0		/*system call instruction*/

/*
Answer:
	When the code from task 4 is re-runed the previously saved 
	values are not altered because the process does not have 
	write permission over the file.
*/