/*Question description:
	Include a 1 second delay within the loop for task 4.
*/

.bss	/*unitialized variables section */
.data	
	pathname:	.asciz "/your_desired_path/time_logs/delay_time.log"
	/*your_desired_path needs to be replaced by the path from your
	home folder to your working directory.*/

.text
		.global _start

_start:
	nop

open_file:
	ldr r0, =pathname 	/*passing folder name as an argument to open*/
	mov r1, #0201		/*flag to append*/
	ldr r2, =384 		/*RW permission argument*/
	mov r7, #5 			/*sys_open syscall no. on r7.*/
	svc 0				/*syscal*/

	mov r5, r0 			@stores the file descriptor on r5

mov r6, #10 			@sets the loop counter to 10
loop:
	@gets system time, which is saved in r0
	_time0:
		mov r7, #13
		eor r0, r0
		svc 0

	@write:
	sub sp, #8			@releases some space in the stack
	str r0, [sp]		@puts sys_time in the stack
	mov r0, r5 			@file descriptor restored to r0
	mov r1, sp 			@stack pointer is passed as an argument
	mov r2, #8			@number of bytes to be written on file
	mov r7, #4 			@write code	
	svc #0

	mov r4, #1 			@the delay is passed throught the stack and it will be 1s
	push {r4} 			@the delay will be 1s and 1 nanosecond
	push {r4}
	mov r0, sp 			@points r0 to the top of the stack
	mov r1, #0			
	mov r7, #162 		@nanosecond_sleep code
	svc #0

add r6, #-1
cmp r6, #0
bne loop

 close_file:
 	mov r7, #6 			@6 is close syscall
 	svc #0
	
exit:
	mov r7, #1 			/*exit code*/
	mov r0, #0			/*returns 0 to the OS*/
	svc #0
