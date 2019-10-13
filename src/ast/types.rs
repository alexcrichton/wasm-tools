use crate::ast::{self, kw};
use crate::parser::{Cursor, Parse, Parser, Peek, Result};

/// The value types for a wasm module.
#[allow(missing_docs)]
#[derive(Debug, PartialEq, Eq, Hash, Copy, Clone)]
pub enum ValType {
    I32,
    I64,
    F32,
    F64,
    Anyref,
    Funcref,
}

impl<'a> Parse<'a> for ValType {
    fn parse(parser: Parser<'a>) -> Result<Self> {
        let mut l = parser.lookahead1();
        if l.peek::<kw::i32>() {
            parser.parse::<kw::i32>()?;
            Ok(ValType::I32)
        } else if l.peek::<kw::i64>() {
            parser.parse::<kw::i64>()?;
            Ok(ValType::I64)
        } else if l.peek::<kw::f32>() {
            parser.parse::<kw::f32>()?;
            Ok(ValType::F32)
        } else if l.peek::<kw::f64>() {
            parser.parse::<kw::f64>()?;
            Ok(ValType::F64)
        } else if l.peek::<kw::anyref>() {
            parser.parse::<kw::anyref>()?;
            Ok(ValType::Anyref)
        } else if l.peek::<kw::funcref>() {
            parser.parse::<kw::funcref>()?;
            Ok(ValType::Funcref)
        } else {
            Err(l.error())
        }
    }
}

/// Type for a `global` in a wasm module
#[derive(Copy, Clone, Debug, PartialEq)]
pub struct GlobalType {
    /// The element type of this `global`
    pub ty: ValType,
    /// Whether or not the global is mutable or not.
    pub mutable: bool,
}

impl<'a> Parse<'a> for GlobalType {
    fn parse(parser: Parser<'a>) -> Result<Self> {
        if parser.peek2::<kw::r#mut>() {
            parser.parens(|p| {
                p.parse::<kw::r#mut>()?;
                Ok(GlobalType {
                    ty: parser.parse()?,
                    mutable: true,
                })
            })
        } else {
            Ok(GlobalType {
                ty: parser.parse()?,
                mutable: false,
            })
        }
    }
}

/// List of different kinds of table types we can have.
///
/// Currently there's only one, a `funcref`.
#[derive(Copy, Clone, Debug, PartialEq)]
pub enum TableElemType {
    /// An element for a table that is a list of functions.
    Funcref,
    /// An element for a table that is a list of `anyref` values.
    Anyref,
}

impl<'a> Parse<'a> for TableElemType {
    fn parse(parser: Parser<'a>) -> Result<Self> {
        // legacy support for `anyfunc`
        if parser.peek::<kw::anyfunc>() {
            parser.parse::<kw::anyfunc>()?;
            return Ok(TableElemType::Funcref);
        }
        let mut l = parser.lookahead1();
        if l.peek::<kw::funcref>() {
            parser.parse::<kw::funcref>()?;
            Ok(TableElemType::Funcref)
        } else if l.peek::<kw::anyref>() {
            parser.parse::<kw::anyref>()?;
            Ok(TableElemType::Anyref)
        } else {
            Err(l.error())
        }
    }
}

impl Peek for TableElemType {
    fn peek(cursor: Cursor<'_>) -> bool {
        kw::funcref::peek(cursor)
            || kw::anyref::peek(cursor)
            || /* legacy */ kw::anyfunc::peek(cursor)
    }
    fn display() -> &'static str {
        "table element type"
    }
}

/// Min/max limits used for tables/memories.
#[derive(Copy, Clone, Debug, PartialEq)]
pub struct Limits {
    /// The minimum number of units for this type.
    pub min: u32,
    /// An optional maximum number of units for this type.
    pub max: Option<u32>,
}

impl<'a> Parse<'a> for Limits {
    fn parse(parser: Parser<'a>) -> Result<Self> {
        let min = parser.parse()?;
        let max = if parser.peek::<u32>() {
            Some(parser.parse()?)
        } else {
            None
        };
        Ok(Limits { min, max })
    }
}

