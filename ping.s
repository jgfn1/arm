/*

*/

.data
	_shellcmd: .string "/bin/bash"
	arg0: .string "bin/bash" 	@ args for shell command
	arg1: .string "-c"
	arg2: .string "ping -c 3 -I eth0 nhcc.edu 2> /dev/null | grep -c 'bytes from'"
	arg3: .zero 4
	all_args:
		.word arg0
		.word arg1
		.word arg2
		.word arg3

	msg: .zero 4
	msg1: .ascii "Hello, ARM World!\n"
	len = . - msg1
	msg2: .ascii "Hello, boring ARM World!\n"
	len2 = . - msg2

.text
	.global _start

_start:
	 bl _syscall
	 @bl _print
	 @bl _print1
	 @bl _print
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

 _print:
 	push {lr}
 	mov r5, #10
 	loop:
 	mov r0, #1 
 	ldr r1, =msg1 
 	ldr r2, =len 
 	mov r7, #4 
 	svc #0
 	sub r5, #1
 	cmp r5, #0
 	beq loop
 	pop {pc}

 _print1:
 	push {lr}
 	mov r5, #10
 	loop1:
 	mov r0, #1 
 	ldr r1, =msg2 
 	ldr r2, =len2
 	mov r7, #4 
 	svc #0
 	sub r5, #1
 	cmp r5, #0
 	beq loop1
 	pop {pc}

exit:
	mov r7, #1 			/*exit code*/
	mov r0, #0			/*returns 0 to the OS*/
	svc #0
