; AyamMan Fitness Club System
; NASM x86 Assembly for Linux
; Combines staff, student, trainer features with loops, jumps, arithmetic

section .data
    ; General Messages
    welcome_msg db "==============================", 10, 0
    welcome_msg2 db "  WELCOME TO THE FITNESS CLUB  ", 10, 0
    welcome_msg3 db "==============================", 10, 0
    role_prompt db "1: Staff | 2: Student | 3: Trainer | 0: Exit", 10, 0
    role_prompt_len equ $ - role_prompt
    invalid_msg db "Invalid choice, try again.", 10, 0
    exit_msg db "==============================", 10, "   THANK YOU FOR USING AYAMMAN   ", 10, "==============================", 10, "Exiting system... Goodbye!", 10, 0

    ; Sign-In Messages
    login_prompt db "Enter password (123 for demo): ", 0
    login_success db "Login successful!", 10, 0
    login_fail_msg db "Login failed, retry.", 10, 0   ; Renamed to avoid label conflict

    ; Staff Messages
    staff_menu db "==============================", 10, "  WELCOME TO THE STAFF MENU  ", 10, "==============================", 10, "1. Charge  |  2. Pay  |  3. View Students  |  0. Back", 10, "==============================", 10, 0
    charge_prompt db "Enter charge amount: ", 0
    pay_prompt db "Enter payment amount: ", 0
    receipt_msg db "Receipt issued. New balance: $", 0

    ; Student Messages
    student_menu db "==============================", 10, "  WELCOME TO THE STUDENT MENU  ", 10, "==============================", 10, "1. View Balance  |  2. View Classes  |  0. Back", 10, "==============================", 10, 0
    balance_msg db "Your balance: $", 0
    class_header db "Class Schedule:", 10, 0

    ; Trainer Messages
    trainer_menu db "==============================", 10, "  WELCOME TO THE TRAINER MENU  ", 10, "==============================", 10, "1. Upload Class  |  2. View Balances  |  0. Back", 10, "==============================", 10, 0
    upload_prompt db "Enter class topic (1 char for demo): ", 0
    upload_success db "Class uploaded!", 10, 0
    balances_header db "Student Balances:", 10, 0

    ; Simulated Data
    correct_pass db "123", 0         ; Demo password
    student_balance dd 0             ; Initial balance ($0)
    class_count db 0                 ; Number of uploaded classes
    class_list db "ZCMDY"            ; Simulated classes (Zumba, Core, Motion, Dynamic Yoga)
    newline db 10, 0

section .bss
    input resb 4                     ; Buffer for user input
    temp_balance resd 1              ; Temporary balance for arithmetic
    class_input resb 2               ; Buffer for class upload

section .text
    global _start

_start:
main_loop:
    ; Display welcome message and role selection
    mov eax, 4
    mov ebx, 1
    mov ecx, welcome_msg
    mov edx, 30
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, welcome_msg2
    mov edx, 27
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, welcome_msg3
    mov edx, 30
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, role_prompt
    mov edx, role_prompt_len
    int 0x80

    ; Read user choice
    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 4
    int 0x80

    ; Role selection with jumps
    cmp byte [input], '0'
    je exit_system
    cmp byte [input], '1'
    je staff_login
    cmp byte [input], '2'
    je student_login
    cmp byte [input], '3'
    je trainer_login
    jmp invalid_choice

staff_login:
    call sign_in
    cmp eax, 1
    je staff_menu_main
    jmp main_loop

student_login:
    call sign_in
    cmp eax, 1
    je student_menu_main
    jmp main_loop

trainer_login:
    call sign_in
    cmp eax, 1
    je trainer_menu_main
    jmp main_loop

invalid_choice:
    mov eax, 4
    mov ebx, 1
    mov ecx, invalid_msg
    mov edx, 23
    int 0x80
    jmp main_loop

; Sign-In Routine
sign_in:
    mov eax, 4
    mov ecx, login_prompt
    mov edx, 25
    int 0x80

    mov eax, 3
    mov ecx, input
    mov edx, 4
    int 0x80

    ; Simplified comparison (first 3 chars)
    mov al, [input]
    cmp al, [correct_pass]
    jne login_fail
    mov al, [input+1]
    cmp al, [correct_pass+1]
    jne login_fail
    mov al, [input+2]
    cmp al, [correct_pass+2]
    jne login_fail

    mov eax, 4
    mov ecx, login_success
    mov edx, 15
    int 0x80
    mov eax, 1                  ; Return success
    ret

