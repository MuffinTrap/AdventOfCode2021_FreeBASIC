' AoC 2021 Day 3 Part 1 only
' By Muffintrap

CONST input_file = "input.txt" ' "input.txt"
CONST input_width = 12

CONST str_one = "1"
CONST str_zero = "0"
CONST zero = Asc("0")
CONST one = Asc("1")
CONST E_VALID = 0
CONST E_INVALID = 1

DIM as LONG file, line_count
DIM as INTEGER gamma, epsilon
DIM as STRING line_string, oxygen, co2

DIM zero_counts(input_width) as INTEGER

DIM numbers() as String
DIM number_count as Integer = 0
DIM numbers_size as Integer = 128
REDIM numbers(numbers_size)

SUB Calculate_zeros(inputs(Any) as String, count as Integer, valid_numbers(Any) as Integer, counts(Any) as Integer, i1 as Integer, i2 as Integer)
  FOR i as Integer = i1 TO i2
    counts(i) = 0
  NEXT i
  
  FOR i as Integer = i1 TO i2
    FOR n as Integer = 0 TO count-1
      IF valid_numbers(n) = E_VALID THEN
        IF inputs(n)[i] = zero THEN
          counts(i) += 1
        END IF
      END IF
    NEXT n
  NEXT i
END SUB

FUNCTION More_zeros_at_index(counts(Any) as Integer, half_count as Integer, index as Integer) as Integer
  RETURN (counts(index) - half_count)
END FUNCTION

' Start program
file = FreeFile
If (Open (input_file FOR Input as #file)) THEN
    Print "Error opening file"
    Sleep
    END -1
END IF

' Read all lines, store numbers and count zeros per column
DO UNTIL EOF(file)
  Line Input #file, line_string
  line_count += 1

  numbers(number_count) = Trim(line_string)
  number_count += 1
  IF number_count = numbers_size THEN
    numbers_size *= 2
    REDIM PRESERVE numbers(numbers_size)
  END IF
LOOP
  
' Keep track which numbers are okay
DIM valid_O2_numbers() as Integer
DIM valid_CO2_numbers() as Integer
REDIM valid_O2_numbers(number_count)
REDIM valid_CO2_numbers(number_count)

' Solve Part 1

' Use O2 numbers for Part 1 since they are all valid
Calculate_zeros(numbers(), number_count, valid_O2_numbers(), zero_counts(), 0, input_width-1)

DIM zero_diff as Integer

line_count = line_count / 2
DIM gamma_str as STRING = "&B"
DIM epsilon_str as STRING = "&B"

FOR i as Integer = 0 TO input_width-1
  zero_diff = More_zeros_at_index(zero_counts(), line_count, i)
  IF zero_diff < 0 THEN
    gamma_str += str_one
    epsilon_str += str_zero
  ELSE
    gamma_str += str_zero
    epsilon_str += str_one
  END IF
NEXT i

gamma = ValInt(gamma_str)
epsilon = ValInt(epsilon_str)
Print "Part 1."
Print "Gamma rate: "; gamma
Print "Epsilon rate: "; epsilon
Print "Product: ", gamma * epsilon

  
'''''''''''''''''''''''''''''''''''''''
' Solve Part 2.
'''''''''''''''''''''''''''''''''''''''
DIM O2_zero_counts(input_width) as INTEGER
DIM CO2_zero_counts(input_width) as INTEGER

DIM as Integer valid_O2_count = number_count
DIM as Integer valid_CO2_count = number_count
DIM as Integer O2_number, CO2_number, O2_zero_diff, CO2_zero_diff, ones

FOR i as Integer = 0 TO input_width-1
  Calculate_zeros(numbers(), number_count, valid_O2_numbers(), O2_zero_counts(), i, i)
  Calculate_zeros(numbers(), number_count, valid_CO2_numbers(), CO2_zero_counts(), i, i)
  
  ones = valid_O2_count - O2_zero_counts(i)
  O2_zero_diff =  O2_zero_counts(i) - ones
  
  ones = valid_CO2_count - CO2_zero_counts(i)
  CO2_zero_diff = CO2_zero_counts(i) - ones

  IF O2_zero_diff <= 0 THEN
    ' One is more common, zero least common
    O2_number = one
  ELSE
    ' Vice versa
    O2_number = zero
  END IF
  
  IF CO2_zero_diff <= 0 THEN
    ' One is more common, zero least common or equal
    CO2_number = zero
  ELSE
    ' Vice versa
    CO2_number = one
  END IF
  
  /'
  Print "At "; i+1; ","; valid_O2_count; " O2 numbers"
  Print "At "; i+1; ","; valid_CO2_count ;" CO2 numbers"
  
  Print "At "; i+1; ","; O2_zero_diff; " O2 number is: "; CHR(O2_number)
  Print "At "; i+1; ","; CO2_zero_diff;" CO2 number is: "; CHR(CO2_number)
  '/
    
  '  Check which numbers fit O2 number
  ' Mark them with 0, since that is the default value
  ' Same for CO2 numbers
  FOR n as Integer = 0 TO number_count-1
    IF valid_O2_numbers(n) = E_VALID THEN
      IF numbers(n)[i] <> O2_number THEN
        valid_O2_numbers(n) = E_INVALID
        valid_O2_count -= 1
      END IF
    END IF
    
    IF valid_CO2_numbers(n) = E_VALID THEN
      IF numbers(n)[i] <> CO2_number THEN
        valid_CO2_numbers(n) = E_INVALID
        valid_CO2_count -= 1
      END IF
    END IF
  NEXT n
  
  IF valid_O2_count = 1 THEN
    ' Oxygen Value found!
    FOR n as Integer = 0 TO number_count-1
      IF valid_O2_numbers(n) = E_VALID THEN
        oxygen = numbers(n)
        valid_O2_count = 0 ' Don't get here again
        EXIT FOR
      END IF 
    NEXT n
  END IF
 
  IF valid_CO2_count = 1 THEN
    ' CO2 Value found!
    FOR n as Integer = 0 TO number_count-1
      IF valid_CO2_numbers(n) = E_VALID THEN
        co2 = numbers(n)
        valid_CO2_count = 0 ' Don't get here again
        EXIT FOR
      END IF 
    NEXT n
  END IF
  
  ' DEBUG
  /'
  IF valid_O2_count > 1 THEN
    Print "Valid O2 numbers"
    FOR n as Integer = 0 TO number_count-1
      IF valid_O2_numbers(n) = E_VALID THEN
        Print "O2 "; numbers(n)
      END IF
    NEXT n
  END IF
  
  IF valid_CO2_count > 1 THEN
    Print "Valid CO2 numbers"
    FOR n as Integer = 0 TO number_count-1
      IF valid_CO2_numbers(n) = E_VALID THEN
        Print "CO2 "; numbers(n)
      END IF
    NEXT n
  END IF
  '/
  
NEXT i ' Next binary position



DIM O2_str as STRING = "&B"
DIM CO2_str as STRING = "&B"
O2_str += oxygen
CO2_str += co2
DIM O2_value as Integer = ValInt(O2_str)
DIM CO2_value as Integer = ValInt(CO2_str)

Print "Part 2."
Print "O2 rate: "; O2_value
Print "CO2 rate: "; CO2_value
Print "Product: ", O2_value * CO2_value

Close #file
Sleep
End 0
