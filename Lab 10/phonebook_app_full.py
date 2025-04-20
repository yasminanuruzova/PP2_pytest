import psycopg2
import csv

conn = psycopg2.connect(
    dbname="phonebook_db",
    user="postgres",           
    password="kotyanya",  
    host="localhost",
    port="5432"
)

cur = conn.cursor()

# Создание таблицы
cur.execute("""
    CREATE TABLE IF NOT EXISTS phonebook (
        id SERIAL PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        phone VARCHAR(20) NOT NULL
    );
""")
conn.commit()

# Вставка из консоли
def insert_from_console():
    name = input("Enter name: ")
    phone = input("Enter phone: ")
    cur.execute("INSERT INTO phonebook (name, phone) VALUES (%s, %s)", (name, phone))
    conn.commit()
    print("Contact saved.")

# Вставка из CSV
def insert_from_csv():
    path = input("Enter CSV file path: ")
    try:
        with open(path, 'r') as file:
            reader = csv.reader(file)
            next(reader)  # Пропускаем заголовок
            for row in reader:
                cur.execute("INSERT INTO phonebook (name, phone) VALUES (%s, %s)", (row[0], row[1]))
        conn.commit()
        print("CSV data inserted.")
    except Exception as e:
        print("Error:", e)

# Обновление данных
def update_contact():
    name = input("Enter the name of the contact to update: ")
    new_name = input("Enter new name (press Enter to skip): ")
    new_phone = input("Enter new phone (press Enter to skip): ")

    if new_name:
        cur.execute("UPDATE phonebook SET name = %s WHERE name = %s", (new_name, name))
    if new_phone:
        cur.execute("UPDATE phonebook SET phone = %s WHERE name = %s", (new_phone, new_name or name))

    conn.commit()
    print("Contact updated.")

# Поиск
def search_contact():
    keyword = input("Enter name or phone to search: ")
    cur.execute("SELECT * FROM phonebook WHERE name ILIKE %s OR phone ILIKE %s", (f"%{keyword}%", f"%{keyword}%"))
    results = cur.fetchall()
    if results:
        for row in results:
            print(f"ID: {row[0]}, Name: {row[1]}, Phone: {row[2]}")
    else:
        print("No matches found.")

# Удаление
def delete_contact():
    value = input("Enter name or phone to delete: ")
    cur.execute("DELETE FROM phonebook WHERE name = %s OR phone = %s", (value, value))
    conn.commit()
    print("Contact deleted if it existed.")

# Меню
def main():
    while True:
        print("\nPhoneBook Menu:")
        print("1. Add new contact (console)")
        print("2. Upload contacts from CSV")
        print("3. Update contact")
        print("4. Search contact")
        print("5. Delete contact")
        print("6. Exit")

        choice = input("Choose option: ")
        if choice == '1':
            insert_from_console()
        elif choice == '2':
            insert_from_csv()
        elif choice == '3':
            update_contact()
        elif choice == '4':
            search_contact()
        elif choice == '5':
            delete_contact()
        elif choice == '6':
            break
        else:
            print("Invalid option. Try again.")

main()
cur.close()
conn.close()
