use std::str;

fn main() {
    let mut parser = Parser::new("opcodes.txt", include_str!("opcodes.txt"));
    let mut src = String::new();
    parser.parse(&mut src);

    let out_dir = std::env::var("OUT_DIR").unwrap();
    std::fs::write(format!("{out_dir}/opcodes.rs"), src).unwrap();
}

#[derive(Clone)]
pub struct Parser<'a> {
    filename: &'a str,
    lines: str::Lines<'a>,
    lineno: u32,
    line: Option<str::SplitWhitespace<'a>>,
}

impl<'a> Parser<'a> {
    pub fn new(filename: &'a str, s: &'a str) -> Parser<'a> {
        Parser {
            filename,
            lines: s.lines(),
            lineno: 0,
            line: None,
        }
    }

    fn line(&mut self) -> Option<&'a str> {
        loop {
            let line = self.lines.next()?.trim();
            self.lineno += 1;
            if line.starts_with("#") {
                continue;
            }
            break Some(line);
        }
    }

    fn token(&mut self) -> Option<&'a str> {
        loop {
            if self.line.is_none() {
                self.line = Some(self.line()?.split_whitespace());
            }
            if let Some(line) = self.line.as_mut() {
                if let Some(next) = line.next() {
                    return Some(next);
                }
                self.line = None;
            }
        }
    }

    fn expect_token(&mut self) -> &'a str {
        match self.token() {
            Some(t) => t,
            None => panic!(
                "{}:{}: expected token found nothing",
                self.filename, self.lineno
            ),
        }
    }

    fn eat(&mut self, token: &str) -> bool {
        let saved = self.clone();
        if self.expect_token() == token {
            true
        } else {
            *self = saved;
            false
        }
    }

    fn expect(&mut self, expected: &str) {
        let actual = self.expect_token();
        if actual != expected {
            panic!(
                "{}:{}: expected `{expected}` found `{actual}`",
                self.filename, self.lineno
            )
        }
    }

    fn parse(&mut self, src: &mut String) {
        src.push_str("pub const OPCODES: &'static [Opcode] = &[\n");
        while let Some(proposal) = self.token() {
            self.expect("{");
            while !self.eat("}") {
                src.push_str(&format!("// defined on line {}\n", self.lineno));
                src.push_str("Opcode {\n");
                src.push_str(&format!("proposal: {proposal:?},\n"));

                let opcode = self.expect_token();
                src.push_str(&format!("opcode: {opcode},\n"));

                if self.eat("|") {
                    src.push_str("subopcode: None,\n");
                } else {
                    let num = self.expect_token();
                    src.push_str(&format!("subopcode: Some({num}),\n"));
                    self.expect("|");
                }

                let instruction = self.expect_token();
                src.push_str(&format!("name: {instruction:?},\n"));

                src.push_str("immediates: &[\n");
                if self.eat("{") {
                    while !self.eat("}") {
                        let imm = self.expect_token();
                        src.push_str(&format!("Immediate::{imm},\n"));
                    }
                }
                src.push_str("],\n");

                self.expect("|");

                let arity = self.expect_token();
                src.push_str(&format!("arity: Arity::{arity},\n"));

                src.push_str("},\n");
            }
        }
        src.push_str("];\n");
    }
}
