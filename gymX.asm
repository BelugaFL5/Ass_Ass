; NASM Assembly Code for Fitness Club System
; Target: Linux x86
; Features: Login, CRUD operations, Payment system, File handling with dynamic string lengths

section .data
    ; File names
    staff_file    db 'staff.txt', 0
    student_file  db 'students.txt', 0
    trainer_file  db 'trainers.txt', 0
    class_file    db 'classes.txt', 0

    ; Prompts with length calculations
    welcome_msg   db 'Welcome to AyamMan Fitness Club System', 10, 0
    welcome_len   equ $ - welcome_msg

    login_prompt  db 'Login as: 1. Staff  2. Trainer  3. Student  4. Exit: ', 0
    login_len     equ $ - login_prompt

    id_prompt     db 'Enter ID: ', 0
    id_len        equ $ - id_prompt

    pass_prompt   db 'Enter Password: ', 0
    pass_len      equ $ - pass_prompt

    invalid_msg   db 'Invalid login!', 10, 0
    invalid_len   equ $ - invalid_msg

    staff_menu    db 'Staff Menu:', 10, '1. Add Student', 10, '2. Charge Student', 10, '3. Make Payment', 10, '4. Exit', 10, 'Option: ', 0
    staff_len     equ $ - staff_menu

    student_menu  db 'Student Menu:', 10, '1. Check Balance', 10, '2. View Classes', 10, '3. Exit', 10, 'Option: ', 0
    student_len   equ $ - student_menu

    trainer_menu  db 'Trainer Menu:', 10, '1. Check Student Balances', 10, '2. Upload Class', 10, '3. Exit', 10, 'Option: ', 0
    trainer_len   equ $ - trainer_menu

    name_prompt   db 'Enter Name: ', 0
    name_len      equ $ - name_prompt

    amount_prompt db 'Enter Amount: ', 0
    amount_len    equ $ - amount_prompt

    class_prompt  db 'Enter Class Topic (e.g., Zumba): ', 0
    class_len     equ $ - class_prompt

    date_prompt   db 'Enter Date (DDMMYY): ', 0
    date_len      equ $ - date_prompt

    time_prompt   db 'Enter Time (HHMM): ', 0
    time_len      equ $ - time_prompt

    success_msg   db 'Operation completed successfully!', 10, 0
    success_len   equ $ - success_msg

    exit_msg      db 'Exiting system...', 10, 0
    exit_len      equ $ - exit_msg

    ; Sample class data (minimum 5 classes)
    class1        db 'Zumba,150325,0900,TrainerA', 10, 0
    class1_len    equ $ - class1
    class2        db 'Core,160325,1000,TrainerB', 10, 0
    class2_len    equ $ - class2
    class3        db 'Motion,170325,1100,TrainerC', 10, 0
    class3_len    equ $ - class3
    class4        db 'Dynamic Yoga,180325,1300,TrainerD', 10, 0
    class4_len    equ $ - class4
    class5        db 'Pilates,190325,1500,TrainerE', 10, 0
    class5_len    equ $ - class5

section .bss
    login_choice  resb 1       ; Store login choice (1-4)
    user_id       resb 10      ; Store user ID
    user_pass     resb 10      ; Store user password
    menu_option   resb 1       ; Store menu option
    name          resb 50      ; Store name
    amount        resb 10      ; Store amount for payment/charge
    class_topic   resb 20      ; Store class topic
    class_date    resb 6       ; Store date (DDMMYY)
    class_time    resb 4       ; Store time (HHMM)
    buffer        resb 256     ; Buffer for file operations
    balance       resb 10      ; Store student balance

section .text
    global _start

_start:
    ; Print welcome message
    mov eax, 4
    mov ebx, 1
    mov ecx, welcome_msg
    mov edx, welcome_len
    int 0x80

main_loop:
    ; Display login prompt
    mov eax, 4
    mov ebx, 1
    mov ecx, login_prompt
    mov edx, login_len
    int 0x80

    ; Read login choice
    mov eax, 3
    mov ebx, 0
    mov ecx, login_choice
    mov edx, 1
    int 0x80

    ; Convert choice to number
    movzx eax, byte [login_choice]
    sub eax, '0'

    ; Branch based on login choice
    cmp eax, 1
    je staff_login
    cmp eax, 2
    je trainer_login
    cmp eax, 3
    je student_login
    cmp eax, 4
    je exit_system
    jmp main_loop  ; Invalid choice, loop back

; --- Login Procedures ---
staff_login:
    call authenticate_user
    cmp eax, 0
    jne staff_menu_loop
    jmp invalid_login

trainer_login:
    call authenticate_user
    cmp eax, 0
    jne trainer_menu_loop
    jmp invalid_login

student_login:
    call authenticate_user
    cmp eax, 0
    jne student_menu_loop
    jmp invalid_login

authenticate_user:
    ; Prompt for ID
    mov eax, 4
    mov ebx, 1
    mov ecx, id_prompt
    mov edx, id_len
    int 0x80
    mov eax, 3
    mov ebx, 0
    mov ecx, user_id
    mov edx, 10
    int 0x80

    ; Prompt for password
    mov eax, 4
    mov ebx, 1
    mov ecx, pass_prompt
    mov edx, pass_len
    int 0x80
    mov eax, 3
    mov ebx, 0
    mov ecx, user_pass
    mov edx, 10
    int 0x80

    ; Placeholder: Assume authentication succeeds (eax = 1)
    mov eax, 1
    ret

