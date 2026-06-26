enum OptionExample {
    Salutation,
    Name(String),
    Some(u32, u32, u32, u32),
    Subtraction(u32, u32, u32),
    Multiplication(u32, u32),
}

fn option_example_match(option_example: OptionExample) {
    match option_example {
        OptionExample::Salutation => print!("Hello world"),
        OptionExample::Name(name) => print!("Hello {}", name),
        OptionExample::Some(a, b, c, d) => print!("{}", a + b + c + d),
        OptionExample::Subtraction(a, b, c) => print!("{}", a - b - c),
        OptionExample::Multiplication(a, b) => print!("{}", a * b),
    }
}

fn main() {
    let say_my_name = OptionExample::Name(String::from("Ismael"));
    option_example_match(say_my_name);

    match option_example("ismael") {
        Some(name) => println!("{}", name),
        None => println!("No name"),
    }
}

fn option_example(name: &str) -> Option<String> {
    if name == "ismael" {
        Some(String::from("ismael"))
    } else {
        None
    }
}
