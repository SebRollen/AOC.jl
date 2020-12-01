use crate::utils::read;

fn part_1() -> Result<i64, Box<dyn std::error::Error>> {
    let data = read("data/day_1.txt")?;
    for d1 in &data {
        for d2 in &data {
            if d1 + d2 == 2020 {
                return Ok(d1*d2)
            }
        }
    }
    Err(String::from("Solution not found").into())
}

fn part_2() -> Result<i64, Box<dyn std::error::Error>> {
    let data = read("data/day_1.txt")?;
    for d1 in &data {
        for d2 in &data {
            for d3 in &data {
                if d1 + d2 + d3 == 2020 {
                    return Ok(d1*d2*d3)
                }
            }
        }
    }
    Err(String::from("Solution not found").into())
}


pub fn main() {
    println!("Day 1, part 1: {}", part_1().unwrap());
    println!("Day 1, part 2: {}", part_2().unwrap());
}
