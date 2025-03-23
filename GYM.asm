section .data
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

    staff_file    db 'staff.txt', 0
    student_file  db 'students.txt', 0
    trainer_file  db 'trainers.txt', 0
    class_file    db 'classes.txt', 0
    temp_file     db 'temp.txt', 0

    comma         db ',', 0
    newline       db 10, 0

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

    course_prompt  db 'Enter Course/Classes (e.g., C001 or Zumba): ', 0
    course_len     equ $ - course_prompt

    success_msg   db 'Operation completed successfully!', 10, 0
    success_len   equ $ - success_msg

    exit_msg      db 'Exiting system...', 10, 0
    exit_len      equ $ - exit_msg

    balance_msg   db 'Your outstanding fee: ', 0
    balance_len   equ $ - balance_msg

    file_error_msg db 'Error: File operation failed!', 10, 0
    file_error_len equ $ - file_error_msg

    empty_file_msg db 'File is empty or does not exist.', 10, 0
    empty_file_len equ $ - empty_file_msg

    student_header db '--- Student List ---', 10, 0
    student_header_len equ $ - student_header

    student_columns db 'ID,Name,Password,Courses Assigned,Outstanding Fee', 10, 0
    student_columns_len equ $ - student_columns

    separator_line db '________________________', 10, 0
    separator_line_len equ $ - separator_line

    trainer_header db '--- Trainer List ---', 10, 0
    trainer_header_len equ $ - trainer_header

    trainer_columns db 'ID,Name,Password,Classes', 10, 0
    trainer_columns_len equ $ - trainer_columns

    admin_str     db 'admin', 0

section .bss
    login_choice  resb 2
    user_id       resb 11
    user_pass     resb 11
    menu_option   resb 2
    name          resb 51
    amount        resb 11
    class_topic   resb 21
    class_date    resb 7
    class_time    resb 5
    trainer_name  resb 21
    courses_assigned resb 11
    buffer        resb 256
    outstanding_fee resb 11
    file_handle   resd 1
    temp_handle   resd 1
    temp_buffer   resb 256
    full_record   resb 256

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, ascii_art
    mov edx, ascii_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, welcome_msg
    mov edx, welcome_len
    int 0x80

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
    mov edi, user_id
    call strip_newline

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
    mov edi, user_pass
    call strip_newline

    movzx eax, byte [login_choice]
    sub eax, '0'

    cmp eax, 1
    je auth_staff
    cmp eax, 2
    je auth_trainer
    cmp eax, 3
    je auth_student
    mov eax, 0
    ret

auth_staff:
    mov esi, user_id
    mov edi, admin_str
    call strcmp
    cmp eax, 0
    jne auth_fail

    mov esi, user_pass
    mov edi, admin_str
    call strcmp
    cmp eax, 0
    jne auth_fail

    mov eax, 1
    ret

auth_trainer:
    mov eax, 5
    mov ebx, trainer_file
    mov ecx, 0
    int 0x80
    cmp eax, -1
    je file_error
    mov [file_handle], eax

auth_trainer_loop:
    call read_line
    cmp eax, 0
    je auth_trainer_fail

    mov esi, buffer
    mov edi, user_id
    call compare_field
    cmp eax, 0
    jne auth_trainer_loop

    call find_third_field
    mov edi, user_pass
    call compare_field
    cmp eax, 0
    jne auth_trainer_loop

    mov eax, 1
    jmp auth_trainer_end

auth_trainer_fail:
    mov eax, 0

auth_trainer_end:
    mov eax, 6
    mov ebx, [file_handle]
    int 0x80
    ret

auth_student:
    mov eax, 5
    mov ebx, student_file
    mov ecx, 0
    int 0x80
    cmp eax, -1
    je file_error
    mov [file_handle], eax

auth_student_loop:
    call read_line
    cmp eax, 0
    je auth_student_fail

    mov esi, buffer
    mov edi, user_id
    call compare_field
    cmp eax, 0
    jne auth_student_loop

    call find_third_field
    mov edi, user_pass
    call compare_field
    cmp eax, 0
    jne auth_student_loop

    mov eax, 1
    jmp auth_student_end

auth_student_fail:
    mov eax, 0

auth_student_end:
    mov eax, 6
    mov ebx, [file_handle]
    int 0x80
    ret

auth_fail:
    mov eax, 0
    ret

