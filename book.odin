package main

import "core:fmt"
import "core:os"
import "core:strings"

Contact :: struct {
    name  : string,
    phone : string,
}

contacts: []Contact = [];

add_contact :: proc() {
    fmt.print("Enter name: ");
    name := os.read_string();

    fmt.print("Enter phone: ");
    phone := os.read_string();

    contact := Contact{name=name, phone=phone};
    contacts = append(contacts, contact);

    fmt.println("Contact added!");
}

list_contacts :: proc() {
    if len(contacts) == 0 {
        fmt.println("No contacts found.");
        return;
    }

    fmt.println("\n--- Contact List ---");
    for i, contact in contacts {
        fmt.printf("%d. %s - %s\n", i+1, contact.name, contact.phone);
    }
}

delete_contact :: proc() {
    list_contacts();
    fmt.print("Enter contact number to delete: ");
    input := os.read_string();
    index := strings.atoi(input) - 1;

    if index < 0 || index >= len(contacts) {
        fmt.println("Invalid index.");
        return;
    }

    contacts = append(contacts[:index], contacts[index+1:]...);
    fmt.println("Contact deleted!");
}

main :: proc() {
    for true {
        fmt.println("\n--- Contact Book ---");
        fmt.println("1. Add Contact");
        fmt.println("2. List Contacts");
        fmt.println("3. Delete Contact");
        fmt.println("4. Exit");

        fmt.print("Choose an option: ");
        choice := os.read_string();

        switch choice {
            case "1": add_contact();
            case "2": list_contacts();
            case "3": delete_contact();
            case "4": {
                fmt.println("Goodbye!");
                break;
            }
            else: fmt.println("Invalid choice.");
        }
    }
}
