struct User {
    last_name: String,
    first_name: String,
    age: u32,
}

impl User {
    fn full_name(&self, salutation: &str) -> String {
        format!("{} {} {}", salutation, self.first_name, self.last_name)
    }

    fn debug() -> u32 {
        return 1;
    }
}

fn main() {
    let user = User {
        last_name: String::from("kouda"),
        first_name: String::from("Soumaila"),
        age: 29,
    };

    println!("{}", user.last_name);
    println!("{}", user.first_name);
    println!("{}", user.age);
    println!("{}", user.full_name("Bonjour"));
    println!("{}", User::debug());
}
