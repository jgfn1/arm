/*Question description:
Create a new directory called time_logs. Make sure to use octal
RWX permission 700 as converted to int 448.
*/

.bss	;unintialized variables section

.data	

.text
		.global main

main:
	nop
	bl create_folder ;branches to the create_folder routine

create_folder:
	;push {r1-r3, lr}

exit:
	mov r7, #1 	;exit code
	mov r0, #0	;returns 0 to the OS
	svc #0		;system call instruction