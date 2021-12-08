' AoC 2021 Day 7 - Crabs
' By Muffintrap

' Assume each position has unique cost
' Assume cost decreasing towards best position

CONST input_file = "input.txt"

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

' Calculate weighted average of crab positions
' This answers "how far crabs are from 0 as average" but is a good
' starting point anyway
FUNCTION Get_weighted_average(weights(Any) as Integer, size as Integer) as Integer
  DIM as Integer product_sum, weight_sum
  DIM products(size) as Integer
  FOR i as Integer = 0 TO size-1
    weight_sum += weights(i)
    products(i) = i * weights(i) ' Each distance can has zero crabs
    product_sum += products(i)
  NEXT i
  IF weight_sum = 0 THEN
    RETURN 0
  END IF
  RETURN product_sum / weight_sum
END FUNCTION

' Calculate which position has most crabs, this provides another good
' starting point
FUNCTION Get_favorite_position(crabs(Any) as Integer, size as Integer) as Integer
  DIM as Integer amount, position
  FOR i as Integer = 0 TO size-1
    IF crabs(i) > amount THEN
      position = i
      amount = crabs(i)
    END IF
  NEXT i
  return position
END FUNCTION

' Calculate fuel use if all crabs would travel to horizontal_position
FUNCTION Get_fuel_use(crabs(Any) as Integer, size as Integer, horizontal_position as Integer) as Integer
  DIM as Integer fuel_sum
  FOR p as Integer = 0 TO size-1
     IF crabs(p) = 0 THEN
      CONTINUE FOR
    END IF
    fuel_sum += crabs(p) * Abs(horizontal_position - p)
  NEXT p
  RETURN fuel_sum
END FUNCTION

' Move left and right from start_pos until next has higher fuel use. Return the best found
FUNCTION Find_lowest_fuel_position(crabs(Any) as Integer, size as Integer, start_pos as Integer) as Integer
  DIM direction as Integer = 1
  DIM try_pos as Integer = start_pos
  DIM as Integer try_fuel, stops, best_pos
  DIM fuel_usage as Integer = Get_fuel_use(crabs(), size, start_pos)
  DO
    try_pos += direction
    try_fuel = Get_fuel_use(crabs(), size, try_pos)
    IF try_fuel > fuel_usage THEN
      direction *= -1
      stops += 1
      try_pos = start_pos
    ELSE
      best_pos = try_pos
      fuel_usage = try_fuel
    END IF
  LOOP UNTIL stops = 2
  Print "Best position found: "; best_pos
  return fuel_usage
END FUNCTION


' Part 2
' Exponential travel cost
FUNCTION Get_cost_exp(distance as Integer) as Integer
  DIM sum as Integer
  FOR d as Integer = 1 TO distance
    sum += d
  NEXT d
  RETURN sum
END FUNCTION

' Calculate cost if all crabs etc.. but cache results
FUNCTION Get_fuel_use_exp(crabs(Any) as Integer, size as Integer, horizontal_position as Integer, costs(Any) as Integer) as Integer
  DIM as Integer fuel_sum, fuel_use, steps
  
  FOR p as Integer = 0 TO size-1
    IF crabs(p) = 0 THEN
      CONTINUE FOR
    END IF
    
    steps = Abs(horizontal_position - p)
    IF costs(steps) = 0 THEN
      costs(steps) = Get_cost_exp(steps)
    END IF
    
    fuel_sum += crabs(p) * costs(steps)
  NEXT p
  RETURN fuel_sum
END FUNCTION

' Move left and right from start_pos until next has higher fuel use
' Cache fuel cost results to array
FUNCTION Find_lowest_fuel_position_exp(crabs(Any) as Integer, size as Integer, start_pos as Integer, largest_pos as Integer) as Integer
  DIM direction as Integer = 1
  DIM try_pos as Integer = start_pos
  DIM as Integer try_fuel, stops, best_pos
  DIM costs(largest_pos) as Integer
  
  try_fuel = Get_fuel_use_exp(crabs(), size, start_pos, costs())
  DIM fuel_usage as Integer = try_fuel
  DO
    try_pos += direction
    try_fuel = Get_fuel_use_exp(crabs(), size, try_pos, costs())
    IF try_fuel > fuel_usage THEN
      direction *= -1
      stops += 1
      try_pos = start_pos
    ELSE
      best_pos = try_pos
      fuel_usage = try_fuel
    END IF
  LOOP UNTIL stops = 2
  Print "Best position found: "; best_pos
  return fuel_usage
END FUNCTION


''''''''''''''''''''''''''''''''''''
' Program start
''''''''''''''''''''''''''''''''''''
' Timing execution
Dim start_time As Double
start_time = Timer()

DIM as Long file
file = FreeFile()

If (Open (input_file FOR Input as #file)) THEN
    Print "Error opening file"
    END -1
END IF


DIM as Integer start, prev_start, read_position, array_size, largest_position

array_size = 32
DIM counts() as Integer
REDIM counts(array_size)

DIM as String line_str
DIM as Boolean all_read
DO UNTIL EOF(file)
  Line Input #file, line_str
  ' Read all numbers on line
  start = 1
  DO
    prev_start = start
    
    IF Read_to(",", line_str, @start, @read_position) THEN
      ' Ok
    ELSE 
      'Did not find next comma, read until end of line
      all_read = true
      start = prev_start
      Read_to("", line_str, @start, @read_position)
    END IF
    
    ' Check that array is large enough
    IF read_position > largest_position THEN
      largest_position = read_position
      IF largest_position >= array_size THEN
        array_size = largest_position+1
        REDIM PRESERVE counts(array_size) ' Max largest, size*2 ??
      END IF
    END IF
    
    ' Increase count of crabs at this position
    counts(read_position) += 1
    
    IF all_read THEN
      EXIT DO ' Next line
    END IF
  LOOP WHILE true
LOOP
Close #file

' Part 1
Print "Part 1"
' Calculate best position  
DIM w_average as Integer = Get_weighted_average(counts(), array_size)
DIM crowd as Integer = Get_favorite_position(counts(), array_size)
DIM  as Integer l_bound, h_bound
l_bound = crowd
h_bound = w_average
IF l_bound >= h_bound THEN
  Swap l_bound, h_bound
END IF
DIM as Integer middle = l_bound + ((h_bound - l_bound) / 2)

Print "Crowded position is "; crowd
Print "Weighted average is: "; w_average
Print "Start to look around: "; middle
' Calculate fuel usage
DIM lowest as Integer = Find_lowest_fuel_position(counts(), array_size, middle)
Print "Lowest use is: "; lowest

Print "Part 2"
' Calculate fuel usage
lowest = Find_lowest_fuel_position_exp(counts(), array_size, middle, largest_position)
Print "Lowest use is: "; lowest

Print "Time"; (Timer() - start_time); " seconds"
Sleep
END 0
