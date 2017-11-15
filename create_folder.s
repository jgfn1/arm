/*Question description:
Create a new directory called time_logs. Make sure to use octal
RWX permission 700 as converted to int 448.
*/

.bss	/*unitialized variables section*/
.data	
	folder_name: .asciz "time_logs"
.text
		.global _start

_start:
	nop

create_folder:
	ldr r0, =folder_name /*passing folder name as an
	argument to mkdir*/
	mov r7, #39 /*mkdir syscall no. on r7.
	r7 is the default reg used to determine the syscall no.*/
	svc 0	/*requests permission and makes the syscall,
	the 0 value is the default parameter for linux*/

change_permissions:
	mov r1, #448 	/*permissions passed as an argument 
	through reg 1*/
	ldr r0, =folder_name /*folder name passed as an argument*/
	/*the order of the arguments needs to be inverted*/
	mov r7, #15 /*chmod syscall*/
	svc 0 /*syscall*/
	
exit:
	mov r7, #1 	/*exit code*/
	mov r0, #0	/*returns 0 to the OS*/
	svc #0		/*system call instruction*/
