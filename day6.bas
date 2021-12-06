' AoC Day 6 - Lanternfish
' By Muffintrap

Dim start_time As Double
start_time = Timer()

CONST debug_print = false
CONST input_file = "input.txt"
CONST days = 256
CONST arr_size = 9 * SizeOf(Integer)
CONST copy_size = 8 * SizeOf(Integer)

' How many fish of each age, 0-8
CONST max_age = 8
DIM as Integer Ptr age_groups, new_groups, temp_group
age_groups = Allocate(arr_size)
new_groups = Allocate(arr_size)
CLEAR ByVal age_groups, 0, arr_size
CLEAR ByVal new_groups, 0, arr_size

' Reads until separator and returns found number, give "" to read until end of string
FUNCTION Read_to(sep as String, in_str as String, start as Integer Ptr, out_int as Integer Ptr) as Boolean
  DIM as Integer i, wide, sep_len
  DIM as String number
  sep_len = Len(sep)
  IF sep_len > 0 THEN
    i = Instr(*start, in_str, sep)
  ELSE
    i = Len(in_str) + 1
  END IF
 
  wide = i - *start
   IF i = 0 OR wide = 0 THEN
    RETURN false
  END IF
  number = Mid(in_str, *start, wide)
  *start += wide + sep_len
  *out_int = ValInt(Trim(number))
  RETURN true
END FUNCTION

DIM as Long file
file = FreeFile()

If (Open (input_file FOR Input as #file)) THEN
    Print "Error opening file"
    END -1
END IF

DIM as String line_str
DIM as Integer age, start, prev_start, read_number

DO UNTIL EOF(file)
  Line Input #file, line_str
  ' Read all numbers on line
  start = 1
  DO
    prev_start = start
    IF Read_to(",", line_str, @start, @read_number) THEN
      age = read_number
      'Print "Read age"; age
      age_groups[age] += 1
    ELSE 'Did not find next comma, read until end of line
      start = prev_start
      Read_to("", line_str, @start, @read_number)
      age = read_number
      'Print "Read last age"; age
      age_groups[age] += 1
      EXIT DO ' Next line
    END IF
  LOOP WHILE true
LOOP
Close #file

IF debug_print THEN
  FOR n as Integer = 0 TO max_age
    Print "Age ";n; ": "; age_groups[n]; " fish"
  NEXT n
END IF

' Simulate fishies
' Age 0 -> Age 8 + Age 6
' Age N -> Age N-1

' Simulate 6 days

DIM as Integer total, babies
FOR t as Integer = 0 TO days-1
  babies = age_groups[0]
  
  ' Memcopy is same as moving to lower index
  fb_memcopy(new_groups[0], age_groups[1], copy_size)
  'FOR ag as Integer = 1 TO max_age
  '  new_groups[ag-1] = age_groups[ag]
  'NEXT ag
  
  new_groups[8] += babies
  new_groups[6] += babies
  
  ' Change age_groups to point to new_groups
  Swap age_groups, new_groups
  CLEAR ByVal new_groups, 0, arr_size
NEXT t

IF debug_print THEN
  Print ""; days; " days later..."
  FOR n as Integer = 0 TO max_age
    Print "Age ";n; ": "; age_groups[n]; " fish"
  NEXT n
END IF

FOR n as Integer = 0 TO max_age
  total += age_groups[n]
NEXT n

Print "Total: "; total; " fish"

Print "Time"; (Timer() - start_time); " seconds"
Sleep
End 0