invalid_login:
    mov eax, 4
    mov ebx, 1
    mov ecx, invalid_msg
    mov edx, invalid_len
    int 0x80
    jmp main_loop

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
    mov ecx, student_header
    mov edx, student_header_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, student_columns
    mov edx, student_columns_len
    int 0x80

    mov eax, 5
    mov ebx, student_file
    mov ecx, 0
    int 0x80
    cmp eax, -1
    je file_error
    mov [file_handle], eax

display_student_loop:
    call read_line
    cmp eax, 0
    je end_display_student

    mov esi, buffer
    call strlen
    mov edx, eax
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    int 0x80
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    jmp display_student_loop

end_display_student:
    mov eax, 6
    mov ebx, [file_handle]
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, separator_line
    mov edx, separator_line_len
    int 0x80

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
    mov edi, user_pass
    call strip_newline

    mov eax, 4
    mov ebx, 1
    mov ecx, course_prompt
    mov edx, course_len
    int 0x80
    mov eax, 3
    mov ebx, 0
    mov ecx, courses_assigned
    mov edx, 11
    int 0x80
    mov edi, courses_assigned
    call strip_newline

    mov byte [outstanding_fee], '0'
    mov byte [outstanding_fee + 1], 0
    call write_student_to_file
    mov eax, 4
    mov ebx, 1
    mov ecx, success_msg
    mov edx, success_len
    int 0x80
    jmp manage_student

delete_student:
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

    call delete_from_file
    mov eax, 4
    mov ebx, 1
    mov ecx, success_msg
    mov edx, success_len
    int 0x80
    jmp manage_student

manage_trainer:
    mov eax, 4
    mov ebx, 1
    mov ecx, trainer_header
    mov edx, trainer_header_len
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, trainer_columns
    mov edx, trainer_columns_len
    int 0x80

    mov eax, 5
    mov ebx, trainer_file
    mov ecx, 0
    int 0x80
    cmp eax, -1
    je file_error
    mov [file_handle], eax

display_trainer_loop:
    call read_line
    cmp eax, 0
    je end_display_trainer

    mov esi, buffer
    call strlen
    mov edx, eax
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    int 0x80
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    jmp display_trainer_loop

end_display_trainer:
    mov eax, 6
    mov ebx, [file_handle]
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, separator_line
    mov edx, separator_line_len
    int 0x80

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
    mov edi, user_pass
    call strip_newline

    mov eax, 4
    mov ebx, 1
    mov ecx, course_prompt
    mov edx, course_len
    int 0x80
    mov eax, 3
    mov ebx, 0
    mov ecx, courses_assigned
    mov edx, 11
    int 0x80
    mov edi, courses_assigned
    call strip_newline

    call write_trainer_to_file
    mov eax, 4
    mov ebx, 1
    mov ecx, success_msg
    mov edx, success_len
    int 0x80
    jmp manage_trainer

delete_trainer:
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

    call delete_from_file_trainer
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

    call update_fee_add
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

    call update_fee_sub
    mov eax, 4
    mov ebx, 1
    mov ecx, success_msg
    mov edx, success_len
    int 0x80
    jmp staff_menu_loop

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
    call read_line
    cmp eax, 0
    je end_read_empty

    mov esi, buffer
    call strlen
    mov edx, eax
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    int 0x80
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    jmp read_loop

end_read_empty:
    mov eax, 4
    mov ebx, 1
    mov ecx, empty_file_msg
    mov edx, empty_file_len
    int 0x80

end_read:
    mov eax, 6
    mov ebx, [file_handle]
    int 0x80
    jmp trainer_menu_loop

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
    call read_student_fee
    mov eax, 4
    mov ebx, 1
    mov ecx, balance_msg
    mov edx, balance_len
    int 0x80
    mov eax, 4
    mov ebx, 1
    mov ecx, outstanding_fee
    mov edx, 11
    int 0x80
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
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
    call read_line
    cmp eax, 0
    je class_read_empty

    mov esi, buffer
    call strlen
    mov edx, eax
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    int 0x80
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80
    jmp class_read_loop

class_read_empty:
    mov eax, 4
    mov ebx, 1
    mov ecx, empty_file_msg
    mov edx, empty_file_len
    int 0x80

end_class_read:
    mov eax, 6
    mov ebx, [file_handle]
    int 0x80
    jmp student_menu_loop

