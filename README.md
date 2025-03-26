````md
# Bash Shell Script Database Management System (DBMS)

## 📌 Project Overview
This project aims to develop a **Database Management System (DBMS)** using **Bash scripting**, allowing users to store and retrieve data from a **hard disk**. The application operates through a **Command Line Interface (CLI) Menu**, providing essential database functionalities.

## 🎯 Features
### **Main Menu**
Upon starting the application, the user will be presented with the following menu:
- 📁 **Create Database** – Allows users to create a new database.
- 📜 **List Databases** – Displays all available databases.
- 🔗 **Connect to Database** – Enables users to access a specific database.
- ❌ **Drop Database** – Deletes an existing database.

### **Database Menu**
Once connected to a specific database, the user will have access to the following options:
- 📑 **Create Table** – Allows users to define a new table with specified columns.
- 📃 **List Tables** – Displays all tables within the connected database.
- 🗑 **Drop Table** – Deletes a specific table from the database.
- ✍ **Insert into Table** – Adds new records into a specified table.
- 🔍 **Select from Table** – Retrieves and displays records from a table in a **structured format**.
- ❌ **Delete from Table** – Removes specific rows from a table.
- ✏ **Update Table** – Modifies existing data in a table.

## 🔍 Hints & Implementation Details
- 📂 **Database Storage** – Each database is stored as a **directory** within the script's directory.
- 📋 **Data Display** – Retrieved data is formatted neatly for better readability in the terminal.
- 🛠 **Column Data Types** – Users are required to define column **data types** during table creation, and data validation is enforced during insertion and updates.
- 🔑 **Primary Key Constraint** – Users can define a **primary key** when creating a table. The system ensures uniqueness while inserting records.

## 🏗 Installation & Usage
### **Prerequisites**
- A **Linux-based OS** (or WSL on Windows)
- Bash Shell

### **Run the Application**
```bash
chmod +x dbms.sh  # Make the script executable
./dbms.sh  # Start the DBMS
````

## 🤝 Contribution

1. **Fork** the repository.
2. **Create** a new branch (`feature-name`).
3. **Commit** your changes.
4. **Push** to the branch.
5. **Open** a Pull Request.

## 📝 License

This project is open-source under the **MIT License**.

---

🚀 **Enjoy using the Bash Shell Script DBMS!**
