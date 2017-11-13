.data

msg: .ascii "Hello, ARM World!\n"
len = . - msg

.text

.global _start
_start:
/* write syscall */
mov r0, #1 
ldr r1, =msg 
ldr r2, =len 
mov r7, #4 
svc #0 

/* exit system call */
mov r0, #0 
mov r7, #1 
svc #0
