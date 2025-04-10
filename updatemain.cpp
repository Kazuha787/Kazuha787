#include <iostream>
#include <vector>
#include <string>

using namespace std;

class Contact {
public:
    string name;
    string phone;
    string email;

    Contact(string n, string p, string e) {
        name = n;
        phone = p;
        email = e;
    }

    void display() {
        cout << "Name : " << name << endl;
        cout << "Phone: " << phone << endl;
        cout << "Email: " << email << endl;
        cout << "---------------------------" << endl;
    }
};

class ContactManager {
private:
    vector<Contact> contacts;

public:
    void addContact(string name, string phone, string email) {
        Contact newContact(name, phone, email);
        contacts.push_back(newContact);
        cout << "Contact added successfully.\n";
    }

    void showAllContacts() {
        if (contacts.empty()) {
            cout << "No contacts to display.\n";
            return;
        }

        cout << "\nAll Contacts:\n";
        for (const auto& contact : contacts) {
            contact.display();
        }
    }

    void searchContact(string keyword) {
        bool found = false;
        for (const auto& contact : contacts) {
            if (contact.name == keyword || contact.phone == keyword || contact.email == keyword) {
                contact.display();
                found = true;
            }
        }
        if (!found) {
            cout << "No contact found matching: " << keyword << endl;
        }
    }
};

int main() {
    ContactManager manager;
    int choice;
    string name, phone, email, searchKey;

    do {
        cout << "\n=== Contact Manager ===\n";
        cout << "1. Add Contact\n";
        cout << "2. Show All Contacts\n";
        cout << "3. Search Contact\n";
        cout << "4. Exit\n";
        cout << "Enter your choice: ";
        cin >> choice;
        cin.ignore(); // flush newline

        switch (choice) {
            case 1:
                cout << "Enter name: ";
                getline(cin, name);
                cout << "Enter phone: ";
                getline(cin, phone);
                cout << "Enter email: ";
                getline(cin, email);
                manager.addContact(name, phone, email);
                break;
            case 2:
                manager.showAllContacts();
                break;
            case 3:
                cout << "Enter name, phone, or email to search: ";
                getline(cin, searchKey);
                manager.searchContact(searchKey);
                break;
            case 4:
                cout << "Exiting... Goodbye!\n";
                break;
            default:
                cout << "Invalid choice. Try again.\n";
        }
    } while (choice != 4);

    return 0;
}
