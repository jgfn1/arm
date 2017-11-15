/*Question description:
	Display the contents of time.log.
*/

.bss	/*unitialized variables section */
.data	
	pathname:	.asciz "/your_desired_path/time_logs/file.txt"
	/*your_desired_path needs to be replaced by the path from your
	home folder to your working directory.*/
	buffer: .asciz ""
.text
		.global _start

_start:
	nop
	
open_file:
	ldr r0, =pathname 	/*passing folder name as an argument to open*/
	mov r1, #0201		/*flag append*/
	ldr r2, =384 		/*RW permission argument*/
	mov r7, #5 			/*sys_open syscall no. on r7.*/
	svc 0				/*syscal*/

	mov r5, r0 			@stores the file descriptor on r5

read:
	mov r0, r5
	@r0 already contains the file descriptor
	@but we need to make sure it will also contain the fd
	@on each loop iteration
	ldr r1, =buffer
	mov r2, #1
	mov r7, #3 @sys_read
	svc #0
	cmp r0, #0
	beq close_file @checks if it reached the EOF

write:
	mov r0, #1 @writes in stdout
	ldr r1, =buffer
	mov r2, #1
	mov r7, #4 @sys_write
	svc #0
	b read

close_file:
 	mov r7, #6 			@6 is close syscall
 	svc #0

exit:
	mov r7, #1 			/*exit code*/
	mov r0, #0			/*returns 0 to the OS*/
	svc #0
