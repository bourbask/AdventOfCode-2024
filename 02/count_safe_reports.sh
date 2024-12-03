#!/bin/bash

source ../common/utils.sh
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

safe_reports_count="$reports_count"

for ((i=0; i<reports_count; i++)); do
  levels=(${report_arrays["report_$i"]})
  levels_count=${#levels[@]}
  isIncreasing=""

  echo "Processing Report $((i + 1)) with ${levels_count} levels: ${levels[@]}"

  for ((j=0; j<levels_count-1; j++)); do
    current_level=${levels[j]}
    next_level=${levels[j+1]}

    if (( current_level == next_level )); then
      ((safe_reports_count--))
      break
    fi

    # Determine the increasing or decreasing trend
    if [ -z "$isIncreasing" ]; then
      if (( current_level < next_level )); then
        isIncreasing=true
      else
        isIncreasing=false
      fi
    elif { [ "$isIncreasing" = "true" ] && (( current_level >= next_level )); } || \
         { [ "$isIncreasing" = "false" ] && (( current_level < next_level )); }; then
      ((safe_reports_count--))
      break
    fi

    abs_diff=$(absolute $((current_level - next_level)))

    if (( abs_diff < 1 || abs_diff > 3 )); then
      ((safe_reports_count--))
      break
    fi
  done
done

# Output safe_reports_count
echo "Number of safe reports: $safe_reports_count"