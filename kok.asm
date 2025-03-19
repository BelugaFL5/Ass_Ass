section .data
    ; ASCII Art for welcome screen
    ascii_art     db "    _                         __  __                                          ", 10
                  db "   / \  _   _  __ _ _ __ ___ |  \/  | __ _ _ __                               ", 10
                  db "  / _ \| | | |/ _ | '_  _ \| |\/| |/ _ | '_ \                              ", 10
                  db " / ___ \ |_| | (_| | | | | | | |  | | (_| | | | |                             ", 10
                  db "/_/   \_\__, |\__,_|_| |_| |_|_|  |_|\__,_|_| |_|                             ", 10
                  db " _____ _|___/___ _   _ _____ ____ ____     ____ _____ _   _ _____ ____  _____ ", 10
                  db "|  ___|_ _|_   _| \ | | ____/ ___/ ___|   / ___| ____| \ | |_   _|  _ \| ____|", 10
                  db "| |_   | |  | | |  \| |  _| \___ \___ \  | |   |  _| |  \| | | | | |_) |  _|  ", 10
                  db "|  _|  | |  | | | |\  | |___ ___) |__) | | |___| |___| |\  | | | |  _ <| |___ ", 10
                  db "|_|   |___| |_| |_| \_|_____|____/____/   \____|_____|_| \_| |_| |_| \_\_____|", 10, 0
    ascii_len     equ $ - ascii_art

    ; File names
    staff_file    db 'staff.txt', 0
    student_file  db 'students.txt', 0
    trainer_file  db 'trainers.txt', 0
    class_file    db 'classes.txt', 0

    ; Common delimiters
    comma         db ',', 0
    newline       db 10, 0

    ; Prompts with length calculations
    welcome_msg   db 'Welcome to AyamMan Fitness Club System', 10, 0
    welcome_len   equ $ - welcome_msg

    login_prompt  db 'Login as: 1. Staff  2. Trainer  3. Student  4. Exit: ', 0
    login_len     equ $ - login_prompt

    id_prompt     db 'Enter ID: ', 0
    id_len        equ $ - id_prompt

    pass_prompt   db 'Enter Password: ', 0
    pass_len      equ $ - pass_prompt

    invalid_msg   db 'Wrong ID and Password!', 10, 0
    invalid_len   equ $ - invalid_msg

    staff_menu    db 'Staff Menu:', 10, '1. Manage Student', 10, '2. Manage Trainer', 10, '3. Charge Student', 10, '4. Make Payment', 10, '5. Log Out', 10, 'Option: ', 0
    staff_len     equ $ - staff_menu

    manage_student_menu db 'Manage Student:', 10, '1. Add Student', 10, '2. Delete Student', 10, '3. Back', 10, 'Option: ', 0
    manage_student_len  equ $ - manage_student_menu

    manage_trainer_menu db 'Manage Trainer:', 10, '1. Add Trainer', 10, '2. Delete Trainer', 10, '3. Back', 10, 'Option: ', 0
    manage_trainer_len  equ $ - manage_trainer_menu

    student_menu  db 'Student Menu:', 10, '1. Check Balance', 10, '2. View Classes', 10, '3. Log Out', 10, 'Option: ', 0
    student_len   equ $ - student_menu

    trainer_menu  db 'Trainer Menu:', 10, '1. Check Student Balances', 10, '2. Upload Class', 10, '3. Log Out', 10, 'Option: ', 0
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

    trainer_prompt db 'Enter Trainer Name: ', 0
    trainer_prompt_len equ $ - trainer_prompt

    success_msg   db 'Operation completed successfully!', 10, 0
    success_len   equ $ - success_msg

    exit_msg      db 'Exiting system...', 10, 0
    exit_len      equ $ - exit_msg

    balance_msg   db 'Your balance: ', 0
    balance_len   equ $ - balance_msg

    error_msg     db 'Error: Invalid input!', 10, 0
    error_len     equ $ - error_msg

    ; Pre-populated classes (to meet the requirement of at least 5 classes)
    class1        db 'Zumba,010125,0900,Trainer1', 10, 0
    class2        db 'Core,020125,1000,Trainer2', 10, 0
    class3        db 'Motion,030125,1100,Trainer3', 10, 0
    class4        db 'Dynamic Yoga,040125,1200,Trainer4', 10, 0
    class5        db 'Cardio,050125,1300,Trainer5', 10, 0

