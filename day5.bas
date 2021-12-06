' AoC 2021 Day 5
' By Muffintrap

CONST input_file = "input.txt"
DIM show_map as Boolean = false
DIM print_vents as Boolean = false


CONST comma = ","
CONST arrow = "->"
CONST str_end = ""

TYPE Vector
  x1 as Integer
  x2 as Integer
  y1 as Integer
  y2 as Integer
  dx as Integer
  dy as Integer
  DECLARE SUB Print_vector()
  DECLARE SUB Calculate_dir()
END TYPE

SUB Vector.Print_vector()
  Print this.x1;this.y1;" -> ";this.x2;this.y2;" "; this.dx; " "; this.dy
END SUB

SUB Vector.Calculate_dir()
  this.dx = this.x2-this.x1
  IF this.dx < 0 THEN
    this.dx = -1
  ELSEIF this.dx > 0 THEN
    this.dx = 1
  END IF
  
  this.dy = this.y2-this.y1
  IF this.dy < 0 THEN
    this.dy = -1
  ELSEIF this.dy > 0 THEN
    this.dy = 1
  END IF
END SUB

DIM vectors() as Vector
DIM as Integer vector_count, vectors_size
vector_count = 0
vectors_size = 32
REDIM vectors(vectors_size)

' Returns first number
FUNCTION Read_to(sep as String, in_str as String, start as Integer Ptr) as Integer
  DIM as Integer i, wide, sep_len
  DIM as String number
  sep_len = Len(sep)
  IF sep_len > 0 THEN
    i = Instr(*start, in_str, sep)
  ELSE
    i = Len(in_str) + 1
  END IF
  wide = i - *start
  number = Mid(in_str, *start, wide)
  *start += wide + sep_len
  RETURN ValInt(Trim(number))
END FUNCTION


SUB Read_vector(in_str as String, vectors(Any) as Vector, vector_count as Integer)
  DIM as Integer index
  DIM as Integer Ptr index_ptr
  index = 1
  index_ptr = @index
  
  vectors(vector_count).x1 = Read_to(comma, in_str, index_ptr)
  vectors(vector_count).y1 = Read_to(arrow, in_str, index_ptr)
  vectors(vector_count).x2 = Read_to(comma, in_str, index_ptr)
  vectors(vector_count).y2 = Read_to(str_end, in_str, index_ptr)
  vectors(vector_count).Calculate_dir()
END SUB

' Map of sea floor
DIM map() as Integer
DIM as Integer max_x, max_y

SUB Add_to_map(v as Vector, map_wide as Integer, floor(Any) as Integer)
  DIM as Integer c, c2, x, y
  x = v.x1
  y = v.y1
  c2 = v.y2 * map_wide + v.x2
  DO
    c = y * map_wide + x
    floor(c) += 1
    x += v.dx
    y += v.dy
  LOOP WHILE (c <> c2)
END SUB

FUNCTION Count_overlaps(map(Any) as Integer, size as Integer) as Integer
  DIM count as Integer 
  FOR i as Integer = 0 TO size-1
    IF map(i) >= 2 THEN
      count += 1
    END IF
  NEXT i
  RETURN count
END FUNCTION




' '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
' Program start
' '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
DIM as Long file
file = FreeFile()

If (Open (input_file FOR Input as #file)) THEN
    Print "Error opening file"
    END -1
END IF

DIM as String line_str
vector_count = 0
DO UNTIL EOF(file)
  Line Input #file, line_str
  ' Print line_str ' Debug
  Read_vector(line_str, vectors(), vector_count)
  vector_count +=1
  IF vector_count = vectors_size THEN
    vectors_size *= 2
    REDIM PRESERVE vectors(vectors_size)
  END IF
LOOP

Close #file

IF print_vents THEN
  Print "Vent amount"; vector_count
  FOR vi as Integer = 0 TO vector_count-1
    vectors(vi).Print_vector()
  NEXT vi
END IF

FOR vi as Integer = 0 TO vector_count-1
  IF vectors(vi).x1 > max_x THEN
    max_x = vectors(vi).x1
  END IF
  IF vectors(vi).x2 > max_x THEN
    max_x = vectors(vi).x2
  END IF
  IF vectors(vi).y1 > max_y THEN
    max_y = vectors(vi).y1
  END IF
  IF vectors(vi).y2 > max_y THEN
    max_y = vectors(vi).y2
  END IF
NEXT vi

max_x +=1
max_y +=1
Print "Map dimensions: ";max_x;",";max_y
REDIM map(max_x * max_y)

' All vectors added. Add them all to map if not diagonal
FOR vi as Integer = 0 TO vector_count-1
  IF Abs(vectors(vi).dx) + Abs(vectors(vi).dy) = 1 THEN
    Add_to_map(vectors(vi), max_x, map())
  END IF 
NEXT vi

IF show_map THEN
  DIM row as String
  DIM v as Integer
  Print " 0123456789"
  FOR r as Integer = 0 TO max_y-1
    row = " "
    row += Str(r)
    FOR c as Integer = 0 TO max_x-1
      v = map(r * max_x + c)
      IF v = 0 THEN
        row += "."
      ELSE
        row += Str(v)
      END IF
    NEXT c
    Print row
  NEXT r
END IF

DIM as Integer total_danger_non_diagonal = Count_overlaps(map(), max_x * max_y)
Print "Part1: Dangerous points "; total_danger_non_diagonal

' Part 2
' Add diagonals too
FOR vi as Integer = 0 TO vector_count-1
  IF Abs(vectors(vi).dx) + Abs(vectors(vi).dy) = 2 THEN
    Add_to_map(vectors(vi), max_x, map())
  END IF 
NEXT vi

DIM as Integer total_danger_all = Count_overlaps(map(), max_x * max_y)
Print "Part2: Dangerous points "; total_danger_all

Sleep
End 0