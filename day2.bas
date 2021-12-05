' AoC 2021 Day 2 
' By Muffintrap

DIM as String file_line, cmd, nmbr
DIM as LONG file, value, horizontal, depth, sep, length, rest, aim, depth_2

file = FreeFile

If (Open ("input.txt" FOR Input as #file)) THEN
    Print "Error opening file"
    END -1
END IF

DO UNTIL EOF(file)
  Line Input #file, file_line
  sep = Instr(file_line, " ")
  length = Len(file_line)
  cmd = Trim(Left(file_line, sep))
  
  rest = length - sep + 1
  nmbr = Mid(file_line, sep+1, rest)
  value = ValInt(nmbr)

  IF cmd = "forward" THEN
    ' Part 1
    horizontal += value
    ' Part 2
    depth_2 += aim * value
  ELSEIF cmd = "up" THEN
    ' Part 1
    depth -= value
    ' Part 2
    aim -= value
  ELSEIF cmd = "down" THEN
    ' Part 1
    depth += value
    ' Part 2
    aim += value
  END IF
LOOP

Print "Part 1"
Print "Horizontal"; horizontal
Print "Depth"; depth
Print "Product"; horizontal * depth

Print "Part 2"
Print "Horizontal"; horizontal
Print "Depth"; depth_2
Print "Product"; horizontal * depth_2

Close #file
Sleep
End 0