section .bss
    login_choice  resb 2       ; Store login choice (1-4) + newline
    user_id       resb 11      ; Store user ID + newline
    user_pass     resb 11      ; Store user password + newline
    menu_option   resb 2       ; Store menu option + newline
    name          resb 51      ; Store name + newline
    amount        resb 11      ; Store amount for payment/charge + newline
    class_topic   resb 21      ; Store class topic + newline
    class_date    resb 7       ; Store date (DDMMYY) + newline
    class_time    resb 5       ; Store time (HHMM) + newline
    trainer_name  resb 21      ; Store trainer name + newline
    buffer        resb 256     ; Buffer for file operations
    balance       resb 11      ; Store student balance + newline
    file_handle   resd 1       ; Store file descriptor

section .text
    global _start

_start:
    ; Print ASCII art
    mov eax, 4
    mov ebx, 1
    mov ecx, ascii_art
    mov edx, ascii_len
    int 0x80

    ; Print welcome message
    mov eax, 4
    mov ebx, 1
    mov ecx, welcome_msg
    mov edx, welcome_len
    int 0x80

    ; Initialize class file with 5 classes if it doesn't exist
    call init_class_file

main_loop:
    mov eax, 4
    mov ebx, 1
    mov ecx, login_prompt
    mov edx, login_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, login_choice
    mov edx, 2
    int 0x80

    movzx eax, byte [login_choice]
    sub eax, '0'

    cmp eax, 1
    je staff_login
    cmp eax, 2
    je trainer_login
    cmp eax, 3
    je student_login
    cmp eax, 4
    je exit_system
    jmp main_loop

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
    mov eax, 4
    mov ebx, 1
    mov ecx, id_prompt
    mov edx, id_len
    int 0x80
    mov eax, 3
    mov ebx, 0
    mov ecx, user_id
    mov edx, 11
    int 0x80

    ; Remove newline from user_id
    call strip_newline
    mov edi, user_id

    mov eax, 4
    mov ebx, 1
    mov ecx, pass_prompt
    mov edx, pass_len
    int 0x80
    mov eax, 3
    mov ebx, 0
    mov ecx, user_pass
    mov edx, 11
    int 0x80

    ; Remove newline from user_pass
    mov edi, user_pass
    call strip_newline

    ; Placeholder: Assume success for now
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
    mov edx, 2
    int 0x80

    movzx eax, byte [menu_option]
    sub eax, '0'

    cmp eax, 1
    je manage_student
    cmp eax, 2
    je manage_trainer
    cmp eax, 3
    je charge_student
    cmp eax, 4
    je make_payment
    cmp eax, 5
    je main_loop
    jmp staff_menu_loop

manage_student:
    mov eax, 4
    mov ebx, 1
    mov ecx, manage_student_menu
    mov edx, manage_student_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, menu_option
    mov edx, 2
    int 0x80

    movzx eax, byte [menu_option]
    sub eax, '0'

    cmp eax, 1
    je add_student
    cmp eax, 2
    je delete_student
    cmp eax, 3
    je staff_menu_loop
    jmp manage_student

add_student:
    mov eax, 4
    mov ebx, 1
    mov ecx, id_prompt
    mov edx, id_len
    int 0x80
    mov eax, 3
    mov ebx, 0
    mov ecx, user_id
    mov edx, 11
    int 0x80
    mov edi, user_id
    call strip_newline

    mov eax, 4
    mov ebx, 1
    mov ecx, name_prompt
    mov edx, name_len
    int 0x80
    mov eax, 3
    mov ebx, 0
    mov ecx, name
    mov edx, 51
    int 0x80
    mov edi, name
    call strip_newline

    ; Initialize balance to 0
    mov byte [balance], '0'
    mov byte [balance + 1], 0
    call write_student_to_file
    mov eax, 4
    mov ebx, 1
    mov ecx, success_msg
    mov edx, success_len
    int 0x80
    jmp manage_student

delete_student:
    ; Placeholder for delete student
    mov eax, 4
    mov ebx, 1
    mov ecx, success_msg
    mov edx, success_len
    int 0x80
    jmp manage_student

manage_trainer:
    mov eax, 4
    mov ebx, 1
    mov ecx, manage_trainer_menu
    mov edx, manage_trainer_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, menu_option
    mov edx, 2
    int 0x80

    movzx eax, byte [menu_option]
    sub eax, '0'

    cmp eax, 1
    je add_trainer
    cmp eax, 2
    je delete_trainer
    cmp eax, 3
    je staff_menu_loop
    jmp manage_trainer

