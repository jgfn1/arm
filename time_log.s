/*Question description:
	Use a loop of 10 iterations to append the current time to
	file time_log/time.log.
*/

.bss	/*unitialized variables section */
.data	
	pathname:	.asciz "/your_path/time_logs/time.log"
	/*your_path needs to be replaced by the path from your
	home folder to your working directory.*/

.text
		.global _start

_start:
	nop

open_file:
	ldr r0, =pathname 	/*passing folder path as an argument to open*/
	mov r1, #0201		/*flag for append*/
	ldr r2, =384 		/*RW permission argument*/
	mov r7, #5 			/*sys_open syscall no. on r7.*/
	svc 0				/*syscall*/

	mov r5, r0 			@stores the file descriptor on r5

mov r6, #10
loop:
	@gets system time, which is saved in r0
	_time0:

		mov r7, #13
		eor r0, r0
		eor r1, r1
		svc 0

	@write:
	sub sp, #8			@release some space in the stack
	str r0, [sp]		@puts systime(r0) in the stack
	mov r0, r5 			@file descriptor restored to r0
	mov r1, sp 			@stack pointer is passed as an argument
	mov r2, #8			@number of bytes to be written on file
	mov r7, #4 			@write code	
	svc #0

add r6, #-1 			@decrements the loop counter
cmp r6, #0				@checks if it reached 0
bne loop
 close_file:
 	mov r7, #6 			@6 is close syscall
 	svc #0
	
exit:
	mov r7, #1 			/*exit code*/
	mov r0, #0			/*returns 0 to the OS*/
	svc #0