write_student_to_file:
    mov eax, 5
    mov ebx, student_file
    mov ecx, 0xA2 | 0x200
    mov edx, 0644
    int 0x80
    cmp eax, -1
    je file_error
    mov [file_handle], eax

    mov esi, user_id
    call strlen
    mov edx, eax
    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, user_id
    int 0x80
    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, comma
    mov edx, 1
    int 0x80

    mov esi, name
    call strlen
    mov edx, eax
    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, name
    int 0x80
    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, comma
    mov edx, 1
    int 0x80

    mov esi, user_pass
    call strlen
    mov edx, eax
    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, user_pass
    int 0x80
    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, comma
    mov edx, 1
    int 0x80

    mov esi, courses_assigned
    call strlen
    mov edx, eax
    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, courses_assigned
    int 0x80
    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, comma
    mov edx, 1
    int 0x80

    mov esi, outstanding_fee
    call strlen
    mov edx, eax
    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, outstanding_fee
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
    mov ecx, 0xA2 | 0x200
    mov edx, 0644
    int 0x80
    cmp eax, -1
    je file_error
    mov [file_handle], eax

    mov esi, user_id
    call strlen
    mov edx, eax
    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, user_id
    int 0x80
    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, comma
    mov edx, 1
    int 0x80

    mov esi, name
    call strlen
    mov edx, eax
    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, name
    int 0x80
    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, comma
    mov edx, 1
    int 0x80

    mov esi, user_pass
    call strlen
    mov edx, eax
    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, user_pass
    int 0x80
    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, comma
    mov edx, 1
    int 0x80

    mov esi, courses_assigned
    call strlen
    mov edx, eax
    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, courses_assigned
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
    mov ecx, 0xA2 | 0x200
    mov edx, 0644
    int 0x80
    cmp eax, -1
    je file_error
    mov [file_handle], eax

    mov esi, class_topic
    call strlen
    mov edx, eax
    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, class_topic
    int 0x80
    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, comma
    mov edx, 1
    int 0x80

    mov esi, class_date
    call strlen
    mov edx, eax
    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, class_date
    int 0x80
    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, comma
    mov edx, 1
    int 0x80

    mov esi, class_time
    call strlen
    mov edx, eax
    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, class_time
    int 0x80
    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, comma
    mov edx, 1
    int 0x80

    mov esi, trainer_name
    call strlen
    mov edx, eax
    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, trainer_name
    int 0x80
    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, comma
    mov edx, 1
    int 0x80

    mov esi, amount
    call strlen
    mov edx, eax
    mov eax, 4
    mov ebx, [file_handle]
    mov ecx, amount
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

read_line:
    mov eax, 3
    mov ebx, [file_handle]
    mov ecx, buffer
    mov edx, 256
    int 0x80
    cmp eax, -1
    je file_error
    cmp eax, 0
    je read_line_end
    mov edi, buffer
    mov ecx, eax
    mov al, 10
    repne scasb
    jne read_line_no_newline
    mov byte [edi - 1], 0
    mov eax, 1
    ret
read_line_no_newline:
    mov byte [edi], 0
    mov eax, 1
    ret
read_line_end:
    mov eax, 0
    ret

compare_field:
    mov al, [esi]
    mov bl, [edi]
    cmp al, ','
    je field_end
    cmp al, 0
    je field_end
    cmp bl, 0
    je field_end
    cmp al, bl
    jne not_equal
    inc esi
    inc edi
    jmp compare_field
field_end:
    cmp bl, 0
    jne not_equal
    mov eax, 0
    ret
not_equal:
    mov eax, 1
    ret

find_third_field:
    mov esi, buffer
    call skip_field
    call skip_field
    ret

find_fifth_field:
    mov esi, buffer
    call skip_field
    call skip_field
    call skip_field
    call skip_field
    ret

skip_field:
    mov al, [esi]
    cmp al, 0
    je skip_end
    cmp al, ','
    je skip_end
    inc esi
    jmp skip_field
skip_end:
    inc esi
    ret

strcmp:
    mov al, [esi]
    mov bl, [edi]
    cmp al, bl
    jne strcmp_diff
    cmp al, 0
    je strcmp_equal
    inc esi
    inc edi
    jmp strcmp
strcmp_diff:
    mov eax, 1
    ret
strcmp_equal:
    mov eax, 0
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

strlen:
    xor eax, eax
    mov edi, esi
strlen_loop:
    mov bl, [edi]
    cmp bl, 0
    je strlen_end
    inc eax
    inc edi
    jmp strlen_loop
strlen_end:
    ret

read_student_fee:
    mov eax, 5
    mov ebx, student_file
    mov ecx, 0
    int 0x80
    cmp eax, -1
    je file_error
    mov [file_handle], eax

read_fee_loop:
    call read_line
    cmp eax, 0
    je fee_not_found

    mov esi, buffer
    mov edi, user_id
    call compare_field
    cmp eax, 0
    jne read_fee_loop

    call find_fifth_field
    mov edi, outstanding_fee
