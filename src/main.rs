enum Shape {
    Circle(f32),
    Rectangle(f32, f32),
}

fn main() {
    let rect_value = Shape::Rectangle(1.0, 2.0);
    let circle_value = Shape::Circle(1.0);

    let rect_area = calculate_area(rect_value);
    let circle_area = calculate_area(circle_value);
    println!("Rectangle area: {}", rect_area);
    println!("Circle area: {}", circle_area);
}

fn calculate_area(shape: Shape) -> f32 {
    let area = match shape {
        Shape::Circle(a) => 3.14 * a * a,
        Shape::Rectangle(a, b) => a * b,
    };
    area
}