/// Configuration for a table of a wasm mdoule
#[derive(Copy, Clone, Debug, PartialEq)]
pub struct TableType {
    /// Limits on the element sizes of this table
    pub limits: Limits,
    /// The type of element stored in this table
    pub elem: TableElemType,
}

impl<'a> Parse<'a> for TableType {
    fn parse(parser: Parser<'a>) -> Result<Self> {
        Ok(TableType {
            limits: parser.parse()?,
            elem: parser.parse()?,
        })
    }
}

/// Configuration for a memory of a wasm module
#[derive(Copy, Clone, Debug, PartialEq)]
pub struct MemoryType {
    /// Limits on the page sizes of this memory
    pub limits: Limits,
    /// Whether or not this is a shared (atomic) memory type
    pub shared: bool,
}

impl<'a> Parse<'a> for MemoryType {
    fn parse(parser: Parser<'a>) -> Result<Self> {
        Ok(MemoryType {
            limits: parser.parse()?,
            shared: parser.parse::<Option<kw::shared>>()?.is_some(),
        })
    }
}

/// A function type with parameters and results.
#[derive(Clone, Debug, PartialEq)]
pub struct FunctionType<'a> {
    pub params: Vec<(Option<ast::Id<'a>>, ValType)>,
    pub results: Vec<ValType>,
}

impl<'a> FunctionType<'a> {
    fn finish_parse(&mut self, parser: Parser<'a>) -> Result<()> {
        while parser.peek2::<kw::param>() || parser.peek2::<kw::result>() {
            parser.parens(|p| {
                let mut l = p.lookahead1();
                if l.peek::<kw::param>() {
                    p.parse::<kw::param>()?;
                    if self.results.len() > 0 {
                        return Err(p.error("cannot list params after results"));
                    }
                    if p.is_empty() {
                        return Ok(());
                    }
                    let id = p.parse::<Option<_>>()?;
                    let parse_more = id.is_none();
                    let ty = p.parse()?;
                    self.params.push((id, ty));
                    while parse_more && !p.is_empty() {
                        self.params.push((None, p.parse()?));
                    }
                } else if l.peek::<kw::result>() {
                    p.parse::<kw::result>()?;
                    while !p.is_empty() {
                        self.results.push(p.parse()?);
                    }
                } else {
                    return Err(l.error());
                }
                Ok(())
            })?;
        }
        Ok(())
    }
}

impl<'a> Parse<'a> for FunctionType<'a> {
    fn parse(parser: Parser<'a>) -> Result<Self> {
        parser.parse::<kw::func>()?;
        let mut ret = FunctionType {
            params: Vec::new(),
            results: Vec::new(),
        };
        ret.finish_parse(parser)?;
        Ok(ret)
    }
}

/// A type declaration in a module
#[derive(Debug, PartialEq)]
pub struct Type<'a> {
    pub name: Option<ast::Id<'a>>,
    pub func: FunctionType<'a>,
}

impl<'a> Parse<'a> for Type<'a> {
    fn parse(parser: Parser<'a>) -> Result<Self> {
        parser.parse::<kw::r#type>()?;
        let name = parser.parse()?;
        let func = parser.parens(FunctionType::parse)?;
        Ok(Type { name, func })
    }
}

/// A type declaration in a module
#[derive(Clone, Default, Debug, PartialEq)]
pub struct TypeUse<'a> {
    pub index: Option<ast::Index<'a>>,
    pub ty: Option<ast::FunctionType<'a>>,
}

impl<'a> Parse<'a> for TypeUse<'a> {
    fn parse(parser: Parser<'a>) -> Result<Self> {
        let index = if parser.peek2::<kw::r#type>() {
            Some(parser.parens(|parser| {
                parser.parse::<kw::r#type>()?;
                Ok(parser.parse()?)
            })?)
        } else {
            None
        };
        let ty = if parser.peek2::<kw::param>() || parser.peek2::<kw::result>() {
            let mut ft = FunctionType {
                params: Vec::new(),
                results: Vec::new(),
            };
            ft.finish_parse(parser)?;
            Some(ft)
        } else {
            None
        };

        Ok(TypeUse { index, ty })
    }
}