' AoC Day 1
' By Muffintrap

CONST win_arr_size = 4
CONST win_size = 3

DIM as Long file, value, prev_value, count
DIM as Long win_index, win_start, win_prev, win_count
DIM win_array(win_arr_size) as Long
DIM as String line_str

file = FreeFile()

If (Open ("input.txt" FOR Input as #file)) THEN
    Print "Error opening file"
    END -1
END IF

count = -1
prev_value = -1

win_prev = -1
win_index = 0
win_start = -3
win_count = -1

DO UNTIL EOF(file)
  Line Input #file, line_str
  value = ValInt(line_str)
  
  ' Part 1
  IF value > prev_value THEN
    count += 1
  END IF
  prev_value = value
  
  ' Part 2 window
  win_array(win_index) = value
  
  win_index += 1
  win_start += 1
  IF win_index = win_arr_size THEN
    win_index = 0
  END IF
  IF win_start = win_arr_size THEN
    win_start = 0
  END IF
  
  IF win_start < 0 THEN
    CONTINUE DO
  END IF
  
  DIM add_in AS Long
  add_in = win_start
  value = 0
  FOR index as Integer = 1 TO win_size
    value += win_array(add_in)
    add_in += 1
    IF add_in = win_arr_size THEN
      add_in = 0
    END IF
  NEXT index
  IF value > win_prev THEN
    win_count += 1
  END IF
  win_prev = value
LOOP

Print "Part 1 greater than: "; count
Print "Part 2 greater than: "; win_count

Close #file
Sleep
End 0
