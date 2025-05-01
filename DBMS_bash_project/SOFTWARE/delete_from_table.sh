#!/usr/bin/bash

# ====== (1) Table Selection Menu ======

echo "
-----> Select your Table number from the menu <--------
"

# Read table list into array
mapfile -t array < <(ls -1)

# Check if there are any files
if [ ${#array[@]} -eq 0 ]; then
  echo "No tables found."
  exit 1
fi

# Show selection menu
select choice in "${array[@]}" "Exit"
do
  if [[ "$REPLY" -lt 1 || "$REPLY" -gt $((${#array[@]} + 1)) ]]; then
    echo "$REPLY is not on the menu."
    continue
  elif [[ "$choice" == "Exit" ]]; then
    echo "Exiting..."
    exit 0
  else
    table_name="${array[$((REPLY-1))]}"
    echo "You selected '$table_name' Table."
    break
  fi
done	

# ====== (2) Delete Menu ======

if [[ -f $table_name ]]; then
  while true; do
    echo "
What would you like to do with '$table_name'?
"
    select choice in Delete_All Delete_Row Back
    do
      case $choice in
        Delete_All )
          sed -i '/^[[:digit:]]/d' "$table_name"
          echo "All rows deleted successfully."
          break
          ;;
        Delete_Row )
          read -p "Enter the ID (PK) of the row to delete: " pk
          row=$(awk -F':' -v pk="$pk" '$1 == pk {print $0}' "$table_name")
          if grep -Fxq "$row" "$table_name"; then
            sed -i "/^$row$/d" "$table_name"
            echo "Row with ID '$pk' deleted."
          else
            echo "ID '$pk' not found. Try again."
          fi
          break
          ;;
        Back )
          echo "Returning to main menu..."
          exit 0
          ;;
        * )
          echo "Invalid choice, please select again."
          ;;
      esac
    done
  done
else
  echo "'$table_name' doesn't exist. Press Enter to try again."
  read
fi


