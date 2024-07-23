use super::BuildRecord;

fn parse_build_record(json_str: &str) -> Result<BuildRecord, Box<dyn std::error::Error>> {
    if let Ok(record) = serde_json::from_str::<BuildRecord>(json_str) {
        return Ok(record);
    }
    match serde_json::from_str::<String>(json_str) {
        Ok(inner_json) => serde_json::from_str::<BuildRecord>(&inner_json)
            .map_err(|e| Box::new(e) as Box<dyn std::error::Error>),
        Err(e) => Err(Box::new(e) as Box<dyn std::error::Error>),
    }
}

fn parse_build_record_array(
    json_str: &str,
) -> Result<Vec<BuildRecord>, Box<dyn std::error::Error>> {
    serde_json::from_str::<Vec<BuildRecord>>(json_str)
        .map_err(|e| Box::new(e) as Box<dyn std::error::Error>)
}

pub fn parse_stdout_lines(lines: Vec<String>) -> Vec<BuildRecord> {
    let mut records = Vec::new();

    for line in lines {
        if line.trim().is_empty() {
            continue;
        }
        if let Ok(array_records) = parse_build_record_array(&line) {
            records.extend(array_records);
            continue;
        }
        match parse_build_record(&line) {
            Ok(record) => {
                records.push(record);
            }
            Err(e) => {
                eprintln!("Failed to parse line as BuildRecord or array: {}", e);
                eprintln!("Line: {}", line);
            }
        }
    }
    records
}
