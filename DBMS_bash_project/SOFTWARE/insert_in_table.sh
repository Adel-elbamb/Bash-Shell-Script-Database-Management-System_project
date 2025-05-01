#!/usr/bin/bash

# ========== (1) Let the user select the table first ==========

echo "
-------------------------> Select your Table number from the menu <------------------------------------
"

# Read table list
mapfile -t array < <(ls -1)

if [ ${#array[@]} -eq 0 ]; then
  echo "No tables found."
  exit 1
fi

# Select from menu
select choice in "${array[@]}"
do
  if [[ $REPLY -lt 1 || $REPLY -gt ${#array[@]} ]]; then
    echo "Invalid option."
    continue
  else
    table_name="${array[$((REPLY-1))]}"
    echo "You selected '$table_name'"
    break
  fi
done

# ========== (2) Insert into table ==========

# Read headers into an array
IFS=':' read -r -a headers < <(head -1 "$table_name")

# Prepare row to insert
row=""

echo "Enter data for each column:"
for ((i = 0; i < ${#headers[@]}; i++)); do
  col_name=${headers[$i]}
  
  while true; do
    read -p "Field $((i+1)) ($col_name): " value
    
    if [[ -z "$value" ]]; then
      echo "Value cannot be empty. Try again."
      continue
    fi

    # Primary key validation (first field only)
    if [[ $i -eq 0 ]]; then
      existing_ids=$(cut -d ':' -f1 "$table_name" | tail -n +2)
      if echo "$existing_ids" | grep -Fxq "$value"; then
        echo "Primary key '$value' already exists. Enter a unique value."
        continue
      fi
    fi

    break
  done

  # Add colon unless it's the last field
  if [[ $i -lt $((${#headers[@]} - 1)) ]]; then
    row+="$value:"
  else
    row+="$value"
  fi
done

# Insert the row
echo "$row" >> "$table_name"
echo "Row inserted into '$table_name'."

