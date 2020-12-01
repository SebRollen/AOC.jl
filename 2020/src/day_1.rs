use std::fs::File;
use std::io::{BufRead, BufReader};

fn read(path: &str) -> Result<Vec<i64>, Box<dyn std::error::Error>> {
    let file = File::open(path)?;
    let reader = BufReader::new(file);
    let mut v = Vec::new();
    for line in reader.lines() {
        let line = line?;
        let n = line
            .trim()
            .parse()?;
        v.push(n);
    }
    Ok(v)
}

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
