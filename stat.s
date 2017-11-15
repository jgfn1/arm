/*Question description:
Executes the shell command "stat time_logs/time.log" which
displays the time.log file's inode number and other meta data.
*/

.bss	/*unitialized variables section*/
.data	
	file_name: .asciz "/your_path/time_logs/time.log"
	string: .asciz ""
.text
		.global _start

_start:
	nop

stat:
	ldr r0, =file_name /*file name passed*/
	/*the order of the arguments needs to be inverted*/
	mov r7, #106 /*sys_stat syscall*/
	svc 0 /*syscall*/
	
/* write syscall */
ldr r3, string
str r0, r3
ldr r1, =string /*r0*/ 
mov r0, #1 
ldr r2, =400 
mov r7, #4 
svc #0 

exit:
	mov r7, #1 	/*exit code*/
	mov r0, #0	/*returns 0 to the OS*/
	svc #0		/*system call instruction*/
