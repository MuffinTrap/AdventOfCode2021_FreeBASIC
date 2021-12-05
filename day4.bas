' AoC 2021 Day 4
' By Muffintrap

CONST comma = ","
CONST number_sep = " "
CONST board_size = 25
CONST row_size = 5
CONST called = -1

TYPE Bingo_Board
  ' When number is called, it is set as -1
  numbers(board_size) as Integer
  index as Integer
  bingo as Boolean
  DECLARE SUB add_row(row(Any) as Integer)
  DECLARE SUB print_board()
  DECLARE FUNCTION call_number(number as Integer) as Integer
  DECLARE CONSTRUCTOR
END TYPE

CONSTRUCTOR Bingo_Board
  index = 0
  bingo = false
END CONSTRUCTOR

SUB Bingo_board.print_board()
  DIM row as String
  FOR r as Integer = 0 TO row_size-1
    row = ""
    FOR c as Integer = 0 TO row_size-1
      row += Str(this.numbers(r*row_size+c))
      row += " "
    NEXT c
    Print row
  NEXT r
END SUB

SUB Bingo_board.add_row(row(Any) as Integer)
  FOR i as Integer = 0 TO 4
    this.numbers(index+i) = row(i)
  NEXT i
  this.index += row_size
END SUB

'Returns sum of uncalled numbers on bingo, 0 otherwise
FUNCTION Bingo_board.call_number(number as Integer) as Integer
  DIM as Integer row, column, sum, coord, hits
  DIM as Boolean yes, bingo_r, bingo_c
  yes = false
  ' Check if we have this number
  FOR r as Integer = 0 TO row_size-1
    FOR c as Integer = 0 TO row_size-1
      coord = r*row_size+c
      IF this.numbers(coord) = number THEN
        this.numbers(coord) = called
        row = r
        column = c
        yes = true
      END IF
    NEXT c
  NEXT r
  
  IF NOT yes THEN
    RETURN 0
  END IF
  
  ' If we had, check the row and column
  bingo_c = true
  FOR c as Integer = 0 TO row_size-1
    IF this.numbers(row*row_size+c) <> called THEN
      bingo_c = false
      EXIT FOR
    END IF
  NEXT c
  
  bingo_r = true
  FOR r as Integer = 0 TO row_size-1
    IF this.numbers(r*row_size+column) <> called THEN
      bingo_r = false
      EXIT FOR
    END IF
  NEXT r
  
  IF NOT (bingo_r OR bingo_c) THEN
    RETURN 0
  END IF
  
  ' We won!
  sum = 0
  FOR n as Integer = 0 TO board_size-1
    IF this.numbers(n) <> called THEN
      sum += this.numbers(n)
    END IF
  NEXT n
  
  RETURN sum
END FUNCTION


' Reads all numbers from line to a given array. Returns the amount of numbers in array
FUNCTION Read_to_array(in_str as String, separator as String, array(Any) as Integer, start as Integer, size as Integer) as Integer
  DIM as Integer sep_pos, mid_start, wide, last_number, count
  DIM as Boolean str_left
  DIM as String number
  mid_start = 1
  sep_pos = 1
  str_left = true
  count = start
  DO WHILE (str_left)
    sep_pos = Instr(sep_pos, in_str, separator)
    IF sep_pos = 0 THEN
      str_left = false
      sep_pos = Len(in_str)-2
    END IF
    wide = sep_pos - mid_start
    number = Mid(in_str, mid_start, wide)
    
    ' Bingo numbers can be separated by two spaces
    IF Len(number)=0 THEN
      sep_pos += 1
      mid_start += 1
      CONTINUE DO
    END IF
    
    last_number = ValInt(number)
    
    mid_start += wide + 1
    sep_pos = mid_start
    
    array(count) = last_number
    count += 1
    IF count = size THEN
      size *= 2
      REDIM PRESERVE array(size)
    END IF
  LOOP
  RETURN count
END FUNCTION


' Bingo board has 25 slots
' Dynamic array of bingo boards
DIM as Integer board_amount, board_count, boards_size
boards_size = 3
DIM boards() as Bingo_Board
REDIM boards(boards_size)

' Bingo Numbers
DIM as Integer numbers_size, number_count
number_count = 0
numbers_size = 20
' Variable length array to hold numbers
DIM numbers() as Integer
' Except at least 20 numbers
REDIM numbers(numbers_size)

' board input array
DIM b_test(row_size) as Integer

' Reading the file
DIM as Long file
DIM as String line_str

'''''''''''''''''''''''''''''''''''''''''''''''''
' Program start
'''''''''''''''''''''''''''''''''''''''''''''''''


file = FreeFile()
If (Open ("input.txt" FOR Input as #file)) THEN
    Print "Error opening file"
    END -1
END IF

DO UNTIL EOF(file)
  Line Input #file, line_str
  ' Read input numbers
  IF number_count = 0 THEN
    number_count = Read_to_array(line_str, comma, numbers(), 0, numbers_size)
    CONTINUE DO
  END IF
  
  ' Read bingo boards
  IF Len(line_str) = 0 THEN
    ' New board
    board_count += 1
    IF board_count = boards_size THEN
      boards_size *= 2
      REDIM PRESERVE boards(boards_size)
    END IF
    CONTINUE DO
  END IF
  
  ' Read board numbers from lines
  DIM as Integer b_read
  b_read = 0
  b_read = Read_to_array(line_str, number_sep, b_test(), 0, 5)
  boards(board_count-1).add_row(b_test())
LOOP
Close #file

' Play the bingo
DIM as Integer score, last_number, winners
FOR ni as Integer = 0 TO number_count-1
  last_number = numbers(ni)

  FOR bi as Integer = 0 TO board_count-1
    IF boards(bi).bingo THEN
      CONTINUE FOR
    END IF
    
    score = boards(bi).call_number(last_number)
    
    IF score = 0 THEN
      CONTINUE FOR
    END IF
    
    boards(bi).bingo = true
    winners += 1
   
    IF winners = 1 THEN
      Print "First winner is board"; bi + 1
      Print "Last number was"; last_number
      Print "Sum is"; score
      Print "Score is"; score * last_number
    END IF
    
    IF winners = board_count THEN
      Print "Last winner is board"; bi + 1
      Print "Last number was"; last_number
      Print "Sum is"; score
      Print "Score is"; score * last_number
    END IF
    
    IF winners = board_count THEN
      goto game_end
    END IF
      
  NEXT bi
NEXT ni

game_end:
Sleep
End 0