login_fail:
    mov eax, 4
    mov ecx, login_fail_msg     ; Updated label to avoid conflict
    mov edx, 18
    int 0x80
    mov eax, 0                  ; Return failure
    ret

; Staff Menu
staff_menu_main:
    ; Display staff menu with ASCII art
    mov eax, 4
    mov ebx, 1
    mov ecx, staff_menu
    mov edx, 68
    int 0x80

    ; Ask for user input
    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 4
    int 0x80

    cmp byte [input], '0'
    je main_loop
    cmp byte [input], '1'
    je staff_charge
    cmp byte [input], '2'
    je staff_pay
    cmp byte [input], '3'
    je staff_view
    jmp staff_menu_main

staff_charge:
    ; Charge student (arithmetic: add to balance)
    mov eax, 4
    mov ecx, charge_prompt
    mov edx, 18
    int 0x80

    mov eax, 3
    mov ecx, input
    mov edx, 4
    int 0x80

    mov eax, [student_balance]
    add eax, 10                 ; Assume $10 charge (simplified)
    mov [student_balance], eax
    jmp staff_menu_main

staff_pay:
    ; Process payment (arithmetic: subtract from balance)
    mov eax, 4
    mov ecx, pay_prompt
    mov edx, 19
    int 0x80

    mov eax, 3
    mov ecx, input
    mov edx, 4
    int 0x80

    mov eax, [student_balance]
    sub eax, 5                  ; Assume $5 payment (simplified)
    mov [student_balance], eax

    ; Issue receipt
    mov eax, 4
    mov ecx, receipt_msg
    mov edx, 23
    int 0x80
    call print_balance
    jmp staff_menu_main

staff_view:
    ; View student balance (simplified single student)
    call print_balance
    jmp staff_menu_main

; Student Menu
student_menu_main:
    ; Display student menu with ASCII art
    mov eax, 4
    mov ebx, 1
    mov ecx, student_menu
    mov edx, 68
    int 0x80

    ; Ask for user input
    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 4
    int 0x80

    cmp byte [input], '0'
    je main_loop
    cmp byte [input], '1'
    je student_view_balance
    cmp byte [input], '2'
    je student_view_classes
    jmp student_menu_main

student_view_balance:
    call print_balance
    jmp student_menu_main

student_view_classes:
    ; Loop to display classes
    mov eax, 4
    mov ecx, class_header
    mov edx, 15
    int 0x80

    mov ecx, 5                  ; 5 classes minimum
    mov esi, class_list         ; Pointer to class list
class_loop:
    mov eax, 4
    mov ebx, 1
    mov edx, 1
    mov ecx, esi                ; Print one char
    int 0x80
    mov eax, 4
    mov ecx, newline
    mov edx, 1
    int 0x80
    inc esi                     ; Next class
    loop class_loop             ; Decrement ECX, jump if not zero
    jmp student_menu_main

; Trainer Menu
trainer_menu_main:
    ; Display trainer menu with ASCII art
    mov eax, 4
    mov ebx, 1
    mov ecx, trainer_menu
    mov edx, 68
    int 0x80

    ; Ask for user input
    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 4
    int 0x80

    cmp byte [input], '0'
    je main_loop
    cmp byte [input], '1'
    je trainer_upload
    cmp byte [input], '2'
    je trainer_view_balances
    jmp trainer_menu_main

trainer_upload:
    ; Upload class
    mov eax, 4
    mov ecx, upload_prompt
    mov edx, 30
    int 0x80

    mov eax, 3
    mov ecx, class_input
    mov edx, 2
    int 0x80

    mov eax, 4
    mov ecx, upload_success
    mov edx, 15
    int 0x80
    inc byte [class_count]        ; Increment class counter
    jmp trainer_menu_main

trainer_view_balances:
    ; Display student balances (simplified to one student)
    mov eax, 4
    mov ecx, balances_header
    mov edx, 20
    int 0x80
    call print_balance
    jmp trainer_menu_main

; Print Balance
print_balance:
    mov eax, 4
    mov ebx, 1
    mov ecx, balance_msg
    mov edx, 14
    int 0x80
    mov eax, [student_balance]
    call print_number
    ret

; Print Integer (simplified)
print_number:
    ; Print the integer in eax
    ; Here we just display the balance as it is (further improvements needed)
    mov eax, 4
    mov ebx, 1
    mov ecx, eax                ; Print balance
    mov edx, 4
    int 0x80
    ret

exit_system:
    mov eax, 4
    mov ebx, 1
    mov ecx, exit_msg
    mov edx, 70
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