add_trainer:
    mov eax, 4
    mov ebx, 1
    mov ecx, id_prompt
    mov edx, id_len
    int 0x80
    mov eax, 3
    mov ebx, 0
    mov ecx, user_id
    mov edx, 11
    int 0x80
    mov edi, user_id
    call strip_newline

    mov eax, 4
    mov ebx, 1
    mov ecx, name_prompt
    mov edx, name_len
    int 0x80
    mov eax, 3
    mov ebx, 0
    mov ecx, name
    mov edx, 51
    int 0x80
    mov edi, name
    call strip_newline

    call write_trainer_to_file
    mov eax, 4
    mov ebx, 1
    mov ecx, success_msg
    mov edx, success_len
    int 0x80
    jmp manage_trainer

delete_trainer:
    ; Placeholder for delete trainer
    mov eax, 4
    mov ebx, 1
    mov ecx, success_msg
    mov edx, success_len
    int 0x80
    jmp manage_trainer

charge_student:
    mov eax, 4
    mov ebx, 1
    mov ecx, id_prompt
    mov edx, id_len
    int 0x80
    mov eax, 3
    mov ebx, 0
    mov ecx, user_id
    mov edx, 11
    int 0x80
    mov edi, user_id
    call strip_newline

    mov eax, 4
    mov ebx, 1
    mov ecx, amount_prompt
    mov edx, amount_len
    int 0x80
    mov eax, 3
    mov ebx, 0
    mov ecx, amount
    mov edx, 11
    int 0x80
    mov edi, amount
    call strip_newline

    call update_balance_add
    mov eax, 4
    mov ebx, 1
    mov ecx, success_msg
    mov edx, success_len
    int 0x80
    jmp staff_menu_loop

make_payment:
    mov eax, 4
    mov ebx, 1
    mov ecx, id_prompt
    mov edx, id_len
    int 0x80
    mov eax, 3
    mov ebx, 0
    mov ecx, user_id
    mov edx, 11
    int 0x80
    mov edi, user_id
    call strip_newline

    mov eax, 4
    mov ebx, 1
    mov ecx, amount_prompt
    mov edx, amount_len
    int 0x80
    mov eax, 3
    mov ebx, 0
    mov ecx, amount
    mov edx, 11
    int 0x80
    mov edi, amount
    call strip_newline

    call update_balance_sub
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
    mov edx, 2
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
    mov eax, 4
    mov ebx, 1
    mov ecx, class_prompt
    mov edx, class_len
    int 0x80
    mov eax, 3
    mov ebx, 0
    mov ecx, class_topic
    mov edx, 21
    int 0x80
    mov edi, class_topic
    call strip_newline

    mov eax, 4
    mov ebx, 1
    mov ecx, date_prompt
    mov edx, date_len
    int 0x80
    mov eax, 3
    mov ebx, 0
    mov ecx, class_date
    mov edx, 7
    int 0x80
    mov edi, class_date
    call strip_newline

    mov eax, 4
    mov ebx, 1
    mov ecx, time_prompt
    mov edx, time_len
    int 0x80
    mov eax, 3
    mov ebx, 0
    mov ecx, class_time
    mov edx, 5
    int 0x80
    mov edi, class_time
    call strip_newline

    mov eax, 4
    mov ebx, 1
    mov ecx, trainer_prompt
    mov edx, trainer_prompt_len
    int 0x80
    mov eax, 3
    mov ebx, 0
    mov ecx, trainer_name
    mov edx, 21
    int 0x80
    mov edi, trainer_name
    call strip_newline

    call write_class_to_file
    mov eax, 4
    mov ebx, 1
    mov ecx, success_msg
    mov edx, success_len
    int 0x80
    jmp trainer_menu_loop

check_student_balances:
    mov eax, 5
    mov ebx, student_file
    mov ecx, 0
    int 0x80
    cmp eax, -1
    je file_error
    mov [file_handle], eax

    read_loop:
        mov eax, 3
        mov ebx, [file_handle]
        mov ecx, buffer
        mov edx, 256
        int 0x80
        cmp eax, 0
        jle end_read

        mov edx, eax
        mov eax, 4
        mov ebx, 1
        mov ecx, buffer
        int 0x80
        jmp read_loop

    end_read:
    mov eax, 6
    mov ebx, [file_handle]
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
    mov edx, 2
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
    call read_student_balance
    mov eax, 4
    mov ebx, 1
    mov ecx, balance_msg
    mov edx, balance_len
    int 0x80
    mov eax, 4
    mov ebx, 1
    mov ecx, balance
    mov edx, 11
    int 0x80
    jmp student_menu_loop