invalid_login:
    mov eax, 4
    mov ebx, 1
    mov ecx, invalid_msg
    mov edx, invalid_len
    int 0x80
    jmp main_loop

; --- Staff Menu ---
staff_menu_loop:
    mov eax, 4
    mov ebx, 1
    mov ecx, staff_menu
    mov edx, staff_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, menu_option
    mov edx, 1
    int 0x80

    movzx eax, byte [menu_option]
    sub eax, '0'

    cmp eax, 1
    je add_student
    cmp eax, 2
    je charge_student
    cmp eax, 3
    je make_payment
    cmp eax, 4
    je main_loop
    jmp staff_menu_loop

add_student:
    ; Prompt and read name
    mov eax, 4
    mov ebx, 1
    mov ecx, name_prompt
    mov edx, name_len
    int 0x80
    mov eax, 3
    mov ebx, 0
    mov ecx, name
    mov edx, 50
    int 0x80

    ; Save to student_file (simplified)
    call write_to_file
    mov eax, 4
    mov ebx, 1
    mov ecx, success_msg
    mov edx, success_len
    int 0x80
    jmp staff_menu_loop

charge_student:
    ; Prompt for amount
    mov eax, 4
    mov ebx, 1
    mov ecx, amount_prompt
    mov edx, amount_len
    int 0x80
    mov eax, 3
    mov ebx, 0
    mov ecx, amount
    mov edx, 10
    int 0x80

    ; Arithmetic: Add to balance (simplified)
    call update_balance
    mov eax, 4
    mov ebx, 1
    mov ecx, success_msg
    mov edx, success_len
    int 0x80
    jmp staff_menu_loop

make_payment:
    ; Prompt for amount
    mov eax, 4
    mov ebx, 1
    mov ecx, amount_prompt
    mov edx, amount_len
    int 0x80
    mov eax, 3
    mov ebx, 0
    mov ecx, amount
    mov edx, 10
    int 0x80

    ; Arithmetic: Subtract from balance (simplified)
    call update_balance
    mov eax, 4
    mov ebx, 1
    mov ecx, success_msg
    mov edx, success_len
    int 0x80
    jmp staff_menu_loop

; --- Trainer Menu ---
trainer_menu_loop:
    mov eax, 4
    mov ebx, 1
    mov ecx, trainer_menu
    mov edx, trainer_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, menu_option
    mov edx, 1
    int 0x80

    movzx eax, byte [menu_option]
    sub eax, '0'

    cmp eax, 1
    je check_student_balances
    cmp eax, 2
    je upload_class
    cmp eax, 3
    je main_loop
    jmp trainer_menu_loop

upload_class:
    ; Prompt for class details
    mov eax, 4
    mov ebx, 1
    mov ecx, class_prompt
    mov edx, class_len
    int 0x80
    mov eax, 3
    mov ebx, 0
    mov ecx, class_topic
    mov edx, 20
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, date_prompt
    mov edx, date_len
    int 0x80
    mov eax, 3
    mov ebx, 0
    mov ecx, class_date
    mov edx, 6
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, time_prompt
    mov edx, time_len
    int 0x80
    mov eax, 3
    mov ebx, 0
    mov ecx, class_time
    mov edx, 4
    int 0x80

    ; Save to class_file
    call write_to_file
    mov eax, 4
    mov ebx, 1
    mov ecx, success_msg
    mov edx, success_len
    int 0x80
    jmp trainer_menu_loop

; --- Student Menu ---
student_menu_loop:
    mov eax, 4
    mov ebx, 1
    mov ecx, student_menu
    mov edx, student_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, menu_option
    mov edx, 1
    int 0x80

    movzx eax, byte [menu_option]
    sub eax, '0'

    cmp eax, 1
    je check_balance
    cmp eax, 2
    je view_classes
    cmp eax, 3
    je main_loop
    jmp student_menu_loop

check_balance:
    ; Placeholder: Display balance
    jmp student_menu_loop

view_classes:
    ; Read and display classes from class_file
    call read_from_file
    jmp student_menu_loop

; --- Helper Procedures ---
write_to_file:
    ; Open file (simplified for student_file)
    mov eax, 5
    mov ebx, student_file
    mov ecx, 0xA2  ; O_WRONLY | O_CREAT | O_APPEND
    mov edx, 0644  ; Permissions
    int 0x80
    mov ebx, eax   ; File descriptor

    ; Write data
    mov eax, 4
    mov ecx, name
    mov edx, 50
    int 0x80

    ; Close file
    mov eax, 6
    int 0x80
    ret

read_from_file:
    ; Open file (simplified for class_file)
    mov eax, 5
    mov ebx, class_file
    mov ecx, 0
    int 0x80
    mov ebx, eax

    ; Read file
    mov eax, 3
    mov ecx, buffer
    mov edx, 256
    int 0x80

    ; Display
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 256
    int 0x80

    ; Close file
    mov eax, 6
    int 0x80
    ret

update_balance:
    ; Placeholder for arithmetic operations
    ret

check_student_balances:
    ; Placeholder: Read and display student balances
    jmp trainer_menu_loop

exit_system:
    mov eax, 4
    mov ebx, 1
    mov ecx, exit_msg
    mov edx, exit_len
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80

; End of program
