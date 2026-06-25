fn main() {
    let str = String::from("kouda");
    let len = get_str_len(str);
    println!("{}", len);
}

fn get_str_len(str: String) -> usize {
    str.chars().count()
}