view_classes:
    mov eax, 5
    mov ebx, class_file
    mov ecx, 0
    int 0x80
    cmp eax, -1
    je file_error
    mov [file_handle], eax

    class_read_loop:
        mov eax, 3
        mov ebx, [file_handle]
        mov ecx, buffer
        mov edx, 256
        int 0x80
        cmp eax, 0
        jle end_class_read

        mov edx, eax
        mov eax, 4
        mov ebx, 1
        mov ecx, buffer
        int 0x80
        jmp class_read_loop

    end_class_read:
    mov eax, 6
    mov ebx, [file_handle]
    int 0x80
    jmp student_menu_loop

; --- Helper Procedures ---
init_class_file:
    mov eax, 5
    mov ebx, class_file
    mov ecx, 0xA2  ; O_WRONLY | O_CREAT | O_APPEND
    mov edx, 0644
    int 0x80
    cmp eax, -1
    je file_error
    mov [file_handle], eax

    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, class1
    mov edx, 25
    int 0x80

    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, class2
    mov edx, 24
    int 0x80

    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, class3
    mov edx, 25
    int 0x80

    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, class4
    mov edx, 31
    int 0x80

    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, class5
    mov edx, 25
    int 0x80

    mov eax, 6
    mov ebx, [file_handle]
    int 0x80
    ret

write_student_to_file:
    mov eax, 5
    mov ebx, student_file
    mov ecx, 0xA2  ; O_WRONLY | O_CREAT | O_APPEND
    mov edx, 0644
    int 0x80
    cmp eax, -1
    je file_error
    mov [file_handle], eax

    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, user_id
    mov edx, 10
    int 0x80

    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, comma
    mov edx, 1
    int 0x80

    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, name
    mov edx, 50
    int 0x80

    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, comma
    mov edx, 1
    int 0x80

    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, balance
    mov edx, 2
    int 0x80

    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov eax, 6
    mov ebx, [file_handle]
    int 0x80
    ret

write_trainer_to_file:
    mov eax, 5
    mov ebx, trainer_file
    mov ecx, 0xA2
    mov edx, 0644
    int 0x80
    cmp eax, -1
    je file_error
    mov [file_handle], eax

    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, user_id
    mov edx, 10
    int 0x80

    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, comma
    mov edx, 1
    int 0x80

    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, name
    mov edx, 50
    int 0x80

    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov eax, 6
    mov ebx, [file_handle]
    int 0x80
    ret

write_class_to_file:
    mov eax, 5
    mov ebx, class_file
    mov ecx, 0xA2
    mov edx, 0644
    int 0x80
    cmp eax, -1
    je file_error
    mov [file_handle], eax

    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, class_topic
    mov edx, 20
    int 0x80

    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, comma
    mov edx, 1
    int 0x80

    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, class_date
    mov edx, 6
    int 0x80

    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, comma
    mov edx, 1
    int 0x80

    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, class_time
    mov edx, 4
    int 0x80

    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, comma
    mov edx, 1
    int 0x80

    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, trainer_name
    mov edx, 20
    int 0x80

    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov eax, 6
    mov ebx, [file_handle]
    int 0x80
    ret

read_student_balance:
    mov eax, 5
    mov ebx, student_file
    mov ecx, 0
    int 0x80
    cmp eax, -1
    je file_error
    mov [file_handle], eax

    ; Placeholder: Read balance for user_id
    mov byte [balance], '0'
    mov byte [balance + 1], 0

    mov eax, 6
    mov ebx, [file_handle]
    int 0x80
    ret

update_balance_add:
    ; Placeholder: Add amount to balance
    ret

update_balance_sub:
    ; Placeholder: Subtract amount from balance
    ret

strip_newline:
    mov esi, edi
    find_newline:
        lodsb
        cmp al, 10
        je replace_newline
        cmp al, 0
        jne find_newline
    replace_newline:
        mov byte [esi - 1], 0
    ret

file_error:
    mov eax, 4
    mov ebx, 1
    mov ecx, error_msg
    mov edx, error_len
    int 0x80
    ret

exit_system:
    mov eax, 4
    mov ebx, 1
    mov ecx, exit_msg
    mov edx, exit_len
    int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80
