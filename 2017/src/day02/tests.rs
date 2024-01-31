#![cfg(test)]

#[test]
fn examples_silver() {
    let input = concat!(
        "5 1 9 5 \n", // 9 - 1 = 8
        "7 5 3   \n", // 7 - 3 = 4
        "2 4 6 8 \n"  // 8 - 2 = 6
    );

    assert_eq!(super::checksum(input), 18);
}

#[test]
fn examples_gold() {
    let input = concat!(
        "5 9 2 8 \n", // 8 / 2 = 4
        "9 4 7 3 \n", // 9 / 3 = 3
        "3 8 6 5 \n"  // 6 / 3 = 2
    );

    assert_eq!(super::divsum(input), 9);
}
