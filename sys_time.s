.bss
.data
	format: .asciz "%lu\n"
	time: .zero 8
.text
	.global _start

.extern printf

_start:
	nop
	ldr r9, =time

	bl _time0
	mov r1, r0
	bl write

exit:
	mov r7, #1
	svc #0

write:
	push {r1-r3, lr}
	ldr r0, =format
	bl printf
	pop {r1-r3, pc}

_time0:
	push {r1-r3, lr}
	mov r7, #13
	eor r0, r0
	svc 0
	pop {r1-r3, pc}
