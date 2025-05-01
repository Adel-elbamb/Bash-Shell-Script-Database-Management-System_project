#!/usr/bin/bash

# Function to show table selection menu
select_table() {
  while true; do
    echo "
-----> Select your Table number from the menu <--------
"

    # Read list of files (tables) into array
    mapfile -t array < <(ls -1)

    if [ ${#array[@]} -eq 0 ]; then
      echo "No tables found."
      return
    fi

    # Show menu with an additional Exit option
    select choice in "${array[@]}" "Exit"
    do
      total_options=$(( ${#array[@]} + 1 ))

      # Validate input
      if [[ "$REPLY" -lt 1 || "$REPLY" -gt "$total_options" ]]; then
        echo "$REPLY is not on the menu"
        continue
      fi

      # Handle Exit choice
      if [[ "$choice" == "Exit" ]]; then
        echo "Exiting..."
        : &> /dev/null  # No-op, silent redirect
        return
      fi

      # Handle table selection
      table_name="${array[$((REPLY-1))]}"
      echo "... You selected $table_name Table ..."
      table_actions "$table_name"
      break
    done
  done
}

# Function to handle table actions
table_actions() {
  local table_name=$1

  # Extract column headers (assumes first line contains headers, colon-separated)
  columns=$(head -1 "$table_name" | awk -F: '{for(i=1;i<=NF;i++) print $i}')
  mapfile -t col_array <<< "$columns"

  while true; do
    echo
    select choice in Select_all Select_column Select_row Back
    do
      case $choice in
        Select_all )
          cat "$table_name"
          break
          ;;

        Select_column )
          echo "Choose the column:"
          select col in "${col_array[@]}" "Back"
          do
            if [[ "$col" == "Back" ]]; then break; fi
            if [[ -n "$col" ]]; then
              awk -F: -v c="$REPLY" '{print $c}' "$table_name"
              break
            fi
          done
          break
          ;;

        Select_row )
          read -p "Enter ID (PK): " pk
          row=$(awk -F: -v pk="$pk" '$1 == pk {print $0}' "$table_name")
          if [[ -n "$row" ]]; then
            echo "----------------------"
            head -1 "$table_name"
            echo "$row"
          else
            echo "ID '$pk' not found."
          fi
          break
          ;;

        Back )
          return  # Go back to select_table
          ;;

        * )
          echo "Invalid option"
          ;;
      esac
    done
  done
}

# Start the script by showing the first menu
select_table
