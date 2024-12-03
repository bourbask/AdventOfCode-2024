#!/bin/bash

source ../common/extract_input.sh

##########################
# Extract data by reports  #
##########################

list_of_reports=()
while IFS= read -r report; do
  list_of_reports+=("$report")
done < "$input_file"

##########################
# Extract numbers per report #
##########################

reports_count=${#list_of_reports[@]}
declare -A report_arrays

for ((i=0; i<reports_count; i++)); do
  report="${list_of_reports[i]}"
  
  # Extract numbers from the report
  numbers=($(echo "$report" | grep -oE '[0-9]+'))
  
  # Store numbers in an associative array using report index as key
  report_arrays["report_$i"]="${numbers[@]}"
  
  # Debug: Print extracted numbers for the current report
#   echo "Report $((i + 1)): ${numbers[@]}"
done

######################################
# Process adjacent levels in reports #
######################################

for ((i=0; i<reports_count; i++)); do
  levels=(${report_arrays["report_$i"]})
  levels_count=${#levels[@]}
  
  echo "Processing Report $((i + 1)) with ${levels_count} levels: ${levels[@]}"

  for ((j=0; j<levels_count-1; j++)); do
    current_level=${levels[j]}
    next_level=${levels[j+1]}
    
    # Example processing: Check if the next level is greater than the current level
    if (( next_level > current_level )); then
      echo "Level $current_level is followed by a greater level $next_level"
    else
      echo "Level $current_level is followed by a smaller or equal level $next_level"
    fi
  done
done