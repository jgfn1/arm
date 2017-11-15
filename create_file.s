/*Question description:
	Without changing directories, create
	a file called time.log within the
	time_logs directory using RW permission
	600 as converted to int 384.
*/

.bss	/*unitialized variables section */
.data	
	pathname:	.asciz "/your_desired_path/time_logs/time.log"
	/*your_desired_path needs to be replaced by the path from your
	home folder to your working directory.*/

.text
		.global _start

_start:
	nop
	
create_file:
	ldr r0, =pathname 	/*passing folder name as an argument to open*/
	mov r1, #0101		/*flag for O_CREAT, create file, if it does not exist*/
	ldr r2, =384 		/*RW permission argument*/
	mov r7, #5 			/*sys_open syscall no. on r7.*/
	svc 0				/*syscal*/
	
exit:
	mov r7, #1 			/*exit code*/
	mov r0, #0			/*returns 0 to the OS*/
	svc #0
