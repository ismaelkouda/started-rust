fn main() {
    println!("{}", is_even(22))
}

fn is_even(num: u32) -> bool {
    return num % 2 == 0;
}