copy_fee:
    mov al, [esi]
    cmp al, 0
    je end_copy
    cmp al, ','
    je end_copy
    mov [edi], al
    inc esi
    inc edi
    jmp copy_fee
end_copy:
    mov byte [edi], 0
    jmp fee_found

fee_not_found:
    mov byte [outstanding_fee], '0'
    mov byte [outstanding_fee + 1], 0

fee_found:
    mov eax, 6
    mov ebx, [file_handle]
    int 0x80
    ret

read_student_record:
    mov eax, 5
    mov ebx, student_file
    mov ecx, 0
    int 0x80
    cmp eax, -1
    je file_error
    mov [file_handle], eax

read_record_loop:
    call read_line
    cmp eax, 0
    je record_not_found

    mov esi, buffer
    mov edi, user_id
    call compare_field
    cmp eax, 0
    jne read_record_loop

    mov esi, buffer
    mov edi, full_record
copy_record:
    mov al, [esi]
    mov [edi], al
    cmp al, 0
    je record_copied
    inc esi
    inc edi
    jmp copy_record
record_copied:
    mov esi, buffer
    call skip_field
    mov edi, name
copy_name:
    mov al, [esi]
    cmp al, ','
    je name_done
    mov [edi], al
    inc esi
    inc edi
    jmp copy_name
name_done:
    mov byte [edi], 0
    inc esi
    call skip_field
    mov edi, courses_assigned
copy_courses:
    mov al, [esi]
    cmp al, ','
    je courses_done
    mov [edi], al
    inc esi
    inc edi
    jmp copy_courses
courses_done:
    mov byte [edi], 0
    inc esi
    mov edi, outstanding_fee
copy_fee_full:
    mov al, [esi]
    cmp al, 0
    je fee_done
    mov [edi], al
    inc esi
    inc edi
    jmp copy_fee_full
fee_done:
    mov byte [edi], 0
    jmp record_found

record_not_found:
    mov byte [outstanding_fee], '0'
    mov byte [outstanding_fee + 1], 0

record_found:
    mov eax, 6
    mov ebx, [file_handle]
    int 0x80
    ret

update_fee_add:
    call read_student_record
    mov esi, outstanding_fee
    call atoi
    mov ebx, eax
    mov esi, amount
    call atoi
    add ebx, eax
    mov edi, outstanding_fee
    call itoa
    call rewrite_student_file_full
    ret

update_fee_sub:
    call read_student_record
    mov esi, outstanding_fee
    call atoi
    mov ebx, eax
    mov esi, amount
    call atoi
    sub ebx, eax
    jge fee_ok
    mov ebx, 0
fee_ok:
    mov edi, outstanding_fee
    call itoa
    call rewrite_student_file_full
    ret

rewrite_student_file_full:
    mov eax, 5
    mov ebx, temp_file
    mov ecx, 0xA2 | 0x200
    mov edx, 0644
    int 0x80
    cmp eax, -1
    je file_error
    mov [temp_handle], eax

    mov eax, 5
    mov ebx, student_file
    mov ecx, 0
    int 0x80
    cmp eax, -1
    je file_error
    mov [file_handle], eax

rewrite_loop:
    call read_line
    cmp eax, 0
    je write_updated

    mov esi, buffer
    mov edi, user_id
    call compare_field
    cmp eax, 0
    je skip_original

    mov esi, buffer
    call strlen
    mov edx, eax
    mov eax, 4
    mov ebx, [temp_handle]
    mov ecx, buffer
    int 0x80
    mov eax, 4
    mov ebx, [temp_handle]
    mov ecx, newline
    mov edx, 1
    int 0x80
    jmp rewrite_loop

skip_original:
    jmp rewrite_loop

