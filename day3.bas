' AoC 2021 Day 3 Part 1 only
' By Muffintrap

CONST input_width = 12

DIM as LONG file, line_count, i
DIM as ULONG gamma, epsilon
DIM as STRING line_string
DIM as ULONG char, zero
DIM zero_counts(input_width) as INTEGER
DIM gamma_str as STRING
DIM epsilon_str as STRING

zero = Asc("0")
gamma_str = "&B"
epsilon_str = "&B"


' Start program
file = FreeFile
If (Open ("input.txt" FOR Input as #file)) THEN
    Print "Error opening file"
    Sleep
    END -1
END IF

DO UNTIL EOF(file)
  Line Input #file, line_string
  line_count += 1

  FOR i=0 TO input_width-1
    char = line_string[i]
    IF char = zero THEN
      zero_counts(i) += 1
    END IF
  NEXT i
LOOP

line_count = line_count / 2
FOR i=0 TO input_width-1
  IF zero_counts(i) < line_count THEN
    gamma_str += "1"
    epsilon_str += "0"
  ELSE
    gamma_str += "0"
    epsilon_str += "1"
  END IF
NEXT i

gamma = ValInt(gamma_str)
epsilon = ValInt(epsilon_str)
Print "Gamma rate: "; gamma
Print "Epsilon rate: "; epsilon
Print "Product: ", gamma * epsilon

Close #file
Sleep
End 0
