use std::fs::File;
use std::io::{BufRead, BufReader};

pub(crate) fn read(path: &str) -> Result<Vec<i64>, Box<dyn std::error::Error>> {
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