write_updated:
    mov eax, 4
    mov ebx, [temp_handle]
    mov ecx, user_id
    mov esi, user_id
    call strlen
    mov edx, eax
    int 0x80
    mov eax, 4
    mov ebx, [temp_handle]
    mov ecx, comma
    mov edx, 1
    int 0x80
    mov eax, 4
    mov ebx, [temp_handle]
    mov ecx, name
    mov esi, name
    call strlen
    mov edx, eax
    int 0x80
    mov eax, 4
    mov ebx, [temp_handle]
    mov ecx, comma
    mov edx, 1
    int 0x80
    mov eax, 4
    mov ebx, [temp_handle]
    mov ecx, user_pass
    mov esi, user_pass
    call strlen
    mov edx, eax
    int 0x80
    mov eax, 4
    mov ebx, [temp_handle]
    mov ecx, comma
    mov edx, 1
    int 0x80
    mov eax, 4
    mov ebx, [temp_handle]
    mov ecx, courses_assigned
    mov esi, courses_assigned
    call strlen
    mov edx, eax
    int 0x80
    mov eax, 4
    mov ebx, [temp_handle]
    mov ecx, comma
    mov edx, 1
    int 0x80
    mov eax, 4
    mov ebx, [temp_handle]
    mov ecx, outstanding_fee
    mov esi, outstanding_fee
    call strlen
    mov edx, eax
    int 0x80
    mov eax, 4
    mov ebx, [temp_handle]
    mov ecx, newline
    mov edx, 1
    int 0x80

    mov eax, 6
    mov ebx, [file_handle]
    int 0x80
    mov eax, 6
    mov ebx, [temp_handle]
    int 0x80

    mov eax, 39
    mov ebx, temp_file
    mov ecx, student_file
    int 0x80
    ret

delete_from_file:
    mov eax, 5
    mov ebx, temp_file
    mov ecx, 0xA2 | 0x200
    mov edx, 0644
    int 0x80
    cmp eax, -1
    je file_error
    mov [temp_handle], eax

    mov eax, 5
    mov ebx, student_file
    mov ecx, 0
    int 0x80
    cmp eax, -1
    je file_error
    mov [file_handle], eax

delete_loop:
    call read_line
    cmp eax, 0
    je delete_end

    mov esi, buffer
    mov edi, user_id
    call compare_field
    cmp eax, 0
    je skip_record

    mov esi, buffer
    call strlen
    mov edx, eax
    mov eax, 4
    mov ebx, [temp_handle]
    mov ecx, buffer
    int 0x80
    mov eax, 4
    mov ebx, [temp_handle]
    mov ecx, newline
    mov edx, 1
    int 0x80

skip_record:
    jmp delete_loop

delete_end:
    mov eax, 6
    mov ebx, [file_handle]
    int 0x80
    mov eax, 6
    mov ebx, [temp_handle]
    int 0x80

    mov eax, 39
    mov ebx, temp_file
    mov ecx, student_file
    int 0x80
    ret

delete_from_file_trainer:
    mov eax, 5
    mov ebx, temp_file
    mov ecx, 0xA2 | 0x200
    mov edx, 0644
    int 0x80
    cmp eax, -1
    je file_error
    mov [temp_handle], eax

    mov eax, 5
    mov ebx, trainer_file
    mov ecx, 0
    int 0x80
    cmp eax, -1
    je file_error
    mov [file_handle], eax

delete_trainer_loop:
    call read_line
    cmp eax, 0
    je delete_trainer_end

    mov esi, buffer
    mov edi, user_id
    call compare_field
    cmp eax, 0
    je skip_trainer_record

    mov esi, buffer
    call strlen
    mov edx, eax
    mov eax, 4
    mov ebx, [temp_handle]
    mov ecx, buffer
    int 0x80
    mov eax, 4
    mov ebx, [temp_handle]
    mov ecx, newline
    mov edx, 1
    int 0x80

skip_trainer_record:
    jmp delete_trainer_loop

delete_trainer_end:
    mov eax, 6
    mov ebx, [file_handle]
    int 0x80
    mov eax, 6
    mov ebx, [temp_handle]
    int 0x80

    mov eax, 39
    mov ebx, temp_file
    mov ecx, trainer_file
    int 0x80
    ret

atoi:
    xor eax, eax
    xor ecx, ecx
atoi_loop:
    movzx ebx, byte [esi + ecx]
    cmp bl, 0
    je atoi_end
    sub bl, '0'
    imul eax, 10
    add eax, ebx
    inc ecx
    jmp atoi_loop
atoi_end:
    ret

itoa:
    push ebx
    mov eax, ebx
    mov ebx, 10
    xor ecx, ecx
itoa_loop:
    xor edx, edx
    div ebx
    add dl, '0'
    mov [edi + ecx], dl
    inc ecx
    test eax, eax
    jnz itoa_loop
    mov byte [edi + ecx], 0
    mov esi, edi
    lea edi, [edi + ecx - 1]
    shr ecx, 1
reverse_loop:
    mov al, [esi]
    mov bl, [edi]
    mov [esi], bl
    mov [edi], al
    inc esi
    dec edi
    loop reverse_loop
    pop ebx
    ret

file_error:
    mov eax, 4
    mov ebx, 1
    mov ecx, file_error_msg
    mov edx, file_error_len
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
