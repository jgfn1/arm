/*

*/

.data
	_shellcmd: .string "/bin/bash"
	arg0: .string "bin/bash" 	@ args for shell command
	arg1: .string "-c"
	arg2: .string "ping -c 3 -I eth0 nhcc.edu 2> /dev/null | grep -c 'bytes from'"
	all_args:
		.word arg0
		.word arg1
		.word arg2
		.zero 4

.text
	.global _start

_start:
	 bl _syscall
	 bl exit
	nop
_syscall:
	push {lr}
	mov r7, #11	@ execv syscall; exec shell command referenced by shellcmd
	ldr r0, =_shellcmd
	ldr r1, =all_args
	mov r2, #0
	svc #0
	pop {pc}

exit:
	mov r7, #1 			/*exit code*/
	mov r0, #0			/*returns 0 to the OS*/
	svc #0
