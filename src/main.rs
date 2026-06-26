use std::fs::read_to_string;
use std::io::Error;

fn main() {
    let file_path = String::from("a.text");
    let answer = read_from_file_kirat(file_path);
    match answer {
        Ok(data) => println!("{}", data),
        Err(e) => println!("Error: {}", e),
    }
}

fn read_from_file_kirat(file_path: String) -> Result<String, Error> {
    let result = read_to_string(file_path);

    match result {
        Ok(data) => Ok(data),
        Err(e) => Err(e),
    }
}
