use std::fs::{File, OpenOptions};
use std::io::{self, BufReader, BufWriter, Write};
use std::path::Path;
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug)]
struct Task {
    description: String,
    completed: bool,
}

fn load_tasks(path: &str) -> Vec<Task> {
    if !Path::new(path).exists() {
        return Vec::new();
    }

    let file = File::open(path).expect("Failed to open file");
    let reader = BufReader::new(file);
    serde_json::from_reader(reader).unwrap_or_else(|_| Vec::new())
}

fn save_tasks(path: &str, tasks: &Vec<Task>) {
    let file = File::create(path).expect("Failed to create file");
    let writer = BufWriter::new(file);
    serde_json::to_writer_pretty(writer, tasks).expect("Failed to write tasks");
}

fn add_task(tasks: &mut Vec<Task>) {
    println!("Enter task description:");
    let mut desc = String::new();
    io::stdin().read_line(&mut desc).expect("Failed to read input");

    tasks.push(Task {
        description: desc.trim().to_string(),
        completed: false,
    });

    println!("Task added!");
}

fn list_tasks(tasks: &Vec<Task>) {
    println!("\nYour Tasks:");
    for (i, task) in tasks.iter().enumerate() {
        let status = if task.completed { "[X]" } else { "[ ]" };
        println!("{}: {} {}", i + 1, status, task.description);
    }
}

fn mark_task_done(tasks: &mut Vec<Task>) {
    list_tasks(tasks);
    println!("\nEnter task number to mark as done:");
    let mut input = String::new();
    io::stdin().read_line(&mut input).expect("Failed to read input");
    let index: usize = input.trim().parse().unwrap_or(0);

    if index == 0 || index > tasks.len() {
        println!("Invalid task number!");
        return;
    }

    tasks[index - 1].completed = true;
    println!("Marked as done!");
}

fn delete_task(tasks: &mut Vec<Task>) {
    list_tasks(tasks);
    println!("\nEnter task number to delete:");
    let mut input = String::new();
    io::stdin().read_line(&mut input).expect("Failed to read input");
    let index: usize = input.trim().parse().unwrap_or(0);

    if index == 0 || index > tasks.len() {
        println!("Invalid task number!");
        return;
    }

    tasks.remove(index - 1);
    println!("Task deleted!");
}

fn main() {
    let path = "tasks.json";
    let mut tasks = load_tasks(path);

    loop {
        println!("\n=== To-Do CLI App ===");
        println!("1. Add Task");
        println!("2. List Tasks");
        println!("3. Mark Task as Done");
        println!("4. Delete Task");
        println!("5. Exit");
        println!("Enter your choice:");

        let mut choice = String::new();
        io::stdin().read_line(&mut choice).expect("Failed to read choice");

        match choice.trim() {
            "1" => add_task(&mut tasks),
            "2" => list_tasks(&tasks),
            "3" => mark_task_done(&mut tasks),
            "4" => delete_task(&mut tasks),
            "5" => {
                save_tasks(path, &tasks);
                println!("Bye!");
                break;
            }
            _ => println!("Invalid choice, try again."),
        }
    }
}
